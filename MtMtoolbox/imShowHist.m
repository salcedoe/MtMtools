function  ha = imShowHist( IMG , varargin)
%IMSHOWHIST Displays image channels and their histograms
% 
% Generates a figure with two rows
%       TOP ROW: images
%       BOTTOM ROW: histograms
%
% OPTIONAL INPUTS: 
%        - 'split': split RGB into composite channels
%        - 'color': show channels in color
%        - 'norm': normalizes the image first using mat2gray
%
% OUTPUTS: ha - handle arry to figure axes
%
% EXAMPLES:
%
% imshowhist(IMG) - displays the image and its histogram
% imshowhist(IMG,'split') - displays the image channels and the
%                           corresponding histograms
% imshowhist(IMG, 'norm','split','color') - normalizes the image, displays
%                                           the image channels and hists,
%                                           and shows the channels in their
%                                           channel color
%
% Dependencies: tight_subplot, get_channel_map, nexttile
% ---
% Author: Ernesto Salcedo, PhD.
% Created: 1-Sep-2017
% Updated: 18-Sep-2020

warning('imShowHist is deprecated.')

% create options structure
fn = {'ch_show_color', 'ch_split','ch_normalize'};
for n = 1:numel(fn)
    options.(fn{n}) = false;
end

% IMG = im2uint8(IMG);

% set options
if nargin>1
    options.ch_split = any(contains(varargin,'split'));
    options.ch_show_color = any(contains(varargin,'color')); 
    options.ch_normalize = any(contains(varargin,'norm'));
end

% set colormap and channels array
if ismatrix(IMG) % is 2D?
    ch_name = {'grayscale'};
    options.ch_show_color = false;
else % so, 3D?
    if options.ch_split
        ch_name = {'red', 'green','blue'};
    else     
        ch_name = {inputname(1)};
    end
end

rows = 2;
cols = numel(ch_name);

figure(Visible="on");
ha = tight_subplot(rows, cols);
ha_offset = numel(ha)/2;

% display channels
for n=1:numel(ch_name)
    
    if options.ch_normalize
       img = mat2gray(IMG(:,:,n));
    elseif options.ch_split
        img = IMG(:,:,n);
    else
        img = IMG;
    end
    
    % display image
    axes(ha(n))    
    if options.ch_show_color       
        imshow(img,get_channel_map(n));
    else
        imshow(img)
    end
    
    title(ch_name{n},'Interpreter','none')
    
    % display histogram
    axes(ha(n+ha_offset))
    if options.ch_split
        imhist(img)
        if n>1
            yticks([])
        end
    else
        imhistcolor(img)
    end
         
end
end

