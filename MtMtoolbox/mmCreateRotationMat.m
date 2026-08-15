function tform = mmCreateRotationMat(angl,ax,options)
%MMCREATEROTATIONMAT Create a rotation matrix
%
%   INPUTS:
%   - angl: amount of rotation in Degrees
%   - ax: axis around which to rotation ('x','y', or 'z')
%   - origin: (optional) 1x3 vector. Origin around which to rotate
%
%   OUTPUT:
%   - tform: affine geometric transformation
%
%   Example
%   rotMat = mmCreateRotationMat(45,'x')

% ---
% Author: Ernesto Salcedo, PhD
% Site: University of Colorado School of Medicine
% Updated: 12/27/2025
% Create the rotation matrix based on the specified axis

arguments
    angl % amount (in degrees) to rotate
    ax {mustBeMember(ax,{'x','y','z'})}
    options.origin (1,3) {mustBeNumeric} = [0 0 0] % 1x3 vector
end

theta = deg2rad(angl); % convert to radians

switch ax
    case 'x'
        rotMat = [1 0 0 0; ...
                  0 cos(theta) -sin(theta) 0;...
                  0 sin(theta)  cos(theta) 0;...
                  0 0 0 1];
    case 'y'
        rotMat = [cos(theta) 0, sin(theta) 0;...
                  0 1 0 0 ;...
                 -sin(theta) 0, cos(theta) 0;...
                  0 0 0 1];
    case 'z'
        rotMat = [cos(theta) -sin(theta) 0 0;...
                  sin(theta)  cos(theta) 0 0;...
                  0 0 1 0; ...
                  0 0 0 1];
    otherwise
        error('Invalid axis. Choose ''x'', ''y'', or ''z''.');
end

if any(options.origin)
    % Adjust the rotation matrix based on the specified origin
    translation = eye(4);
    translation(1:3, 4) = options.origin(:);
    rotMat = translation * rotMat / translation;
end

tform = affinetform3d(rotMat); % store 3D affine geometric transformation information

end