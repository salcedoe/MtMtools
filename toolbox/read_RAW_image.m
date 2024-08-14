function [RAW,metadata] = read_RAW_image(im_file)
%READ_RAW_IMAGE read a raw image captured using a Sony DSLR camera
%   INPUT:
%           file_path - path to raw image (.dng file)
%   OUTPUT:
%           RAW - raw image
%           META - metadata to raw image
% ---
% Author: Ernesto Salcedo, PhD.
% Created: 1-Sep-2017
% Updated: 18-Sep-2020

if nargin == 0
    [file, path] = uigetfile('*.*');
    im_file = fullfile(path,file);
end

warning off

t = Tiff(im_file,'r'); % create a tiff object
offsets = getTag(t,'SubIFD'); % find the saved image
t.setSubDirectory(offsets(3));
RAW = t.readRGBAImage(); % second out is A
metadata = imfinfo(im_file);

warning on

end


