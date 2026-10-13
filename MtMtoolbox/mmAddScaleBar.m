function [hl, ht] = mmAddScaleBar(ax, width, widthPERpixel, varargin)
%MMADDSCALEBAR Adds a scale bar to an image
%
% [hl, ht] = mmAddScaleBar(ax, width, widthPERpixel)
% [hl, ht] = mmAddScaleBar(ax, width, widthPERpixel, Color, LineThickness, pos, unit)
% [hl, ht] = mmAddScaleBar(___, Name=Value)
%
% INPUTS
%   - ax: the handle to the axes containing the image (e.g. gca)
%   - width: the length of the scale bar (e.g. 50)
%   - widthPERpixel: the size of one pixel side (e.g. 0.23 um per pixel)
%
% OPTIONAL INPUTS (in this order)
%   - Color: the color of the scale bar and label (default 'k')
%   - LineThickness: thickness of the scale bar in points (default 2)
%   - pos: where to put the scale bar. One of:
%       []                  drag the bar into place interactively (default)
%       [x y]               the left end of the bar, in axes coordinates
%       a corner name       "southwest", "southeast", "northwest", "northeast"
%                           also accepted: "bottomleft", "bottomright",
%                           "topleft", "topright", "bl", "br", "tl", "tr",
%                           "sw", "se", "nw", "ne"
%   - unit: text for the unit (e.g. 'µm'). If given, a label such as
%           '50 µm' is centered above the bar.
%
% NAME-VALUE OPTIONS (can replace or follow the optional inputs)
%   - Location: same as pos (e.g. Location="southeast")
%   - Unit:     same as unit
%   - Color, LineWidth: same as Color and LineThickness
%   - Margin:   distance from the image edges for corner placement, as a
%               fraction of the shorter image side (default 0.05)
%   - FontSize: label font size (default 10)
%
% OUTPUTS
%   - hl: handle to the scale bar line   (Tag 'mmScaleBar')
%   - ht: handle to the label text        (Tag 'mmScaleBarLabel'), empty if no unit
%   hl.UserData stores Width, Unit, Location and LengthPixels, which is
%   useful for checking a scale bar in MATLAB Grader tests.
%
% EXAMPLES
%   mmAddScaleBar(gca,100,2.3);                            % interactive
%   mmAddScaleBar(gca,50,0.23,'white',4,[],'µm');          % interactive, labeled
%   mmAddScaleBar(gca,50,0.23,'white',2,"southeast",'µm'); % bottom right corner
%   mmAddScaleBar(gca,50,0.23,'white',2,[20 480]);         % left end at x=20, y=480
%   mmAddScaleBar(gca,50,0.23,Location="northwest",Unit="µm",Color="w");
%
% NOTES
%   - width and widthPERpixel just need to use the same unit.
%   - The image's XData/YData are respected, so the bar is correct for
%     spatially referenced images (e.g. imshow(I,'XData',...)).
%   - Interactive placement needs a person to drag the bar; use a corner
%     name or [x y] in scripts that must run unattended (e.g. MATLAB Grader).
% ---
% Author: Ernesto Salcedo, PhD.
% Created: 1-Sep-2017
% Updated: 12-Oct-2026 (corner placement, name-value options, bug fixes)

%% ---- parse inputs -------------------------------------------------------
optionNames = ["Location","Unit","Color","LineWidth","Margin","FontSize"];

% optional positional inputs come first; name-value pairs start at the
% first text input that matches an option name
nPos = numel(varargin);
for k = 1:numel(varargin)
    v = varargin{k};
    if (ischar(v) || (isstring(v) && isscalar(v))) && any(strcmpi(string(v), optionNames))
        nPos = k-1;
        break
    end
end
if nPos > 4
    error('mmAddScaleBar:tooManyInputs','Too many positional inputs.')
end
positional = [varargin(1:nPos) cell(1,4-nPos)];
[Color, LineThickness, pos, unit] = positional{:};

ip = inputParser;
ip.FunctionName = 'mmAddScaleBar';
ip.addParameter('Location',[]);
ip.addParameter('Unit',[]);
ip.addParameter('Color',[]);
ip.addParameter('LineWidth',[]);
ip.addParameter('Margin',0.05,@(x) isnumeric(x) && isscalar(x) && x >= 0 && x < 0.5);
ip.addParameter('FontSize',10,@(x) isnumeric(x) && isscalar(x) && x > 0);
ip.parse(varargin{nPos+1:end});
opt = ip.Results;

% name-value inputs override positional ones
if ~isempty(opt.Location),  pos = opt.Location;            end
if ~isempty(opt.Unit),      unit = opt.Unit;               end
if ~isempty(opt.Color),     Color = opt.Color;             end
if ~isempty(opt.LineWidth), LineThickness = opt.LineWidth; end

% defaults
if isempty(ax),            ax = gca;          end
if isempty(Color),         Color = 'k';       end
if isempty(LineThickness), LineThickness = 2; end
unit = char(unit);

