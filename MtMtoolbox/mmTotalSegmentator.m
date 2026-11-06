function [segMV, segT] = mmTotalSegmentator(input, options)
%MMTOTALSEGMENTATOR  Segment a CT scan with TotalSegmentator, from MATLAB
% Runs TotalSegmentator (Wasserthal et al.) on a CT volume, using the copy
% of TotalSegmentator that the TotalSegmentator extension installed in
% 3D Slicer. You don't need to install Python. It gives the same result as
% the TotalSegmentator module in Slicer, with the same segment names and
% colors, and it uses the GPU when Slicer can (for example, on a Mac with
% Apple silicon). Use it to segment many scans in a loop.
%
% Before you use it: install 3D Slicer and its TotalSegmentator extension,
% and run TotalSegmentator once in Slicer (this installs everything it
% needs and downloads the AI models).
%
% Usage:
%   [segMV, segT] = mmTotalSegmentator(input)
%   [segMV, segT] = mmTotalSegmentator(input, OutputFile="CTA segmentation.seg.nrrd")
%
% INPUTS
%   input: a medicalVolume, or the name of a file that medicalVolume can
%          read (.nrrd, .nii, .nii.gz, or a DICOM folder). A CT scan
%
%   Name-Value options
%   - OutputFile:  a .seg.nrrd file for the segmentation, with the same
%                  segment names and colors as in Slicer. Default: no file
%   - VolumesFile: a .csv file with the volume of each structure (the
%                  table segT). Default: no file
%   - Quality:     "normal", "fast" (3 mm), or "fastest" (6 mm), as in the
%                  Slicer module. Default "auto": "normal" with a GPU (an
%                  NVIDIA GPU, or a Mac with Apple silicon), and "fast"
%                  without one (for example, most Windows laptops), because
%                  "normal" takes much longer on the CPU
%   - Structures:  segment only these structures, for example
%                  ["aorta" "left kidney"]. Use Slicer names or
%                  TotalSegmentator names (like "kidney_left"). This is
%                  faster, because TotalSegmentator first crops the CT to
%                  the region of these structures, so the result can
%                  differ slightly from a full run. Default: all structures
%   - Task:        the TotalSegmentator task. Default "total". Other tasks
%                  get TotalSegmentator's label names, not Slicer's
%   - Device:      "auto" (default), "gpu", "mps" (Mac GPU), or "cpu"
%   - SlicerPath:  the Slicer installation to use (the .app on a Mac, or
%                  the Slicer folder on Windows). Default: the newest
%                  Slicer that has TotalSegmentator
%   - Verbose:     false hides the progress messages. Default true
%
% OUTPUTS
%   segMV: a medicalVolume with the label of each voxel, on the same voxel
%          grid (and in the same coordinate system) as the input. The label
%          values are TotalSegmentator's (for example, 52 = aorta), so they
%          are the same in every scan
%   segT:  a table with one row for each structure that was found: its name
%          (as in Slicer), label value, color, TotalSegmentator name, and
%          volume (mL)
%
% EXAMPLES
%   ctMV = medicalVolume("CTACardio Crop.nrrd");
%   [segMV, segT] = mmTotalSegmentator(ctMV, OutputFile="CTACardio Crop segmentation.seg.nrrd");
%   aortaMask = segMV.Voxels == segT.LabelValue(segT.SegName == "aorta");
%
%   % only the kidneys and the aorta
%   [segMV, segT] = mmTotalSegmentator(ctMV, Structures=["left kidney" "right kidney" "aorta"]);
%
% CITATION
%   Wasserthal J et al., TotalSegmentator: robust segmentation of 104
%   anatomic structures in CT images. Radiology: Artificial Intelligence 2023
%
% See also mmSynthSeg2, mmWriteNRRD, mmGetSlicerSegmentInfo, medicalVolume

% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado Modern Human Anatomy
% UPDATED: 11/06/2026

arguments
    input
    options.OutputFile string = ""
    options.VolumesFile string = ""
    options.Quality (1,1) string {mustBeMember(options.Quality, ["auto" "normal" "fast" "fastest"])} = "auto"
    options.Structures string = string.empty
    options.Task (1,1) string = "total"
    options.Device (1,1) string {mustBeMember(options.Device, ["auto" "gpu" "mps" "cpu"])} = "auto"
    options.SlicerPath (1,1) string = ""
    options.Verbose (1,1) logical = true
