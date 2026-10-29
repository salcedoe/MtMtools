function mmSynthSegNRRD(input, outputseg, modelfile, outputvols)
%%MMSYNTHSEGNRRD  SynthSeg segmentation saved as a Slicer-ready .seg.nrrd
% Same interface as mmSynthSeg but writes a 3D Slicer .seg.nrrd file with
% named, colored segments — drag the output directly into Slicer, no
% conversion script required.
%
% Usage:
%   mmSynthSegNRRD(input, outputseg, modelfile)
%   mmSynthSegNRRD(input, outputseg, modelfile, outputvols)
%
%   input     : nifti file (.nii/.nii.gz) or directory of nifti files
%   outputseg : output .seg.nrrd file, or a directory for batch output
%   modelfile : .h5 network weights (downloaded automatically if absent)
%   outputvols: optional csv file for estimated ROI volumes
%
if nargin~=3 && nargin~=4
    error('mmSynthSegNRRD requires 3 or 4 arguments (see help).')
end
if nargin==3
    outputvols=[];
end

% ── Validate inputs ────────────────────────────────────────────────────────
switch exist(input,"file")
    case 2  % single file
        if contains(input,'.nii') || contains(input,'.nii.gz')
            if exist(outputseg,'file')
                error('Output file already exists; function will not overwrite.');
            end
        else
            error('Input must be a .nii/.nii.gz file or a directory.');
        end
        disp('First input is a single nifti file.');
        inputs  = string(input);
        names   = string(regexp(regexp(input,'[^/\\]+$','match','once'), '^[^.]+', 'match','once'));
        outputs = string(outputseg);  % caller supplies full output path

    case 7  % directory
        disp('First input is a directory.');
        files   = dir(fullfile(input, '*.nii*'));
        inputs  = string(fullfile({files.folder}, {files.name}))';
        names   = string(regexp({files.name},'^[^.]+','match','once'))';
        fprintf('%d nifti file(s) found.\n', numel(names))
        disp(names)
        outputs = string(fullfile(outputseg, names)) + ".seg.nrrd";
        % if any(arrayfun(@exist, outputs))
        %     error('One or more .seg.nrrd output files already exist in that directory.')
        % end

    case 0
        error('Input does not exist: %s', input)
    otherwise
        error('Unable to process input: %s', input)
end

% ── Model file ─────────────────────────────────────────────────────────────
if exist(modelfile,'file')
    disp('Model file found; no need to download.');
else
    disp('Model file not found; downloading (~50 MB)...');
    [filepath,~,~] = fileparts(modelfile);
    if ~isempty(filepath) && exist(filepath,'dir')==0
        error('Directory for model file does not exist: %s', filepath);
    end
    websave(modelfile,'https://www.mathworks.com/supportfiles/image/data/trainedBrainSynthSegNetwork.h5');
    disp('Download complete.');
end

% ── Optional CSV output ────────────────────────────────────────────────────
if ~isempty(outputvols)
    [filepath,~,~] = fileparts(outputvols);
    if ~isempty(filepath) && exist(filepath,'dir')==0
        error('Directory for CSV file does not exist: %s', filepath);
    end
end

% ── Segmentation loop ──────────────────────────────────────────────────────
disp('Segmenting!')
currentSize = [0, 0, 0];
net = [];
[classNames, labelIDs] = getBrainCANDISegmentationLabels;

if ~isempty(outputvols)
    fid = fopen(outputvols,'w');
    fprintf(fid,'FileName');
    for i = 2:length(classNames)
        fprintf(fid,',%s', classNames{i});
    end
    fprintf(fid,'\n');
end

for i = 1:numel(inputs)

    fprintf('%d. Working on image %s\n', i, names{i})

    disp('      Reading image...');
    metaData = niftiinfo(inputs{i});
    X        = niftiread(metaData);

    disp('      Preprocessing image...');
    [X1, aff] = preProcessBrainCANDIData(X, metaData);
    inputSize  = size(X1);

    if any(currentSize~=inputSize) || isempty(net)
        disp('      Reading network weights...');
        warning('off','all')
        lgraph = importKerasLayers(modelfile, ImportWeights=true, ImageInputSize=inputSize);
        findPlaceholderLayers(lgraph);
        sf     = softmaxLayer;
        lgraph = replaceLayer(lgraph,"unet_prediction",sf);
        net    = dlnetwork(lgraph);
        warning('on','all')
        currentSize = inputSize;
    else
        disp('      No need to reload network weights.')
    end

    disp('      Prediction 1: original orientation...');
    X2         = dlarray(X1,"SSSCB");
    predictIm  = predict(net, X2);

    disp('      Prediction 2: flipped orientation...');
    flippedData = fliplr(X1);
    flippedData = flip(flippedData,2);
    flippedData = flip(flippedData,1);
    flippedData = dlarray(flippedData,"SSSCB");
    flipPredictIm = predict(net, flippedData);

    disp('      Postprocessing...')
    [seg, vols] = postProcessBrainCANDIData(predictIm, flipPredictIm, labelIDs);

    if ~isempty(outputvols)
        fprintf(fid,'%s', names{i});
        for v = 2:length(vols)
            fprintf(fid,',%f', vols(v));
        end
        fprintf(fid,'\n');
    end

    disp('      Writing .seg.nrrd...');
    writeSlicerSegNRRD(outputs{i}, uint8(seg), aff);
    disp('      Image done!');

