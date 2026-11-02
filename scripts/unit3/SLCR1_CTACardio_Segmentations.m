%[text] # Slicer Segmentations in MATLAB, Part 1: Load and Visualize
%[text] In the 3D Slicer exercise *Segmenting a Contrast-Enhanced CT Volume*, you segmented the kidneys and the aorta from the **CTACardio** sample dataset, and then let the AI tool **TotalSegmentator** segment the whole volume automatically. Slicer is great for creating segmentations. MATLAB is great for **analyzing** them: measuring them, comparing them, and repeating the same analysis exactly on many datasets.
%[text] In this live script, we bring the CT volume and your Slicer segmentation into MATLAB, display them in 2D and 3D, and measure the volume of each structure. In Part 2 (SLCR2), we will compare your segmentations with the ones from TotalSegmentator.
%[text] ### Learning Objectives
%[text] - Explain what a label map is, and how Slicer stores segmentations in a .seg.nrrd file
%[text] - Load a CT volume and a Slicer segmentation as medicalVolume objects
%[text] - Read the segment names and colors that you set in Slicer
%[text] - Display segmentations as 2D overlays, 3D volume renderings, and 3D surfaces
%[text] - Measure the volume of each segmented structure in mL \
%[text] ### Before you start
%[text] - Create a new folder in your MATLAB Drive called **MedImaging**, and copy this live script into it
%[text] - If you finished the Slicer exercise, you can use your own files. If not, you can use the example files in the unit 3 data folder \
%[text:tableOfContents]{"heading":"Table of Contents"}
%%
%[text] ## Background
%[text] This example assumes that you have completed the [CTA Cardio segmentation exercise](https://salcedoe.github.io/MtMdocs/slicer/CTACardioSegment/) using 3D Slicer. In the process, you should have created a segmentation file with the file extension \*.seg.nrrd. You should have also saved a cropped volume, likely called CTACardio Crop, with the extension \*.nrrd. 
%[text] ### Segmentations are label maps
%[text] When you segment in Slicer, you create a **segmentation volume**, also called a **label map**. A label map has exactly the same dimensions as the original volume, but instead of intensities, its voxels hold **labels**: whole numbers that tell you which structure each voxel belongs to. For example:
%[text] - 0 = background (not segmented)
%[text] - 1 = right kidney
%[text] - 2 = left kidney
%[text] - 3 = aorta \
%[text] A label is not a measurement. Label 2 isn't "twice as much" as label 1. It's just a name, written as a number.
%[text] ### Slicer file types
%[text] Slicer saves volumes in the **NRRD** format (Nearly Raw Raster Data): a header with the metadata (size, voxel spacing, orientation), followed by the voxel data.
%[text] - Intensity volumes are saved as **\*.nrrd** files. Here: **CTACardio Crop.nrrd**
%[text] - Segmentations are saved as **\*.seg.nrrd** files. Here: **LastName Segmentation.seg.nrrd** \
%[text] A .seg.nrrd file is a NRRD file with extra information in its header: the **name**, **color**, and **label value** of each segment that you set in Slicer.
%[text] If segments overlap (for example, the lungs and the thoracic cavity), a single label can't describe a voxel. In that case, Slicer stores the segmentation in several **layers**, and MATLAB reads it as a 4D array. That's why you collapsed the layers to a single layer at the end of the Slicer exercise.
%%
%[text] ## Setup
%[text] ### Choose your CTA Cardio Folder
%[text] - Set **`paths.project`** to the Slicer CTA Cardio folder on your computer \
clearvars
close all
paths.project = "/Users/ernesto/MATLAB-Drive/MtMresources/data/unit3/CTACardio"; %[control:filebrowser:1641]{"position":[17,80]}
contents = dir(fullfile(paths.project,"*.nrrd")); % find the slicer volume files in folder
disp((1:numel(contents))' + ". " + string({contents.name})') % display folder content info
%[text] - The output should show a mix of `*.nrrd` and `*.seg.nrrd` files \
%%
%[text] Review the above output and match the numbers for the following
%[text] - **`paths.intensity`** should be your cropped CTA Cardio Volume (Should contain Crop in the name and end in \*.nrrd)
%[text] - **`paths.segment`** should be your segmentation volume (starts with your Last Name and ends in `*.seg.nrrd`) \
paths.intensity = fullfile(paths.project, contents(2).name); % Number of Cropped CTA Cardio volume %[control:spinner:7f95]{"position":[52,53]}
paths.segment = fullfile(paths.project, contents(3).name) % Number of your Segmentation volume %[control:spinner:2481]{"position":[50,51]}
%[text] - **`contents`** is a structure containing file information. To get the name of a file, you index contents as follows: `contents(1).name` - returns first file name
%[text] - **paths** is a structure that holds all of our file paths in one place
%[text] - **fullfile** joins folder and file names with the correct separator for your computer (/ on a Mac, \\ on Windows) \
%%
%[text] ### Use the **example files instead**
%[text] Only run if you want to use the example files in the unit3 folder
unit3f = mmSetUnitDataFolder(3); % change Current Folder to the Unit 3 Data Folder and get path
lastName = "Salcedo"; % your segmentation is called "LastName Segmentation.seg.nrrd"
paths.project = fullfile(unit3f, "CTACardio");
paths.intensity = fullfile(paths.project, "CTACardio Crop.nrrd"); % the Cropped CTA Cardio volume
paths.segment = fullfile(paths.project, "Salcedo Segmentation.seg.nrrd"); % Kidney and Aorta Segmentation volume
paths.total = fullfile(paths.project, "CTACardio Crop segmentation.seg.nrrd"); % TotalSegmentator volume (used in SLRC2)
beep
disp("Using the course example files instead")
%%
%[text] ### Check the paths
%[text] Before loading anything, let's make sure every path exists. If one doesn't, check the names of your files in the folder listing:
pathCheck = table(string(fieldnames(paths)), structfun(@(p) isfile(p) || isfolder(p), paths), ...
    VariableNames=["Path" "Exists"])
if ~all(pathCheck.Exists)
    ls(paths.project) % show the files in the folder, so you can check the names
    error("At least one file was not found. Check the file names in paths.")
end
%[text] - **structfun** runs a function on every field of a structure. Here, it checks whether each path is a file or a folder that exists \
%%
%[text] ## Load the CT volume
%[text] This is the \*.nrrd intensity volume. Here, we load the cropped CT volume as a **medicalVolume**, an object that stores both the voxel data and the metadata in one variable:
warning("off", "medical:medicalVolume:noEndian") % Slicer's NRRD files trigger a harmless warning
ctMV = medicalVolume(paths.intensity)
%[text] - **Voxels** is a 3D array of signed 16-bit integers (int16). The values are in **Hounsfield units** (HU), which can be negative (air is −1000 HU)
%[text] - **VoxelSpacing** is the same in all three directions (about 1.03 mm), so the voxels are **isotropic**. The original CTACardio voxels were 0.93 × 0.93 × 1.25 mm. When you cropped the volume in Slicer with "Interpolated cropping" checked, Slicer also resampled it to isotropic voxels, which makes 3D measurements simpler \
%%
%[text] ## Load the segmentation
%[text] This is the \*.seg.nrrd file
segMV = medicalVolume(paths.segment)
%[text] - The segmentation looks similar to the CT volume, but its voxels are **unsigned 8-bit integers** (uint8): whole numbers from 0 to 255. That's plenty for labels
%[text] - It has exactly the same size and voxel spacing as the CT volume, because you segmented the cropped volume in Slicer. Let's confirm: \
isequal(size(segMV.Voxels), size(ctMV.Voxels)) % same size as intensity volume
%[text] Which labels are in the label map?
unique(segMV.Voxels)' % display seg volume labels
%[text] - 0 is the background, and 1, 2, and 3 are our segments. But what do these numbers label? \
%%
%[text] ### Read the Slicer segment information
%[text] The course function **mmGetSlicerSegmentInfo** reads the segment information from the header of the `.seg.nrrd` file, and returns it as a table:
segT = mmGetSlicerSegmentInfo(paths.segment)
%[text] - **SegName**: the name you gave each segment in Slicer
%[text] - **Layer**: the layer that holds the segment (always 1, if you collapsed the layers)
%[text] - **LabelValue**: the label of the segment in the label map
%[text] - **Color**: the color you chose in Slicer, as \[red green blue\] values from 0 to 1 \
%%
%[text] ## Display the segmentation in 2D
%[text] Let's overlay the segmentation on a transverse slice through the kidneys. To find a good slice, we use **regionprops3** to find the center (**centroid**) of each segment. When we give regionprops3 a label map, it returns one row for each label: row 1 for label 1, row 2 for label 2, and so on. Each centroid is returned as \[x y z\], where z is the slice number:
labelProps = regionprops3(segMV.Voxels, "Centroid")
kidneyLabels = segT.LabelValue(contains(segT.SegName, "kidney")); % labels of both kidneys
kidneySlice = round(mean(labelProps.Centroid(kidneyLabels, 3))) % slice halfway between the two kidney centers
%[text] Now we extract that slice from both volumes. The function **labeloverlay** colors the labels on top of the CT slice. We pass it the colors from Slicer, so each segment has the same color it had in Slicer. (Row 1 of the colormap colors label 1, row 2 colors label 2, and so on.)
ctSlice = extractSlice(ctMV, kidneySlice, "transverse");
labelSlice = extractSlice(segMV, kidneySlice, "transverse");

figure
imshow(labeloverlay(mat2gray(ctSlice, [-160 240]), labelSlice, ...
    Colormap=segT.Color, Transparency=0.3))
title("Slice " + kidneySlice)
%[text] - **mat2gray(ctSlice, \[-160 240\])** applies a soft-tissue window: −160 HU is shown as black and 240 HU as white
%[text] - The patient's right is on the **left** of the image (the radiological convention). Which kidney is which?
%[text] - Look closely at the kidneys. The outer layer (the **cortex**) is bright, and the inner part (the **medulla**) is darker. Did your threshold capture both? Keep this in mind. It will matter in Part 2 \
%%
%[text] ## Display the segmentation in 3D
%[text] ### Volume rendering
%[text] Here we use **volshow** to render the CT volume, with the segmentation as an overlay.
%[text] First, we create a **viewer3d**. A viewer3d is like a figure, but for volshow: nothing is displayed yet, but we can set properties like the background color:
viewer1 = viewer3d(BackgroundColor="white", BackgroundGradient="off", CameraZoom=1);
%[text] Next, **volshow** displays the volumes in the viewer:
volshow(ctMV, Parent=viewer1, ...
    RenderingStyle="GradientOpacity", ... % makes uniform regions transparent, so we can see the edges
    OverlayData=segMV.Voxels); % add the segmentation as an overlay
%[text] - The **GradientOpacity** rendering style makes regions with uniform intensity more transparent, and keeps the edges between tissues visible
%[text] - Right-click on the viewer to add a scale bar, or to save a screenshot to a file \
%%
%[text] ### Segmentation only
%[text] To see only the segmentation, we make the CT volume completely transparent with an alphamap of all zeros:
viewer2 = viewer3d(BackgroundColor="white", BackgroundGradient="off", CameraZoom=1.5);
volshow(ctMV, Parent=viewer2, ...
    Alphamap=zeros(256,1), ... % make the CT volume invisible
    OverlayData=segMV.Voxels, ...
    OverlayAlpha=1);
%[text] - Rotate the view. Where are the kidneys, compared with the aorta? Which kidney sits lower in the abdomen? \
%%
%[text] ## From voxels to millimeters
%[text] A label map stores the segmentation as rows, columns, and slices: its **intrinsic** coordinates. To place the segmentation in the real world, in millimeters and in the patient's coordinate system, we need a **transformation**.
%[text] The **VolumeGeometry** property of a medicalVolume holds this information. The function **intrinsicToWorldMapping** converts it into an affine transformation (an **affinetform3d** object):
tform = intrinsicToWorldMapping(segMV.VolumeGeometry);
tform.A % the 4 × 4 transformation matrix
%[text] - The 1.027 values scale each voxel step to 1.027 mm. The minus signs and the swapped first two columns flip and reorder the axes, so they match the patient's coordinate system (LPS+: x increases toward the patient's left, y toward the back, and z toward the head)
%[text] - The last column is the position, in mm, of the first voxel
%[text] - We can use **tform** to place a surface made from the label map in the correct position, size, and orientation \
%%
%[text] ## Display the segmentation as surfaces
%[text] **volshow** renders the voxels directly. Another option is to turn each segment into a **surface**: a mesh of small triangles that covers the outside of the segment. This is what Slicer creates when you click "Show 3D", and what you export as a 3D model (for example, an .obj file).
%[text] MATLAB creates a surface from a mask with the function **isosurface**. The course function **mmPlotMask2Surface** calls isosurface, simplifies the mesh, and plots it with nice lighting.
%[text] ### Plot the aorta
figure
aortaLabel = segT.LabelValue(segT.SegName == "aorta"); % look up the label of the aorta
aortaMask = segMV.Voxels == aortaLabel; % a logical mask: true for every voxel of the aorta
hp = mmPlotMask2Surface(aortaMask, ...
    fcolor=segT.Color(segT.SegName == "aorta",:), ... % use the Slicer color
    transform=tform); % place the surface in mm, in patient coordinates