end

say = @(varargin) printIf(options.Verbose, varargin{:});
startTime = tic;

% ── Read the CT ───────────────────────────────────────────────────────────
if isa(input, "medicalVolume")
    ctMV = input;
else
    input = string(input);
    if ~isfile(input) && ~isfolder(input)
        error("mmTotalSegmentator:noInput", "File not found: %s", input)
    end
    warning("off", "medical:medicalVolume:noEndian")
    ctMV = medicalVolume(input);
end
if ndims(ctMV.Voxels) ~= 3
    error("mmTotalSegmentator:notVolume", "The input must be a single 3-D volume.")
end

% ── Find TotalSegmentator in Slicer ───────────────────────────────────────
[python, totalSeg, slicerName] = findTotalSegmentator(options.SlicerPath);
device = options.Device;
if device == "auto"
    device = chooseDevice(python);
end
quality = options.Quality;
if quality == "auto"
    if device == "cpu"
        quality = "fast"; % "normal" takes much longer without a GPU
        say("No GPU found, so TotalSegmentator runs in fast mode. Use Quality=""normal"" for the full resolution (much slower).\n")
    else
        quality = "normal";
    end
end

% ── Labels ────────────────────────────────────────────────────────────────
if options.Task == "total"
    lut = totalLabels();
else
    lut = taskLabels(python, options.Task);
end
subset = string.empty;
if ~isempty(options.Structures)
    if options.Task ~= "total"
        error("mmTotalSegmentator:structures", "Structures works only with the ""total"" task.")
    end
    [isTS, iTS] = ismember(options.Structures, lut.TSName);
    [isSlicer, iSlicer] = ismember(options.Structures, lut.SegName);
    if ~all(isTS | isSlicer)
        error("mmTotalSegmentator:structures", "Unknown structure: %s", ...
            join(options.Structures(~(isTS | isSlicer)), ", "))
    end
    iTS(~isTS) = iSlicer(~isTS);
    subset = lut.TSName(iTS)';
end

% ── Write the CT as NIfTI (the only format TotalSegmentator reads) ────────
tempFolder = string(tempname);
mkdir(tempFolder);
cleanup = onCleanup(@() rmdir(tempFolder, "s"));
ctFile = fullfile(tempFolder, "ct.nii");
segFile = fullfile(tempFolder, "segmentation.nii");
logFile = fullfile(tempFolder, "log.txt");
writeNIfTI(ctFile, ctMV);

% ── Run TotalSegmentator ──────────────────────────────────────────────────
args = ["-i" q(ctFile) "-o" q(segFile) "--ml" "--task" options.Task "--device" device];
if quality == "fast"
    args(end+1) = "--fast";
elseif quality == "fastest"
    args(end+1) = "--fastest";
end
if ~isempty(subset)
    args = [args "--roi_subset" subset];
end
command = join([q(python) q(totalSeg) args], " ") + " > " + q(logFile) + " 2>&1";
if ispc
    command = """" + command + """"; % keep the inner quotes (cmd.exe removes the outer pair)
end

say("Running TotalSegmentator (%s quality, %s) from %s...\n", quality, device, slicerName)
oldFallback = getenv("PYTORCH_ENABLE_MPS_FALLBACK");
setenv("PYTORCH_ENABLE_MPS_FALLBACK", "1"); % as in Slicer: run on the CPU what the Mac GPU can't
status = system(command);
setenv("PYTORCH_ENABLE_MPS_FALLBACK", oldFallback);
if status ~= 0 || ~isfile(segFile)
    error("mmTotalSegmentator:failed", "TotalSegmentator failed. The end of its log:\n\n%s", logTail(logFile))
end

% ── Read the segmentation, on the voxels of the input ─────────────────────
resultMV = medicalVolume(segFile); % NIfTI: RAS+ coordinates
resultMV = medicalVolume(uint8(resultMV.Voxels), resultMV.VolumeGeometry);
ctSystem = ctMV.VolumeGeometry.PatientCoordinateSystem;
if resultMV.VolumeGeometry.PatientCoordinateSystem ~= ctSystem
    resultMV = switchLPSRAS(resultMV, ctSystem);
end
% the voxels are the voxels of the CT (maybe in another order), so
% nearest-neighbor resampling just puts them back in the CT's order
segMV = resample(resultMV, ctMV.VolumeGeometry, Method="nearest");
labels = segMV.Voxels;

