function BW = mmGetWatershed(BW, EXMIN, options)
%MMGETWATERSHED performs the necessary steps to properly watershed an image
% for more info, see here: http://blogs.mathworks.com/steve/2013/11/19/watershed-transform-question-from-tech-support/
%
% INPUTS
% BW:  logical 3D array
% EXMIN: H-minima transform (size of transform) - see imextendedmin
% OPTIONAL
% conn: connectivity  - see imextendedmin
%
% EXAMPLES
% BW = mmGetWatershed(BW,5);
% BW = mmGetWatershed(BW,5,8);
% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado Modern Human Anatomy
% UPDATED: 07-29-23

arguments
    BW (:,:,:)
    EXMIN (1,1) = 3
    options.conn = 0
end

D1 = -bwdist(~BW); % distance transform and invert

if options.conn
    ixm = imextendedmin(D1,EXMIN,options.conn); % merges minima points
else
    ixm = imextendedmin(D1,EXMIN);
end

D1 = imimposemin(D1,ixm); % add minima only where its non zero

% D1 = imhmin(D1,3); % may not currently run

if options.conn
    Ld1 = watershed(D1,options.conn);
else
    Ld1 = watershed(D1); % watershed transform
end

Ld1(~BW) = 0;
BW(Ld1 == 0) = 0; % watershed segmentation

end