end

if ~isempty(outputvols)
    fclose(fid);
end
disp('All done!');

end  % main function


% ═══════════════════════════════════════════════════════════════════════════
function writeSlicerSegNRRD(filename, seg, aff)
%WRITESLICERSEGNRRD  Write a labeled segmentation as a Slicer .seg.nrrd
%
%  filename : output path (should end in .seg.nrrd)
%  seg      : uint8 3-D array with SynthSeg / FreeSurfer label IDs
%  aff      : 4×4 voxel-to-RAS affine (from preProcessBrainCANDIData)
%
%  The output is a single-layer NRRD: all segments share the same 3-D
%  volume; each segment is identified by its LabelValue.  Drag-and-drop
%  the file directly into 3D Slicer — it will appear in the Segmentations
%  module with correct names and colors.

% ── Label table ────────────────────────────────────────────────────────────
LABEL_IDS = [2 3 4 5 7 8 10 11 12 13 14 15 16 17 18 26 28 ...
             41 42 43 44 46 47 49 50 51 52 53 54 58 60];

LABEL_NAMES = { ...
    'Left Cerebral White Matter',      'Left Cerebral Cortex', ...
    'Left Lateral Ventricle',          'Left Inferior Lateral Ventricle', ...
    'Left Cerebellum White Matter',    'Left Cerebellum Cortex', ...
    'Left Thalamus',                   'Left Caudate', ...
    'Left Putamen',                    'Left Pallidum', ...
    '3rd Ventricle',                   '4th Ventricle', ...
    'Brain Stem',                      'Left Hippocampus', ...
    'Left Amygdala',                   'Left Accumbens Area', ...
    'Left Ventral DC', ...
    'Right Cerebral White Matter',     'Right Cerebral Cortex', ...
    'Right Lateral Ventricle',         'Right Inferior Lateral Ventricle', ...
    'Right Cerebellum White Matter',   'Right Cerebellum Cortex', ...
    'Right Thalamus',                  'Right Caudate', ...
    'Right Putamen',                   'Right Pallidum', ...
    'Right Hippocampus',               'Right Amygdala', ...
    'Right Accumbens Area',            'Right Ventral DC'};

% Colors in [R G B] (0-1 range), matching FreeSurfer / SynthSeg convention
LABEL_COLORS = [ ...
    0.961 0.961 0.961; ...  %  2  Left Cerebral White Matter
    0.804 0.243 0.306; ...  %  3  Left Cerebral Cortex
    0.471 0.071 0.525; ...  %  4  Left Lateral Ventricle
    0.769 0.227 0.980; ...  %  5  Left Inferior Lateral Ventricle
    0.863 0.973 0.643; ...  %  7  Left Cerebellum White Matter
    0.902 0.580 0.133; ...  %  8  Left Cerebellum Cortex
    0.000 0.463 0.055; ...  % 10  Left Thalamus
    0.478 0.729 0.863; ...  % 11  Left Caudate
    0.925 0.051 0.690; ...  % 12  Left Putamen
    0.047 0.188 1.000; ...  % 13  Left Pallidum
    0.800 0.714 0.557; ...  % 14  3rd Ventricle
    0.165 0.800 0.643; ...  % 15  4th Ventricle
    0.467 0.624 0.690; ...  % 16  Brain Stem
    0.863 0.847 0.078; ...  % 17  Left Hippocampus
    0.404 1.000 1.000; ...  % 18  Left Amygdala
    1.000 0.647 0.000; ...  % 26  Left Accumbens Area
    0.647 0.165 0.165; ...  % 28  Left Ventral DC
    0.000 0.882 0.000; ...  % 41  Right Cerebral White Matter
    0.804 0.243 0.306; ...  % 42  Right Cerebral Cortex
    0.471 0.071 0.525; ...  % 43  Right Lateral Ventricle
    0.769 0.227 0.980; ...  % 44  Right Inferior Lateral Ventricle
    0.863 0.973 0.643; ...  % 46  Right Cerebellum White Matter
    0.902 0.580 0.133; ...  % 47  Right Cerebellum Cortex
    0.000 0.463 0.055; ...  % 49  Right Thalamus
    0.478 0.729 0.863; ...  % 50  Right Caudate
    0.925 0.051 0.690; ...  % 51  Right Putamen
    0.047 0.188 1.000; ...  % 52  Right Pallidum
    0.863 0.847 0.078; ...  % 53  Right Hippocampus
    0.404 1.000 1.000; ...  % 54  Right Amygdala
    1.000 0.647 0.000; ...  % 58  Right Accumbens Area
    0.647 0.165 0.165];     % 60  Right Ventral DC

