function [alignedSeg, rmse, worldTform] = mmMirrorAlign(fixedSeg, movingSeg, options)
%MMMIRRORALIGN  Mirror a segmentation (left <-> right) and align it to another
% Compares paired structures, like the left and right kidneys: mirrors the
% moving segmentation across the patient's midline (x -> -x), aligns it to
% the fixed segmentation with ICP (a rigid registration: rotation and
% translation only), and puts the result on the voxel grid of the fixed
% segmentation. Then you can compare the two with dice or mmSurfaceDistance.
%
% Usage:
%   alignedSeg = mmMirrorAlign(fixedSeg, movingSeg)
%   [alignedSeg, rmse, worldTform] = mmMirrorAlign(fixedSeg, movingSeg, Mirror=false)
%
% INPUTS
%   fixedSeg, movingSeg: structures from mmGetMedicalVolumeSegment (with the
%                        fields mask and tform). For example, the right and
%                        the left kidney
%
%   Name-Value options
%   - Mirror:        false aligns without mirroring (rotation and
%                    translation only). Default true
%   - MaxIterations: maximum number of ICP iterations. Default 100
%   - GridSize:      the surfaces are downsampled to this grid (mm) for
%                    ICP. Default 1
%
% OUTPUTS
%   alignedSeg: a structure like fixedSeg (fields mask, tform, spacing,
%               segName), with the mirrored and aligned moving
%               segmentation on the voxel grid of fixedSeg
%   rmse:       root-mean-square distance (mm) between the two surfaces
%               after ICP. Lower means a better fit
%   worldTform: the affinetform3d that maps the moving segmentation (mm)
%               onto the fixed segmentation (mm), mirror included
%
% EXAMPLE
%   rk = mmGetMedicalVolumeSegment(segMV, segT, segName="right kidney");
%   lk = mmGetMedicalVolumeSegment(segMV, segT, segName="left kidney");
%   lkOnRk = mmMirrorAlign(rk, lk);
%   mmSurfaceDistance(rk, lkOnRk, Names=["Right kidney" "Left kidney (mirrored)"], Direction="both")
%
% See also mmSurfaceDistance, mmGetMedicalVolumeSegment, pcregistericp

% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado Modern Human Anatomy
% UPDATED: 11/07/2026

arguments
    fixedSeg struct
    movingSeg struct
    options.Mirror (1,1) logical = true
    options.MaxIterations (1,1) {mustBeInteger, mustBePositive} = 100
    options.GridSize (1,1) {mustBePositive} = 1
end

if ~any(fixedSeg.mask(:)) || ~any(movingSeg.mask(:))
    error("mmMirrorAlign:empty", "A segmentation is empty.")
end

% surfaces, in mm
fixedVerts = mmGetSurface(fixedSeg.mask, transform=fixedSeg.tform, decimator=0.3).vertices;
movingVerts = mmGetSurface(movingSeg.mask, transform=movingSeg.tform, decimator=0.3).vertices;
fixedCenter = mean(fixedVerts);
movingCenter = mean(movingVerts);

% start: mirror across the midline (x -> -x), and move the center of the
% moving surface onto the center of the fixed surface
S = eye(3);
if options.Mirror
    S(1, 1) = -1;
end
startA = [S, fixedCenter' - S * movingCenter'; 0 0 0 1];
startVerts = transformPointsForward(affinetform3d(startA), movingVerts);

% ICP: rotate and translate for the best fit
fixedPC = pcdownsample(pointCloud(fixedVerts), "gridAverage", options.GridSize);
movingPC = pcdownsample(pointCloud(startVerts), "gridAverage", options.GridSize);
[icpTform, ~, rmse] = pcregistericp(movingPC, fixedPC, Metric="pointToPoint", ...
    MaxIterations=options.MaxIterations);
worldTform = affinetform3d(icpTform.A * startA); % moving mm -> fixed mm

% put the moving mask on the fixed voxel grid (nearest neighbor): for each
% fixed voxel near the aligned surface, find the moving voxel it came from
alignedVerts = transformPointsForward(worldTform, movingVerts);
alignedVox = transformPointsInverse(fixedSeg.tform, alignedVerts); % [col row slice]
sz = size(fixedSeg.mask);
gridSize = [sz(2) sz(1) sz(3)]; % [col row slice]
low = max(floor(min(alignedVox)) - 2, 1);
high = min(ceil(max(alignedVox)) + 2, gridSize);
[c, r, s] = ndgrid(low(1):high(1), low(2):high(2), low(3):high(3));
world = transformPointsForward(fixedSeg.tform, [c(:) r(:) s(:)]);
fromVox = round(transformPointsInverse(movingSeg.tform, transformPointsInverse(worldTform, world)));
msz = size(movingSeg.mask);
inside = all(fromVox >= 1, 2) & fromVox(:, 1) <= msz(2) & fromVox(:, 2) <= msz(1) & fromVox(:, 3) <= msz(3);
hit = false(numel(c), 1);
hit(inside) = movingSeg.mask(sub2ind(msz, fromVox(inside, 2), fromVox(inside, 1), fromVox(inside, 3)));

alignedMask = false(sz);
alignedMask(sub2ind(sz, r(hit), c(hit), s(hit))) = true;

alignedSeg = fixedSeg;
alignedSeg.mask = alignedMask;
for f = ["segName" "color" "volume"] % keep the moving segmentation's own name, color, and volume
    if isfield(movingSeg, f)
        alignedSeg.(f) = movingSeg.(f);
    end
end
end