xlabel("x (mm)"); ylabel("y (mm)"); zlabel("z (mm)")
%[text] - Use the Rotate 3D button in the axes toolbar to turn the aorta
%[text] - Because we used tform, the axes are in millimeters \
%%
%[text] The function returns a handle to the surface, a **patch** object:
hp
%[text] - **Vertices** holds the x, y, and z coordinates of the corners of the triangles, and **Faces** lists which three vertices make up each triangle
%[text] - Like any graphics object, you can change its properties. Try hp.FaceAlpha = 0.2 \
%%
%[text] ### Plot all the segments
%[text] The course function **mmPlotAllSeg** plots every segment in the table as a surface, in its Slicer color:
figure
hpAll = mmPlotAllSeg(segMV, segT);
%[text] - **hpAll** holds a surface handle for each segment \
%%
hpAll
%%
%[text] ## Measure the volumes of the segments
%[text] To measure each segment, we use **regionprops3**. If we give it a label map, regionprops3 measures each label. But if we first convert the label map to a **categorical** array, it also labels each measurement with the segment name. The table segT gives us the label values and names:
segCat = categorical(segMV.Voxels, segT.LabelValue, segT.SegName);
volumeTable = regionprops3(segCat, "Volume")
%[text] - The volumes are in **voxels**. To convert them to mm³, we multiply by the volume of one voxel. Then we divide by 1000 to convert to mL (1 mL = 1 cm³ = 1000 mm³): \
voxelVolume = prod(segMV.VoxelSpacing) % volume of one voxel in mm^3
volumeTable.Volume_mm3 = volumeTable.Volume * voxelVolume;
volumeTable.Volume_mL = volumeTable.Volume_mm3 / 1000
%[text] - A healthy adult kidney has a volume of roughly 120–200 mL. How do your kidneys compare? If your kidneys are on the small side, why might that be? (Hint: look at the 2D overlay again)
%[text] - In Part 2, we will compare these volumes with the TotalSegmentator segmentations \
%%
%[text] ## Check your understanding
%[text] 1. A label map and its CT volume have the same size. What is the difference between the values stored in their voxels?
%[text] 2. Why are the voxels of the segmentation uint8, while the CT voxels are int16?
%[text] 3. What information does a .seg.nrrd file contain that a plain label map doesn't?
%[text] 4. What does the transformation tform do to a surface made from the label map? What would the surface look like without it?
%[text] 5. Why do we multiply the number of voxels by prod(segMV.VoxelSpacing) to get a volume? \

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[control:filebrowser:1641]
%   data: {"browserType":"Folder","defaultValue":"\"\"","label":"Choose your CTA Cardio Folder","run":"Section"}
%---
%[control:spinner:7f95]
%   data: {"defaultValue":2,"label":"Spinner","max":10,"min":1,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:spinner:2481]
%   data: {"defaultValue":2,"label":"Spinner","max":10,"min":1,"run":"Section","runOn":"ValueChanging","step":1}
%---
