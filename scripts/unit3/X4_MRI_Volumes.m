%[text] # MRI Volumes
%[text] In the CT and volume rendering scripts, we loaded CT volumes, used Hounsfield Units to choose windows, and rendered the volumes in 3D. In this script, we do the same with MRI volumes, and see what is different. We will read the scan settings from the DICOM header, compare a T1-weighted scan with a T2-weighted scan of the same brain, and use a maximum intensity projection (MIP) to display blood vessels, the way an MR angiogram (MRA) is displayed.
%[text] ### Learning Objectives
%[text] After this exercise, you should be able to
%[text] 1. Find TR, TE, TI, the field strength, and the imaging frequency in an MRI DICOM header
%[text] 2. Use TR, TE, and TI to predict whether a series is T1-weighted, T2-weighted, or FLAIR
%[text] 3. Explain why MRI intensities, unlike Hounsfield Units, have no fixed meaning
%[text] 4. Compare T1- and T2-weighted volumes of the same patient
%[text] 5. Use a maximum intensity projection (MIP) to display blood vessels \
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] ## Clear workspace
clearvars
close all
%%
%[text] ## The dataset: CEREBRIX
%[text] CEREBRIX is a brain dataset from the OsiriX DICOM library. It was acquired on a 1.5 T Siemens scanner and includes several MRI series of the same patient.
mmSetUnitDataFolder(3); % change Current Folder to the Unit 3 Data Folder
dataFolder = fullfile("CEREBRIX", "Neuro Crane");
ls(dataFolder)
%[text] - Each folder is one series: one scan of the same patient, made with a different pulse sequence
%[text] - The folder names are the series descriptions from the scanner. For example, "t2\_tse\_tra" means a T2-weighted turbo spin echo (fast spin echo) scan, acquired in the transverse (axial) plane \
%%
%[text] ## The MRI DICOM header
%[text] In the CT script, the DICOM header told us the slice thickness, pixel spacing, and how to convert pixel values to Hounsfield Units. An MRI header records the **pulse sequence settings** that were used to make the image. Here we load the header of the first image of the T2-weighted series:
t2Folder = fullfile(dataFolder, "t2_tse_tra_p2 - 6");
t2Files = dir(fullfile(t2Folder, "*.dcm"));
meta = dicominfo(fullfile(t2Folder, t2Files(1).name));
%[text] Here are the fields that matter for MRI:
mriFields = ["SeriesDescription" "ScanningSequence" "SequenceName" "RepetitionTime" "EchoTime" "EchoTrainLength" "FlipAngle" "MagneticFieldStrength" "ImagingFrequency" "SliceThickness"];
for f = mriFields
    disp(f + ": " + string(meta.(f)))
