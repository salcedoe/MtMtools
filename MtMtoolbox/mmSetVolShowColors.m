function [MapName] = mmSetVolShowColors(hVolShow,options)
%MMSETVOLSHOWCOLORS Utility Function for volshow that changes background
%color of the display and applies a Medical Color map to the volume render
%
% Changes Background color of the viewer and applies a Medical Colormap and
% alphamap to a volshow render. If no MapName inputted, a list dialog window,
% pops up to allow for the selection of a MapName.
%
% To maintain the default background settings, input a BackgroundColor of
% 'default'.
%
% Available MapNames: CTBone, CTBoneShift (more bone oriented), CTCoronary,
%    CTLung, CTSoftTissue, MRI, PET (maps captured from the Medical Volume Viewer)
%
% INPUTs:
%  - hVolShow: Handle to volshow
%  - MapName: (optional) Name of Medical Colormap to apply.
%  - BackgroundColor: Color of the background (default = white). If set to
%  'default', the Background Color and Gradient are not changed.
%  - BackgroundGradient: applies a gradient to display (default = 'off')
%  - GradientColor: color of gradient (only applicable if BackgroundGradient is on)
%
% OUTPUT: Name of Selected Map
%
% EXAMPLEs:
%   MapName = mmSetColorMap(hVolShow)
%   MapName = mmSetColorMap(hVolShow,"CTLung")

arguments (Input)
    hVolShow % handle to volshow
    options.MapName {mustBeTextScalar} = ''
    options.BackgroundColor = 'white';
    options.BackgroundGradient = 'off';
    options.GradientColor = [0.0667 0.4431 0.7451]; % some kind of gray smudge
end

load("MedColorMapTable.mat","medColorMapT"); % table containing colormaps

if isempty(options.MapName)
    VN = medColorMapT.Properties.VariableNames; % get table headers
    la = endsWith(VN,'AM'); % find headers ending with AM (Alphamap names)
    MapNames = string(VN(~la)); % Only keep headers without AM (Colormap names)

    [indx,ok] = listdlg("ListString",MapNames,"PromptString",'Select Alphamap');

    if ok
        MapName = MapNames(indx); % set selected colormap
    else
        MapName = "CTBone"; % set default colormap if none selected
    end
else
    MapName = options.MapName;
end

Colormap = medColorMapT.(MapName); % get colormap from table
Alphamap = medColorMapT.(MapName+'AM'); % get alphamap from table

hVolShow.Colormap = Colormap; % set colormap
hVolShow.Alphamap = Alphamap; % set alphamap

% Adjust viewer3D settings (only if backgroundColor is not set to 'default')
if ~strcmp(options.BackgroundColor,'default')
    hVolShow.Parent.BackgroundColor = options.BackgroundColor;
    hVolShow.Parent.BackgroundGradient = options.BackgroundGradient;
    hVolShow.Parent.GradientColor = options.GradientColor;
end

% Assuming LPS, rotate view so Anterior is forward
hVolShow.Parent.CameraPosition(1:2) = -hVolShow.Parent.CameraPosition(1:2); % adjust camera position

end