% ── Table of the structures that were found ───────────────────────────────
present = setdiff(unique(labels), 0);
segT = lut(ismember(lut.LabelValue, present), :);
voxelVolume = prod(ctMV.VoxelSpacing); % mm^3
segT.Volume_mL = arrayfun(@(v) nnz(labels == v), segT.LabelValue) * voxelVolume / 1000;
say("Found %d structures.\n", height(segT))

% ── Save ──────────────────────────────────────────────────────────────────
if options.OutputFile ~= ""
    mmWriteNRRD(options.OutputFile, segMV, Segments=segT);
    say("Saved the segmentation: %s\n", options.OutputFile)
end
if options.VolumesFile ~= ""
    csvT = segT(:, ["SegName" "TSName" "LabelValue" "Volume_mL"]);
    writetable(csvT, options.VolumesFile)
    say("Saved the volumes: %s\n", options.VolumesFile)
end
say("Done in %.0f seconds.\n", toc(startTime))
end


% ═════════════════════════════════════════════════════════════════════════
function [python, totalSeg, slicerName] = findTotalSegmentator(slicerPath)
% The Python of Slicer and the TotalSegmentator script installed in it.
% Without a path, use the newest Slicer that has TotalSegmentator
persistent cachedPython cachedScript cachedName
if slicerPath == "" && ~isempty(cachedPython) && isfile(cachedPython) && isfile(cachedScript)
    [python, totalSeg, slicerName] = deal(cachedPython, cachedScript, cachedName);
    return
end

if slicerPath ~= ""
    candidates = slicerPath;
elseif ismac
    candidates = [listFolders("/Applications", "*Slicer*.app") listFolders(fullfile(getenv("HOME"), "Applications"), "*Slicer*.app")];
elseif ispc
    candidates = [listFolders(fullfile(getenv("LOCALAPPDATA"), "slicer.org"), "Slicer*") ...
        listFolders(getenv("ProgramFiles"), "*Slicer*")];
else
    candidates = [listFolders(getenv("HOME"), "Slicer*") listFolders("/opt", "Slicer*")];
end

found = struct("python", {}, "script", {}, "name", {}, "version", {});
for c = candidates
    [py, script] = slicerFiles(c);
    if isfile(py) && isfile(script)
        [~, name, ext] = fileparts(c);
        found(end+1) = struct("python", py, "script", script, "name", name + ext, "version", slicerVersion(name)); %#ok<AGROW>
    end
end
if isempty(found)
    if slicerPath ~= ""
        error("mmTotalSegmentator:noSlicer", "TotalSegmentator isn't installed in this Slicer: %s", slicerPath)
    end
    error("mmTotalSegmentator:noSlicer", ['Could not find 3D Slicer with TotalSegmentator.\n' ...
        'Install 3D Slicer and its TotalSegmentator extension, and run TotalSegmentator once in Slicer. ' ...
        'If Slicer is installed in an unusual place, give its location with SlicerPath.'])
