function hp = mmPlotSurface(fv, fcolor, falpha)
%PLOT_SURFACE plots the input fv structure as a patch. Lights not added. Use
%set_seg_plot_props to add lighting and correct aspect ratios
% INPUTS: 
%   - fv: a faces-vertices structure (output from isosurface)
%   - fcolor: face color
%   - falpha: face alpha
%
% OUTPUT:
%   -  hp: handle to the patch
% EXAMPLES:
% hp = plot_surface(fv,'cyan',0.5)
% ---
% Author: Ernesto Salcedo, PhD
% Site: University of Colorado Modern Human Anatomy
% Updated: 03/12/23

hp = patch(fv, ...
    'FaceColor',fcolor,...
    'FaceAlpha', falpha,...
    'EdgeColor','none');

% set(hp,'SpecularColorReflectance',0.3,'SpecularExponent',20) %0 50
camproj('perspective')