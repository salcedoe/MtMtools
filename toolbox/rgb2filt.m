function rgbf = rgb2filt(rgb, nbhd, fltr)
%RGB2MEDFILT2 applies a median filter to each channel of an RGB image
%   INPUTS:
%       - rgb: an rgb truecolor image
%       - nbhd: median: a 1X2 matrix indicating the size neighborhood kernel you
%       want to use; gaussian: the sigma you want to use
%       - fltr: filter to employ ('median' or 'gauss'
%   OUTPUTS:
%       - rgbf: the filtered rgb image
%
%   EXAMPLE:
% rgbf = rgb2medfilt2(rgb, [5 5]);
% ---
% Author: Ernesto Salcedo, PhD. CU School of Medicine
% Created: 4-Oct-2020
% Updated: 4-Oct-2020

rgbf = rgb;

for n=1:3    
    switch fltr
        case 'median'
            
            rgbf(:,:,n) = medfilt2(rgb(:,:,n),nbhd);
            
        case {'gauss','gaussian'}
            rgbf(:,:,n) = imgaussfilt(rgb(:,:,n),nbhd);
            
        otherwise
            return
    end
end
end