end
[~, newest] = sortrows([vertcat(found.version) (1:numel(found))'], [-1 -2 -3 -4]);
best = found(newest(1));
[python, totalSeg, slicerName] = deal(best.python, best.script, best.name);
if slicerPath == ""
    [cachedPython, cachedScript, cachedName] = deal(python, totalSeg, slicerName);
end
end


function folders = listFolders(parent, pattern)
folders = string.empty(1, 0);
if parent == "" || ~isfolder(parent)
    return
end
d = dir(fullfile(parent, pattern));
d = d([d.isdir]);
folders = string(fullfile({d.folder}, {d.name}));
end


function [python, script] = slicerFiles(slicerFolder)
% The PythonSlicer launcher and the TotalSegmentator script of a Slicer
if ismac
    root = fullfile(slicerFolder, "Contents");
    python = fullfile(root, "bin", "PythonSlicer");
    script = fullfile(root, "lib", "Python", "bin", "TotalSegmentator");
elseif ispc
    python = fullfile(slicerFolder, "bin", "PythonSlicer.exe");
    script = fullfile(slicerFolder, "lib", "Python", "Scripts", "TotalSegmentator.exe");
else
    python = fullfile(slicerFolder, "bin", "PythonSlicer");
    script = fullfile(slicerFolder, "lib", "Python", "bin", "TotalSegmentator");
end
end


function v = slicerVersion(name)
% [major minor patch date] from a name like "3D Slicer 5.13.0 2026-11-01"
v = zeros(1, 3);
versionText = string(regexp(name, "\d+(\.\d+)+", "match", "once"));
if strlength(versionText) > 0
    numbers = str2double(split(versionText, "."))';
    n = min(3, numel(numbers));
    v(1:n) = numbers(1:n);
end
dateNum = 0;
dateText = string(regexp(name, "\d{4}-\d{2}-\d{2}", "match", "once"));
if strlength(dateText) > 0
    dateNum = datenum(dateText, "yyyy-mm-dd"); %#ok<DATNM>
end
v = [v dateNum];
end


function device = chooseDevice(python)
% "mps" on a Mac with Apple silicon (as in Slicer), "gpu" with an NVIDIA
% GPU, otherwise "cpu"
persistent cachedDevice cachedPython
if ~isempty(cachedDevice) && cachedPython == python
    device = cachedDevice;
    return
end
if ismac
    [~, arch] = system("uname -m");
    if strtrim(arch) == "arm64"
        device = "mps";
    else
        device = "cpu";
    end
else
    command = q(python) + " -c ""import torch; print(torch.cuda.is_available())""";
    if ispc
        command = """" + command + """";
    end
    [status, out] = system(command);
    if status == 0 && contains(out, "True")
        device = "gpu";
    else
        device = "cpu";
    end
end
[cachedDevice, cachedPython] = deal(device, python);
end


function lut = taskLabels(python, task)
% The label values and names of another task, from TotalSegmentator
code = sprintf("from totalsegmentator.map_to_binary import class_map; " + ...
    "[print(k, v) for k, v in sorted(class_map['%s'].items())]", task);
command = q(python) + " -c """ + code + """";
if ispc
    command = """" + command + """";
end
[status, out] = system(command);
if status ~= 0
    error("mmTotalSegmentator:task", "Unknown TotalSegmentator task: %s", task)
end
lines = splitlines(strtrim(string(out)));
lines = lines(~cellfun(@isempty, regexp(lines, "^\d+ \S+$", "once")));
parts = split(lines, " ");
names = parts(:, 2);
labelValues = str2double(parts(:, 1));
colors = lines2colors(numel(labelValues));
lut = table(names, ones(size(labelValues)), labelValues, colors, names, ...
    VariableNames=["SegName" "Layer" "LabelValue" "Color" "TSName"]);
end


function colors = lines2colors(n)
colors = lines(max(n, 1));
colors = colors(1:n, :);
end


function writeNIfTI(filename, mv)
% Write a medicalVolume as NIfTI, with the correct voxel size.
% (medicalVolume/write saves the right orientation, but in some versions
% of MATLAB the wrong voxel size, which TotalSegmentator uses)
warnState = warning("off", "all");
restore = onCleanup(@() warning(warnState));
write(mv, filename);
info = niftiinfo(filename);
info.PixelDimensions = mv.VoxelSpacing;
voxels = niftiread(filename);
niftiwrite(voxels, erase(filename, ".nii"), info);
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


function text = logTail(logFile)
text = "(no log)";
if isfile(logFile)
    lines = splitlines(string(fileread(logFile)));
    lines = strtrim(regexprep(lines, ".*\r", "")); % keep the last state of progress bars
    lines = lines(lines ~= "");
    text = join(lines(max(1, end-14):end), newline);
end
end


function s = q(s)
% Put quotes around a path, for the command line
s = """" + string(s) + """";
end


function printIf(verbose, varargin)
if verbose
    fprintf(varargin{:});
end
end


function lut = totalLabels()
% The labels of the "total" task, with the segment names and colors that
% the TotalSegmentator module of 3D Slicer uses (TotalSegmentator 2.14,
% SlicerTotalSegmentator extension)
labels = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117]';
tsNames = [ ...
    "spleen" "kidney_right" "kidney_left" "gallbladder" "liver" ...
    "stomach" "pancreas" "adrenal_gland_right" "adrenal_gland_left" "lung_upper_lobe_left" ...
    "lung_lower_lobe_left" "lung_upper_lobe_right" "lung_middle_lobe_right" "lung_lower_lobe_right" "esophagus" ...
    "trachea" "thyroid_gland" "small_bowel" "duodenum" "colon" ...
    "urinary_bladder" "prostate" "kidney_cyst_left" "kidney_cyst_right" "sacrum" ...
    "vertebrae_S1" "vertebrae_L5" "vertebrae_L4" "vertebrae_L3" "vertebrae_L2" ...
    "vertebrae_L1" "vertebrae_T12" "vertebrae_T11" "vertebrae_T10" "vertebrae_T9" ...
    "vertebrae_T8" "vertebrae_T7" "vertebrae_T6" "vertebrae_T5" "vertebrae_T4" ...
    "vertebrae_T3" "vertebrae_T2" "vertebrae_T1" "vertebrae_C7" "vertebrae_C6" ...
    "vertebrae_C5" "vertebrae_C4" "vertebrae_C3" "vertebrae_C2" "vertebrae_C1" ...
    "heart" "aorta" "pulmonary_vein" "brachiocephalic_trunk" "subclavian_artery_right" ...
    "subclavian_artery_left" "common_carotid_artery_right" "common_carotid_artery_left" "brachiocephalic_vein_left" "brachiocephalic_vein_right" ...
    "atrial_appendage_left" "superior_vena_cava" "inferior_vena_cava" "portal_vein_and_splenic_vein" "iliac_artery_left" ...
    "iliac_artery_right" "iliac_vena_left" "iliac_vena_right" "humerus_left" "humerus_right" ...
    "scapula_left" "scapula_right" "clavicula_left" "clavicula_right" "femur_left" ...
    "femur_right" "hip_left" "hip_right" "spinal_cord" "gluteus_maximus_left" ...
    "gluteus_maximus_right" "gluteus_medius_left" "gluteus_medius_right" "gluteus_minimus_left" "gluteus_minimus_right" ...
    "autochthon_left" "autochthon_right" "iliopsoas_left" "iliopsoas_right" "brain" ...
    "skull" "rib_left_1" "rib_left_2" "rib_left_3" "rib_left_4" ...
    "rib_left_5" "rib_left_6" "rib_left_7" "rib_left_8" "rib_left_9" ...
    "rib_left_10" "rib_left_11" "rib_left_12" "rib_right_1" "rib_right_2" ...
    "rib_right_3" "rib_right_4" "rib_right_5" "rib_right_6" "rib_right_7" ...
    "rib_right_8" "rib_right_9" "rib_right_10" "rib_right_11" "rib_right_12" ...
    "sternum" "costal_cartilages" ...
    ]';
slicerNames = [ ...
    "spleen" "right kidney" "left kidney" "gallbladder" ...
    "liver" "stomach" "pancreas" "right adrenal gland" ...
    "left adrenal gland" "superior lobe of left lung" "inferior lobe of left lung" "superior lobe of right lung" ...
    "middle lobe of right lung" "inferior lobe of right lung" "esophagus" "trachea" ...
    "thyroid" "small bowel" "duodenum" "colon" ...
    "urinary bladder" "prostate" "cyst" "cyst" ...
    "Sacrum" "S1 vertebra" "L5 vertebra" "L4 vertebra" ...
    "L3 vertebra" "L2 vertebra" "L1 vertebra" "T12 vertebra" ...
    "T11 vertebra" "T10 vertebra" "T9 vertebra" "T8 vertebra" ...
    "T7 vertebra" "T6 vertebra" "T5 vertebra" "T4 vertebra" ...
    "T3 vertebra" "T2 vertebra" "T1 vertebra" "C7 vertebra" ...
    "C6 vertebra" "C5 vertebra" "C4 vertebra" "C3 vertebra" ...
    "C2 vertebra" "C1 vertebra" "heart" "aorta" ...
    "pulmonary vein" "brachiocephalic trunk" "right subclavian artery" "left subclavian artery" ...
    "right common carotid artery" "left common carotid artery" "left brachiocephalic vein" "right brachiocephalic vein" ...
    "left atrial appendage" "superior vena cava" "inferior vena cava" "portal vein and splenic vein" ...
    "left common iliac artery" "right common iliac artery" "left common iliac vein" "right common iliac vein" ...
    "left humerus" "right humerus" "left scapula" "right scapula" ...
    "left clavicle" "right clavicle" "left femur" "right femur" ...
    "left hip" "right hip" "spinal cord" "left gluteus maximus" ...
    "right gluteus maximus" "left gluteus medius" "right gluteus medius" "left gluteus minimus" ...
    "right gluteus minimus" "left deep back muscle" "right deep back muscle" "left iliopsoas muscle" ...
    "right iliopsoas muscle" "brain" "skull" "left rib 1" ...
    "left rib 2" "left rib 3" "left rib 4" "left rib 5" ...
    "left rib 6" "left rib 7" "left rib 8" "left rib 9" ...
    "left rib 10" "left rib 11" "left rib 12" "right rib 1" ...
    "right rib 2" "right rib 3" "right rib 4" "right rib 5" ...
    "right rib 6" "right rib 7" "right rib 8" "right rib 9" ...
    "right rib 10" "right rib 11" "right rib 12" "sternum" ...
    "costal cartilage" ...
    ]';
colors = [ ...
    0.6157 0.4235 0.6353
    0.7255 0.4 0.3255
    0.7255 0.4 0.3255
    0.5451 0.5882 0.3843
    0.8667 0.5098 0.3961
    0.8471 0.5176 0.4118
    0.9765 0.7059 0.4353
    0.9765 0.7294 0.5882
    0.9765 0.7294 0.5882
    0.6745 0.5412 0.451
    0.8784 0.7294 0.6353
    0.6745 0.5412 0.451
    0.7922 0.6431 0.549
    0.8784 0.7294 0.6353
    0.8275 0.6706 0.5608
    0.7137 0.8941 1.0
    0.8627 0.6275 0.1176
    0.8039 0.6549 0.5569
    1.0 0.9922 0.898
    0.8 0.6588 0.5608
    0.8706 0.6039 0.5176
    0.902 0.6196 0.549
    0.8039 0.8039 0.3922
    0.8039 0.8039 0.3922
    0.8314 0.7373 0.4
    0.8314 0.8157 0.4784
    0.8314 0.7373 0.4
    0.8314 0.7373 0.4
    0.8314 0.7373 0.4
    0.8314 0.7373 0.4
    0.8314 0.7373 0.4
    0.8863 0.7922 0.5255
    0.8863 0.7922 0.5255
    0.8863 0.7922 0.5255
    0.8863 0.7922 0.5255
    0.8863 0.7922 0.5255
    0.8863 0.7922 0.5255
    0.8863 0.7922 0.5255
    0.8863 0.7922 0.5255
    0.8863 0.7922 0.5255
    0.8863 0.7922 0.5255
    0.8863 0.7922 0.5255
    0.8863 0.7922 0.5255
    1.0 1.0 0.8118
    1.0 1.0 0.8118
    1.0 1.0 0.8118
    1.0 1.0 0.8118
    1.0 1.0 0.8118
    1.0 1.0 0.8118
    1.0 1.0 0.8118
    0.8078 0.4314 0.3294
    0.8784 0.3804 0.298
    0.7647 0.1765 0.098
    0.7686 0.4745 0.3098
    0.8471 0.3961 0.349
    0.8471 0.3961 0.2706
    0.8471 0.3961 0.3098
    0.8471 0.3961 0.2706
    0.0 0.6314 0.7686
    0.0 0.5922 0.8078
    0.0 0.6314 0.7686
    0.0 0.5529 0.8863
    0.0 0.5922 0.8078
    0.0 0.5922 0.8078
    0.8471 0.3961 0.3098
    0.8471 0.3961 0.3098
    0.0 0.5922 0.8078
    0.0 0.5922 0.8078
    0.8039 0.702 0.4235
    0.8039 0.702 0.4235
    0.8314 0.7373 0.4
    0.8314 0.7373 0.4
    0.8039 0.702 0.4235
    0.8039 0.702 0.4235
    1.0 0.9333 0.6667
    1.0 0.9333 0.6667
    0.8314 0.7373 0.4
    0.8314 0.7373 0.4
    0.9569 0.8392 0.1922
    0.7373 0.3725 0.298
    0.7373 0.3725 0.298
    0.698 0.4118 0.298
    0.698 0.4118 0.298
    0.698 0.3725 0.3373
    0.698 0.3725 0.3373
    0.6706 0.3333 0.2667
    0.6706 0.3333 0.2667
    0.7373 0.3725 0.298
    0.7373 0.3725 0.298
    0.9804 0.9804 0.8824
    0.9451 0.8353 0.5647
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9922 0.9098 0.6196
    0.9569 0.851 0.6039
    0.4353 0.7216 0.8235
    ];
lut = table(slicerNames, ones(size(labels)), labels, colors, tsNames, ...
    VariableNames=["SegName" "Layer" "LabelValue" "Color" "TSName"]);
end
