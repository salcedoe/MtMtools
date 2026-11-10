function mVout = mmMatchVolumeGeometry(mV,refMV,options)
%MMMATCHVOLUMEGEOMETRY Put a segmentation volume on the voxel grid of a
%   reference volume, by adding or removing slices at the edges
%
% Use this when a Slicer segmentation has a slightly different size than
% the volume it was made from (for example, one extra empty slice from
% TotalSegmentator in Slicer 5.13). Both volumes must have the same voxel
% spacing and orientation, and their grids must line up: the function only
% pads or crops, it never interpolates.
%
% INPUTS
%
% - mV    (required):   medicalVolume to fix (usually a segmentation)
% - refMV (required):   medicalVolume with the geometry to match (usually
%                       the intensity volume the segmentation was made from)
% - Tolerance (optional): allowed mismatch, as a fraction of a voxel.
%                       Default 0.01
%
% OUTPUTS
%
% mVout: medicalVolume with the same size and geometry as refMV. Slices
%        that were added are zeros. A warning is issued if any removed
%        slices contained segmented (non-zero) voxels
%
% EXAMPLE
%
%   totalMV = medicalVolume(paths.total);
%   totalMV = mmMatchVolumeGeometry(totalMV, ctMV);
%
% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado Modern Human Anatomy
% UPDATED: 11/01/2026

arguments
    mV medicalVolume
    refMV medicalVolume
    options.Tolerance (1,1) double {mustBePositive} = 0.01
end

R = mV.VolumeGeometry;
refR = refMV.VolumeGeometry;
refSize = refR.VolumeSize;

% same voxel spacing and orientation?
A = intrinsicToWorldMapping(R).A;
refA = intrinsicToWorldMapping(refR).A;
if max(abs(A(1:3,1:3) - refA(1:3,1:3)), [], "all") > options.Tolerance * min(refMV.VoxelSpacing)
    error("mmMatchVolumeGeometry:spacing", ...
        "The volumes have different voxel spacing or orientation. Use mmResampleIsotropic (or resample the segmentation in Slicer) instead.")
end

% where is the first voxel of mV in the reference grid?
[x, y, z] = intrinsicToWorld(R, 1, 1, 1);
[i, j, k] = worldToIntrinsic(refR, x, y, z);
offset = [i j k] - 1; % [row col slice] shift of mV relative to refMV
if any(abs(offset - round(offset)) > options.Tolerance)
    error("mmMatchVolumeGeometry:grid", ...
        "The voxel grids of the volumes don't line up. Use mmResampleIsotropic (or resample the segmentation in Slicer) instead.")
end
offset = round(offset);

if ~isnumeric(mV.Voxels)
    error("mmMatchVolumeGeometry:voxels", "mV.Voxels must be a numeric array.")
end
V = mV.Voxels;
sz = size(V, 1:3);

if isequal(offset, [0 0 0]) && isequal(sz, refSize)
    mVout = mV; % already matches
    return
end

% overlapping index range, in mV and in the reference grid
srcFirst = max(1, 1 - offset);
srcLast = min(sz, refSize - offset);
if any(srcLast < srcFirst)
    error("mmMatchVolumeGeometry:noOverlap", "The volumes don't overlap.")
end
dstFirst = srcFirst + offset;
dstLast = srcLast + offset;

% warn if any segmented voxels fall outside the reference volume
nKept = nnz(V(srcFirst(1):srcLast(1), srcFirst(2):srcLast(2), srcFirst(3):srcLast(3), :));
nLost = nnz(V) - nKept;
if nLost > 0
    warning("mmMatchVolumeGeometry:cropped", ...
        "%d segmented voxels were outside the reference volume and were removed.", nLost)
end

Vout = zeros([refSize size(V, 4)], "like", V); % keep any layers (4th dimension)
Vout(dstFirst(1):dstLast(1), dstFirst(2):dstLast(2), dstFirst(3):dstLast(3), :) = ...
    V(srcFirst(1):srcLast(1), srcFirst(2):srcLast(2), srcFirst(3):srcLast(3), :);

fprintf("mmMatchVolumeGeometry: resized volume from %s to %s\n", ...
    mat2str(size(V, 1:3)), mat2str(refSize))
mVout = medicalVolume(Vout, refR);

end
