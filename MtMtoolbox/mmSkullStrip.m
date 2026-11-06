function [strippedMV, brainMV] = mmSkullStrip(input, options)
%MMSKULLSTRIP  Remove the skull from a brain MRI, using SynthSeg 2.0
% Finds the brain with SynthSeg 2.0 (mmSynthSeg2), and sets every voxel
% outside the brain to 0. The brain mask is every voxel that SynthSeg
% labels (the brain structures and the CSF), with the holes filled in. A
% tumor that SynthSeg doesn't label is inside the brain, so it is kept.
% This replaces the HD Brain Extraction extension of 3D Slicer.
%
% Usage:
%   [strippedMV, brainMV] = mmSkullStrip(input)
%   [strippedMV, brainMV] = mmSkullStrip(input, OutputFile="MRBT1stripped.nrrd", MaskFile="MRBT1SkullStrip.seg.nrrd")
%
% INPUTS
%   input: a medicalVolume, or the name of a file that medicalVolume can
%          read (.nrrd, .nii, .nii.gz, or a DICOM folder)
%
%   Name-Value options
%   - OutputFile: a .nrrd file for the skull-stripped MRI. Default: no file
%   - MaskFile:   a .seg.nrrd file for the brain mask, as a Slicer
%                 segmentation with one segment, "brain". Default: no file
%   - SynthSeg:   the SynthSeg segmentation of the same MRI (the first
%                 output of mmSynthSeg2), if you already have it. Then
%                 SynthSeg doesn't run again. Default: run SynthSeg
%   - Verbose:    false hides the progress messages. Default true
%
% OUTPUTS
%   strippedMV: a medicalVolume: the MRI, with 0 outside the brain
%   brainMV:    a medicalVolume: the brain mask (1 = brain, 0 = outside)
%   Both are on the voxel grid of the input MRI.
%
% EXAMPLES
%   mriMV = medicalVolume("MRBrainTumor1.nrrd");
%   strippedMV = mmSkullStrip(mriMV, OutputFile="MRBT1stripped.nrrd", MaskFile="MRBT1SkullStrip.seg.nrrd");
%
%   % segment the brain and remove the skull, with one run of SynthSeg
%   synthMV = mmSynthSeg2(mriMV);
%   strippedMV = mmSkullStrip(mriMV, SynthSeg=synthMV);
%
% See also mmSynthSeg2, mmWriteNRRD

% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado Modern Human Anatomy
% UPDATED: 11/06/2026

arguments
    input
    options.OutputFile string = ""
    options.MaskFile string = ""
    options.SynthSeg = []
    options.Verbose (1,1) logical = true
end

if isa(input, "medicalVolume")
    mriMV = input;
else
    warning("off", "medical:medicalVolume:noEndian")
    mriMV = medicalVolume(input);
end

% segment the brain (unless we already have the segmentation), and put
% the labels on the voxels of the MRI
synthMV = options.SynthSeg;
if isempty(synthMV)
    synthMV = mmSynthSeg2(mriMV, Verbose=options.Verbose);
elseif ~isa(synthMV, "medicalVolume")
    error("mmSkullStrip:synthSeg", "SynthSeg must be the medicalVolume returned by mmSynthSeg2.")
end
if synthMV.VolumeGeometry.PatientCoordinateSystem ~= mriMV.VolumeGeometry.PatientCoordinateSystem
    synthMV = switchLPSRAS(synthMV, mriMV.VolumeGeometry.PatientCoordinateSystem); % for example, a NIfTI MRI
end
labels = resample(synthMV, mriMV.VolumeGeometry, Method="nearest").Voxels;

% the brain mask: every labeled voxel, with the holes (like a tumor) filled in
brain = imfill(labels > 0, "holes");
CC = bwconncomp(brain, 6);
[~, biggest] = max(cellfun(@numel, CC.PixelIdxList));
brain = false(size(brain));
brain(CC.PixelIdxList{biggest}) = true; % keep only the largest piece

strippedMV = medicalVolume(mriMV.Voxels .* cast(brain, class(mriMV.Voxels)), mriMV.VolumeGeometry);
brainMV = medicalVolume(uint8(brain), mriMV.VolumeGeometry);

if options.OutputFile ~= ""
    mmWriteNRRD(options.OutputFile, strippedMV);
    if options.Verbose
        fprintf("Saved the skull-stripped MRI: %s\n", options.OutputFile)
    end
end
if options.MaskFile ~= ""
    segT = table("brain", 1, [0.886 0.678 0.584], VariableNames=["SegName" "LabelValue" "Color"]);
    mmWriteNRRD(options.MaskFile, brainMV, Segments=segT);
    if options.Verbose
        fprintf("Saved the brain mask: %s\n", options.MaskFile)
    end
end
end


function mv = switchLPSRAS(mv, system)
% Express a medicalVolume in the other patient coordinate system (LPS+ or
% RAS+). The two differ only in the sign of the x and y coordinates
geom = mv.VolumeGeometry;
flipXY = [-1 -1 1];
voxelDistances = cellfun(@(v) v .* flipXY, geom.VoxelDistances, UniformOutput=false);
newGeom = medicalref3d(geom.VolumeSize, geom.Position .* flipXY, voxelDistances);
newGeom.PatientCoordinateSystem = system;
mv = medicalVolume(mv.Voxels, newGeom);
end
