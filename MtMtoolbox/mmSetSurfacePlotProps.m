function mmSetSurfacePlotProps
%MMSETSURFACEPLOTPROPS - sets the light location and the aspect ratio.
%Labels the axes 
%Use after surface plot or after a FOR LOOP with multiple surface plots
% INPUT:
%   - xyz: (optional) voxel dimensions. Default is [1 1 1]
%
% EXAMPLE: 
% plot_surface(F.fv, 'cyan',0.75);
% set_surface_plot_props
%---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado Modern Human Anatomy
% UPDATED: 11-1-2020

% if nargin == 0
%     xyz = [1 1 1];
% end

% Define View
view(-71,12)
axis equal % vis3d
grid on

% da = [xyz(3) xyz(3) xyz(1)];
% daspect(da) % [dim_z dim_z dim_xy ] this is wrong! don't do

xlabel('x')
ylabel('y')
zlabel('z')

% lightangle(45,30);
lighting gouraud
material dull

% camera position - adds two opposing lights for better visibility
camlight('right')
camorbit(180,0,'data',[0 0 1])
camlight('right')

end