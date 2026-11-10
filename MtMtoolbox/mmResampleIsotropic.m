function [mV, segMV] = mmResampleIsotropic(mV, segMV, options)
%MMRESAMPLEISOTROPIC  Resample a volume and its segmentation to isotropic voxels
% Many scans have voxels that are longer in one direction (for example
% 0.9 x 0.9 x 3 mm). Functions that measure in voxels (regionprops3,
% volshow, bwdist) then give distorted results. This function resamples
% the intensity volume to isotropic voxels (the same size in all three
% directions), and puts the segmentation on exactly the same voxel grid.
% It does the same job as resampling in Slicer, but without changing your
% files.
% If the voxels are already isotropic, it returns your inputs unchanged.
%
% Usage:
%   mV = mmResampleIsotropic(mV)
%   [mV, segMV] = mmResampleIsotropic(mV, segMV)
%   [mV, segMV] = mmResampleIsotropic(mV, segMV, Segments=segT)
%   [mV, segMV] = mmResampleIsotropic(mV, segMV, VoxelSize=1)
%
% INPUTS
%   mV:    medicalVolume of the intensity volume (CT or MRI)
%   segMV: (optional) medicalVolume of the segmentation of that volume.
%          It can have layers (4-D voxels)
%
%   Name-Value options
%   - VoxelSize: the size of the new voxels, in mm. Default: the smallest
%                voxel dimension of mV (no detail is lost)
%   - Segments:  the segment table from mmGetSlicerSegmentInfo. Only used
%                to show the segment names in the report
%   - Method:    interpolation of the intensity volume: "linear" (default),
%                "cubic", or "nearest"
%
% OUTPUTS
%   mV:    medicalVolume with isotropic voxels. The volume covers the same
%          space as before
%   segMV: the segmentation on the same voxel grid as mV. The label values
%          don't change, so your segment table (segT) is still valid
%
% HOW THE SEGMENTATION IS RESAMPLED
%   Label values are names, not amounts, so they can't be averaged: each
%   new voxel takes the label of the nearest old voxel. Large segments
%   barely change. Small or thin segments can change by a few percent, and
%   surfaces can look stepped along the direction of the long voxels. The
%   function reports the volume of each segment before and after.
%
% EXAMPLE
%   ctMV = medicalVolume("CTACardio.nrrd");
%   segMV = medicalVolume("Salcedo Segmentation.seg.nrrd");
%   segT = mmGetSlicerSegmentInfo("Salcedo Segmentation.seg.nrrd");
%   ctMV.VoxelSpacing     % three different numbers: not isotropic
%   [ctMV, segMV] = mmResampleIsotropic(ctMV, segMV, Segments=segT);
%   ctMV.VoxelSpacing     % three equal numbers
%
% See also mmCollapseSegmentLayers, mmMatchVolumeGeometry, medicalVolume/resample

% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado Modern Human Anatomy
% UPDATED: 11/10/2026

arguments
    mV medicalVolume
    segMV = []
    options.VoxelSize double {mustBeScalarOrEmpty, mustBePositive} = []
    options.Segments table = table()
    options.Method (1,1) string {mustBeMember(options.Method, ["linear" "cubic" "nearest"])} = "linear"
end
if ~isempty(segMV) && ~isa(segMV, "medicalVolume")
    error("mmResampleIsotropic:segMV", "The second input must be the medicalVolume of the segmentation.")
end
if ndims(mV.Voxels) ~= 3
    error("mmResampleIsotropic:size", "The intensity volume must be 3-D, not %d-D.", ndims(mV.Voxels))
end
tol = 1e-3; % relative tolerance for "the same voxel size"

% --- the intensity volume
R = mV.VolumeGeometry;
A = intrinsicToWorldMapping(R).A;
spacing = vecnorm(A(1:3, 1:3)); % voxel size along intrinsic x (columns), y (rows), z (slices)
newSize_mm = options.VoxelSize;
if isempty(newSize_mm)
    newSize_mm = min(spacing);
end

if all(abs(spacing - newSize_mm) <= tol * newSize_mm)
    fprintf("mmResampleIsotropic: the voxels are already %.4g mm in all directions. The intensity volume is unchanged.\n", newSize_mm)
    newR = R;
