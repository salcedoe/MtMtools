function T = mmGetSlicerMetadata(file_name,options)
%MMGETSLICERMETADATA Reads in the metadata from a Slicer Segmentation file (seg.nrrd) 
% Returns a subset of the metadata as a formatted table,T, including the
% segmentation names and colors set in Slicer (formerly mmGetSlicerSegTable)
%
% INPUTS: file_name of a segmentation file
% OUTPUT: a table with segmentation names, layer, label, and color values
%
% EXAMPLE
%
% segT = mmGetSlicerMetadata(file_name)
%
% Works with Slicer 4.11.2020 and higher
% ---
% Ernesto Salcedo, PhD
% Updated: 10-20-2025
% University of Colorado Modern Human Anatomy


arguments
    file_name {mustBeTextScalar}
    options.addVolInfo logical = false
end

if ~contains(file_name,".seg.nrrd")
    error("Slicer *.seg.nrrd files only")    
elseif ~exist("nrrdinfo","file")
    error("Medical Toolbox required")    
end

info = nrrdinfo(file_name); % read in metadata
meta = info.RawAttributes; % raw metadata

FN = string(fieldnames(meta));
%     FNsegment = FN(startsWith(FN,"Segment"+digitsPattern(1))); % find Segment FN
FNsegment = FN(~cellfun(@isempty, regexp(FN,'segment\d+')));
seg_count = max(str2double(string(regexp(FNsegment,'(?<=segment)\d+','match'))))+1;

T = table(strings(seg_count,1), zeros(seg_count,1), zeros(seg_count,1), zeros(seg_count,3),...
    'VariableNames',{'SegName','Layer','LabelValue','Color'}); % changed Name to Segment

for n = 1:seg_count
    T.SegName(n) = meta.(sprintf('segment%d_name',n-1)); 
    T.Layer(n) = str2double(meta.(sprintf('segment%d_layer',n-1)))+1; % convert to MATLAB index
    T.LabelValue(n) = str2double(meta.(sprintf('segment%d_labelvalue',n-1)));
    T.Color(n,:) = str2num(meta.(sprintf('segment%d_color',n-1)));
end

if options.addVolInfo
    T.VolumeDimensions = repmat(numel(info.ImageSize),height(T),1);
    T.PixelSpacing = repmat(info.PixelDimensions,height(T),1);
end

T = sortrows(T,"LabelValue");

T.Properties.UserData = info; % attach metadata back to table
end

