function [B, aff]  = preProcessBrainCANDIData(data,metaData)
% Pre-process the data before passing it to the pre-trained model.
% Modified by Juan Eugenio Iglesias to make sure that headers are always
% fine and sizes are multiples of 2^levels

% Copyright 2022 The MathWorks, Inc.

% Perform resampling to make data isotropic
aff = metaData.Transform.T';
voxelSize = metaData.PixelDimensions;
newVoxelSize = [1 1 1];
[data,aff]  = resampleVolume(data,aff,voxelSize,newVoxelSize); %#ok<*UNRCH>


% Align volume to ref
[data, aff] = AlignWithIdentityVOX2RAS(data, aff);

% pad if needed
numLevels = 5;
N = 2^numLevels;
siz=size(data);
sizNew=N*ceil(siz/N);
dataNew=zeros(sizNew,class(data));
dataNew(1:size(data,1),1:size(data,2),1:size(data,3))=data;
B=dataNew;

% Normalize
inMax = prctile(data(:),99.5);
inMin = prctile(data(:),0.5);
B = rescale(B,0,1,InputMax=inMax,InputMin=inMin);
end

function [resampleData,aff] = resampleVolume(data,aff,voxelSize,newVoxelSize)
% Resample data to make it isotropic of voxel size 1mmx1mmx1mm.

% Copyright 2022 The MathWorks, Inc.

% Make isotropic volume with new voxel size
scale = voxelSize./newVoxelSize;
outputSz = [ceil(size(data,1)*scale(1)),ceil(size(data,2)*scale(2)),...
    ceil(size(data,3)*scale(3))];
resampleData = imresize3(data,outputSz,method="linear",AntiAliasing=false);

% Update affine transform
aff(1:3,1:3)= aff(1:3,1:3)./scale;
aff(1:3,end) = aff(1:3,end)-(aff(1:3,1:3)*0.5*(scale'-1));
end