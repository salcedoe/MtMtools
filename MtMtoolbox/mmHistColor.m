function mmHistColor(varargin)
%MMHISTCOLOR - overlays the channel histograms from an RGB image using
%either stem or area plot
%
% mmHistColor(RGB) - DEFAULT - plot an area plot of each channel's histogram
% histogram and modifies the transparence
%
% EXAMPLES:
%
% mmHistColor(RGB,'stem') - plots a stem plot of the histograms
% mmHistColor(RGB,'area') - plots an area plot of histograms (the default)
%
% ---
% Author: Ernesto Salcedo, PhD. University of Colorado School of Medicine
% Created: 1-Sep-2017
% Updated: 18-Sep-2020


% set default values
alpha = 0.75; % default transparency setting
plot_type = 'area'; % default plot type

% count inputs
input_count = numel(varargin); % varargin - cell array containing all the inputs

if ~isnumeric(varargin{1})
    error('first input must be a numeric variable')
end

switch input_count
    case 2
        if ischar(varargin{2}) && strcmpi(varargin{2},'stem')
            plot_type = 'stem'; % stem plot type
        elseif isnumeric(varargin{2}) && varargin{2} < 1
            alpha = varargin{2};
        end
end

% % test the second input (if there's one)
% if input_count == 2 && strcmpi(varargin{2},'stem') % must be the char 'stem'
%     plot_type = 'stem'; % stem plot type
% end

% if inputs check out, get image
IMG = varargin{1};

% Overlays the histogram from the three channels of an rgb image
channels = 'rgb';
x=0; % initialize x

for ch= size(IMG,3):-1:1 %plot in reverse channel order (so blue is in back)
    
    [counts, x] = imhist(IMG(:,:,ch)); % returns the counts and the x locations
    
    switch plot_type
        case 'stem'
            x = x+ch/10;
            stem(x, counts,'Color', channels(ch), 'Marker','.')
        case 'area'
            area(x,counts,'FaceColor',channels(ch), 'FaceAlpha',alpha)
        otherwise
            area(x,counts,'FaceColor',channels(ch), 'FaceAlpha',alpha)
    end
    hold on
end
xlim([0 x(end)]) % tighten up the
hold off
end