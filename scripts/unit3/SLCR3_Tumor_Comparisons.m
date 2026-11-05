%[text] # Tumor Comparison
%[text] In the [Segment a Brain Tumor](https://salcedoe.github.io/MtMdocs/slicer/MRTumorSegment/) exercise in Slicer, you segmented a falcine meningioma in two MRIs of the same patient: a baseline scan (MRBrainTumor1, segmented as **Tumor1**) and a follow-up scan (MRBrainTumor2, registered to the baseline as MRBT2mvd, and segmented as **Tumor2**). You also measured both tumors with the Line tool, stripped the skull, and ran SynthSeg.
%[text] In this live script, we bring those results into MATLAB to answer two questions:
%[text] 1. Did the tumor change between the two scans?
%[text] 2. Which brain structures does the tumor affect? \
%[text] ### Learning Objectives
%[text] - Load a Slicer segmentation with overlapping segments stored in layers
%[text] - Display a tumor in 3D, as a volume rendering and as a surface
%[text] - Import line measurements made in Slicer (.mrk.json files), and compare them with the segmentations
%[text] - Compare two segmentations with the Dice coefficient and the surface distance
%[text] - Use a SynthSeg segmentation to determine which brain structures a tumor affects \
%[text:tableOfContents]{"heading":"Table of Contents"}
clearvars
close all hidden
%%
%[text] ## Load the tumor segmentations
%[text] ### Set Paths structure
%[text] To use your own files, change `paths.project` to your own Slicer folder.
clearvars
close all
paths.project = "/Users/ernesto/MATLAB-Drive/MtMresources/data/unit3/Tumors"; %[control:filebrowser:788d]{"position":[17,77]}
paths.contents = dir(fullfile(paths.project,"*.nrrd")); % find the slicer volume files in folder
paths.contents = [paths.contents; dir(fullfile(paths.project,"*.csv"))]; % find csv files in folder]
fnames = {paths.contents.name}' % cell array of relevant files
%%
%[text] This script uses these files from the Slicer exercise, saved in one folder:
%[text] - **MRBT1stripped.nrrd**: MRBrainTumor1 with the skull removed (from [Skull Stripping](https://salcedoe.github.io/MtMdocs/slicer/MRTumorSegment/#skull-stripping))
%[text] - **Merged Segmentations.seg.nrrd**: one segmentation with three segments: the brain (from skull stripping), Tumor1, and Tumor2
%[text] - **T1-AP.mrk.json**, **T1-LR.mrk.json**, ..., **T2-SI.mrk.json**: your line measurements
%[text] - **MRBT1stripped\_synthseg\_v2.seg.nrrd** the SynthSeg segmentation
%[text] - **MRBT1stripped\_volumes.csv**: a table containing the volume of each brain structure (from [SynthSeg](https://salcedoe.github.io/MtMdocs/slicer/MRTumorSegment/#synthseg)) \
paths.intensity = fullfile(paths.project,fnames(1)); % MRBT1stripped %[control:dropdown:295d]{"position":[42,51]}
paths.segment = fullfile(paths.project,fnames(1)); % Merged Segmentations %[control:dropdown:5312]{"position":[40,49]}
paths.synthseg = fullfile(paths.project,fnames(2)); % MRBT1stripped_synthseg_v2.seg.nrrd %[control:dropdown:0b92]{"position":[41,50]}
paths.volumes = fullfile(paths.project,fnames(1)) % MRBT1stripped_volumes.csv %[control:dropdown:19fb]{"position":[40,49]}
%%
%[text] ### Use Example paths
%[text] If you don't have the requisite files, using the example paths instead. Uncomment the code first
% paths.project = fullfile(mmSetUnitDataFolder(3), "Tumors"); % Tumors folder in the Unit 3 Data Folder
% paths.intensity = fullfile(paths.project, "MRBT1stripped.nrrd"); % T1-weighted MRI, with the skull removed
% paths.segment = fullfile(paths.project, "Merged Segmentations.seg.nrrd"); % brain, Tumor1, and Tumor2
% paths.synthseg = fullfile(paths.project, "MRBT1stripped_synthseg_v2.seg.nrrd"); % SynthSeg segmentation
% paths.volumes = fullfile(paths.project, "MRBT1stripped_volumes.csv"); % SynthSeg volumes
% table(fieldnames(paths), structfun(@(x) exist(x, "file"), paths), VariableNames=["path" "X"]) % make sure the paths exist
%[text] - 7 means a folder, and 2 means a file. A zero means that the path doesn't exist. \
%%
%[text] ### Load the medical volumes
warning("off", "medical:medicalVolume:noEndian") % Slicer's NRRD files trigger a harmless warning
intMV = medicalVolume(paths.intensity)
segMV = medicalVolume(paths.segment)
%[text] - Notice that the voxels of the segmentation volume are a **4D** array (256×256×112×3). The fourth dimension is the layer: Slicer stored each segment in its own layer, because the segments overlap (both tumors are inside the brain, and the two tumors overlap each other)
%[text] - So we have to be careful how we process this data \
%%
%[text] ### Get the segmentation metadata
%[text] The segmentation metadata lists both the layer and the label value of each segment:
segT = mmGetSlicerSegmentInfo(paths.segment)
%[text] - There are three layers, and in every layer, the segment has a label value of 1
%[text] - Because the label values are the same, we can't tell the segments apart by their label values alone, and we can't pass the 4D segmentation volume directly to **volshow**
%[text] - Instead, we need to index out each segment from its own layer \
%%
%[text] ### Extract the segments from the medical volume
%[text] Luckily, the course function **`mmGetMedicalVolumeSegment`** can handle layers. It looks up the layer and the label value of each segment in the table:
brainSeg = mmGetMedicalVolumeSegment(segMV, segT, segName="brain")
t1Seg = mmGetMedicalVolumeSegment(segMV, segT, segName="Tumor1")
t2Seg = mmGetMedicalVolumeSegment(segMV, segT, segName="Tumor2")
%[text] - Now we have three structures, each with its own 3D mask
%[text] - All three masks have the same voxels, even though Tumor2 comes from the follow-up scan. When you [registered the volumes](https://salcedoe.github.io/MtMdocs/slicer/MRTumorSegment/#register-the-volumes), Slicer resampled the follow-up scan onto the voxels of the baseline scan (MRBT2mvd). That is what lets us compare the two tumors voxel by voxel \
%%
%[text] ## Display the tumor as a volume
%[text] In Slicer, you volume-rendered MRBrainTumor1 and cropped it to the tumor. Here we render the skull-stripped brain with **volshow**, and overlay Tumor1. **volshow** can display `intMV`, because it is a 3D volume, and we pass the Tumor1 mask as the `OverlayData`:
hvr3 = viewer3d(BackgroundColor="white", BackgroundGradient="off", CameraZoom=1); % white background, no gradient
hvol = volshow(intMV, Parent=hvr3, ...
    RenderingStyle="GradientOpacity", ... % makes the intensity volume more transparent
    OverlayData=t1Seg.mask);
%[text] - The default display settings aren't very exciting. Let's change them one at a time \
%%
hvol.Alphamap = single(linspace(0, 1, 256)); % make brighter voxels more opaque
%%
hvol.OverlayAlpha = single(1); % make the tumor overlay opaque
%%
hvol.RenderingStyle = "VolumeRendering"; % try other rendering styles, such as "MaximumIntensityProjection" or "GradientOpacity"
%%
%[text] ## Display the surfaces
%[text] To display the segments as surfaces, we use the course function **`mmPlotMask2Surface`**, with the mask of each segment. To display the surfaces in mm, we pass the transformation from voxels to mm, which **`intrinsicToWorldMapping`** creates from the geometry of the volume.
%[text] We call **`mmPlotMask2Surface`** once for each segment. But each call adds lights to the scene, and too many lights make the scene look washed out. So in every call except the last one, we set the option `lightEMup` to false, which adds no lights. In the last call, we leave it at true (the default), which lights the whole scene once.
%[text] First, pick a color for the brain:
brainColor = [0.969 0.961 0.816]; % pick a pretty color %[control:colorPicker:2342]{"position":[14,33]}
%%
tform = intrinsicToWorldMapping(segMV.VolumeGeometry); % transformation from voxels to mm (scale, rotate, translate)
figure
mmPlotMask2Surface(brainSeg.mask, fcolor=brainColor, transform=tform, smooth=true, lightEMup=false);
mmPlotMask2Surface(t1Seg.mask, fcolor="cyan", transform=tform, smooth=false, lightEMup=true);
%%
%[text] Now let's plot the two tumor segmentations together:
figure
t1Seg.hp = mmPlotMask2Surface(t1Seg.mask, fcolor="cyan", transform=tform, smooth=false, lightEMup=false);
t2Seg.hp = mmPlotMask2Surface(t2Seg.mask, fcolor="green", transform=tform, smooth=false, lightEMup=true);
%[text] - Compare this view with the overlay you made in Slicer, in [Review Segments](https://salcedoe.github.io/MtMdocs/slicer/MRTumorSegment/#review-segments). Do the two tumors look the same size? \
%%
%[text] ## Measure the tumors
%[text] ### Import your Slicer measurements
%[text] In Slicer, you [measured each tumor with the Line tool](https://salcedoe.github.io/MtMdocs/slicer/MRTumorSegment/#manually-measure-tumor-with-ruler) along its three anatomical axes, and named each line by tumor and axis (e.g. `T1-LR`). Slicer saves each line in its own markup file (.mrk.json). These files are JSON text files that contain the coordinates of the control points and the length of the line.
%[text] The local function **readLineMarkups** (at the end of this script) finds every .mrk.json file in a folder, keeps the lines, and collects their names, lengths, and control points into one table:
markups = readLineMarkups(paths.project)
%[text] - `Point1` and `Point2` are the two control points, in mm (LPS coordinates, the same as our surfaces) \
%%
%[text] Next, we keep only the lines that follow the naming scheme: the tumor number, a dash, and the axis. Lines with other names are listed, so you can check them:
isNamed = matches(markups.Name, "T" + ("1" | "2") + "-" + ("AP" | "LR" | "SI"));
markups.Name(~isNamed) % lines that don't follow the naming scheme
markups = markups(isNamed, :);
markups.Tumor = extractBefore(markups.Name, "-");
markups.Axis = extractAfter(markups.Name, "-");
%[text] - If one of your measurements is missing, rename it in Slicer (or rename the .mrk.json file) and run this section again \
%%
%[text] **unstack** turns the table into one row per tumor, with one column per axis:
measured = unstack(markups(:, ["Tumor" "Axis" "Length_mm"]), "Length_mm", "Axis")
%%
%[text] ### Plot the measurements on the tumors
%[text] Because the markups and the surfaces are both in mm, we can plot the lines right on top of the tumors:
figure
tiledlayout(1, 2, TileSpacing="compact")
for tumor = ["T1" "T2"]
    nexttile
    seg = t1Seg;
    if tumor == "T2"
        seg = t2Seg;
    end
    mmPlotMask2Surface(seg.mask, fcolor=seg.color, falpha=0.3, transform=tform, smooth=false, lightEMup=true);
    hold on % keep the surface when we add the lines
    lines = markups(markups.Tumor == tumor, :);
    for k = 1:height(lines)
        P = [lines.Point1(k,:); lines.Point2(k,:)];
        plot3(P(:,1), P(:,2), P(:,3), "-o", LineWidth=2, MarkerFaceColor="auto")
    end
    legend(["tumor" lines.Axis'], Location="southoutside", Orientation="horizontal")
    title(tumor)
    hold off
end
%%
%[text] ### Compare the measurements with the extent of the segmentations
%[text] Because we transformed the surfaces to mm, the range of their vertices is the **extent** of each tumor in mm: the size of the box that just fits around it, along x (LR), y (AP), and z (SI). **join** puts the extents next to your measurements:
extent = array2table([range(t1Seg.hp.Vertices); range(t2Seg.hp.Vertices)], VariableNames=["LR" "AP" "SI"]);
extent.Tumor = ["T1"; "T2"];
comparison = join(measured, extent, Keys="Tumor");
comparison = comparison(:, ["Tumor" "AP_measured" "AP_extent" "LR_measured" "LR_extent" "SI_measured" "SI_extent"]) % put each axis side by side
%[text] - **Question**: a line measures the tumor on one slice, at one place, while the extent covers the whole segmentation. So which should be longer? Are your lines shorter or longer than the extents? If a line is longer, where did you put its control points?
%[text] - **Question**: the baseline radiologist reported 3.10 cm anteroposteriorly and 3.51 cm in height, and the follow-up radiologist reported 3.3 × 3.2 cm. How do your measurements compare? Did the tumor grow? \
%%
%[text] ## Compare the two segmentations
%[text] ### Dice coefficient
%[text] The Dice coefficient measures how much the two tumor segmentations overlap, from 0 (no overlap) to 1 (identical):
dice(t1Seg.mask, t2Seg.mask)
%[text] - A Dice coefficient above 0.9 is excellent agreement. The tumor looks about the same in the two scans \
%%
%[text] ### Surface distance
%[text] The Dice coefficient tells us how much the two tumors overlap, but not **where** they differ. The course function **`mmSurfaceDistance`** measures the distance from every vertex of one tumor surface to the other surface, and colors the surface by that distance: **blue** where the surface is inside the other tumor, **white** where they agree, and **red** where it is outside. Neither segmentation is the "truth" here, so we measure in both directions:
tumorDistTable = mmSurfaceDistance(t1Seg, t2Seg, Names=["Tumor1" "Tumor2"], Direction="both", Title="Tumor1 vs. Tumor2")
%[text] - The two maps are close to mirror images: where Tumor1 sticks out of Tumor2 (red), Tumor2 is inside Tumor1 (blue)
%[text] - Most of the surface is within 2 mm, which is about 2 voxels
%[text] - The histograms have peaks at about -1 and +1 mm. Both tumors are on the same voxels, which are about 1 mm wide (0.94 × 0.94 × 1.4 mm). So where the two segmentations differ, they usually differ by a whole voxel
%[text] - The voxels of this MRI aren't cubes, but **mmSurfaceDistance** takes care of that: the distances are in mm
%[text] - **Question**: the two tumors come from two scans and two segmentations. Can you tell whether the differences come from a change in the tumor or from how you segmented it? \
%%
%[text] ### Summary table
%[text] Let's collect the volume and the extent of each tumor in one table. The volume is the number of voxels times the volume of one voxel:
rp = table(["Tumor1"; "Tumor2"], ...
    [t1Seg.volume * prod(t1Seg.spacing); t2Seg.volume * prod(t2Seg.spacing)] / 1000, ... % mm^3 to mL
    [range(t1Seg.hp.Vertices); range(t2Seg.hp.Vertices)], ...
    VariableNames=["Segment" "Volume_mL" "Extent_mm"])
%[text] - **Question**: by what percent did the volume change between the two scans? Does that agree with the follow-up radiologist, who reported that the mass "appears unchanged"? \
%%
%[text] # Which brain structures does the tumor affect?
%[text] In the [SynthSeg](https://salcedoe.github.io/MtMdocs/slicer/MRTumorSegment/#synthseg) step in Slicer, you ran SynthSeg 2.0 on the skull-stripped MRI, and scrubbed through the slices to see whether SynthSeg segmented the tumor. Now let's answer that question with numbers, and use SynthSeg to find out which structures the tumor affects.
%%
%[text] ## Load the SynthSeg segmentation
synthMV = medicalVolume(paths.synthseg)
synthT = mmGetSlicerSegmentInfo(paths.synthseg)
%[text] - Unlike the merged tumor segmentation, the SynthSeg segments don't overlap, so they all share one layer, and each segment has its own label value
%[text] - SynthSeg works on 1 mm cubic voxels, so its volume has different voxels from our MRI (137×177×136 voxels of 1 mm, instead of 256×256×112 voxels of 0.94 × 0.94 × 1.4 mm) \
%%
%[text] We can visualize the intensity volume and the labels, as follows:
medicalVolumeViewer(intMV,synthMV)
%%
%[text] Even though the voxels differ, both segmentations line up when we plot them in mm. Here are the left and right cerebral white matter with the tumor:
synWML = mmGetMedicalVolumeSegment(synthMV, synthT, segName="left cerebral white matter");
synWMR = mmGetMedicalVolumeSegment(synthMV, synthT, segName="right cerebral white matter");

figure
mmPlotMask2Surface(synWML.mask, fcolor="blue", falpha=0.1, transform=synWML.tform, lightEMup=false);
mmPlotMask2Surface(synWMR.mask, fcolor=brainColor, falpha=0.1, transform=synWMR.tform, lightEMup=false);
mmPlotMask2Surface(t1Seg.mask, fcolor="magenta", transform=tform, smooth=false, lightEMup=true);
legend(["left white matter" "right white matter" "tumor"])
%%
%[text] ### Put the SynthSeg labels on the MRI voxels
%[text] To count the SynthSeg labels inside the tumor, we need both on the same voxels. **resample** puts the labels on the voxel grid of the MRI. We use nearest-neighbor interpolation, because the labels are categories: label 17 (left hippocampus) and label 18 (left amygdala) can't be averaged into label 17.5.
labels = resample(synthMV, intMV.VolumeGeometry, Method="nearest").Voxels; % one label per MRI voxel
%%
%[text] Let's check the result on the slice through the center of the tumor:
[~, ~, tumorSlices] = ind2sub(size(t1Seg.mask), find(t1Seg.mask));
z = round(mean(tumorSlices)); % slice through the center of the tumor
mriSlice = mat2gray(intMV.Voxels(:,:,z));

figure
tiledlayout(1, 2, TileSpacing="tight")
nexttile
imshow(mriSlice)
title("MRI, slice " + z)
nexttile
imshow(labeloverlay(mriSlice, labels(:,:,z), Transparency=0.5))
hold on
visboundaries(t1Seg.mask(:,:,z), Color="w", LineWidth=1); % outline of Tumor1
hold off
title("SynthSeg labels and the tumor (white)")
%[text] - The labels line up with the MRI: the cortex (the folded gray matter) and the white matter follow the anatomy
%[text] - Look at the tumor. Did SynthSeg label it? \
%%
%[text] ## Exercise: which structures does the tumor affect?
%[text] ### Step 1: What did SynthSeg call the tumor?
%[text] The local function **labelSummary** (at the end of this script) counts the voxels of each SynthSeg label inside a mask, and lists them in a table. Here it is for the voxels inside Tumor1:
insideTumor = labelSummary(labels, t1Seg.mask, synthT)
%[text] - About 60% of the tumor voxels are labeled **background**: SynthSeg left a hole where the tumor is. SynthSeg was trained on healthy brains, so it has no label for a tumor
%[text] - About 20% are labeled **csf**, the fluid around the brain. So SynthSeg called most of the tumor something other than brain tissue
%[text] - The rest is labeled cortex or white matter, mostly in the left hemisphere. Some of these voxels are along the edge of the tumor, where two segmentations rarely agree exactly. But some are deeper inside: there, SynthSeg mistook part of the tumor for brain. An automated segmentation can be wrong, so always check it against the image
%[text] - **Question**: is the tumor inside the brain tissue, or outside it, pressing on the brain? How does that fit with [where meningiomas grow](https://salcedoe.github.io/MtMdocs/slicer/MRTumorSegment/#what-is-a-meningioma)? \
%%
%[text] ### Step 2: What does the tumor touch?
%[text] To find the structures next to the tumor, we build a **shell** around it: we dilate the tumor mask (**imdilate**) by 3 voxels in every direction, and remove the tumor itself. Then we list the labels in the shell:
shell = imdilate(t1Seg.mask, strel("sphere", 3)) & ~t1Seg.mask; % a shell about 3-4 mm thick around the tumor
aroundTumor = labelSummary(labels, shell, synthT)
%[text] - **Question**: which structures does the tumor touch? Which hemisphere is it in? (Hint: "left" and "right" are the patient's left and right)
%[text] - **Question**: the tumor touches both hemispheres. Look at the slice above: what separates the two hemispheres where the tumor sits? Why is this tumor called a **falcine** meningioma? \
%%
%[text] ### Step 3: Display the tumor with its neighbors in 3D
%[text] Let's plot the tumor with the two cerebral hemispheres. Each hemisphere is its cortex plus its white matter:
leftHemisphere = ismember(labels, synthT.LabelValue(ismember(synthT.SegName, ["left cerebral cortex" "left cerebral white matter"])));
rightHemisphere = ismember(labels, synthT.LabelValue(ismember(synthT.SegName, ["right cerebral cortex" "right cerebral white matter"])));

figure
mmPlotMask2Surface(leftHemisphere, fcolor="blue", falpha=0.15, transform=tform, smooth=true, lightEMup=false);
mmPlotMask2Surface(rightHemisphere, fcolor="green", falpha=0.15, transform=tform, smooth=true, lightEMup=false);
mmPlotMask2Surface(t1Seg.mask, fcolor="red", transform=tform, lightEMup=true);
legend(["left hemisphere" "right hemisphere" "tumor"])
view(0, 90) % view from above
%[text] - This MRI uses LPS coordinates: +x points to the patient's **L**eft, +y to the **P**osterior (back), and +z to the **S**uperior (top). So in this view from above, the front of the brain is at negative y
%[text] - Rotate the figure. Is the tumor on the surface of the brain, or deep inside? The follow-up radiologist described a "left frontal lobe mass". Do you agree? \
%%
%[text] ### Step 4: Does the tumor push on the brain?
%[text] A large tumor can push brain structures out of place (a **mass effect**). One sign is a difference between the left and right sides: for example, a lateral ventricle that is squeezed on the side of the tumor.
%[text] SynthSeg saved the volume of each structure, in mm³, in the CSV file. The file has one row, with one column per structure:
volumes = readtable(paths.volumes, VariableNamingRule="preserve", TextType="string")
%[text] - SynthSeg created this file when it segmented the brain. The column names are the segment names, and **`total intracranial`** is everything inside the skull: the brain and the CSF around it \
%%
%[text] For a sense of scale, let's compare the tumor with the intracranial volume:
intracranial_mL = volumes.("total intracranial") / 1000 % mm^3 to mL
tumorPercent = 100 * rp.Volume_mL(1) / intracranial_mL % Tumor1, as a percent of the intracranial volume
%[text] - The tumor is small compared with the whole brain. But the skull can't expand, so even a small mass can push on the structures next to it \
%%
%[text] Let's compare the volumes of the left and right structures:
structureNames = string(volumes.Properties.VariableNames);
pairNames = erase(structureNames(startsWith(structureNames, "left ")), "left "); % structures with a left and a right side
leftVolumes = arrayfun(@(name) volumes.("left " + name), pairNames) / 1000; % mL
rightVolumes = arrayfun(@(name) volumes.("right " + name), pairNames) / 1000; % mL
asymmetry = table(pairNames', leftVolumes', rightVolumes', 100 * (leftVolumes - rightVolumes)' ./ ((leftVolumes + rightVolumes)' / 2), ...
    VariableNames=["Structure" "Left_mL" "Right_mL" "Difference_pct"])
%[text] - `Difference_pct` is the difference between the left and right volumes, as a percent of their mean. Positive means the left one is larger
%[text] - **Question**: which structures differ the most between left and right? Could the tumor explain the difference? (Hint: small structures, like the ventricles, vary a lot between healthy people too. How could you tell whether a difference is caused by the tumor?) \
%%
%[text] ## Questions
%[text] 1. Your line measurements, the extents of the segmentations, and the radiologists' reports all describe the size of the tumor. Which one do you trust the most, and why?
%[text] 2. Why couldn't we pass the 4D segmentation volume directly to **volshow**?
%[text] 3. Why did we use nearest-neighbor interpolation to put the SynthSeg labels on the MRI voxels? What would happen with linear interpolation?
%[text] 4. SynthSeg didn't label the tumor. Is that a problem or useful? How could you use SynthSeg to find tumors automatically?
%[text] 5. Based on Steps 1-4, write one or two sentences, as you would in a radiology report, describing where the tumor is and which structures it affects. \
%%
%[text] ## Local functions
function T = readLineMarkups(folder)
% Read every line markup (.mrk.json) in a folder and its subfolders into a
% table, with one row per line
files = dir(fullfile(folder, "**", "*.mrk.json"));
folderNames = strings(0, 1);
names = strings(0, 1);
lengths = zeros(0, 1);
point1 = zeros(0, 3);
point2 = zeros(0, 3);
for k = 1:numel(files)
    markup = readstruct(fullfile(files(k).folder, files(k).name)).markups;
    if markup.type ~= "Line" || numel(markup.controlPoints) ~= 2
        continue % skip other markups, like the volume rendering ROI
    end
    P = [markup.controlPoints.position];
    P = reshape(P, 3, 2)';
    if markup.coordinateSystem == "RAS"
        P(:, 1:2) = -P(:, 1:2); % convert to LPS, like the volumes
    end
    [~, folderNames(end+1, 1)] = fileparts(files(k).folder);
    names(end+1, 1) = erase(files(k).name, ".mrk.json");
    lengths(end+1, 1) = markup.measurements(1).value;
    point1(end+1, :) = P(1, :);
    point2(end+1, :) = P(2, :);
end
T = table(folderNames, names, lengths, point1, point2, VariableNames=["Folder" "Name" "Length_mm" "Point1" "Point2"]);
end

function T = labelSummary(labels, mask, segT)
% Count the voxels of each label inside a mask, and list the labels from
% the most voxels to the fewest
inside = double(labels(mask));
[ids, ~, idx] = unique(inside);
counts = accumarray(idx, 1);
names = repmat("background", numel(ids), 1); % label 0 isn't a segment
for i = 1:numel(ids)
    isLabel = segT.LabelValue == ids(i);
    if any(isLabel)
        names(i) = segT.SegName(isLabel);
    end
end
T = table(ids, names, counts, 100 * counts / sum(counts), VariableNames=["LabelID" "Structure" "Voxels" "Percent"]);
T = sortrows(T, "Voxels", "descend");
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[control:filebrowser:788d]
%   data: {"browserType":"Folder","defaultValue":"\"\"","label":"Choose your Tumor Folder","run":"Section"}
%---
%[control:dropdown:295d]
%   data: {"defaultValue":"fnames(1)","itemLabels":["6 BODY BONE cropped.nrrd","Salcedo Segmentation.seg.nrrd","Total Segmentation.seg.nrrd"],"items":["fnames(1)","fnames(2)","fnames(3)"],"itemsVariable":"fnames","label":"Drop down","run":"Section"}
%---
%[control:dropdown:5312]
%   data: {"defaultValue":"fnames(1)","itemLabels":["6 BODY BONE cropped.nrrd","Salcedo Segmentation.seg.nrrd","Total Segmentation.seg.nrrd"],"items":["fnames(1)","fnames(2)","fnames(3)"],"itemsVariable":"fnames","label":"Drop down","run":"Section"}
%---
%[control:dropdown:0b92]
%   data: {"defaultValue":"fnames(1)","itemLabels":["6 BODY BONE cropped.nrrd","Salcedo Segmentation.seg.nrrd","Total Segmentation.seg.nrrd"],"items":["fnames(1)","fnames(2)","fnames(3)"],"itemsVariable":"fnames","label":"Drop down","run":"Section"}
%---
%[control:dropdown:19fb]
%   data: {"defaultValue":"fnames(1)","itemLabels":["6 BODY BONE cropped.nrrd","Salcedo Segmentation.seg.nrrd","Total Segmentation.seg.nrrd"],"items":["fnames(1)","fnames(2)","fnames(3)"],"itemsVariable":"fnames","label":"Drop down","run":"Section"}
%---
%[control:colorPicker:2342]
%   data: {"colorFormat":"RGB [0-1]","defaultValue":"[1 1 1]","label":"Color picker","run":"Section"}
%---
