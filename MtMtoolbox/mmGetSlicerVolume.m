function S = mmGetSlicerVolume(vol_file)
%GET_SLICER_VOLUME Wrapper for nrrdread that adds new fields to the
%structure output
% INPUTS: vol_file (optional) - a file path to the nrrd file
% OUTPUT: S - a structure that contains
%   - metaData: metadata read by nrrdread
%   - metaDatafieldNames: names for space directions and origins
%   - pixelData: the volume
%   - xyz: 1X3 vector voxel dimensions
%   - segmentations: For segmentation volumes only. Table that contains the
%   Name, Layer, LabelValue, and Color of the segmentations. More than 1
%   layer is possible and LabelValues can be shared across Layers. Default
%   is to include at least 1 layer (as of Slicer 4.11)
% EXAMPLES:
% S = get_slicer_volume
% S = get_slicer_volume(file_path)
% ---
% Author: Ernesto Salcedo, PhD
% Site: University of Colorado Modern Human Anatomy
% Updated: 11/3/2020

if nargin == 0 % prompt for a nrrd file if one not provided
    [nrrd_file,nrrd_path] = uigetfile('*.nrrd');
    if nrrd_file
        vol_file = fullfile(nrrd_path,nrrd_file); % constructs a full path
    else
        disp('Load canceled')
        S = [];
        return
    end
end

[~,vol_name]=fileparts(vol_file); % returns the name of the selected file

S = slicer_nrrdread(vol_file); % reads SLICER NRRD file
S.vol_name = vol_name; % add volume name to the VS structure
S.vol_file = vol_file; % full path to the volume
S.xyz = get_slicer_xyz(S.metaData.space_directions);

if contains(vol_file,'.seg.')
    S.segmentations = get_seg_names(S.metaData);
    if str2double(S.metaData.dimension) == 3
        S.pixelData = reshape(S.pixelData,[1 size(S.pixelData)]); % converts 3D to 4D for simplicity later
    end
end

end

function xyz = get_slicer_xyz(space_directions)
%get_xyz converts strings to numbers
% returns a 1X3 array with the spacing values (in mm) for X, Y, and Z
voxel_spacing = regexp(space_directions,'[0-9.]+','match'); % find and return the numbers
xyz = cellfun(@str2double, voxel_spacing); % convert to numeric array
xyz(xyz == 0) = []; % remove any zeros
end

function T = get_seg_names(meta)
%get_seg_names. Returns the segmentation names found in seg.nrrd
%   INPUTS: meta data loaded from nrrdread
%   OUTPUT: a table with segmentation names, layer, label, and color values
% Works with Slicer 4.11.2020
% ---
% Ernesto Salcedo, PhD
% Updated: 11-3-2020
% University of Colorado Modern Human Anatomy

FN = string(fieldnames(meta));
%     FNsegment = FN(startsWith(FN,"Segment"+digitsPattern(1))); % find Segment FN
FNsegment = FN(~cellfun(@isempty, regexp(FN,'Segment\d+')));
seg_count = max(str2double(string(regexp(FNsegment,'(?<=Segment)\d+','match'))))+1;

T = table(strings(seg_count,1), zeros(seg_count,1), zeros(seg_count,1), zeros(seg_count,3),...
    'VariableNames',{'Name','Layer','LabelValue','Color'});

for n = 1:seg_count
    T.Name(n) = meta.(sprintf('Segment%d_Name',n-1));
    T.Layer(n) = str2double(meta.(sprintf('Segment%d_Layer',n-1)))+1; % convert to mlb index
    T.LabelValue(n) = str2double(meta.(sprintf('Segment%d_LabelValue',n-1)));
    T.Color(n,:) = str2num(meta.(sprintf('Segment%d_Color',n-1)));
end

end
