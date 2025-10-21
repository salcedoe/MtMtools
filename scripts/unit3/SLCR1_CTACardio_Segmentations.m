%[text] # Slicer Volume Visualization - CTACardio Segmentations
%[text] In this module, we will load the CTACardio volume and segmentations that we created in Slicer.  Remember, segmentation files are label maps that have the same dimensions as the original volume, but have labels (numbers) instead of intensity values. There is a label value for each structure segmented from the original file. So, if there four structures segmented, there will be 4 labels in the volume (labels 1-4).
%[text] **File Extension Conventions:** In Slicer, intensity files are saved as **\*.nrrd files**, while segmentation files are saved as **\*.seg.nrrd files**
%%
clearvars
close all
setupMatGeom
%%
%[text] ## Set Folder path
%[text] Select your CTACardio folder. If you don't have one yet, you can choose the CTACardio folder in the unit3 folder.
paths.project = "/Users/ernesto/Desktop/CTACardio"; %[control:filebrowser:3f76]{"position":[17,51]}
ls(paths.project) % display folder contents
paths.intensity = fullfile(paths.project,"CTACardio Crop.nrrd");
paths.segment = fullfile(paths.project,"Salcedo Segmentation.seg.nrrd")
%[text] path check
structfun(@(x) exist(x,"file"),paths) % make sure paths exist - zeros mean the indicated file does not exist
%%
%[text] ## Load Volumes
%[text] ### Load the intensity volume
mVint = medicalVolume(paths.intensity)
%[text] - notice that Voxels here is a structure (not a volume) \
%%
%[text] ### review Voxel Structure
%[text] This is unique to Slicer volumes (I believe)
mVint.Voxels
%[text] - the Intensity values are stored in mVint.Voxels.pixelData \
%%
%[text] ### Load the segmentation volume
mVseg = medicalVolume(paths.segment)
%[text] - same deal with the Segmentation Data \
%%
%[text] #### review the segmentation volume
mVseg.Voxels
%%
%[text] ### Visualize a Intensity Segmentation Overlay
%[text] We can overlay the segmentation of the intensity values using `volshow` as follows:
hvr3 = viewer3d(BackgroundColor="white",BackgroundGradient="off",CameraZoom=1); % set background color to white and turn off gradient
volshow(mVint.Voxels.pixelData,Parent=hvr3,RenderingStyle="GradientOpacity",OverlayData=mVseg.Voxels.pixelData)
%[text] - The function **`viewer3d`** is like `figure`, but for `volshow`.
%[text] - We can use it to set the properties of  volshow background \
%%
%[text] ### Volume transformation
%[text] - The kidney is displayed on the wrong side in the image above
%[text] - This means that the volume is not being displayed properly
%[text] - Since we plugged in the Voxel data directly (mVint.Voxels.pixelData and mVseg.Voxels.pixelData), **`volshow`** didn't know how to properly transform the data
%[text] - the `VolumeGeometry` field in the medical volume has all the information necessary to properly transform the volume
%[text] - The function **`instrinsicToWorldMapping`** converts that field into a transformation matrix.  \
tform = intrinsicToWorldMapping(mVseg.VolumeGeometry) % create transformation matrix (scale, rotate, translate)
hvr3 = viewer3d(BackgroundColor="white",BackgroundGradient="off",CameraZoom=1); % set background color to white and turn off gradient
hvol = volshow(mVint.Voxels.pixelData,Parent=hvr3,RenderingStyle="GradientOpacity",OverlayData=mVseg.Voxels.pixelData,Transformation=tform);
%%
%[text] ### Use Slicer colors
segT = mmGetSlicerSegTable(paths.segment)
%%
%[text] ### Plot Segmentations as Surfaces
%[text] ### Plot Aorta
figure
MASK = mVseg.Voxels.pixelData == 1; % 
hp = mmPlotMask2Surface(MASK,fcolor=segT.Color(1,:),affTrfm=tform.A);
%%
%[text] ### Plot all Segmentations
figure;
hp = mmPlotAllSeg(mVseg,segT)

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[control:filebrowser:3f76]
%   data: {"browserType":"Folder","defaultValue":"\"\"","label":"select CTACardio folder","run":"Section"}
%---
