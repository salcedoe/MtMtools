function [SurfaceArea] = mmCalcSurfaceAreaFromMesh(V,F)
%mmCalcSurfaceAreaFromMesh This function will calculate the sum of all
%triangles in the mesh to calculate Surface area
%   If P1, P2, and P3 are 3D coordinate vectors of the three respective vertices 
%   of some particular triangle, then its area is given by:
%        AreaP1P2P3 = 1/2*norm(cross(P2-P1,P3-P1));

%   adapted from this discussion:
%   https://www.mathworks.com/matlabcentral/answers/271797-surface-area-of-a-3d-surface 


% V for vertices and F for the facets

% Perform cross product across all the Facets and Vertices in the Model
a = V(F(:, 2), :) - V(F(:, 1), :);
b = V(F(:, 3), :) - V(F(:, 1), :);
c = cross(a, b, 2);


% Add up the triangles
SurfaceArea = 1/2 * sum(sqrt(sum(c.^2, 2)));


end