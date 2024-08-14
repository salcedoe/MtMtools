function S = mmGetMedicalVolumeSegment(mV,segT,options)
%MMMEDICALVOLUME2SURFACE Summary of this function goes here
%   Detailed explanation goes here

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

    vol = squeeze(mV.Voxels(:,:,:,layer));
    S.mask = vol == label;
else
    S.mask = mV.Voxels == segT.LabelValue(row);
end

S.color = segT.Color(row,:);
S.tform = intrinsicToWorldMapping(mV.VolumeGeometry);

end