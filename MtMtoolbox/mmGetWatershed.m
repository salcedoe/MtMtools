function BW = mmGetWatershed(BW, PixSz, options)
%MMGETWATERSHED performs the necessary steps to properly watershed an image
% for more info, see here: http://blogs.mathworks.com/steve/2013/11/19/watershed-transform-question-from-tech-support/
%
% INPUTS
%   - BW:  logical 3D array
%   - PixSz: Pixel Size of the extended regional minima inside the blob you are 
%           trying to separate. The smaller the value, the smaller the  
%           extended regional minima - see imextendedmin
% OPTIONAL
%   - conn: connectivity  - see imextendedmin
%   - ShowSteps: boolean - display watershed steps
%
%
% EXAMPLES
% BW = mmGetWatershed(BW,5);
% BW = mmGetWatershed(BW,5,8);
% BW = mmGetWatershed(BW,[5 3 1]); % runs the watershed multiple times
% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado Modern Human Anatomy
% UPDATED: 07-29-25

arguments
    BW (:,:,:)
    PixSz (1,:) {isnumeric} = 3 % a scalar or vector 
    options.conn = 0
    options.ShowSteps = false;    
end

cols = 3;

if options.ShowSteps
    figure(Visible="on")
    tiledlayout(numel(PixSz),cols,"TileSpacing","none")
    ax = gobjects(numel(PixSz)*cols);
end

tile_idx = 1;
for n=PixSz % repeat each PixSz element
    D1 = -bwdist(~BW); % distance transform and invert

    if options.conn
        ixm = imextendedmin(D1,n,options.conn); % merges minima points
    else
        ixm = imextendedmin(D1,n);
    end

    D1 = imimposemin(D1,ixm); % add minima only where its non zero

    % D1 = imhmin(D1,3); % may not currently run

    if options.conn
        Ld1 = watershed(D1,options.conn);
    else
        Ld1 = watershed(D1); % watershed transform
    end

    pBW = BW; %previous mask
    pLd1 = Ld1; % previous watershed transform
    Ld1(~BW) = 0;
    BW(Ld1 == 0) = 0; % watershed segmentation

    if options.ShowSteps
        ax(tile_idx) =  nexttile(tile_idx);
        imshow(D1,[])
        ylabel(sprintf('PixSz=%d',n))

        ax(tile_idx+1) = nexttile(tile_idx+1);
        burnedImage = imoverlay(label2rgb(pLd1,turbo(max(pLd1(:)))),ixm);
        imshow(burnedImage)
        
        % nexttile(tile_idx+2)
        % imshowpair(BW,label2rgb(Ld1))

        ax(tile_idx+2) = nexttile(tile_idx+2);
        imshowpair(pBW, BW)
    end
    tile_idx = tile_idx+cols;
end

if options.ShowSteps
    linkaxes(ax,'xy')
    impixelinfo
end

end