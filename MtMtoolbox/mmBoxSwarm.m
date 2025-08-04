function chart_handle = mmBoxSwarm(x,y,options)
%mmBoxSwarm plots data as a box chart swarm chart overlay
%
% INPUTS
%
%   - x: Optional Enter empty brackets to generate a series of ones
%   - y: Vector of Numeric ata

% OPTIONS
%   - PlotType - default is 'swarm', enter 'violin' for a violin plot
%
% AUTHOR
% CU Anschutz School of Medicine Modern Human Anatomy
% Ernesto Salcedo, PhD
% Updated, July 7, 2025


arguments (Input)
    x
    y {mustBeNumeric}
    options.PlotType = 'swarm'
    options.XAxVisible = 'off';
    options.MarkerFaceColor = 'flat';
    options.MarkerFaceAlpha=0.25;
    options.doBoxPlot = true;
    options.BoxFaceColor = [];
    options.BoxFaceAlpha = 0.1;
    options.Notch = 'off';
    options.XJitterWidth {mustBeFloat} = 1  % jitter width
end

if isempty(x)
    x = ones(1,numel(y));
else
    options.XAxVisible = 'on';
end

hold on

switch options.PlotType
    case 'violin'
        hc(1) = violinplot(x,y);
    otherwise
        hc(1) = swarmchart(x,y,'filled',...
            MarkerFaceColor=options.MarkerFaceColor,...
            MarkerFaceAlpha=options.MarkerFaceAlpha, ...
            XJitterWidth=options.XJitterWidth); % swarm
end

if options.doBoxPlot
    if isempty(options.BoxFaceColor)
        hc(2) = boxchart(x,y,Notch=options.Notch); % box
    else
        hc(2) = boxchart(x,y,BoxFaceColor=options.BoxFaceColor,BoxFaceAlpha=options.BoxFaceAlpha,...
            Notch=options.Notch); % box
    end
end

% set X Axis visibility
ax = gca;
ax.XAxis.Visible=options.XAxVisible;


if nargout>0
    chart_handle = hc; % Assign the handle to the output variable
end

end