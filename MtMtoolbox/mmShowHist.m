function mmShowHist(img,col,num_cols,title_str,options)
%MMSHOWHIST Pairs Image with its histogram. Always displays the image above
%the histgram (two rows). If you input an RGB image, this function will automatically
%index out the channels and display the histogram for each channel
%   Uses subplot to show the image and the histogram
%   If an RGB image is input, separate channels are shown
% INPUTS
%   Required:
%       - img: an image matrix
%   Optional:
%       - col (default = 1): current column to position image
%       - num_cols (default = 1): total number of columns in the figure.
%       - title_str (default = empty): a string to title the image
%       - add_color (logical = false): if true add color 
% EXAMPLES
%   mmShowHist(img) — displays image above its histogram
%   mmShowHist(img, 2, 6) - displays the image and the histogram in the 2
%   column of a six column figure
% ---
% Author: Ernesto Salcedo, PhD
% Site: University of Colorado Modern Human Anatomy
% Updated: 09/10/2023

arguments
    img {mustBeNumeric}
    col(1,1) {mustBeNumeric} = 1
    num_cols(1,1) {mustBeNumeric} = 1
    title_str {mustBeText} = ''
    options.add_color(1,1) logical = false
end

if size(img,3)>1 % rgb
    num_cols = size(img,3);

    if num_cols ~= 3
        str_ch = "ch" + (1:num_cols);
    else
        str_ch = ["red", "green","blue"]; % default titles for RGB images
    end
    
    for n=1:num_cols
        i = img(:,:,n); % index out channel       

        title_str = str_ch(n);

        ax = subplot_display(i,n,num_cols,title_str);
        if options.add_color
            cm = mmGetChannelMap(n);
            colormap(ax,cm)
        end
    end
else % grayscale
    subplot_display(img,col,num_cols,title_str);
end

set(gcf,"Tag","mmShowHist")

    function iax = subplot_display(img,col,num_cols,title_str)
        
        iax = subplot(2,num_cols,col); % position image
        imshow(img,[]) % display image
        set(iax,Tag=sprintf('img%d',col))
        if ~isempty(title_str)
            title(title_str) % title image
        end

        hax = subplot(2,num_cols,col+num_cols); % position histogram
        imhist(img) % display histogram
        set(hax,Tag=sprintf('hist%d',col))
    end
end
