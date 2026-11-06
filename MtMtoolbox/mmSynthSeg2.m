function [segMV, segT, volumes] = mmSynthSeg2(input, options)
%MMSYNTHSEG2  Segment a brain MRI with SynthSeg 2.0, in MATLAB
% SynthSeg (Billot et al.) segments a brain MRI of any contrast and
% resolution into 32 structures. This function runs the SynthSeg 2.0 model
% in MATLAB, so you don't need Python or the 3D Slicer SynthSeg extension.
% It gives the same results as the Slicer extension (SynthSeg 2.0,
% without parcellation): the same structure names and label values,
% including "csf".
%
% Usage:
%   [segMV, segT, volumes] = mmSynthSeg2(input)
%   [segMV, segT, volumes] = mmSynthSeg2(input, OutputFile="brain.seg.nrrd")
%
% INPUTS
%   input: a medicalVolume, or the name of a file that medicalVolume can
%          read (.nrrd, .nii, .nii.gz, or a DICOM folder)
%
%   Name-Value options
%   - OutputFile:  a .seg.nrrd file for the segmentation. You can drag it
%                  into 3D Slicer. Default: no file
%   - VolumesFile: a .csv file for the volumes, with the same columns as
%                  the volumes file of the Slicer SynthSeg extension.
%                  Default: no file
%   - ModelFile:   the SynthSeg 2.0 network weights (synthseg_2.0.h5).
%                  Default: SynthSeg/synthseg_2.0.h5 in the course toolbox,
%                  or, if it isn't there, SynthSeg/synthseg_2.0.h5 in your
%                  MATLAB folder (userpath). If the file doesn't exist, it is
%                  downloaded the first time (about 50 MB)
%   - Verbose:     false hides the progress messages. Default true
%
% OUTPUTS
%   segMV:   a medicalVolume with the label of each voxel, on the 1 mm
%            grid that SynthSeg works on. To put the labels on the voxels
%            of your MRI, use:
%            labels = resample(segMV, mriMV.VolumeGeometry, Method="nearest")
%   segT:    a table with the name, label value, and color of each
%            structure (like mmGetSlicerSegmentInfo)
%   volumes: a table with the volume of each structure (mm^3), and the
%            total intracranial volume. These are "soft" volumes: each
%            voxel contributes its probability of belonging to the
%            structure, as in SynthSeg
%
% EXAMPLE
%   mriMV = medicalVolume("MRBT1stripped.nrrd");
%   [segMV, segT, volumes] = mmSynthSeg2(mriMV, OutputFile="MRBT1stripped_synthseg.seg.nrrd");
%
% REQUIREMENTS
%   Deep Learning Toolbox, Image Processing Toolbox, and Medical Imaging
%   Toolbox (no support packages and no Python). About 8 GB of memory.
%
% CITATIONS
%   Billot B et al., SynthSeg, Medical Image Analysis 2023
%   Billot B et al., SynthSeg 2.0, PNAS 2023
%   The model is from the SynthSeg repository (github.com/BBillot/SynthSeg,
%   Apache 2.0 license).
%
% See also mmSynthSegNRRD, mmGetSlicerSegmentInfo, medicalVolume

% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado Modern Human Anatomy
% UPDATED: 11/06/2026

arguments
    input
    options.OutputFile string = ""
    options.VolumesFile string = ""
    options.ModelFile string = defaultModelFile()
    options.Verbose (1,1) logical = true
end

say = @(varargin) printIf(options.Verbose, varargin{:});
startTime = tic;

% ── Read the MRI ──────────────────────────────────────────────────────────
if isa(input, "medicalVolume")
    mriMV = input;
    subject = "image";
else
    input = string(input);
    if ~isfile(input) && ~isfolder(input)
        error("mmSynthSeg2:noInput", "File not found: %s", input)
    end
    warning("off", "medical:medicalVolume:noEndian")
    mriMV = medicalVolume(input);
    [~, subject] = fileparts(input);
    subject = erase(subject, [".nii" ".nrrd"]);
end
if ndims(mriMV.Voxels) ~= 3
    error("mmSynthSeg2:notVolume", "The input must be a single 3-D volume.")
end

% ── Labels of SynthSeg 2.0 ────────────────────────────────────────────────
% The network has one output channel per label, in this order
lut = synthSegLabels();
nLabels = height(lut);

% ── Network ───────────────────────────────────────────────────────────────
getModel(options.ModelFile, say);
net = getNetwork(options.ModelFile, nLabels, say);

% ── Preprocess ────────────────────────────────────────────────────────────
say("Preprocessing...\n")
[X, aff, voxelSize] = preprocess(mriMV);
[X, padIdx] = padVolume(X);