% ── Which labels are actually present in this segmentation? ────────────────
present = unique(seg(:));
present(present == 0) = [];

% ── Convert affine: NIfTI RAS+ → NRRD left-posterior-superior (LPS) ───────
% Negate X and Y rows/columns to go from RAS to LPS.
ras2lps   = diag([-1, -1, 1, 1]);
aff_lps   = ras2lps * aff;

d1     = aff_lps(1:3, 1);   % direction along 1st array axis
d2     = aff_lps(1:3, 2);   % direction along 2nd array axis
d3     = aff_lps(1:3, 3);   % direction along 3rd array axis
origin = aff_lps(1:3, 4);

sz = size(seg);

% ── Open file and write NRRD header ───────────────────────────────────────
fid = fopen(filename, 'w');
if fid == -1
    error('Cannot open file for writing: %s', filename);
end

fprintf(fid, 'NRRD0005\n');
fprintf(fid, 'type: unsigned char\n');
fprintf(fid, 'dimension: 3\n');
fprintf(fid, 'space: left-posterior-superior\n');
fprintf(fid, 'sizes: %d %d %d\n', sz(1), sz(2), sz(3));
fprintf(fid, 'space directions: (%g,%g,%g) (%g,%g,%g) (%g,%g,%g)\n', ...
    d1(1), d1(2), d1(3), ...
    d2(1), d2(2), d2(3), ...
    d3(1), d3(2), d3(3));
fprintf(fid, 'kinds: domain domain domain\n');
fprintf(fid, 'endian: little\n');
fprintf(fid, 'encoding: raw\n');
fprintf(fid, 'space origin: (%g,%g,%g)\n', origin(1), origin(2), origin(3));

% Slicer segmentation keys  (NRRD arbitrary key-value pairs use :=)
fprintf(fid, 'Segmentation_ContainedRepresentationNames:=Binary labelmap|\n');
fprintf(fid, 'Segmentation_MasterRepresentation:=Binary labelmap\n');

segIdx = 0;
for k = 1:length(LABEL_IDS)
    lid = LABEL_IDS(k);
    if ~ismember(lid, present)
        continue;
    end

    r = LABEL_COLORS(k, 1);
    g = LABEL_COLORS(k, 2);
    b = LABEL_COLORS(k, 3);

    % Compute bounding box (0-based indices, as Slicer expects)
    mask     = (seg == lid);
    [ix,iy,iz] = ind2sub(sz, find(mask));
    extStr   = sprintf('%d %d %d %d %d %d', ...
        min(ix)-1, max(ix)-1, min(iy)-1, max(iy)-1, min(iz)-1, max(iz)-1);

    fprintf(fid, 'Segment%d_Color:=%g %g %g\n',           segIdx, r, g, b);
    fprintf(fid, 'Segment%d_ColorAutoGenerated:=0\n',     segIdx);
    fprintf(fid, 'Segment%d_Extent:=%s\n',                segIdx, extStr);
    fprintf(fid, 'Segment%d_ID:=Segment_%d\n',            segIdx, segIdx+1);
    fprintf(fid, 'Segment%d_LabelValue:=%d\n',            segIdx, lid);
    fprintf(fid, 'Segment%d_Layer:=0\n',                  segIdx);
    fprintf(fid, 'Segment%d_Name:=%s\n',                  segIdx, LABEL_NAMES{k});
    fprintf(fid, 'Segment%d_NameAutoGenerated:=0\n',      segIdx);
    segIdx = segIdx + 1;
end

% Blank line signals end of NRRD header — required by spec
fprintf(fid, '\n');

% ── Write raw voxel data ───────────────────────────────────────────────────
% MATLAB arrays are column-major: first dimension varies fastest, which
% matches NRRD's expectation for the sizes/space-directions ordering above.
fwrite(fid, seg(:), 'uint8');
fclose(fid);

fprintf('      Wrote %d segments to:\n      %s\n', segIdx, filename);
end
