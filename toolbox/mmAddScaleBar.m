function [ hl ] = mmAddScaleBar(ax, width, widthPERpixel, Color,LineThickness, pos, unit)
%MMADDSCALEBAR Adds a scalebar to current image
% 
% INPUTS
%   - ax: the handle to the axis where you want to add your scale bar
%   - width: the length of the scalebar 
%   - widthPERpixel: the dimensions of a pixel side (e.g. um per pixel)
%
% OPTIONAL INPUTS
%   - Color: the color of the scale bar
%   - Line Thickness: thickness of the scale bar (in points)
%   - pos: a row vector containing the X and Y coordinates where
%           you want the scale bar. You can enter empty brackets to skip
%   - unit: a character array indicating the unit of measure. If
%           inputted, the width of the scalebar will be printed above the bar
%
% EXAMPLES
%
% add_scale_bar(gca,100, 2.3);
% add_scale_bar(gca,50,0.23,'white', 4, [],'µm');
%
% NOTE: the measurements don't have to be in microns. They just have
% be consistent between width and widthPERpixel
% ---
% Author: Ernesto Salcedo, PhD.
% Created: 1-Sep-2017
% Updated: 18-Sep-2020

if nargin < 4
    Color = 'k';
    LineThickness = 2;
elseif nargin < 5
    LineThickness = 2;
end

bar_width = width/widthPERpixel;

% if position inputted
if nargin == 6 && ~isempty(pos) %user-defined position
    pos(2,:) = [pos(1) + bar_width pos(2)];
else    
    x = size(ax.Children.CData,1)* 0.50; % target left corner of image
    y = size(ax.Children.CData,2)* 0.60; % target bottom of image
    roi = drawline(ax,'Position',[x y; x+bar_width  y]);
    roi.wait
    pos = (roi.Position);
    delete(roi)
end

hl = line(pos(:,1), pos(:,2), 'Color',Color,'LineWidth',LineThickness);

if nargin == 7
    text(hl.XData(1), hl.YData(1)-40,sprintf('%d %s',width,unit),'Color',Color)
end
end


% if isempty(ax)
%     beep
%     disp('axis not found')
%     return
% end