% ── Predict, and predict again with the image flipped left-right ──────────
say("Segmenting (1 of 2)...\n")
post = predictSmoothed(net, X);
say("Segmenting (2 of 2, flipped)...\n")
postFlip = predictSmoothed(net, flip(X, 1));
postFlip = flip(postFlip, 1); % flip back
postFlip = postFlip(:,:,:,lut.FlipIndex); % swap the left and right labels
post = 0.5 * (post + postFlip);
clear postFlip

% ── Postprocess ───────────────────────────────────────────────────────────
say("Postprocessing...\n")
post = postprocess(post, lut.Topology);
post = post(padIdx{:}, :); % remove the padding
post = post ./ sum(post, 4);
[~, k] = max(post, [], 4);
seg = uint8(lut.Label(k));
softVolumes = squeeze(sum(post(:,:,:,2:end), [1 2 3]))' * prod(voxelSize); % mm^3
clear post

% ── Outputs ───────────────────────────────────────────────────────────────
segFile = options.OutputFile;
deleteSegFile = segFile == "";
if deleteSegFile
    segFile = string(tempname) + ".seg.nrrd";
end
writeSlicerSegNRRD(segFile, seg, aff, lut);
segMV = medicalVolume(segFile);
segT = mmGetSlicerSegmentInfo(segFile);
if deleteSegFile
    delete(segFile)
else
    say("Saved the segmentation: %s\n", segFile)
end

