%[text] # Automated Brain Segmentation with SynthSeg
%[text] Segmenting the brain by hand — outlining the cortex, white matter, ventricles, and deep gray nuclei on every slice — can take an expert many hours. In this live script, we will use **SynthSeg**, a deep learning model, to segment 32 brain structures in a T1-weighted MRI in less than a minute. Then we will check the results, view them in 2D and 3D, and measure the volume of each structure.
%[text] SynthSeg ([Billot et al., 2023, Medical Image Analysis](https://doi.org/10.1016/j.media.2023.102789)) is a convolutional neural network (a U-Net). What makes it special is how it was trained: instead of real MRI scans, it was trained on **synthetic** images generated from label maps, with random contrasts, resolutions, and artifacts. Because it has seen so much variety, SynthSeg works on brain MRI scans of almost any contrast and resolution, without any retraining. Here we use **SynthSeg 2.0** ([Billot et al., 2023, PNAS](https://doi.org/10.1073/pnas.2216399120)), the same version as the SynthSeg extension of 3D Slicer, running entirely in MATLAB.
%[text] ### Learning Objectives
%[text] - Load a DICOM MRI series and convert it to NIfTI
%[text] - Check a NIfTI header for errors before using the file
%[text] - Run an automated segmentation with a pretrained deep learning model
%[text] - Resample a label map to match an image volume, and explain why nearest-neighbor interpolation is used for labels
%[text] - Display a segmentation in 2D and 3D
%[text] - Measure the volumes of brain structures from a label map
%[text] - Batch-process a folder of scans with a loop, and keep going when a scan fails
%[text] - Check automated segmentations for errors, and compare measurements between two groups \
%[text] ### Requirements
%[text] - Medical Imaging Toolbox, Image Processing Toolbox, and Deep Learning Toolbox (no support packages or Python needed)
%[text] - About 8 GB of memory. In Part 1, the segmentation takes less than a minute on a laptop. In Part 2, segmenting all six scans takes about 2–3 minutes \
%[text:tableOfContents]{"heading":"Table of Contents"}
%%
%[text] # Part 1: Segment one brain
%[text] ## Setup
%[text] ### Create a project folder
%[text] The MRI is stored in the unit 3 data folder. We won't save anything there. Instead, we save the files that we create (the NIfTI file and the segmentation) in a **project folder** of your own.
%[text] 1. Using Finder (Mac) or File Explorer (Windows), create a new, empty folder where you want to save your files. For example, create a folder called **SynthSeg\_Project** in your Documents folder
%[text] 2. Run this section. A dialog box opens: go to your new folder, select it, and click **Open** (Mac) or **Select Folder** (Windows) \
clearvars
close all

projectFolder = uigetdir(userpath, "Select your SynthSeg project folder") %[output:6890cb29]
if isequal(projectFolder, 0) % uigetdir returns 0 if you click Cancel %[output:group:077e9ca4]
    error("No folder selected. Run this section again and select your project folder.") %[output:7ad32fc9]
end %[output:group:077e9ca4]
checkProjectFolder(projectFolder) % stops with an error if you can't save files in this folder
%[text] - Tip: instead of using the dialog box, you can type the path to your folder, for example: projectFolder = "/Users/yourname/Documents/SynthSeg\_Project" \
%%
%[text] ### Find the data
mmSetUnitDataFolder(3); % change Current Folder to the Unit 3 Data Folder
dcmFolder = fullfile("SynthSegDemo","T1_MPRAGE_DICOM"); % folder with the DICOM series
%%
%[text] ## Load the MRI
%[text] This series is a **T1-weighted MPRAGE** scan of the head: a 3D MRI sequence that is commonly used to study brain anatomy. In a T1-weighted image, white matter is bright, gray matter is gray, and cerebrospinal fluid (CSF) is dark. This contrast makes it a good scan for segmenting brain structures.
mV = medicalVolume(dcmFolder)
%[text] - There are 224 sagittal slices, each 256 × 256 pixels
%[text] - The voxels are 0.94 × 0.94 × 0.90 mm, so they are almost **isotropic** (almost cubes). High-resolution, nearly isotropic voxels make a good input for automated segmentation
%[text] - This dataset has been de-identified: the patient's name, ID, birth date, and the scan dates were removed from the DICOM headers \
%%
%[text] ### Look at the volume
%[text] Let's display the middle slice in each of the three anatomical planes. The function **extractSlice** pulls out a slice in the requested plane and orients it correctly for display.
sagSlice = extractSlice(mV, round(mV.NumSagittalSlices/2), "sagittal");
corSlice = extractSlice(mV, round(mV.NumCoronalSlices/2), "coronal");
traSlice = extractSlice(mV, round(mV.NumTransverseSlices/2), "transverse");

figure;
tiledlayout(1,3,TileSpacing="tight")
nexttile
imshow(sagSlice,[])
title("Sagittal")
nexttile
imshow(corSlice,[])
title("Coronal")
nexttile
imshow(traSlice,[])
title("Transverse")
%[text] - Can you find the white matter, the gray matter (cortex), and the ventricles?
%[text] - Notice that the scan includes the whole head, not just the brain. SynthSeg will have to find the brain on its own \
%%
%[text] ## Convert to NIfTI
%[text] Our SynthSeg function can read a DICOM series, but most brain imaging tools (FreeSurfer, the original Python SynthSeg, and many others) expect **NIfTI** files (.nii or .nii.gz), and most public brain MRI datasets are shared as NIfTI. So we'll convert our scan to NIfTI, and segment the NIfTI file. A NIfTI file stores the whole volume in a single file. Its header holds the information needed to place the volume in the patient's coordinate system, including the size of the voxels.
%[text] The **write** function saves a medicalVolume as a NIfTI file:
niftiFile = fullfile(projectFolder,"t1_mprage.nii.gz"); % saved in your project folder
write(mV, niftiFile)
%[text] - You may see a warning: "Creating an affine3d valid for just the first slice." The slices in this scan are very slightly tilted relative to each other, so MATLAB uses the position of the first slice. You can ignore this warning here \
%%
%[text] ### Check the NIfTI header
%[text] Before using any file in an analysis, it's a good habit to check that its header is correct. Let's compare the voxel size stored in the NIfTI header (**PixelDimensions**) with the voxel size of our medicalVolume:
info = niftiinfo(niftiFile);
info.PixelDimensions
mV.VoxelSpacing
%[text] - They don't match! In our version of MATLAB, **write** saves the voxel size in the header as 2 mm, even though the actual voxels are about 0.9 mm
%[text] - (The orientation information in the header is correct. Only the voxel size field is wrong) \
%[text] This matters, because many programs (including the Python version of SynthSeg) use PixelDimensions to resample the volume to 1 mm voxels before segmenting it. With the wrong voxel size, they would think the head is more than twice as big as it really is.
%[text] To fix the header, we set the correct voxel size and save the volume again with **niftiwrite**:
info.PixelDimensions = mV.VoxelSpacing; % correct the voxel size
V = niftiread(niftiFile); % read the voxel data back in

niftiFixed = fullfile(projectFolder,"t1_mprage_fixed.nii.gz");
niftiwrite(V, erase(niftiFixed,".nii.gz"), info, Compressed=true) % niftiwrite adds the .nii.gz extension

infoFixed = niftiinfo(niftiFixed);
infoFixed.PixelDimensions % check that the fix worked
%[text] - **Lesson:** always check your headers. A small error in the metadata can ruin an analysis, even when the image looks fine \
%%
%[text] ## Run SynthSeg
%[text] The course function **mmSynthSeg2** runs the segmentation. It saves the result as a .seg.nrrd file, which can be opened directly in 3D Slicer, and the estimated volume of each structure as a CSV file.
%[text] Here's what happens inside the function:
%[text] 1. **Resample** the volume to 1 mm isotropic voxels, and align it with the standard axes
%[text] 2. **Normalize** the intensities to a range of 0 to 1
%[text] 3. **Predict:** the network calculates, for every voxel, the probability that it belongs to each of the 32 structures (and the background)
%[text] 4. **Predict again** on a mirrored (left-right flipped) copy of the volume, and average the two predictions. This makes the result more robust
%[text] 5. **Clean up:** keep only the largest connected piece of the brain and of each structure, then label each voxel with its most likely structure \
%[text] The first time you run it, MATLAB builds the network from the pretrained weights, which takes a few extra seconds.
segFile = fullfile(projectFolder,"t1_mprage_synthseg.seg.nrrd");
volFile = fullfile(projectFolder,"t1_mprage_volumes.csv");

[segMV, segT] = mmSynthSeg2(niftiFixed, OutputFile=segFile, VolumesFile=volFile);
%[text] - **segMV** is the segmentation, as a medicalVolume
%[text] - **segT** is a table with the name, label ID, and color of each structure \
%%
%[text] ## Look at the segmentation
%[text] The segmentation is a **label map**: a volume where each voxel holds a whole number (a label ID) that tells you which structure the voxel belongs to. A label ID of 0 means background.
segMV
%[text] - Notice that the segmentation has 1 mm voxels and a different size than our MRI. That's because SynthSeg resampled the MRI to 1 mm before segmenting it
%[text] - So, before we can overlay the segmentation on the MRI, we need to put them on the same voxel grid \
%%
%[text] ### Resample the segmentation to match the MRI
%[text] We use **resample** to calculate a label for the center of every MRI voxel. For a label map, we must use **nearest-neighbor** interpolation: each new voxel simply copies the label of the closest original voxel.
%[text] Why not use linear interpolation, like we would for an image? Because label IDs are categories, not measurements. Halfway between the left cerebral white matter (label 2) and the right cerebral white matter (label 41), linear interpolation would give a label of 21.5 — which isn't a structure at all!
segOnT1 = resample(segMV, mV.VolumeGeometry, Method="nearest");
size(segOnT1.Voxels)
size(mV.Voxels)
%[text] - Now the segmentation and the MRI have the same size and voxel grid \
%%
%[text] ### Label names
%[text] The table **segT** holds the name of the structure for each label ID. SynthSeg uses the same label IDs as FreeSurfer, a popular brain analysis program.
%[text] The names have spaces in them, like "left lateral ventricle". Later, we will use the names as table variable names, so we turn them into names without spaces (like "leftLateralVentricle") with **matlab.lang.makeValidName**:
structureIDs = segT.LabelValue'; % label IDs of the 32 structures (the background, 0, isn't a structure)
structureNames = matlab.lang.makeValidName(segT.SegName)';
labelTable = table(structureIDs', segT.SegName, structureNames', VariableNames=["LabelID","Name","Structure"])
%[text] - Label 24, **csf**, is the cerebrospinal fluid around the brain, outside the ventricles. It is the one structure that is not brain tissue \
%%
%[text] ## Display the segmentation in 2D
%[text] The function **labeloverlay** colors each labeled structure on top of a grayscale image. We extract the same three slices from the MRI and from the resampled segmentation:
sagLabels = extractSlice(segOnT1, round(mV.NumSagittalSlices/2), "sagittal");
corLabels = extractSlice(segOnT1, round(mV.NumCoronalSlices/2), "coronal");
traLabels = extractSlice(segOnT1, round(mV.NumTransverseSlices/2), "transverse");

figure;
tiledlayout(1,3,TileSpacing="tight")
nexttile
imshow(labeloverlay(mat2gray(sagSlice), sagLabels, Transparency=0.5))
title("Sagittal")
nexttile
imshow(labeloverlay(mat2gray(corSlice), corLabels, Transparency=0.5))
title("Coronal")
nexttile
imshow(labeloverlay(mat2gray(traSlice), traLabels, Transparency=0.5))
title("Transverse")
%[text] - Does the segmentation follow the boundaries between the gray matter and the white matter?
%[text] - Notice that the left and right sides of each structure have different labels (and different colors)
%[text] - Notice that SynthSeg ignored the skull, scalp, and face. It only labeled the brain \
%%
%[text] ## Display the segmentation in 3D
%[text] ### Slice planes
%[text] Here we use **volshow** to display the MRI as three slice planes, with the segmentation as an overlay. Drag the planes to scrub through the volume.
viewer1 = viewer3d(BackgroundColor="white", BackgroundGradient="off");
volshow(mV, Parent=viewer1, ...
    RenderingStyle="SlicePlanes", ...
    OverlayData=segOnT1.Voxels, ...
    OverlayAlpha=0.5);
%%
%[text] ### Deep brain structures
%[text] The deep brain structures are hidden inside the cerebral hemispheres. To see them, we keep only their labels and make the MRI completely transparent (an alphamap of all zeros):
deepIDs = [4 43 10 49 17 53 11 50 12 51]; % lateral ventricles, thalami, hippocampi, caudates, putamens (left and right)
deepLabels = segOnT1.Voxels;
deepLabels(~ismember(deepLabels, deepIDs)) = 0; % set all other labels to background

viewer2 = viewer3d(BackgroundColor="white", BackgroundGradient="off", CameraZoom=2);
volshow(mV, Parent=viewer2, ...
    Alphamap=zeros(256,1), ... % make the MRI invisible
    OverlayData=deepLabels, ...
    OverlayAlpha=1);
%[text] - Rotate the view. Can you find the C-shaped lateral ventricles, the thalami between them, and the hippocampi below them?
%[text] - Try adding other label IDs from labelTable to deepIDs, and rerun this section \
%%
%[text] ## Measure the volumes of the structures
%[text] Once we have a label map, measuring the volume of a structure is easy: count its voxels, and multiply by the volume of one voxel. We use the original segmentation (segMV), because its voxels are exactly 1 mm × 1 mm × 1 mm = 1 mm³.
voxelVolume = prod(segMV.VoxelSpacing); % volume of one voxel, in mm^3

numVoxels = arrayfun(@(id) nnz(segMV.Voxels == id), structureIDs);
volume_mL = numVoxels * voxelVolume / 1000; % 1 mL = 1000 mm^3

volumeTable = table(structureNames', volume_mL', VariableNames=["Structure","Volume_mL"]);
volumeTable = sortrows(volumeTable, "Volume_mL", "descend")
%[text] For the total brain volume, we add up every structure except the CSF, which is not brain tissue:
isBrain = structureNames ~= "csf";
totalBrainVolume_mL = sum(volume_mL(isBrain))
%[text] - The cerebral cortex and the cerebral white matter are by far the largest structures
%[text] - A typical adult brain is about 1,100–1,500 mL. Is this brain in that range?
%[text] - The CSV file saved by SynthSeg (volFile) holds slightly different volumes, because SynthSeg calculates them from its probabilities instead of counting voxels. It also holds the **total intracranial** volume: everything inside the skull, including the CSF \
%%
%[text] ### Compare the left and right sides
%[text] Most brain structures come in left/right pairs. Here we plot the volume of each pair side by side:
isLeft = startsWith(structureNames, "left");
pairNames = erase(structureNames(isLeft), "left"); % for example, "Hippocampus"
leftVolumes = volume_mL(isLeft);
rightVolumes = arrayfun(@(name) volume_mL(structureNames == "right" + name), pairNames);

figure;
barh(categorical(pairNames), [leftVolumes' rightVolumes'])
legend(["Left" "Right"], Location="southeast")
xlabel("Volume (mL)")
title("Left vs. right brain structures")
set(gca, XScale="log") % log scale, so the small structures are visible too
%[text] - Are the left and right sides about the same size? Which pairs differ the most?
%[text] - Note: the x-axis uses a log scale, because the structures range from less than 1 mL to over 250 mL \
%%
%[text] ## Open the segmentation in 3D Slicer
%[text] The .seg.nrrd file can be opened directly in 3D Slicer, with each structure named and colored. To find the file:
projectFolder
%[text] - Drag the t1\_mprage\_fixed.nii.gz file and then the t1\_mprage\_synthseg.seg.nrrd file into 3D Slicer
%[text] - The structures will appear in the Segmentations module \
%%
%[text] ## Exercise 1 - Hippocampal Asymmetry
%[text] The hippocampus is important for memory, and it often shrinks in Alzheimer's disease. One way researchers compare the two hippocampi is with an **asymmetry index**:
%[text] $\\textrm{Asymmetry}\\;\\textrm{Index}=100\\times \\frac{L-R}{(L+R)/2}${"editStyle":"visual"}
%[text] where L and R are the volumes of the left and right hippocampus. An index of 0 means the two sides are the same size. (The answer key is in a separate file.)
%[text] 1. Get the volume of the left and the right hippocampus from **volumeTable** (or from **volume\_mL** and **structureNames**)
%[text] 2. Calculate the asymmetry index. Which hippocampus is larger?
%[text] 3. Calculate the total volume of the left and right lateral ventricles (in mL), and the percentage of the total brain volume that they take up \
% YOUR CODE HERE

%%
%[text] ## Check your understanding
%[text] 1. Why did we check and fix the NIfTI header before using the file? What could go wrong if we shared the unfixed file with someone who uses a different program?
%[text] 2. Why must we use nearest-neighbor interpolation when we resample a label map?
%[text] 3. SynthSeg was trained only on synthetic images. Why does that help it work on real scans from many different MRI scanners?
%[text] 4. SynthSeg was trained on brains without large lesions. What might go wrong if you used it on a scan of a patient with a large brain tumor? \
%%
%[text] # Part 2: Batch processing — a capstone project
%[text] In research, you rarely segment just one scan. A study might have dozens or hundreds of them, and each one has to go through exactly the same steps. Running the same steps on a whole set of files with a loop is called **batch processing**.
%[text] In this part, we will repeat part of a capstone project from the MHA program: Von Imhof L, Prince E, Hankinson T, Salcedo E (2026). *Quantifying Human Variability in Neuroanatomical Identification: Establishing a Baseline for Artificial Intelligence-Based Brain Segmentation*. MHA Capstone Report, University of Colorado Anschutz. The project used six public T1-weighted MRI scans from [OpenNeuro](https://openneuro.org): three healthy controls and three patients with brain tumors. The lateral ventricles were segmented by hand and with SynthSeg, and the two were compared. Among other things, the project found that:
%[text] - The size and shape of the lateral ventricles vary from person to person, even in healthy brains
%[text] - The brains with tumors showed more obvious left-right asymmetry of the ventricles
%[text] - SynthSeg (version 1.0) could not segment one of the six scans (subject 4). We will see how the newer version, SynthSeg 2.0, does \
%[text] We will segment all six scans in one batch, check the results for errors, display the two groups side by side, and compare the volume of their lateral ventricles.
%%
%[text] ## Setup
%[text] ### Create a second project folder
%[text] It's good practice to keep each project in its own folder, so the files from different analyses don't get mixed up.
%[text] 1. Create another new, empty folder, for example **SynthSeg\_Batch**
%[text] 2. Run this section and select the new folder. The script will create a **segmentations** subfolder inside it for the SynthSeg output \
close all

batchFolder = uigetdir(userpath, "Select your batch project folder")
if isequal(batchFolder, 0)
    error("No folder selected. Run this section again and select your batch project folder.")
end
checkProjectFolder(batchFolder)

segFolder = fullfile(batchFolder, "segmentations"); % where the SynthSeg output will go
if ~isfolder(segFolder)
    mkdir(segFolder);
end
%%
%[text] ### Find the scans
%[text] The six scans are stored as NIfTI files in the SynthSegCapstone folder of the unit 3 data folder. The function **dir** lists the files in a folder. The wildcard **\*** matches any text, so "\*.nii.gz" finds every file that ends in .nii.gz:
mmSetUnitDataFolder(3);
scanFolder = fullfile(pwd, "SynthSegCapstone"); % pwd: the full path of the Current Folder

scanFiles = dir(fullfile(scanFolder, "*.nii.gz"));
numScans = numel(scanFiles)
{scanFiles.name}'
%[text] - **dir** returns a struct array, with one element for each file. Each element holds the file's name, its folder, its size, and its date
%[text] - The headers of these files have already been checked, so they don't need the fix from Part 1. (Go ahead and check one, if you like!)
%[text] - Notice that some files end in **T1ce** instead of **T1w**. These are T1-weighted scans taken after a contrast agent (gadolinium) was injected. SynthSeg doesn't need to know this, because it was trained to handle any contrast \
%%
%[text] ### Subject information
%[text] A file name alone doesn't tell us who the subject is. In a real study, this information would come from a spreadsheet. Here we type it into a table, using the information from the capstone report (the age and sex of subject 8 were not available):
Scan = ["sub-01_ses-1_T1w"; "sub-c08_T1w"; "sub-29_ses-1_T1w"; ...
    "sub-004_T1ce"; "sub-RS005_ses-1_T1w"; "sub-016_T1ce"]; % file names without .nii.gz
Subject = [1; 8; 29; 4; 5; 16];
Group = categorical(["Healthy"; "Healthy"; "Healthy"; "Tumor"; "Tumor"; "Tumor"]);
Diagnosis = ["none"; "none"; "none"; "astrocytoma"; "oligoastrocytoma"; "glioblastoma"];
Age = [24; NaN; 32; 30; 36; 76];
Sex = ["M"; "unknown"; "F"; "M"; "M"; "F"];

subjects = table(Scan, Subject, Group, Diagnosis, Age, Sex)
%%
%[text] ## Run SynthSeg on every scan
%[text] Now for the batch. The **for** loop runs the same steps once for each scan:
%[text] 1. Build the name of the output file from the name of the input file
%[text] 2. If the output file already exists, skip the scan. This way, if you run the section again, you don't redo the work
%[text] 3. Otherwise, run SynthSeg on the scan, inside a **try/catch** block
%[text] 4. Record what happened in a log \
%[text] Why **try/catch**? Normally, an error stops your code. If scan 3 of 100 fails, scans 4–100 never run, and you might not notice until the next morning! Inside a **try** block, an error jumps to the **catch** block instead. There we record the error message, and the loop moves on to the next scan.
%[text] This section takes about 2–3 minutes. SynthSeg prints its progress for each scan as it works.
scanNames = strings(numScans, 1); % one row for each scan
status = strings(numScans, 1);
runTime = nan(numScans, 1);
errorMessage = strings(numScans, 1);

for k = 1:numScans
    inFile = fullfile(scanFiles(k).folder, scanFiles(k).name);
    scanNames(k) = erase(scanFiles(k).name, ".nii.gz");
    outFile = fullfile(segFolder, scanNames(k) + ".seg.nrrd");
    fprintf("Scan %d of %d: %s\n", k, numScans, scanNames(k))

    if isfile(outFile)
        status(k) = "skipped (already done)";
        continue % go straight to the next scan
    end

    try
        tic
        mmSynthSeg2(inFile, OutputFile=outFile);
        runTime(k) = toc; % seconds
        status(k) = "done";
    catch err
        status(k) = "failed";
        errorMessage(k) = err.message; % save the error, and keep going
    end
end

batchLog = table(scanNames, status, runTime, errorMessage, ...
    VariableNames=["Scan", "Status", "Seconds", "ErrorMessage"])
%[text] - Did any scans fail? If so, read the error message. The next step is to figure out what is different about that scan, fix the problem, and run the batch again. Because the loop skips finished scans, only the failed scans will run
%[text] - **What about subject 4?** In the capstone project, SynthSeg 1.0 crashed on this scan with the error "At least one index is required." We tracked the problem down: SynthSeg 1.0 found no voxels at all for one structure, and the clean-up step (keep the largest connected piece of each structure) assumed that every structure has at least one piece. SynthSeg 2.0 segments this scan without an error. But that raises a new question: did it get the right answer? \
%%
%[text] ## Check the results
%[text] ### Measure every structure in every scan
%[text] Just like in Part 1, we count the voxels of each structure and convert to mL. This time we do it for every scan, and store the results in a matrix with one row for each subject and one column for each structure. We loop over the rows of the subjects table, so the healthy subjects come first.
%[text] If a segmentation is missing (because SynthSeg failed), we leave that row as NaN (not a number) and move on.
%[text] First, we need the label IDs and names of the structures. A .seg.nrrd file only lists the structures that SynthSeg actually found, so we take them from the segmentation of a healthy subject (subject 1), which has all 32. **mmGetSlicerSegmentInfo** reads them from the file:
segT = mmGetSlicerSegmentInfo(fullfile(segFolder, subjects.Scan(1) + ".seg.nrrd"));
structureIDs = segT.LabelValue';
structureNames = matlab.lang.makeValidName(segT.SegName)';

numSubjects = height(subjects);
volumes = nan(numSubjects, numel(structureIDs));

for k = 1:numSubjects
    segFile = fullfile(segFolder, subjects.Scan(k) + ".seg.nrrd");
    if ~isfile(segFile)
        warning("No segmentation for %s", subjects.Scan(k))
        continue
    end
    seg = medicalVolume(segFile);
    voxelVolume = prod(seg.VoxelSpacing); % mm^3
    volumes(k,:) = arrayfun(@(id) nnz(seg.Voxels == id), structureIDs) * voxelVolume / 1000; % mL
end

results = [subjects, array2table(volumes, VariableNames=structureNames)];
results(:, ["Subject" "Group" "leftLateralVentricle" "rightLateralVentricle" "leftHippocampus" "rightHippocampus"])
%[text] - **results** holds the subject information and all 32 volumes, one row per subject \
%%
%[text] ### Did any structures go missing?
%[text] "SynthSeg ran without an error" is not the same as "SynthSeg got the right answer." A simple automated check is to compare each volume with the median volume of the same structure in all six subjects, and flag any structure that is less than half the usual size:
medianVolume = median(volumes, 1, "omitnan"); % median of each column (structure)
isSmall = volumes < 0.5 * medianVolume;
[row, col] = find(isSmall); % the subject (row) and structure (column) of each flag

flagTable = table(results.Subject(row), structureNames(col)', ...
    volumes(isSmall), medianVolume(col)', ...
    VariableNames=["Subject", "Structure", "Volume_mL", "Median_mL"]);
flagTable = sortrows(flagTable, "Subject")
%[text] - The right accumbens area of subject 4 is less than half the usual size. This is the structure that SynthSeg 1.0 couldn't find at all in this scan, which is what crashed it
%[text] - Some flags are probably harmless. The inferior lateral ventricles (the temporal horns) are tiny, often less than 0.5 mL, so they vary a lot from person to person. The capstone project found that the temporal horn was also the hardest part of the ventricle to segment by hand
%[text] - An automated check like this doesn't make the decision for you. It tells you where to look \
%%
%[text] ### Look at subject 4
%[text] Let's look at the scan. To overlay the segmentation, we need to resample it onto the MRI's voxel grid, as in Part 1. But there's a catch: the .seg.nrrd file uses the **LPS+** patient coordinate system (the one used by DICOM and 3D Slicer), while NIfTI files use **RAS+**. The two systems describe the same space, but their x and y axes point in opposite directions. **resample** refuses to combine volumes with different coordinate systems, so the local function **lpsToRAS** (at the end of this script) converts the segmentation to RAS+ first.
%[text] We display the transverse slice through the middle of subject 4's right putamen (label 51), which is next to the missing structures:
t1 = medicalVolume(fullfile(scanFolder, "sub-004_T1ce.nii.gz"));
seg = lpsToRAS(medicalVolume(fullfile(segFolder, "sub-004_T1ce.seg.nrrd")));
segOnT1 = resample(seg, t1.VolumeGeometry, Method="nearest");

putamenMV = medicalVolume(uint8(segOnT1.Voxels == 51), t1.VolumeGeometry); % right putamen only
putamenArea = zeros(t1.NumTransverseSlices, 1);
for z = 1:t1.NumTransverseSlices
    putamenArea(z) = nnz(extractSlice(putamenMV, z, "transverse"));
end
[~, putamenSlice] = max(putamenArea); % the slice with the most putamen

img = extractSlice(t1, putamenSlice, "transverse");
labels = extractSlice(segOnT1, putamenSlice, "transverse");

figure
tiledlayout(1, 2, TileSpacing="tight")
nexttile
imshow(img, [])
title("Subject 4 (astrocytoma)")
nexttile
imshow(labeloverlay(mat2gray(img), labels, Transparency=0.5))
title("SynthSeg labels")
%[text] - In this view, the patient's right side is on the **left** of the image (the radiological convention)
%[text] - Compare the deep gray nuclei on the two sides. On the patient's right, the tumor has changed the normal anatomy, and SynthSeg found a much smaller accumbens area
%[text] - Notice that every voxel of the brain got a label, including the tumor. SynthSeg has no "tumor" label, so it labels the tumor as whatever normal tissue it looks most like, mostly white matter. Keep this in mind when you measure the white matter in the exercise! \
%%
%[text] ## Compare the two groups
%[text] ### Ventricles in 2D
%[text] For each subject, we display the transverse slice with the largest area of lateral ventricle, with the left ventricle in red and the right ventricle in blue. The healthy subjects are in the top row, and the tumor patients in the bottom row.
%[text] We count the inferior lateral ventricles (the temporal horns) as part of the lateral ventricles:
leftVentIDs = [4 5]; % left lateral ventricle and left inferior lateral ventricle
rightVentIDs = [43 44]; % the same on the right

figure
tiledlayout(2, 3, TileSpacing="tight")
for k = 1:numSubjects
    nexttile
    segFile = fullfile(segFolder, subjects.Scan(k) + ".seg.nrrd");
    if ~isfile(segFile)
        title(sprintf("Subject %d: no segmentation", subjects.Subject(k)))
        continue
    end

    t1 = medicalVolume(fullfile(scanFolder, subjects.Scan(k) + ".nii.gz"));
    seg = lpsToRAS(medicalVolume(segFile));
    segOnT1 = resample(seg, t1.VolumeGeometry, Method="nearest");

    % ventricle mask: 1 = left, 2 = right, 0 = everything else
    ventricles = zeros(size(segOnT1.Voxels), "uint8");
    ventricles(ismember(segOnT1.Voxels, leftVentIDs)) = 1;
    ventricles(ismember(segOnT1.Voxels, rightVentIDs)) = 2;
    ventMV = medicalVolume(ventricles, t1.VolumeGeometry);

    % find the transverse slice with the largest area of ventricle
    ventArea = zeros(t1.NumTransverseSlices, 1);
    for z = 1:t1.NumTransverseSlices
        ventArea(z) = nnz(extractSlice(ventMV, z, "transverse"));
    end
    [~, bestSlice] = max(ventArea);

    img = extractSlice(t1, bestSlice, "transverse");
    ventSlice = extractSlice(ventMV, bestSlice, "transverse");
    imgRange = double(prctile(img(:), [0.5 99.5])); % ignore the few brightest voxels when scaling
    imshow(labeloverlay(mat2gray(img, imgRange), ventSlice, ...
        Colormap=[1 0.3 0.3; 0.3 0.6 1], Transparency=0.3))
    title(sprintf("Subject %d (%s)", subjects.Subject(k), subjects.Group(k)))
end
%[text] - Remember: the patient's left (red) is on the right of each image
%[text] - Subject 8's scan was skull-stripped (the skull and scalp were removed) before it was shared. SynthSeg works either way
%[text] - Can you find the tumors? Look for the bright ring in subject 16 (a glioblastoma takes up the contrast agent at its edge). How does it change the ventricle next to it?
%[text] - Which subject has the largest ventricles? \
%%
%[text] ### Ventricles in 3D
%[text] To compare the shapes, we can build a 3D surface of each ventricle with **isosurface**, and display it with **patch**. A faint gray surface of the whole brain (every voxel with a label greater than 0) gives a sense of position. We view the brains from above, with the front of the brain at the top.
%[text] We use the segmentations directly, without resampling. After SynthSeg, their first, second, and third dimensions point to the patient's right, anterior (front), and superior (top). **isosurface** treats the first dimension as y (the rows) and the second dimension as x (the columns), so we use **permute** to swap them.
figure
tiledlayout(2, 3, TileSpacing="tight")
for k = 1:numSubjects
    nexttile
    segFile = fullfile(segFolder, subjects.Scan(k) + ".seg.nrrd");
    if ~isfile(segFile)
        title(sprintf("Subject %d: no segmentation", subjects.Subject(k)))
        continue
    end

    seg = medicalVolume(segFile);
    labels = permute(seg.Voxels, [2 1 3]); % x = right, y = anterior, z = superior

    patch(isosurface(labels > 0, 0.5), FaceColor=[0.7 0.7 0.7], EdgeColor="none", FaceAlpha=0.1) % whole brain
    hold on
    patch(isosurface(smooth3(ismember(labels, leftVentIDs)), 0.5), FaceColor=[1 0.3 0.3], EdgeColor="none")
    patch(isosurface(smooth3(ismember(labels, rightVentIDs)), 0.5), FaceColor=[0.3 0.6 1], EdgeColor="none")
    hold off

    axis equal off
    view(0, 90) % look down from above
    camlight
    lighting gouraud
    title(sprintf("Subject %d (%s)", subjects.Subject(k), subjects.Group(k)))
end
%[text] - In this view, the patient's left (red) is on the left. (We are looking down at the top of the head, not up from the feet)
%[text] - **smooth3** smooths the masks slightly, so the surfaces aren't blocky
%[text] - Use the Rotate 3D button in the axes toolbar to turn the brains. How do the ventricles differ between the subjects? Between the left and right sides of each brain? \
%%
%[text] ## Measure and compare the lateral ventricles
%[text] Now let's put numbers on what we saw. For each subject we calculate:
%[text] - The total volume of the lateral ventricles, in mL
%[text] - The ventricles as a percentage of the total brain volume. Bigger heads have bigger brains, and bigger ventricles. Dividing by the brain volume corrects for head size, so we can compare people fairly
%[text] - The left-right **asymmetry index**, from the Part 1 exercise: $\\textrm{AI}=100\\times \\frac{L-R}{(L+R)/2}${"editStyle":"visual"} \
leftVent_mL = results.leftLateralVentricle + results.leftInferiorLateralVentricle;
rightVent_mL = results.rightLateralVentricle + results.rightInferiorLateralVentricle;

results.Ventricles_mL = leftVent_mL + rightVent_mL;
results.TotalBrain_mL = sum(volumes(:, structureNames ~= "csf"), 2); % sum of all the structures, except the CSF
results.VentriclesPct = 100 * results.Ventricles_mL ./ results.TotalBrain_mL;
results.VentricleAI = 100 * (leftVent_mL - rightVent_mL) ./ ((leftVent_mL + rightVent_mL) / 2);
results.AbsVentricleAI = abs(results.VentricleAI); % size of the asymmetry, either direction

results(:, ["Subject" "Group" "Age" "Ventricles_mL" "TotalBrain_mL" "VentriclesPct" "VentricleAI"])
%[text] - A positive asymmetry index means the left ventricle is larger, and a negative one means the right ventricle is larger
%[text] - For comparing groups, we use the absolute value of the index (**AbsVentricleAI**). A tumor might enlarge or compress either side, and we want to know how asymmetric the ventricles are, not which side is larger \
%%
%[text] ### Group summary
%[text] **groupsummary** calculates statistics for each group in a table:
groupsummary(results, "Group", "mean", ["Ventricles_mL" "VentriclesPct" "AbsVentricleAI"])
%[text] With only three subjects in each group, it's important to look at the individual values, not just the means. Here we plot each subject as a labeled point, with a black line at the mean of each group:
measures = ["Ventricles_mL" "VentriclesPct" "AbsVentricleAI"];
yLabels = ["Ventricle volume (mL)" "Ventricles (% of brain)" "|Asymmetry index| (%)"];

figure
tiledlayout(1, 3)
for m = 1:numel(measures)
    nexttile
    x = double(results.Group); % 1 = Healthy, 2 = Tumor
    y = results.(measures(m)); % the column of results with this name
    scatter(x, y, 60, "filled")
    hold on
    text(x + 0.1, y, string(results.Subject)) % label each point with its subject number
    groupMeans = groupsummary(y, x, "mean");
    plot(1:2, groupMeans, "k_", MarkerSize=40, LineWidth=2)
    hold off
    xlim([0.5 2.5])
    xticks(1:2)
    xticklabels(categories(results.Group))
    ylabel(yLabels(m))
end
%[text] - The ventricles of subject 5 are about three times as large as anyone else's. Without subject 5, the two groups would look much more alike
%[text] - Even in the healthy group, the size of the asymmetry index ranges from about 4% to 50%. Some asymmetry of the lateral ventricles is normal
%[text] - On average, the ventricles of the tumor group are more asymmetric, which agrees with what the capstone project saw in the 3D models. But with three subjects per group, we can't tell whether this is a real difference or just chance \
%%
%[text] ### Compare with the capstone project
%[text] The capstone report lists the SynthSeg volume of the lateral ventricles (labels 4 and 43, without the temporal horns) as a number of 1 mm voxels. Let's compare them with our values. Subject 4 is NaN because SynthSeg 1.0 crashed on that scan in the original project:
capstoneVoxels = [12511; 13412; 9805; NaN; 48628; 10977]; % from Table 1 of the report, in our subject order
ourVoxels = round(1000 * (results.leftLateralVentricle + results.rightLateralVentricle)); % mL -> mm^3 = voxels
table(results.Subject, capstoneVoxels, ourVoxels, VariableNames=["Subject" "Capstone" "ThisScript"])
%[text] - The values are close (within about 3%), but they don't match exactly. The capstone project used SynthSeg 1.0, and we used SynthSeg 2.0. The two versions were trained differently, so they draw slightly different boundaries
%[text] - The same version of SynthSeg gives exactly the same result every time it runs on the same scan, which makes automated results easy to **reproduce**. But only if you know which version was used! Always report the name and version of the software in your methods \
%%
%[text] ## Exercise 2 - White Matter
%[text] In this exercise, you will compare the cerebral white matter of the two groups. (The answer key is in a separate file.)
%[text] 1. For each subject, calculate the total volume of the cerebral white matter (left plus right), and add it to **results** as a new variable called **WhiteMatter\_mL**
%[text] 2. Calculate the white matter as a percentage of the total brain volume, and add it to **results** as **WhiteMatterPct**
%[text] 3. Use **groupsummary** to calculate the mean **WhiteMatterPct** of each group
%[text] 4. Which group has the larger percentage of white matter? Which subject has the largest? Using what you learned about subject 4, can you explain why? \
% YOUR CODE HERE

%%
%[text] ## Check your understanding
%[text] 1. Why did we put mmSynthSeg2 inside a try/catch block? What would happen to the batch if one scan failed without it?
%[text] 2. The batch log for subject 4 says "done." Why isn't that enough to trust its segmentation?
%[text] 3. Why do we divide the ventricle volume by the total brain volume before comparing people?
%[text] 4. The ventricles naturally get larger with age. Subject 16 is 76 years old, while the other subjects are 24–36. How could this affect our comparison of the two groups? How would you design a better study? \
%%
%[text] ## Local functions
function checkProjectFolder(folder)
% Stop with a clear error if the folder is the shared course data folder,
% or if we can't save files in it
if contains(folder, "MtMresources")
    error("This folder is inside the shared course data folder (MtMresources). " + ...
        "Run this section again and choose a folder of your own, for example in your Documents folder.")
end
testFile = fullfile(folder, "write_test.tmp");
fid = fopen(testFile, "w"); % try to create a small file
if fid == -1
    error("You can't save files in this folder: %s\nRun this section again and choose a different folder, for example in your Documents folder.", folder)
end
fclose(fid);
delete(testFile)
end

function segRAS = lpsToRAS(segMV)
% Convert a medicalVolume from LPS+ to RAS+ patient coordinates.
% The two systems differ only in the direction of the x and y axes,
% so we flip the sign of the x and y coordinates.
geom = segMV.VolumeGeometry;
flipXY = [-1 -1 1];
position = geom.Position .* flipXY;
voxelDistances = cellfun(@(v) v .* flipXY, geom.VoxelDistances, UniformOutput=false);
geomRAS = medicalref3d(geom.VolumeSize, position, voxelDistances);
geomRAS.PatientCoordinateSystem = "RAS+";
segRAS = medicalVolume(segMV.Voxels, geomRAS);
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:6890cb29]
%   data: {"dataType":"textualVariable","outputData":{"name":"projectFolder","value":"0"}}
%---
%[output:7ad32fc9]
%   data: {"dataType":"error","outputData":{"errorType":"runtime","text":"No folder selected. Run this section again and select your project folder."}}
%---
