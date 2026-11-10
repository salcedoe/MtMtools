function [newIntensityFile, newSegmentFile] = mmResampleSlicerFiles(intensityFile, segmentFile, options)
%MMRESAMPLESLICERFILES  Save isotropic copies of a Slicer volume and its segmentation
% Use this function if you forgot to resample your volume to isotropic
% voxels in Slicer before you segmented it. It loads the intensity volume
% and the segmentation, resamples both to the same isotropic voxel grid
% (with mmResampleIsotropic), and saves them as two NEW files next to the
% originals, with " isotropic" added to the names:
%
%   CTACardio.nrrd                 ->  CTACardio isotropic.nrrd
%   Salcedo Segmentation.seg.nrrd  ->  Salcedo Segmentation isotropic.seg.nrrd
%
% Your original files are never changed. Slicer can open the new files:
% the segment names, colors, and layers are kept.
% If the files are already isotropic, no files are written.
%
% Usage:
%   mmResampleSlicerFiles(intensityFile, segmentFile)
%   [newIntensityFile, newSegmentFile] = mmResampleSlicerFiles(intensityFile, segmentFile)
%   mmResampleSlicerFiles(intensityFile, segmentFile, Overwrite=true)
%
% INPUTS
%   intensityFile: the intensity volume (CT or MRI) saved from Slicer (.nrrd)
%   segmentFile:   the segmentation of that volume (.seg.nrrd)
%
%   Name-Value options
%   - VoxelSize:    the size of the new voxels, in mm. Default: the
%                   smallest voxel dimension of the intensity volume
%   - OutputFolder: where to save the new files. Default: the folder of
%                   each original file
%   - Overwrite:    true replaces " isotropic" files that already exist
%                   (from an earlier run). Default false. The original
%                   files are never replaced
%
% OUTPUTS
%   newIntensityFile, newSegmentFile: the full paths of the files to use
%       from now on. These are the new files, or your original files if
%       nothing had to change
%
% EXAMPLE
%   paths.intensity = fullfile(paths.project, "CTACardio.nrrd");
%   paths.segment = fullfile(paths.project, "Salcedo Segmentation.seg.nrrd");
%   [paths.intensity, paths.segment] = mmResampleSlicerFiles(paths.intensity, paths.segment);
%
% See also mmResampleIsotropic, mmWriteNRRD, mmGetSlicerSegmentInfo

% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado Modern Human Anatomy
% UPDATED: 11/10/2026

arguments
    intensityFile (1,1) string {mustBeFile}
    segmentFile (1,1) string {mustBeFile}
    options.VoxelSize double {mustBeScalarOrEmpty, mustBePositive} = []
    options.OutputFolder (1,1) string = ""
    options.Overwrite (1,1) logical = false
end
if ~endsWith(segmentFile, ".seg.nrrd", IgnoreCase=true)
    error("mmResampleSlicerFiles:segmentFile", "The second file must be a Slicer segmentation (.seg.nrrd): %s", segmentFile)
end
if endsWith(intensityFile, ".seg.nrrd", IgnoreCase=true)
    error("mmResampleSlicerFiles:intensityFile", "The first file must be the intensity volume, not a segmentation: %s", intensityFile)
end

newIntensityFile = newName(intensityFile, ".nrrd", options.OutputFolder);
newSegmentFile = newName(segmentFile, ".seg.nrrd", options.OutputFolder);

% load
warnState = warning("off", "medical:medicalVolume:noEndian"); % Slicer's NRRD files trigger a harmless warning
restoreWarning = onCleanup(@() warning(warnState));
mV = medicalVolume(intensityFile);
segMV = medicalVolume(segmentFile);
segT = mmGetSlicerSegmentInfo(segmentFile);

% resample
[newMV, newSegMV] = mmResampleIsotropic(mV, segMV, Segments=segT, VoxelSize=options.VoxelSize);
intensityChanged = ~sameGrid(mV, newMV);
segmentChanged = ~sameGrid(segMV, newSegMV);
if ~intensityChanged && ~segmentChanged
    fprintf("mmResampleSlicerFiles: nothing to do. No files were written.\n")
    newIntensityFile = intensityFile;
    newSegmentFile = segmentFile;
    return
end

% don't replace existing files by accident
toWrite = [newIntensityFile newSegmentFile];
toWrite = toWrite([intensityChanged segmentChanged]);
exists = toWrite(isfile(toWrite));
if ~isempty(exists) && ~options.Overwrite
    error("mmResampleSlicerFiles:exists", ...
        "This file already exists:\n  %s\nUse it, delete it, or add Overwrite=true to replace it.", strjoin(exists, newline + "  "))
end

% save
fprintf("mmResampleSlicerFiles:\n")
if intensityChanged
    mmWriteNRRD(newIntensityFile, newMV);
    fprintf("  saved %s\n", newIntensityFile)
else
    newIntensityFile = intensityFile;
    fprintf("  the intensity volume did not change: keep using %s\n", intensityFile)
end
if segmentChanged
    mmWriteNRRD(newSegmentFile, newSegMV, Segments=segT);
    fprintf("  saved %s\n", newSegmentFile)
else
    newSegmentFile = segmentFile;
    fprintf("  the segmentation did not change: keep using %s\n", segmentFile)
end
fprintf("  Your original files were not changed.\n")
end

function out = newName(file, ext, outputFolder)
% "folder/name.ext" -> "folder/name isotropic.ext"
[folder, name, e] = fileparts(file);
name = extractBefore(name + e, strlength(name + e) - strlength(ext) + 1); % the name without .nrrd or .seg.nrrd
if outputFolder ~= ""
    if ~isfolder(outputFolder)
        error("mmResampleSlicerFiles:folder", "The output folder does not exist: %s", outputFolder)
    end
    folder = outputFolder;
end
out = fullfile(folder, name + " isotropic" + ext);
end

function tf = sameGrid(a, b)
% do two medicalVolumes have the same voxel grid?
tf = isequal(size(a.Voxels), size(b.Voxels)) && ...
    max(abs(intrinsicToWorldMapping(a.VolumeGeometry).A - intrinsicToWorldMapping(b.VolumeGeometry).A), [], "all") < 1e-6;
end