names = ["total intracranial" lut.Name(2:end)'];
volumes = array2table([sum(softVolumes) softVolumes], VariableNames=names);
if options.VolumesFile ~= ""
    csvTable = [table(subject, VariableNames="subject") volumes];
    csvTable.synthseg_model = "SynthSeg 2.0 (MATLAB)";
    csvTable.citation = "Billot B et al., SynthSeg, Medical Image Analysis 2023; Billot B et al., SynthSeg 2.0, PNAS 2023";
    writetable(csvTable, options.VolumesFile)
    say("Saved the volumes: %s\n", options.VolumesFile)
end
say("Done in %.0f seconds.\n", toc(startTime))
end


% ═════════════════════════════════════════════════════════════════════════
function lut = synthSegLabels()
% The labels of SynthSeg 2.0, sorted by label value (the order of the
% network's output channels), with their names, FreeSurfer colors, the
% label of the same structure on the other side, and the topological
% class (structures that must form one connected piece)
labels = [0 2 3 4 5 7 8 10 11 12 13 14 15 16 17 18 24 26 28 41 42 43 44 46 47 49 50 51 52 53 54 58 60]';
names = ["background" "left cerebral white matter" "left cerebral cortex" "left lateral ventricle" ...
    "left inferior lateral ventricle" "left cerebellum white matter" "left cerebellum cortex" ...
    "left thalamus" "left caudate" "left putamen" "left pallidum" "3rd ventricle" "4th ventricle" ...
    "brain-stem" "left hippocampus" "left amygdala" "csf" "left accumbens area" "left ventral DC" ...
    "right cerebral white matter" "right cerebral cortex" "right lateral ventricle" ...
    "right inferior lateral ventricle" "right cerebellum white matter" "right cerebellum cortex" ...
    "right thalamus" "right caudate" "right putamen" "right pallidum" "right hippocampus" ...
    "right amygdala" "right accumbens area" "right ventral DC"]';
colors = [0 0 0; 245 245 245; 205 62 78; 120 18 134; 196 58 250; 220 248 164; 230 148 34; ...
    0 118 14; 122 186 220; 236 13 176; 12 48 255; 204 182 142; 42 204 164; 119 159 176; ...
    220 216 20; 103 255 255; 60 60 60; 255 165 0; 165 42 42; ...
    245 245 245; 205 62 78; 120 18 134; 196 58 250; 220 248 164; 230 148 34; ...
    0 118 14; 122 186 220; 236 13 176; 13 48 255; 220 216 20; 103 255 255; 255 165 0; 165 42 42] / 255;
topology = [0 4 4 4 4 5 5 6 7 8 9 1 2 3 10 11 0 12 13 14 14 14 14 15 15 16 17 18 19 20 21 22 23]';

% left-right pairs: the flipped image puts each left structure on the right
left = [2 3 4 5 7 8 10 11 12 13 17 18 26 28];
right = [41 42 43 44 46 47 49 50 51 52 53 54 58 60];
otherSide = labels;
[isLeft, iRight] = ismember(labels, left);
otherSide(isLeft) = right(iRight(isLeft));
[isRight, iLeft] = ismember(labels, right);
otherSide(isRight) = left(iLeft(isRight));
[~, flipIndex] = ismember(otherSide, labels);

lut = table(labels, names, colors, topology, flipIndex, ...
    VariableNames=["Label" "Name" "Color" "Topology" "FlipIndex"]);
end


function modelFile = defaultModelFile()
% The model in the course toolbox, if it is there. Otherwise, in the
% SynthSeg folder of the user's MATLAB folder, where it can be downloaded
modelFile = fullfile(fileparts(mfilename("fullpath")), "SynthSeg", "synthseg_2.0.h5");
if ~isfile(modelFile)
    folder = userpath;
    if folder == ""
        folder = tempdir;
    end
    modelFile = fullfile(folder, "SynthSeg", "synthseg_2.0.h5");
end
modelFile = string(modelFile);
end

function getModel(modelFile, say)
% Download the SynthSeg 2.0 weights, if needed, and check their SHA-256
expectedSHA = "f190bfd742f450ef3ca2c9df9ed4d2e0232b3a74471da5e51b7770bacdf80c3e";
if isfile(modelFile)
    return
end
folder = fileparts(modelFile);
if folder ~= "" && ~isfolder(folder)
    mkdir(folder)
end
% Redistributed with the permission of the SynthSeg authors by the
% SlicerSynthSeg extension (github.com/niyaziacer/SlicerSynthSeg)
url = "https://github.com/niyaziacer/SlicerSynthSeg/releases/download/models-v1/synthseg_2.0.h5";
say("Downloading the SynthSeg 2.0 model (about 50 MB)...\n")
tmpFile = string(tempname) + ".h5";
websave(tmpFile, url, weboptions(Timeout=120));
if fileSHA256(tmpFile) ~= expectedSHA
    delete(tmpFile)
    error("mmSynthSeg2:badDownload", "The downloaded model file is damaged (wrong SHA-256). Try again.")
end
movefile(tmpFile, modelFile)
say("Saved the model: %s\n", modelFile)
end


function sha = fileSHA256(file)
fid = fopen(file, "r");
bytes = fread(fid, Inf, "*uint8");
fclose(fid);
md = java.security.MessageDigest.getInstance("SHA-256");
md.update(bytes);
sha = string(lower(reshape(dec2hex(typecast(md.digest(), "uint8"))', 1, [])));
end


function net = getNetwork(modelFile, nLabels, say)
% Build the SynthSeg U-Net and load its weights. The network is kept in
% memory, so the next call is faster
persistent cachedNet cachedFile
if ~isempty(cachedNet) && cachedFile == modelFile
    net = cachedNet;
    return
end
say("Loading the network...\n")
net = buildUNet(modelFile, nLabels);
cachedNet = net;
cachedFile = modelFile;
end


function net = buildUNet(h5file, nLabels)
% The SynthSeg U-Net (the "unet" model of the neurite package): 5 levels,
% 2 convolutions per level, 24 features in the first level, doubled at
% each level, ELU activations, and batch normalization after each level
nLevels = 5;
net = dlnetwork;
previous = ""; % no input layer, so the network takes volumes of any size

% encoder
for level = 0:nLevels-1
    for c = 0:1
        name = sprintf("unet_conv_downarm_%d_%d", level, c);
        net = addLayers(net, [ ...
            convLayer(h5file, name, 3)
            eluLayer(1, Name=name + "_elu")]);
        if previous ~= ""
            net = connectLayers(net, previous, name);
        end
        previous = name + "_elu";
    end
    skip(level+1) = previous; %#ok<AGROW> the skip connections leave before batch normalization
    name = sprintf("unet_bn_down_%d", level);
    net = addLayers(net, bnLayer(h5file, name));
    net = connectLayers(net, previous, name);
    previous = name;
    if level < nLevels-1
        name = sprintf("unet_maxpool_%d", level);
        net = addLayers(net, maxPooling3dLayer(2, Stride=2, Padding="same", Name=name));
        net = connectLayers(net, previous, name);
        previous = name;
    end
end

% decoder
for k = 0:nLevels-2
    level = nLevels-2-k; % 3, 2, 1, 0
    up = sprintf("unet_up_%d", nLevels+k);
    merge = sprintf("unet_merge_%d", nLevels+k);
    net = addLayers(net, [ ...
        resize3dLayer(Scale=2, Method="nearest", Name=up)
        concatenationLayer(4, 2, Name=merge)]);
    net = connectLayers(net, previous, up);
    net = disconnectLayers(net, up, merge + "/in1");
    net = connectLayers(net, skip(level+1), merge + "/in1");
    net = connectLayers(net, up, merge + "/in2");
    previous = merge;
    for c = 0:1
        name = sprintf("unet_conv_uparm_%d_%d", nLevels+k, c);
        net = addLayers(net, [ ...
            convLayer(h5file, name, 3)
            eluLayer(1, Name=name + "_elu")]);
        net = connectLayers(net, previous, name);
        previous = name + "_elu";
    end
    name = sprintf("unet_bn_up_%d", k);
    net = addLayers(net, bnLayer(h5file, name));
    net = connectLayers(net, previous, name);
    previous = name;
end

% output: one channel per label
net = addLayers(net, [ ...
    convLayer(h5file, "unet_likelihood", 1)
    softmaxLayer(Name="unet_prediction")]);
net = connectLayers(net, previous, "unet_likelihood");
assert(size(net.Layers(end-1).Weights, 5) == nLabels, ...
    "The model file has %d labels, but SynthSeg 2.0 has %d.", size(net.Layers(end-1).Weights, 5), nLabels)
net = initialize(net, dlarray(zeros(32, 32, 32, 1, "single"), "SSSCB"));
end


function layer = convLayer(h5file, name, kernelSize)
% A 3-D convolution layer with the weights of a Keras layer. Keras stores
% the weights as [out in z y x] in MATLAB order; MATLAB wants [x y z in out]
W = permute(h5read(h5file, "/" + name + "/" + name + "/kernel:0"), [5 4 3 2 1]);
b = h5read(h5file, "/" + name + "/" + name + "/bias:0");
layer = convolution3dLayer(kernelSize, size(W, 5), Padding="same", Name=name, ...
    Weights=W, Bias=reshape(b, 1, 1, 1, []));
end


function layer = bnLayer(h5file, name)
% A batch normalization layer with the weights of a Keras layer
read = @(field) reshape(h5read(h5file, "/" + name + "/" + name + "/" + field + ":0"), 1, 1, 1, []);
layer = batchNormalizationLayer(Name=name, Epsilon=0.001, Offset=read("beta"), Scale=read("gamma"), ...
    TrainedMean=read("moving_mean"), TrainedVariance=read("moving_variance"));
end


function [X, aff, voxelSize] = preprocess(mriMV)
% Resample to 1 mm voxels, align the axes with RAS, and scale to [0, 1]

% voxel-to-RAS transformation (0-based voxel indices, as in NIfTI)
R = mriMV.VolumeGeometry;
[x, y, z] = intrinsicToWorld(R, [1 2 1 1], [1 1 2 1], [1 1 1 2]); % patient coordinates (mm)
P = [x(:) y(:) z(:)];
aff = [(P(2:4,:) - P(1,:))' P(1,:)'; 0 0 0 1];
if R.PatientCoordinateSystem ~= "RAS+" % DICOM and NRRD volumes are LPS+, NIfTI volumes are RAS+
    aff = diag([-1 -1 1 1]) * aff; % LPS -> RAS
end
X = single(mriMV.Voxels);
voxelSize = vecnorm(aff(1:3, 1:3));

% resample to 1 mm, if needed
if any(abs(voxelSize - 1) > 0.05)
    newSize = ceil(size(X) .* voxelSize);
    scale = newSize ./ size(X); % the scale that imresize3 uses
    X = imresize3(X, newSize, Method="linear", AntiAliasing=false);
    aff(1:3, 1:3) = aff(1:3, 1:3) ./ scale;
    aff(1:3, 4) = aff(1:3, 4) - aff(1:3, 1:3) * (0.5 * (scale' - 1));
    voxelSize = vecnorm(aff(1:3, 1:3));
end

% align the axes with RAS (permute and flip the array)
[X, aff] = alignToRAS(X, aff);

% rescale the intensities to [0, 1], between the 0.5th and 99.5th percentiles
limits = prctile(X(:), [0.5 99.5]);
X = rescale(X, 0, 1, InputMin=limits(1), InputMax=limits(2));
end


function [X, aff] = alignToRAS(X, aff)
% Permute and flip the array, so that its 1st, 2nd, and 3rd axes point
% (approximately) to the right, anterior, and superior, as in SynthSeg
cosines = abs(aff(1:3, 1:3)) ./ vecnorm(aff(1:3, 1:3)); % (j,i): how much voxel axis i points along RAS axis j
orders = perms(1:3);
score = arrayfun(@(k) sum(cosines(sub2ind([3 3], 1:3, orders(k,:)))), 1:height(orders));
[~, best] = max(score);
order = orders(best, :);
X = permute(X, order);
aff(1:3, 1:3) = aff(1:3, order);
for d = 1:3
    if aff(d, d) < 0
        aff(1:3, d) = -aff(1:3, d);
        aff(1:3, 4) = aff(1:3, 4) - aff(1:3, d) * (size(X, d) - 1);
        X = flip(X, d);
    end
end
end

function [Xpad, idx] = padVolume(X)
% Pad the volume, centered, to a multiple of 32 voxels (and at least 128)
sz = size(X);
padSize = max(32 * ceil(sz / 32), 128);
before = floor((padSize - sz) / 2);
Xpad = zeros(padSize, "single");
idx = arrayfun(@(d) before(d) + (1:sz(d)), 1:3, UniformOutput=false);
Xpad(idx{:}) = X;
end


function post = predictSmoothed(net, X)
% The network's probabilities for each label, smoothed with a small
% Gaussian (sigma = 0.5 voxels), as in SynthSeg
post = gather(extractdata(predict(net, dlarray(X, "SSSCB"))));
for k = 1:size(post, 4)
    post(:,:,:,k) = imgaussfilt3(post(:,:,:,k), 0.5, FilterSize=3, Padding=0);
end
end


function post = postprocess(post, topology)
% Remove everything outside the largest connected piece of the brain, and
% outside the largest connected piece of each structure, as in SynthSeg
threshold = 0.25;
brain = largestComponent(sum(post(:,:,:,2:end), 4) > threshold);
post(:,:,:,2:end) = post(:,:,:,2:end) .* brain;

mask = post > threshold;
for c = unique(topology(topology > 0))'
    channels = find(topology == c);
    piece = largestComponent(any(mask(:,:,:,channels), 4));
    post(:,:,:,channels) = post(:,:,:,channels) .* piece;
end
end


function mask = largestComponent(mask)
CC = bwconncomp(mask, 6);
if CC.NumObjects == 0
    return
end
[~, biggest] = max(cellfun(@numel, CC.PixelIdxList));
mask = false(size(mask));
mask(CC.PixelIdxList{biggest}) = true;
end


function writeSlicerSegNRRD(filename, seg, aff, lut)
% Write a label volume as a Slicer segmentation (.seg.nrrd), with one
% named, colored segment for each label that is present
% aff: 4x4 voxel-to-RAS transformation (0-based voxel indices)
affLPS = diag([-1 -1 1 1]) * aff; % NRRD files use LPS
present = setdiff(unique(seg(:)), 0);
sz = size(seg);

fid = fopen(filename, "w");
if fid == -1
    error("mmSynthSeg2:cannotWrite", "Cannot write the file: %s", filename)
end
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, "NRRD0005\n");
fprintf(fid, "type: unsigned char\n");
fprintf(fid, "dimension: 3\n");
fprintf(fid, "space: left-posterior-superior\n");
fprintf(fid, "sizes: %d %d %d\n", sz);
fprintf(fid, "space directions: (%.10g,%.10g,%.10g) (%.10g,%.10g,%.10g) (%.10g,%.10g,%.10g)\n", affLPS(1:3, 1:3));
fprintf(fid, "kinds: domain domain domain\n");
fprintf(fid, "endian: little\n");
fprintf(fid, "encoding: raw\n");
fprintf(fid, "space origin: (%.10g,%.10g,%.10g)\n", affLPS(1:3, 4));
fprintf(fid, "Segmentation_ContainedRepresentationNames:=Binary labelmap|\n");
fprintf(fid, "Segmentation_MasterRepresentation:=Binary labelmap\n");
for s = 1:numel(present)
    row = find(lut.Label == present(s));
    [i, j, k] = ind2sub(sz, find(seg == present(s)));
    n = s - 1; % Slicer numbers the segments from 0
    fprintf(fid, "Segment%d_Color:=%.6g %.6g %.6g\n", n, lut.Color(row, :));
    fprintf(fid, "Segment%d_ColorAutoGenerated:=0\n", n);
    fprintf(fid, "Segment%d_Extent:=%d %d %d %d %d %d\n", n, min(i)-1, max(i)-1, min(j)-1, max(j)-1, min(k)-1, max(k)-1);
    fprintf(fid, "Segment%d_ID:=Segment_%d\n", n, present(s));
    fprintf(fid, "Segment%d_LabelValue:=%d\n", n, present(s));
    fprintf(fid, "Segment%d_Layer:=0\n", n);
    fprintf(fid, "Segment%d_Name:=%s\n", n, lut.Name(row));
    fprintf(fid, "Segment%d_NameAutoGenerated:=0\n", n);
end
fprintf(fid, "\n"); % a blank line ends the header
fwrite(fid, seg(:), "uint8");
end


function printIf(verbose, varargin)
if verbose
    fprintf(varargin{:});
end
end