%% ---- image geometry ------------------------------------------------------
hi = findobj(ax,'Type','image');
if isempty(hi)
    error('mmAddScaleBar:noImage','No image found in the specified axes.')
end
hi = hi(1); % most recently added image

[nr,nc] = size(hi.CData,[1 2]);
[xMin,xMax,dx] = imageExtent(hi.XData,nc);
[yMin,yMax,dy] = imageExtent(hi.YData,nr);
W = xMax - xMin;
H = yMax - yMin;

lengthPixels = width/widthPERpixel;   % bar length in image pixels
barLen = lengthPixels*dx;             % bar length in axes units

% +1 if moving "up" on screen increases y, -1 if it decreases y (imshow)
up = 1;
if strcmp(ax.YDir,'reverse'), up = -1; end
% +1 if moving "right" on screen increases x
right = 1;
if strcmp(ax.XDir,'reverse'), right = -1; end

%% ---- choose position -----------------------------------------------------
location = "manual";
if isempty(pos)
    % interactive: start near the lower left and let the user drag it
    x0 = xMin + 0.1*W;
    y0 = yMin + 0.9*H;
    roi = drawline(ax,'Position',[x0 y0; x0+barLen y0]);
    roi.wait
    xy = roi.Position;
    delete(roi)
    xBar = xy(:,1)';
    yBar = xy(:,2)';
    location = "interactive";

elseif isnumeric(pos)
    if numel(pos) ~= 2
        error('mmAddScaleBar:badPosition','pos must be [x y], a corner name, or [].')
    end
    xBar = [pos(1) pos(1)+barLen];
    yBar = [pos(2) pos(2)];

else
    location = cornerName(pos);
    m = opt.Margin*min(W,H);

    isLeft  = any(location == ["southwest","northwest"]);
    isBelow = any(location == ["southwest","southeast"]);

    % screen-left/right edges in axes units
    edgeL = xMin; edgeR = xMax;
    if right < 0, edgeL = xMax; edgeR = xMin; end
    if isLeft
        xStart = edgeL + right*m;
    else
        xStart = edgeR - right*(m + barLen);
    end
    xBar = [xStart xStart + right*barLen];

    % screen-bottom/top edges in axes units
    edgeB = yMin; edgeT = yMax;
    if up < 0, edgeB = yMax; edgeT = yMin; end
    if isBelow
        yBar = (edgeB + up*m)*[1 1];
    else
        yBar = (edgeT - up*m)*[1 1]; % shifted down for the label below
    end

    if barLen > W - 2*m
        warning('mmAddScaleBar:tooLong', ...
            'The scale bar (%g pixels) is longer than the image is wide.', lengthPixels)
    end
end

%% ---- draw ----------------------------------------------------------------
hl = line(ax, xBar, yBar, 'Color',Color, 'LineWidth',LineThickness, ...
    'Tag','mmScaleBar');

ht = gobjects(0);
if ~isempty(unit)
    gap = 0.01*min(W,H);
    ht = text(ax, mean(xBar), yBar(1) + up*gap, sprintf('%g %s',width,unit), ...
        'Color',Color, 'FontSize',opt.FontSize, ...
        'HorizontalAlignment','center', 'VerticalAlignment','bottom', ...
        'Tag','mmScaleBarLabel');

    % in the top corners, move bar and label down so the label stays inside
    if any(location == ["northwest","northeast"])
        shift = ht.Extent(4) + gap;
        hl.YData = hl.YData - up*shift;
        ht.Position(2) = ht.Position(2) - up*shift;
    end
end

hl.UserData = struct('Width',width, 'Unit',string(unit), ...
    'Location',location, 'LengthPixels',lengthPixels);

fprintf('Scale bar placed at %1.1f, %1.1f\n', hl.XData(1), hl.YData(1))

if nargout == 0
    clear hl ht
end

end

%% ---- helpers -------------------------------------------------------------
function [lo,hi,d] = imageExtent(data,n)
% outer edges of the image and the size of one pixel in axes units
if n > 1
    d = (data(end) - data(1))/(n-1);
else
    d = 1;
end
lo = min(data(1),data(end)) - abs(d)/2;
hi = max(data(1),data(end)) + abs(d)/2;
d = abs(d);
end

function name = cornerName(pos)
% convert a corner name or alias to legend-style naming
key = lower(regexprep(string(pos),'[\s_-]',''));
switch key
    case {"southwest","sw","bottomleft","bl","lowerleft"}
        name = "southwest";
    case {"southeast","se","bottomright","br","lowerright"}
        name = "southeast";
    case {"northwest","nw","topleft","tl","upperleft"}
        name = "northwest";
    case {"northeast","ne","topright","tr","upperright"}
        name = "northeast";
    otherwise
        error('mmAddScaleBar:badLocation', ...
            ['Unknown location "%s". Use "southwest", "southeast", ' ...
            '"northwest", or "northeast" (or "bottomleft", "br", etc.).'], string(pos))
end
end
