function [segMV, segT, overlapT] = mmCollapseSegmentLayers(segMV, segT, options)
%MMCOLLAPSESEGMENTLAYERS  Collapse the layers of a Slicer segmentation into one label volume
% Slicer saves a segmentation in more than one layer when its segments
% overlap (or when they were created in separate layers). MATLAB then
% loads the voxels as a 4-D array, with one label volume per layer, and
% functions that expect one 3-D label volume (regionprops3, categorical,
% labeloverlay, mmMatchVolumeGeometry) fail.
%
% This function combines the layers into one 3-D label volume, with the
% same result as collapsing the layers in Slicer, but without changing
% your file.
% If the segmentation has only one layer, it returns your inputs unchanged.
%
% Usage:
%   [segMV, segT] = mmCollapseSegmentLayers(segMV, segT)
%   [segMV, segT, overlapT] = mmCollapseSegmentLayers(segMV, segT)
%   [segMV, segT] = mmCollapseSegmentLayers(segMV, segT, OutputFile="Collapsed.seg.nrrd")
%
% INPUTS
%   segMV: medicalVolume of a Slicer segmentation (.seg.nrrd)
%   segT:  the segment table of that file, from mmGetSlicerSegmentInfo
%
%   Name-Value options
%   - OutputFile: also save the collapsed segmentation as a new .seg.nrrd
%                 file, which Slicer can open. Default "" (don't save)
%
% OUTPUTS
%   segMV:    medicalVolume with one 3-D label volume, and the same
%             geometry (voxel size, orientation, and position)
%   segT:     the updated segment table. The label values are renumbered:
%             each segment's LabelValue is now its row number, and every
%             Layer is 1. The names and colors don't change
%   overlapT: a table of the voxels that were overwritten (empty if the
%             segments don't overlap)
%
% OVERLAPPING SEGMENTS
%   One voxel can hold only one label. Where two segments overlap, the
%   segment in the HIGHER layer wins (see the Layer column of segT), and
%   the other segment loses those voxels. This is the rule that Slicer
%   uses. The function tells you which segments lost voxels, and how many.
%   If the overlap matters for your analysis (for example, two
%   segmentations of the same tumor), don't collapse: use
%   mmGetMedicalVolumeSegment, which reads each segment from its own layer.
%
% EXAMPLE
%   segMV = medicalVolume("Salcedo Segmentation.seg.nrrd");
%   segT = mmGetSlicerSegmentInfo("Salcedo Segmentation.seg.nrrd");
%   size(segMV.Voxels)     % 4 numbers: the segmentation has layers
%   [segMV, segT] = mmCollapseSegmentLayers(segMV, segT);
%   size(segMV.Voxels)     % 3 numbers
%
% See also mmGetSlicerSegmentInfo, mmGetMedicalVolumeSegment, mmWriteNRRD

% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado Modern Human Anatomy
% UPDATED: 11/09/2026

arguments
    segMV medicalVolume
    segT table
    options.OutputFile (1,1) string = ""
end

overlapT = table(strings(0,1), strings(0,1), zeros(0,1), zeros(0,1), ...
    VariableNames=["Segment" "OverwrittenBy" "NumVoxels" "Volume_mL"]);

V = segMV.Voxels;
needed = ["SegName" "Layer" "LabelValue"];
if ~all(ismember(needed, segT.Properties.VariableNames))
    error("mmCollapseSegmentLayers:segT", "segT must be the table from mmGetSlicerSegmentInfo (with SegName, Layer, and LabelValue).")
end

if ndims(V) == 3 % only one layer: nothing to do
    if options.OutputFile ~= ""
        mmWriteNRRD(options.OutputFile, segMV, Segments=segT);
    end
    return
end
if ndims(V) ~= 4
    error("mmCollapseSegmentLayers:size", "The voxels must be a 3-D or 4-D array, not %d-D.", ndims(V))
end
if max(segT.Layer) > size(V, 4)
    error("mmCollapseSegmentLayers:mismatch", ...
        "segT has %d layers, but the volume has %d. Do segMV and segT come from the same file?", max(segT.Layer), size(V, 4))
end

numSegments = height(segT);
if numSegments <= 255
    out = zeros(size(V, 1:3), "uint8");
else
    out = zeros(size(V, 1:3), "uint16");
end
voxel_mL = prod(segMV.VoxelSpacing) / 1000;

[~, order] = sort(segT.Layer); % layer by layer, like Slicer: a higher layer overwrites a lower one
for k = order'
    mask = V(:, :, :, segT.Layer(k)) == segT.LabelValue(k);
    under = out(mask); % what is already in these voxels
    under = under(under > 0);
    if ~isempty(under)
        lost = accumarray(double(under), 1, [numSegments 1]); % voxels lost by each earlier segment
        rows = find(lost);
        overlapT = [overlapT; table(segT.SegName(rows), repmat(segT.SegName(k), numel(rows), 1), ...
            lost(rows), lost(rows) * voxel_mL, VariableNames=overlapT.Properties.VariableNames)]; %#ok<AGROW>
    end
    out(mask) = k;
end

numLayers = size(V, 4);
segMV = medicalVolume(out, segMV.VolumeGeometry);
segT.Layer(:) = 1;
segT.LabelValue = (1:numSegments)';

fprintf("mmCollapseSegmentLayers: collapsed %d layers into 1 (%d segments).\n", numLayers, numSegments)
if isempty(overlapT)
    fprintf("  The segments don't overlap: no voxels were overwritten.\n")
else
    fprintf("  Some segments overlap. Where they do, the segment in the higher layer won (as in Slicer):\n")
    for r = 1:height(overlapT)
        fprintf("  - %s lost %d voxels (%.2f mL) to %s\n", overlapT.Segment(r), overlapT.NumVoxels(r), ...
            overlapT.Volume_mL(r), overlapT.OverwrittenBy(r))
    end
end

if options.OutputFile ~= ""
    mmWriteNRRD(options.OutputFile, segMV, Segments=segT);
    fprintf("  Saved as %s\n", options.OutputFile)
end
end
