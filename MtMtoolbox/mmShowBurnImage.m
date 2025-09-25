function mmShowBurnImage(img,mask,options)
%MMSHOWBURNIMAGE - simplifies creating a burned image, where a masked is
%burned into an image using the function imoverlay
% INPUTS
% - img: a grayscale or rgb image
% - mask: a binary mask
% OPTIONS
% - color: the color of the burned image (default = yellow)
% 
% EXAMPLES
% mmShowBurn(rgb,mask)
% mmShowBurn(rgb,mask,color='white')

% Author: Ernesto Salcedo, PhD
% Site: University of Colorado Modern Human Anatomy
% Updated: 10/01/2024

arguments
    img
    mask (:,:) {mustBeNumericOrLogical}
    options.color {mustBeText} = '';
end

if isempty(options.color)
    burnedImage = imoverlay(img,mask);
else
    burnedImage = imoverlay(img,mask,options.color);
end

imshow(burnedImage)

end