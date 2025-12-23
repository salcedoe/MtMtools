function [vertMoving,rmse] = mmAlignSurfaces(vertFixed, vertMoving,options)
%%MMALIGNSURFACES registers two point clouds using an iterative closest point
%algorithm
%   This function requires the Computer Vision Toolbox. The inputs and
%   outputs of this function are a matrix of 3D coordinate points (xyz) 
% INPUTS 
% - SurfFixed: NX3 vertices matrix of Fixed Surface 
% - Surf2Move: NX3 vertices matrix of Surface to be moved (registered to
%               fixed surface
% OUTPUT
% - Surf2Move: NX3 vertices matrix of registered surface

arguments
    vertFixed (:,3) {mustBeNumeric}
    vertMoving (:,3) {mustBeNumeric}
    options.gridSize (1,1) {mustBeNumeric} = 0.1
    options.MaxIterations (1,1) {mustBeInteger} = 30;
end

PCr = pointCloud(vertFixed); % creates a point cloud object of the Right femur
PCl = pointCloud(vertMoving);

fixed = pcdownsample(PCr, 'gridAverage',options.gridSize);
moving = pcdownsample(PCl,'gridAverage',options.gridSize);

% transform
[tform,~,rmse] = pcregistericp(moving, fixed, 'Metric',"pointToPoint","MaxIterations",options.MaxIterations);
PCl_aligned = pctransform(PCl,tform);

% return
vertMoving = PCl_aligned.Location;
end
