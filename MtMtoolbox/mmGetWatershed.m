function [BW,pLd1] = mmGetWatershed(BW, PixSz, options)
%MMGETWATERSHED Separate touching objects in a mask using the watershed transform
%   BW = MMGETWATERSHED(BW) splits touching objects in the 2D or 3D logical
%   mask BW using a minimum basin depth of 3.
%
%   BW = MMGETWATERSHED(BW,PixSz) uses the minimum basin depth PixSz. If
%   PixSz is a vector, the watershed is run once for each value, in order.
%
%   [BW,pLd1] = MMGETWATERSHED(___) also returns the watershed label
%   matrix from the last pass.
%
%   How it works (for each value in PixSz):
%     1. Compute the distance transform of the background, bwdist(~BW), and
%        invert it, so the center of each object becomes the bottom of a
%        basin. Where two objects touch, the basins meet at a narrow "neck".
%     2. Use imextendedmin to keep only the basins at least PixSz deep, and
%        impose them as the only minima (imimposemin). This stops the
%        watershed from splitting one object at every small dip.
%     3. Run the watershed transform, which floods the basins and draws
%        dividing lines where they meet. Pixels on those lines are set to
%        false, which separates the objects.
%   Based on: https://blogs.mathworks.com/steve/2013/11/19/watershed-transform-question-from-tech-support/
%
% INPUTS
%   - BW:     logical 2D or 3D array (the mask to separate)
%   - PixSz:  minimum basin depth, in pixels (2D) or voxels (3D) of distance.
%             An object is split from its neighbor only if its center is at
%             least PixSz pixels farther from the background than the
%             narrowest point of the neck joining them. Passed to
%             imextendedmin as H.
%               - Larger values split fewer objects (conservative; less
%                 risk of cutting one object into pieces).
%               - Smaller values split more objects (aggressive; separates
%                 tightly fused objects).
%             A vector, e.g. [5 3 1], runs several passes from conservative
%             to aggressive. Default: 3
% OPTIONAL (name-value)
%   - conn:      connectivity passed to imextendedmin and watershed
%                (e.g. 4 or 8 in 2D; 6, 18, or 26 in 3D). Default: 0, which
%                uses the MATLAB defaults (8 in 2D, 26 in 3D).
%   - ShowSteps: logical - if true, display each pass in a figure (2D only):
%                the inverted distance transform, the watershed regions with
%                the chosen basins overlaid, and the mask before vs. after
%                (imshowpair). Default: false
%
% OUTPUTS
%   - BW:   the mask with touching objects separated
%   - pLd1: watershed label matrix from the last pass, before it is
%           masked to BW (each basin has its own label; dividing lines are 0)
%
% EXAMPLES
% BW = mmGetWatershed(BW,5);                 % one pass, basin depth 5
% BW = mmGetWatershed(BW,5,conn=4);          % 4-connectivity (2D)
% BW = mmGetWatershed(BW,5,ShowSteps=true);  % display the steps
% BW = mmGetWatershed(BW,[5 3 1]);           % three passes, depths 5, 3, then 1
%
% See also bwdist, imextendedmin, imimposemin, watershed
% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado Modern Human Anatomy
% UPDATED: 10-18-26

arguments
    BW (:,:,:)
    PixSz (1,:) {isnumeric} = 3 % minimum basin depth: a scalar or a vector (one pass per value)
    options.conn = 0 % 0 = use MATLAB's default connectivity
    options.ShowSteps = false;
end

cols = 3; % ShowSteps: 3 panels per pass

if options.ShowSteps
    if ismatrix(BW)
        figure(Visible="on")
        tiledlayout(numel(PixSz),cols,"TileSpacing","none") % one row per pass
        ax = gobjects(numel(PixSz)*cols);
    else
        options.ShowSteps = false;
        warning('Can''t Show Steps for 3D volumes')
    end
end

tile_idx = 1;
for n=PixSz % one watershed pass per basin depth
    D1 = -bwdist(~BW); % distance to background, inverted: object centers become basins

    % keep only basins at least n deep (shallower basins merge with their neighbors)
    if options.conn
        ixm = imextendedmin(D1,n,options.conn);
    else
        ixm = imextendedmin(D1,n);
    end

    D1 = imimposemin(D1,ixm); % make the chosen basins the only minima, so each one becomes a single region

    % D1 = imhmin(D1,3); % may not currently run

    % flood the basins; dividing lines between basins are labeled 0
    if options.conn
        Ld1 = watershed(D1,options.conn);
    else
        Ld1 = watershed(D1);
    end

    pBW = BW; % mask before this pass (for ShowSteps)
    pLd1 = Ld1; % label matrix before masking (returned as the 2nd output)
    Ld1(~BW) = 0; % ignore labels outside the mask
    BW(Ld1 == 0) = 0; % cut the mask along the dividing lines

    if options.ShowSteps
        % panel 1: inverted distance transform (dark = basin)
        ax(tile_idx) =  nexttile(tile_idx);
        imshow(D1,[])
        ylabel(sprintf('PixSz=%d',n))

        % panel 2: watershed regions, with the chosen basins overlaid
        ax(tile_idx+1) = nexttile(tile_idx+1);
        burnedImage = imoverlay(label2rgb(pLd1,turbo(max(pLd1(:)))),ixm);
        imshow(burnedImage)

        % nexttile(tile_idx+2)
        % imshowpair(BW,label2rgb(Ld1))

        % panel 3: mask before vs. after this pass (cut pixels show in color)
        ax(tile_idx+2) = nexttile(tile_idx+2);
        imshowpair(pBW, BW)
    end
    tile_idx = tile_idx+cols;
end

if options.ShowSteps
    linkaxes(ax,'xy') % zoom and pan all panels together
    impixelinfo
end

end
