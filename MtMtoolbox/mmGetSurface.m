function [fv,s] = mmGetSurface(Vol,options)
%MMGETSURFACE returns a face-vertices structure representing the surface of the
%inputted 3D volume
% INPUTS: 
%   - Vol: a 3D volume
%   - iv (numeric): isovalue from which to generate the surface
%   - decimator (0-1): amount by which to decimate the generated surface (from 0
%                       to 1). 
%   - use_fast_march (logical): Use the function extractIsosurface to more
%                               quickly generate an isosurface. Default = true
%   - centerSurface (logical): Center the surface to 0,0,0. Default = false
% OUTPUT: 
%   - fv: a faces-vertices structure
%   - s: string reporting the decimation
%
% EXAMPLES:
% fv = mmGetSurface(Vol);
% fv = mmGetSurface(Vol,0.5,0.1) % good default values to use
%
% REQUIREMENTS:
% Medical toolbox required for fast marching isosurface
% ---
% Author: Ernesto Salcedo, PhD
% Site: University of Colorado Modern Human Anatomy
% Updated: 03/13/23

arguments
    Vol (:,:,:) 
    options.iv (1,1) double = 0.5
    options.decimator (1,1) double = 0.15
    options.transform affinetform3d = affinetform3d; % 3D affinity transformation
    % options.affTrfm (4,4) double = zeros(4,4); % 3D affinity transformation
    options.use_fast_march logical = true; 
    options.centerSurface = false; % center surface to 0,0,0
end

if options.use_fast_march && exist('extractIsosurface','file')
    [fv.faces,fv.vertices] = extractIsosurface(Vol,options.iv); % requires Medical Toolbox
else
    fv = isosurface(Vol,options.iv); % decimation value returns a structure of vertices and faces
end

if options.decimator
    prev_count = [size(fv.faces,1) size(fv.vertices,1)];
    fv = reducepatch(fv, options.decimator); % decimate

    s=sprintf(['Decimation set to %1.1f.\n' ...
        'Surface reduced from %d faces and %d vertices to %d faces and %d vertices...\n'], ...
        options.decimator,...
        prev_count, ...
        [size(fv.faces,1) size(fv.vertices,1)]);
end

if ~isequal(options.transform.A, eye(4))
    fv.vertices = transformPointsForward(options.transform,fv.vertices);
end

if options.centerSurface
    fv.vertices = fv.vertices - mean(fv.vertices, 1); % Center the surface
end

end