end
%[text] - **RepetitionTime** (TR) and **EchoTime** (TE) are in ms
%[text] - **ScanningSequence** = SE means spin echo
%[text] - **EchoTrainLength** = 11 means 11 echoes are collected in each TR. This is a fast (turbo) spin echo, which is why the series name includes "tse"
%[text] - **MagneticFieldStrength** is in tesla, and **ImagingFrequency** is in MHz \
%[text] **Predict:** based on TR and TE, is this series T1-weighted or T2-weighted? [Review MRI doc](https://salcedoe.github.io/MtMdocs/imaging/MRImaging/#tr-and-te-weighting)
%%
%[text] ### Check the Larmor frequency
%[text] The imaging frequency is the Larmor frequency of hydrogen in this scanner:
%[text]{"align":"center"} $ f\_0 = \\bar{\\gamma} B\_0 $
gammaBar = 42.58; % gyromagnetic ratio of hydrogen [MHz/T]
f0 = gammaBar * meta.MagneticFieldStrength % predicted Larmor frequency [MHz]
meta.ImagingFrequency % frequency recorded by the scanner [MHz]
%[text] - The scanner was tuned to the Larmor frequency of hydrogen: a radio tuned to about 64 MHz \
%%
%[text] ### Compare the settings of every series
%[text] The local function **getSeriesSettings** (at the end of the script) reads the header of the first image in every series and collects the settings in a table. Series without pulse sequence settings (such as the "Axial\_T1" series, which was made by OsiriX) are skipped.
settings = getSeriesSettings(dataFolder)
%[text] - "\<MPR Range\[1\]\>" is a reformat of the 3D series, so it has the same settings
%[text] - The two 3D series (IR\\GR) are an **MPRAGE**: a fast 3D T1-weighted gradient echo scan. Its T1 contrast comes from an inversion pulse (TI = 1100 ms), so its TR doesn't follow the simple "short TR = T1-weighted" rule \
%[text] Answer these questions:
%[text] 1. Which volume(s) has the smallest voxels? `prod(settings.VoxelSpacing,2)`
%[text] 2. Which series is T1-weighted? Which settings tell you?
%[text] 3. Which series is T2-weighted? Which settings tell you?
%[text] 4. The "dark-fluid" series has a long TR and a long TE, like a T2-weighted scan, but it also has an inversion time (TI) of 2500 ms. What kind of sequence is this, and what tissue does it suppress? (Hint: look at the [sequences table](https://salcedoe.github.io/MtMdocs/imaging/MRImaging/#common-pulse-sequences) on the [MtMdocs MRI page](https://salcedoe.github.io/MtMdocs/imaging/MRImaging/#learning-objectives).)
%[text] 5. The "t1\_mpr3D\_ns\_sag\_gd" series ends in "gd". What do you think "gd" stands for? \
%%
%[text] The dicom browser shows these series and allows you to browse the individual images
dicomBrowser(dataFolder)
%%
%[text] ## T1- vs T2-weighted volumes
%[text] Now we load the T1-weighted and T2-weighted series as medicalVolume objects.
t1 = medicalVolume(fullfile(dataFolder, "t1_fl2d_tra - 10"));
t2 = medicalVolume(fullfile(dataFolder, "t2_tse_tra_p2 - 6"));
size(t1.Voxels)
size(t2.Voxels)
%[text] - The two volumes cover the same brain, but they have different numbers of rows, columns, and slices
%[text] - So, slice 15 of the T1 volume is not at the same position as slice 15 of the T2 volume \
%[text] To compare them slice by slice, we **resample** the T2 volume onto the T1 voxel grid, just as we resampled the PET volume onto the CT grid in the volume rendering script. (You may see a warning that an approximate mapping is used. That's OK here.)
t2Resampled = resample(t2, t1.VolumeGeometry);
size(t2Resampled.Voxels)
%%
%[text] ### Display the same slice
sliceNumber = 15; % default = 15, try 24
t1Slice = rot90(t1.Voxels(:,:,sliceNumber), -1); % rotate so the front of the head is at the top
t2Slice = rot90(t2Resampled.Voxels(:,:,sliceNumber), -1);
figure;
tiledlayout(1,2,"TileSpacing","tight")
nexttile
imshow(t1Slice, [])
title("T1-weighted")
nexttile
imshow(t2Slice, [])
title("T2-weighted")
%[text] Same patient, same slice, different pulse sequences. Compare these structures:
%[text] - **CSF** (in the ventricles and around the brain)
%[text] - **The eyes** (the vitreous humor is mostly water)
%[text] - **Gray matter vs white matter**
%[text] - **Fat** (in the scalp and behind the eyes) \
%[text] **Predict:** which tissues will be bright on each scan? Then check your predictions against the images.
%[text] - Try other slices (change sliceNumber) \
%%
%[text] ### The FLAIR series
%[text] FLAIR (fluid-attenuated inversion recovery) is a T2-weighted scan with an extra 180° inversion pulse at the start. The inversion time (TI) is chosen so that CSF has no signal when the image is made. This series was acquired in the coronal plane.
flair = medicalVolume(fullfile(dataFolder, "t2_tirm_cor_dark-fluid-fs - 5"));
flairSlice = rot90(flair.Voxels(:,:,round(end/2)), -1); % the middle slice, rotated so the top of the head is at the top
figure;
imshow(flairSlice, [])
title("FLAIR (coronal)")
%[text] - Notice that CSF is dark, even though this is a T2-weighted scan
%[text] - This patient has a large lesion. Find it on the FLAIR image, then go back and find it on the T1- and T2-weighted slices (slice 24). On which scans is it bright?
%[text] - Why is this useful? Lesions next to the ventricles, like multiple sclerosis plaques, are bright on T2. On a regular T2-weighted scan, they are hard to see next to the bright CSF. On FLAIR, they stand out \
%%
%[text] ### Explore the volumes in the Medical Volume Viewer
medicalVolumeViewer(t1)
%[text] - Click on Import and select **t2** from the workspace
%[text] - Click the eye icon next to t2 to show it, then drag the Slice Opacity slider to blend the two scans
%[text] - Because the Medical Volume Viewer uses the spatial referencing of each volume, you can import the original t2 volume (not the resampled one) \
%%
hvs = volshow(t2,RenderingStyle="SlicePlanes")
%%
%[text] ## No Hounsfield Units
%[text] In CT, every voxel value has a fixed meaning: air is -1000 HU, water is 0 HU, and bone is several hundred HU or more, on any CT scanner. That's why CT windows (lung window, bone window) work for every patient.
%[text] MRI intensities have **no units and no fixed meaning**. The value of a voxel depends on the tissue, but also on the pulse sequence, the scanner, the receiver coil, and even where the voxel is in the coil. Let's compare the histograms of a CT volume (from the volume rendering script) with our two MRI volumes:
ct = medicalVolume(fullfile("MedicalVolumeDICOMData", "LungCT01"));
figure;
tiledlayout(1,3,"TileSpacing","compact")
nexttile
histogram(ct.Voxels(ct.Voxels > -2000)) % skip the -3024 filler values
xline([-1000 0], "--", ["air" "water"])
xlabel("Hounsfield Units")
title("CT")
nexttile
histogram(t1.Voxels)
xlabel("Intensity (no units)")
title("MRI: T1-weighted")
nexttile
histogram(t2.Voxels)
xlabel("Intensity (no units)")
title("MRI: T2-weighted")
%[text] - On CT, you can label the peaks: air near -1000, soft tissue near 0 to +80
%[text] - On MRI, the numbers are arbitrary. The same tissue (for example, CSF) has a different value on the T1 and T2 scans, and would have different values on another scanner \
%%
%[text] ### Windowing MRI
%[text] Because there are no standard values, there are no standard MRI windows. Instead, MRI viewers set the window from the data itself, for example from the 1st to the 99th percentile of the voxel values:
t1Window = prctile(double(t1.Voxels(:)), [1 99])
t2Window = prctile(double(t2.Voxels(:)), [1 99])
figure;
tiledlayout(1,2,"TileSpacing","tight")
nexttile
imshow(t1Slice, t1Window)
title("T1-weighted, 1st–99th percentile window")
nexttile
imshow(t2Slice, t2Window)
title("T2-weighted, 1st–99th percentile window")
impixelinfo
%[text] - Move the cursor over CSF in the T2-weighted image, and note the value. Would that value mean anything on another scanner?
%[text] - Try narrowing a window (for example, `[0 300]` for the T1 slice). Which tissues become easier to tell apart? \
%%
%[text] ## Maximum intensity projection (MIP) for MR angiography
%[text] A **maximum intensity projection** keeps only the brightest voxel along each line of sight. If blood is the brightest thing in the volume, a MIP shows the blood vessels as a 3D "roadmap". That's how MR angiograms (MRA) are displayed.
%[text] The "t1\_mpr3D\_ns\_sag\_gd" series is a 3D T1-weighted scan acquired after an injection of gadolinium contrast, which shortens the T1 of blood, so blood vessels are bright.
gd = medicalVolume(fullfile(dataFolder, "t1_mpr3D_ns_sag_gd - 16"));
gd.VoxelSpacing % small voxels
gdMIP = squeeze(max(gd.Voxels, [], 1)); % brightest voxel along the first dimension
figure;
imshow(rot90(gdMIP, 2), []) % rotate so the face is at the top
title("MIP of the post-gadolinium T1 volume")
%[text] - You can see some vessels, but the scalp is in the way. Why is the scalp so bright on a T1-weighted scan? (Hint: what tissue is in the scalp, and does it have a short or long T1?) \
%%
%[text] ### Visualize volume
medicalVolumeViewer(gd)
%%
%[text] ### MIP of a skull-stripped volume
%[text] This volume is a post-gadolinium T1 scan of a different patient (from the Tumors folder) that has been **skull-stripped**: the scalp and skull were removed, leaving only the brain.
stripped = medicalVolume(fullfile("Tumors", "MRBT1stripped.nrrd"));
strippedMIP = max(stripped.Voxels, [], 3); % brightest voxel along each line from top to bottom
figure;
imshow(rot90(strippedMIP), [])
title("MIP of a skull-stripped post-gadolinium T1 volume")
%[text] - Now the blood vessels stand out clearly
%[text] - Can you find the tumor? It enhances with gadolinium, so it is bright too \
%[text] Real MRA sequences do not need skull-stripping. For example, **time-of-flight (TOF)** MRA suppresses the signal from stationary tissue, so that only fresh, flowing blood is bright. Contrast-enhanced MRA uses gadolinium, as here, plus fat suppression to darken the scalp.
%%
%[text] ### MIP in 3D
%[text] **volshow** can render the volume as a MIP. Rotate the volume and watch the vessels move past each other.
hvs = volshow(stripped, RenderingStyle="MaximumIntensityProjection");
%[text] - Compare this with the bone MIP in the volume rendering script. Why does MIP work so well for both bone on CT and vessels on MRA? \
%%
%[text] ## Questions
%[text] 1. Which two header fields would you check first to decide if an MRI series is T1- or T2-weighted?
%[text] 2. Why can't you use a fixed window, like the CT lung window, on an MRI?
%[text] 3. On which scan is CSF bright: T1-weighted, T2-weighted, or FLAIR? Why?
%[text] 4. Why did we need to resample the T2 volume before comparing it slice by slice with the T1 volume?
%[text] 5. What does a MIP display, and why is it useful for MR angiography?
%[text] 6. Create a render of the gd volume using volshow. Crop the anterior part of the face to reveal the tumor.  \
%%
%[text] # Local Functions
%[text] ### getSeriesSettings
%[text] Reads the header of the first DICOM file in each series folder and returns a table of pulse sequence settings. Series that don't record TR (such as reformats) are skipped.
function settings = getSeriesSettings(dataFolder)
seriesFolders = dir(dataFolder);
seriesFolders = seriesFolders([seriesFolders.isdir] & ~startsWith({seriesFolders.name}, "."));
settings = table();
for i = 1:numel(seriesFolders)
    files = dir(fullfile(dataFolder, seriesFolders(i).name, "*.dcm"));
    info = dicominfo(fullfile(files(1).folder, files(1).name));
    if ~isfield(info, "RepetitionTime") || isempty(info.RepetitionTime)
        continue % skip series without pulse sequence settings
    end
    voxSpacing = [info.PixelSpacing(:)' info.SliceThickness];
    row = table(string(info.SeriesDescription), string(info.ScanningSequence), ...
        voxSpacing,...
        info.RepetitionTime, info.EchoTime, getNumber(info, "InversionTime"), getNumber(info, "EchoTrainLength"), ...
        'VariableNames', ["Series" "Sequence" "VoxelSpacing" "TR_ms" "TE_ms" "TI_ms" "EchoTrain"]);
    settings = [settings; row]; %#ok<AGROW>
end
settings = unique(settings, "stable"); % repeated series (same settings) appear once
end
%[text] ### getNumber
%[text] Returns a numeric header field, or NaN if the field is missing or empty
function value = getNumber(info, fieldName)
value = NaN;
if isfield(info, fieldName) && ~isempty(info.(fieldName))
    value = double(info.(fieldName));
end
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
