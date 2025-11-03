function vertices = mmRotateSurfaceVertices(vertices, ax, angl,options)
%MMROTATESURFACEVERTICES Rotate the vertices of a surface around the 
%       specified axis by the specified angle (in degrees). requires
%       MatGeom.
% INPUTS
%   - vertices (matrix): Nx3 vertices
%   - ax (character array): axis around which to rotate — x, y, or z
%   - angl (scalar): amount (in degrees) to rotate 
%   - centerVerts (logical): optional. Center Vertices around 0,0,0 prior
%   to rotation
% 
% EXAMPLE
%   vertices = mmRotateSurfaceVertices(vertices, 'x',45)
% ---
% Author: Ernesto Salcedo, PhD
% Site: University of Colorado School of Medicine
% Updated: 11/01/2025

arguments
    vertices (:,3) double
    ax string
    angl (1,1) double   
    options.centerVerts logical = false
end

if ~exist('createRotationOx','file')
    error('MatGeom Required. Try running setupMatGeom')    
end

if options.centerVerts
    centroid = mean(vertices);
    vertices = vertices - centroid; % Center the vertices around the origin
end

theta = deg2rad(angl);

switch lower(ax)
    case 'x'
        tform = createRotationOx(theta); % rotate z angle
    case 'y'
        tform = createRotationOy(theta); % rotate y angle
    case 'z'
        tform = createRotationOz(theta); % rotate y angle
    otherwise
        disp('axis not found')
        return
end

tform = affine3d(tform);
vertices = transformPointsForward(tform, vertices);