else
    oldSize = R.VolumeSize; % [rows columns slices]
    extent_mm = oldSize([2 1 3]) .* spacing; % along x, y, z
    n = max(round(extent_mm / newSize_mm), 1); % number of new voxels along x, y, z
    newA = A;
    newA(1:3, 1:3) = A(1:3, 1:3) ./ spacing * newSize_mm; % same directions, new voxel size
    corner = A * [0.5; 0.5; 0.5; 1]; % the outer corner of the first voxel stays where it is
    newA(1:3, 4) = corner(1:3) - newA(1:3, 1:3) * [0.5; 0.5; 0.5];
    newR = medicalref3d(n([2 1 3]), affinetform3d(newA));
    newR = updatePatientCoordinateSystem(newR, R.PatientCoordinateSystem);

    mV = resampleVolume(mV.Voxels, R, newR, options.Method);
    fprintf("mmResampleIsotropic: resampled the intensity volume\n")
    fprintf("  voxel size: %s mm  ->  %.4g mm isotropic\n", strjoin(compose("%.4g", spacing([2 1 3])), " x "), newSize_mm)
    fprintf("  size:       %s  ->  %s voxels\n", strjoin(string(oldSize), " x "), strjoin(string(newR.VolumeSize), " x "))
end

% --- the segmentation
if isempty(segMV)
    return
end
segR = segMV.VolumeGeometry;
if isequal(segR.VolumeSize, newR.VolumeSize) && ...
        max(abs(intrinsicToWorldMapping(segR).A - intrinsicToWorldMapping(newR).A), [], "all") <= tol * newSize_mm
    fprintf("  The segmentation is already on the voxel grid of the intensity volume: unchanged.\n")
    return
end

V = segMV.Voxels;
numLayers = size(V, 4);
before = countVoxels(V) * prod(segMV.VoxelSpacing) / 1000; % mL
out = zeros([newR.VolumeSize numLayers], class(V));
for layer = 1:numLayers % nearest neighbor: every new voxel takes an existing label
    layerMV = resampleVolume(V(:, :, :, layer), segR, newR, "nearest");
    out(:, :, :, layer) = layerMV.Voxels;
end
segMV = medicalVolume(out, newR);
after = countVoxels(out) * newSize_mm^3 / 1000;

fprintf("  Resampled the segmentation to the same voxel grid (nearest neighbor). Segment volumes:\n")
segT = options.Segments;
hasNames = all(ismember(["SegName" "Layer" "LabelValue"], segT.Properties.VariableNames));
change = 100 * (after - before) ./ before; % percent
showAll = nnz(before) <= 15; % many segments: only list the ones that changed by more than 2%
if ~showAll
    fprintf("  (%d segments: only those that changed by more than 2%% are listed)\n", nnz(before))
end
for layer = 1:numLayers
    for label = find(before(:, layer) > 0)'
        if ~showAll && abs(change(label, layer)) <= 2
            continue
        end
        name = sprintf("label %d", label);
        if numLayers > 1
            name = sprintf("layer %d, label %d", layer, label);
        end
        if hasNames
            row = segT.Layer == layer & segT.LabelValue == label;
            if any(row)
                name = segT.SegName(find(row, 1));
            end
        end
        fprintf("  - %s: %.2f mL  ->  %.2f mL (%+.1f%%)\n", name, before(label, layer), after(label, layer), change(label, layer))
    end
end
end

function outMV = resampleVolume(V, R, newR, method)
% Resample the voxels V (with geometry R) to the geometry newR.
% The volume is first padded with a copy of its outer voxels, so that the
% outer half of the edge voxels is not lost
A = intrinsicToWorldMapping(R).A;
A(1:3, 4) = A(1:3, 4) - A(1:3, 1:3) * [1; 1; 1]; % the first voxel is now a padding voxel
padR = medicalref3d(size(V, 1:3) + 2, affinetform3d(A));
padR = updatePatientCoordinateSystem(padR, R.PatientCoordinateSystem);
padMV = medicalVolume(padarray(V, [1 1 1], "replicate"), padR);
outMV = resample(padMV, newR, Method=method);
end

function counts = countVoxels(V)
% number of voxels of each label value (rows) in each layer (columns)
numLabels = double(max(V, [], "all"));
counts = zeros(max(numLabels, 1), size(V, 4));
for layer = 1:size(V, 4)
    L = V(:, :, :, layer);
    L = double(L(L > 0));
    if ~isempty(L)
        counts(:, layer) = accumarray(L, 1, [max(numLabels, 1) 1]);
    end
end
end
