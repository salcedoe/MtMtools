function [ img ] = imread_jsrt( im_path )
%imopen_jsrt Opens images in the Japanese Society of Radiological Technology
%   http://www.jsrt.or.jp/jsrt-db/eng.php
% Code courtesy of  google 'matlab raw images', 12 bit image

% significant bit = 12
im_size = [2048 2048]; % all images 2048 X 2048
fid=fopen(im_path); % opens the file
img = fread(fid, im_size, 'uint16=>uint16',0,'b')'; % switch to big-endian
imgn = double(img) / 4095; % normalize
img = imcomplement(imgn); % get the complement (white = 1)    imshow(img)
end

