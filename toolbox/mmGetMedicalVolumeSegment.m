function S = mmGetMedicalVolumeSegment(mV,segT,options)
%MMGETMEDICALVOLUMESEGMENT Return Structure that contains the mask, color,
%   and transformation matrix of the selected segmentation
%   
% INPUTS
%
% - mV   (required):    medicalVolume of a slicer Segmentation dataset
% - segT (required):    table - table created by mmGetSlicerSegTable
% - segName (optional): string - Name of Segment to return. 
%
% If segName not provided, the function prompts for a segmentation to be
% selected from the inputted segT table
%
% OUTPUTS
%
% - S: A structure with the following fields
%      - name: Name of selected segment
%      - mask: binary mask containing the selected segment
%      - color: color of the segmentation as set in Slicer
%      - tform: transformation matrix to properly orient segmentation 
%
% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado Modern Human Anatomy
% UPDATED: 10/27/2023

arguments
    mV medicalVolume
    segT table
    options.segName {mustBeText} = '';
end

if isempty(options.segName)
    names = segT.Name;
    [row,tf] = listdlg('ListString',names);
    
    if tf
        options.segName = names(row);
    else
        S = [];
        disp('mmMedicalVolume2Surface canceled...')
        return
    end
    S.name = names{row};
else
    S.name = options.segName;
    row = find(lower(segT.Name)==lower(S.name));
end

% index out relevant segmentation

if ndims(mV.Voxels)>3 % 4D arrays are created when overlap is allowed in Slicer
    layer = segT.Layer(row);
    label = segT.LabelValue(row);

    try
        vol = squeeze(mV.Voxels(:,:,:,layer));
        S.mask = vol == label;
    catch
        warning('%s. Indexing %d layer of the mV.Voxels failed',segT.File(1),layer)
        S.mask = false(size(mV.Voxels,1:3));
    end

else
    S.mask = mV.Voxels == segT.LabelValue(row);
end
S.color = segT.Color(row,:);


S.tform = intrinsicToWorldMapping(mV.VolumeGeometry);

end