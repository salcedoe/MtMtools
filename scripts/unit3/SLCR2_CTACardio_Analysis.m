%[text] # Slicer Segmentations in MATLAB, Part 2: Compare Segmentations
%[text] In the Slicer exercise, you segmented the kidneys with a threshold and the aorta with a local threshold. You also ran **TotalSegmentator**, an AI model that segmented the whole volume automatically. Now we have two segmentations of the same organs. How similar are they? And if they differ, which one is right?
%[text] In this live script, we compare the two segmentations of the right kidney and the aorta. We measure how much they overlap, find out where and why they differ, and try a few ways to fix our own segmentation.
%[text] ### Learning Objectives
%[text] - Compare two segmentations with volume ratios, the Dice and Jaccard coefficients, and the Hausdorff distance
%[text] - Map the distance between two surfaces at every vertex, and summarize it with a histogram, the mean surface distance, and HD95
%[text] - Find where two segmentations differ, in 2D and in 3D
%[text] - Explain how the anatomy of an organ, and the timing of the contrast agent, can affect a threshold segmentation
%[text] - Estimate the volume of a segmentation with holes, using a convex hull and an alpha shape \
%[text] ### Before you start
%[text] - Complete Part 1 (SLCR1) first
%[text] - As in Part 1, you can use your own Slicer files or the example files in the unit 3 data folder \
%[text:tableOfContents]{"heading":"Table of Contents"}
%%
%[text] ## Background
%[text] ### TotalSegmentator
%[text] [TotalSegmentator](https://doi.org/10.1148/ryai.230024) (Wasserthal et al., 2023, *Radiology: Artificial Intelligence*) is a deep learning model that segments more than 100 anatomical structures in CT scans: organs, bones, muscles, and blood vessels. It was trained on more than 1,000 CT scans that had been segmented by experts. TotalSegmentator is fast and consistent, but it isn't perfect, and a manual segmentation isn't perfect either. When two segmentations disagree, we have to look at the images to decide which one to trust.
%[text] ### How do we compare two segmentations?
%[text] Let's call the voxels in our segmentation **A**, and the voxels in the TotalSegmentator segmentation **B**.
%[text] - **Volume ratio**: the volume of A divided by the volume of B. A ratio of 1 means the volumes are the same. But two segmentations can have the same volume and still be in different places!
%[text] - **Dice coefficient**: twice the number of voxels in both A and B (the overlap), divided by the total number of voxels in A and B: $\\textrm{Dice}=\\frac{2|A\\cap B|}{|A|+|B|}${"editStyle":"visual"}
%[text] - **Jaccard index**: the overlap divided by the number of voxels in A or B (the union): $\\textrm{Jaccard}=\\frac{|A\\cap B|}{|A\\cup B|}${"editStyle":"visual"}
%[text] - **Hausdorff distance**: the largest distance between the surfaces of A and B, in mm. Dice and Jaccard tell us how much the segmentations overlap; the Hausdorff distance tells us how far apart their surfaces get \
%[text] Dice and Jaccard both range from 0 (no overlap) to 1 (identical). Dice is always at least as large as Jaccard. As a rough guide, a Dice coefficient above 0.9 is excellent agreement, and below 0.7 is poor agreement.
%[text] ### The anatomy of the kidney
%[text] *Kidney anatomy. Blausen Medical (2014), CC BY 3.0*
%[text] The kidney has an outer layer, the **cortex**, and an inner region, the **medulla**, which is made of cone-shaped **renal pyramids**. Urine collects in the **renal pelvis**, which drains into the ureter. Blood vessels and the ureter enter and leave the kidney at the **hilum**, an opening on its medial side.
%[text] In a CT angiogram, the images are taken soon after the contrast agent is injected. At this point, the cortex, which receives most of the kidney's blood flow, is very bright, but the contrast agent hasn't reached the medulla yet. Keep this in mind when we compare the kidneys.
%%
%[text] ## Set Paths structure
%[text] Select your CTA Cardio Folder (hop back to SLRC1 if you need to use the Course example files instead). 
clearvars
close all
paths.project = "/Users/ernesto/MATLAB-Drive/MtMresources/data/unit3/CTACardio"; %[control:filebrowser:2ad7]{"position":[17,80]}
paths.contents = dir(fullfile(paths.project,"*.nrrd")); % find the slicer volume files in folder
fnames = {paths.contents.name}' % cell array of relevant files
%[text] - The output should show a mix of `*.nrrd` and `*.seg.nrrd` files \
%%
%[text] Select the file names for the Intensity Volume, Segmentation Volume, and TotalSegmentator segmentation volume. 
paths.intensity = fullfile(paths.project,fnames(2)); % CTACardio crop .nrrd %[control:dropdown:1462]{"position":[42,51]}
paths.segment = fullfile(paths.project,fnames(1)); % LastName segmentations .seg.nrrd %[control:dropdown:9705]{"position":[40,49]}
paths.total = fullfile(paths.project,fnames(1)) % CTACardio Crop segmentation .seg.nrrd %[control:dropdown:1bab]{"position":[38,47]}
%[text] - Double-check the file names \
%%
%[text] ### Use the **example files instead**
%[text] Only run if you want to use the example files in the unit3 folder. Uncomment code first
% paths = getExamplePaths

function paths = getExamplePaths
unit3f = mmSetUnitDataFolder(3); % change Current Folder to the Unit 3 Data Folder and get path
paths.project = fullfile(unit3f, "CTACardio");
paths.intensity = fullfile(paths.project, "CTACardio Crop.nrrd"); % the Cropped CTA Cardio volume
paths.segment = fullfile(paths.project, "Salcedo Segmentation.seg.nrrd"); % Kidney and Aorta Segmentation volume
paths.total = fullfile(paths.project, "CTACardio Crop segmentation.seg.nrrd"); % TotalSegmentator volume (used in SLRC2)
beep
disp("Using the course example files instead")
end
%%
%[text] ## Load the volumes
warning("off", "medical:medicalVolume:noEndian") % Slicer's NRRD files trigger a harmless warning

ctMV = medicalVolume(paths.intensity) % CT volume
segMV = medicalVolume(paths.segment) % our kidney and aorta segmentations
totalMV = medicalVolume(paths.total) % TotalSegmentator segmentations
%[text] - Does totalMV have the same number of slices as segMV? \
%%
%[text] Both segmentations were made from the same cropped volume, so they should have the same size as the CT volume. But some versions of Slicer add an extra empty slice to the TotalSegmentator segmentation. **mmMatchVolumeGeometry** puts each segmentation on the voxel grid of the CT volume, by adding or removing slices at the edges. If a segmentation already matches, it is left unchanged:
segMV = mmMatchVolumeGeometry(segMV, ctMV);
totalMV = mmMatchVolumeGeometry(totalMV, ctMV);
%[text] - Now all three volumes have the same size and voxel spacing. That means we can compare them voxel by voxel
%[text] - Each voxel is about 1.03 mm on each side. We will use the volume of one voxel to convert voxel counts to mL: \
voxelVolume = prod(segMV.VoxelSpacing) % mm^3
%%
%[text] ### Read the Slicer segment information
%[text] The function `mmGetSlicerSegmentInfo` creates a table that contains the name, label, and color of each segment:
segT = mmGetSlicerSegmentInfo(paths.segment) % just kidneys and aorta
totalT = mmGetSlicerSegmentInfo(paths.total); % total segmentator
height(totalT) % number of segments found by TotalSegmentator
totalT.SegName(contains(totalT.SegName, ["kidney" "aorta"]))
%[text] - TotalSegmentator found 88 structures in our cropped volume, including both kidneys and the aorta
%[text] - **Make sure your segments have the same names that TotalSegmentator uses**. We will need them to match.
%[text] - You can update segT.SegName to make sure the names match.  \
%%
%[text] # Compare the right kidneys
%[text] ## Index out one segment
%[text] The course function **mmGetMedicalVolumeSegment** finds a segment by name, and returns a structure with:
%[text] - **mask**: a logical volume, true for every voxel of the segment
%[text] - **color**: the Slicer color of the segment
%[text] - **tform**: the transformation from voxels to mm (see Part 1)
%[text] - **spacing**: the voxel spacing
%[text] - **volume**: the volume of the segment, in voxels \
segName = "right kidney";
mySeg = mmGetMedicalVolumeSegment(segMV, segT, segName=segName) % change segName to the name of your kidney
totSeg = mmGetMedicalVolumeSegment(totalMV, totalT, segName=segName)
%[text] - if your right kidney name is different, change the input into `mmGetMedicalVolumeSegment` for `mySeg` \
%%
%[text] ## Compare the volumes
%[text] We'll convert to mL, so we can compare to standard values
myVolume_mL = mySeg.volume * voxelVolume / 1000 % our kidney
totVolume_mL = totSeg.volume * voxelVolume / 1000 % TotalSegmentator kidney
volumeRatio = mySeg.volume / totSeg.volume
%[text] - Our kidney is only about 60% as large as the TotalSegmentator kidney. That's a big difference! \
%%
%[text] ## Measure the overlap
%[text] The functions **dice** and **jaccard** calculate the [Dice coefficient](https://en.wikipedia.org/wiki/Dice-S%C3%B8rensen_coefficient) and the Jaccard index of two masks:
diceKidney = dice(mySeg.mask, totSeg.mask)
jaccardKidney = jaccard(mySeg.mask, totSeg.mask)
%[text] - A Dice coefficient of about 0.76 is only fair agreement. What's going on? Let's look \
%%
%[text] ## Where do the segmentations differ?
%[text] ### Roll your own Label Map In 2D
%[text] To see where the two kidneys differ, we combine the two masks into one **comparison label map**:
%[text] 
compareLabels = zeros(size(mySeg.mask), "uint8");
compareLabels(mySeg.mask & totSeg.mask) = 1; % GREEN - Ours AND total
compareLabels(totSeg.mask & ~mySeg.mask) = 2; % CYAN - Total, but not ours
compareLabels(mySeg.mask & ~totSeg.mask) = 3; % MAGENTA - Ours but not total
compareMV = medicalVolume(compareLabels, segMV.VolumeGeometry); % same geometry as the segmentation
%[text] Next, we find the center of the kidney, and display a transverse and a coronal slice through it, zoomed in on the kidney:
kidneyProps = regionprops3(mySeg.mask | totSeg.mask, "Centroid", "Volume");
[~, biggest] = max(kidneyProps.Volume); % the kidney itself (not any small fragments)
center = round(kidneyProps.Centroid(biggest,:)) % [x y z]: column, row, slice
compareColors = [0.2 0.8 0.2; 0 0.8 1; 1 0 1]; % green, cyan, magenta

figure
tiledlayout(1, 2, TileSpacing="tight")
nexttile
showComparison(ctMV, compareMV, center(3), "transverse", compareColors)
title("Transverse")
nexttile
showComparison(ctMV, compareMV, center(1), "coronal", compareColors)
title("Coronal")
%[text] Results:
%[text] - 1 (green) = in both segmentations
%[text] - 2 (cyan) = only in the TotalSegmentator segmentation
%[text] - 3 (magenta) = only in our segmentation \
%[text] Comments and Analysis
%[text] - The local function **showComparison** (at the end of this script) extracts the same slice from the CT volume and the comparison label map, overlays them, and zooms in on the labels
%[text] - Most of the cortex is green: both segmentations agree there
%[text] - The inner part of the kidney is cyan: TotalSegmentator included the **medulla** and the renal sinus, but our threshold didn't. In this CT angiogram, the contrast agent hadn't reached the medulla yet, so its intensity was below our threshold range
%[text] - Which segmentation is "right" depends on the question. To measure the whole kidney, we want the medulla. To measure the enhancing cortex, our segmentation might be better! \
%%
%[text] ### In 3D
%[text] Next, we display our segmentations as a volume rendering, and the TotalSegmentator segmentations as an overlay on slice planes. Drag the slice planes through the kidney:
viewer1 = viewer3d(Parent=uifigure, BackgroundColor="white", BackgroundGradient="off", CameraZoom=1);
volshow(segMV, Parent=viewer1); % our segmentations as a volume rendering
volshow(ctMV, Parent=viewer1, RenderingStyle="SlicePlanes", OverlayData=totalMV.Voxels); % TotalSegmentator on slice planes
%%
%[text] ### As surfaces
%[text] We can also plot both kidneys as surfaces. We add the surface handles to the segment structures, so we can use the vertices later:
figure
mySeg.hp = mmPlotMask2Surface(mySeg.mask, fcolor="m", transform=mySeg.tform, lightEMup=false);
totSeg.hp = mmPlotMask2Surface(totSeg.mask, fcolor="cyan", transform=totSeg.tform);
legend(["Ours" "TotalSegmentator"])
%[text] - Because we used the transformations, the vertices are in mm
%[text] - From the outside, the two kidneys look similar. The TotalSegmentator kidney is a little larger and smoother
%[text] - Notice the medullary pyramids in the Magenta surface (our segmentation) \
%[text] **YOU TRY**: Plot the TotalSegmentator kidney with smooth=true
%%
%[text] ### Hausdorff distance
%[text] The Hausdorff distance finds, for every vertex on each surface, the distance to the nearest vertex on the other surface, and reports the largest of these distances. A single stray vertex can make the Hausdorff distance very large, so we use **robustHD**, a version that is less sensitive to outliers. (The third input, 5, controls how strongly outliers are suppressed.)
hausdorff_mm = robustHD(mySeg.hp.Vertices, totSeg.hp.Vertices, 5, "euclidean")
%[text] - The surfaces are at most about 14 mm apart. Where do you think that largest distance is? \
%%
%[text] ### Look inside the kidneys
%[text] If we display each kidney with volshow, we can use the volshow tools to cut through the kidneys and look inside. The course function **mmVolShowPair** displays two segment structures side by side, in a **uifigure**: a figure that can hold several viewers.
%[text] After the kidney appears:
%[text] 1. Click on the clipping plane tool  and add a clipping plane
%[text] 2. Drag the clipping plane through the kidney \
volshow(mySeg.mask)
%%
%[text] ### Surface distance map
%[text] The Hausdorff distance boils a whole surface down to one number. Programs like [CloudCompare](https://www.cloudcompare.org) go further: they measure the distance from **every vertex** of one surface to the other surface, and color the surface by that distance. Then you can see exactly **where** two surfaces agree and where they don't. Let's do the same in MATLAB.
%[text] #### Step 1: A signed distance map
%[text] First, we make a **signed distance map** of the TotalSegmentator kidney: a volume that holds, for every voxel, its distance to the surface of the kidney. The function **bwdist** calculates, for every voxel, the distance to the nearest true voxel of a mask:
%[text] - **bwdist(totSeg.mask)** is the distance to the kidney, for every voxel outside it (and 0 inside)
%[text] - **bwdist(~totSeg.mask)** is the distance to the outside, for every voxel inside the kidney (and 0 outside) \
%[text] Subtracting the second from the first gives distances that are **positive outside** the kidney and **negative inside** it. Because the voxels are isotropic, we can convert from voxels to mm by multiplying by the voxel spacing:
signedDistMap = (bwdist(totSeg.mask) - bwdist(~totSeg.mask)) * totSeg.spacing(1); % mm
volshow(signedDistMap,colormap=parula(256))
%%
%[text] #### Step 2: Read the distance at every vertex of our kidney
%[text] Next, we make a surface of our kidney with **isosurface**, and keep 30% of its triangles with **reducepatch**. We leave its vertices in voxel units, so that they line up with the voxels of the distance map.
%[text] The function **interp3** reads the value of a volume at any point, even between voxel centers. Like the vertices, it takes the points as (x, y, z) = (column, row, slice):
fvKidney = reducepatch(isosurface(mySeg.mask, 0.5), 0.3); % create surface of our kidney, in voxel units
kidneyDist = interp3(signedDistMap, fvKidney.vertices(:,1), fvKidney.vertices(:,2), fvKidney.vertices(:,3)); % mm, one value per vertex
%[text] - **kidneyDist** holds one signed distance for each vertex of our kidney: negative if the vertex is inside the TotalSegmentator kidney, and positive if it is outside \
%%
%[text] #### Step 3: Color the surface by distance
%[text] The local function **plotSurfaceDistance** (at the end of this script) colors each vertex by its distance. It uses a blue-white-red colormap: **white** where the surfaces agree, **blue** where our surface is inside the TotalSegmentator kidney, and **red** where it is outside.
%[text] The surface opens in its own window, in a 3-D viewer made by **surfaceMeshShow**. The light in the viewer follows the camera, so every side of the kidney stays lit as you rotate it.
%[text] - surfaceMeshShow needs the Lidar Toolbox (or the Point Cloud Toolbox, in newer versions of MATLAB). If you don't have it, plotSurfaceDistance uses **patch** instead, with four lights from different directions, as we did with FaceVertexCData in X6
%[text] - To use patch even if you have the toolbox, add **UsePatch=true** to the end of the function call \
plotSurfaceDistance(fvKidney, mySeg.tform, kidneyDist, 6, "Our kidney: distance to the TotalSegmentator kidney")
%[text] - The outside of our kidney is mostly white or pale: on the outside, the two kidneys agree within a few mm
%[text] - The red spots, where our surface sticks out, are near the hilum, where our segmentation still includes some vessels
%[text] - Rotate the kidney. Is the agreement better on some sides than others? \
%%
%[text] #### Step 4: Summarize the distances
%[text] A **histogram** shows how the distances are distributed over the whole surface, including the parts we can't see from outside:
figure
histogram(kidneyDist, -12:0.5:12)
xline(0, "k", LineWidth=1.5)
xlabel("Signed distance (mm)")
ylabel("Number of vertices")
title("Kidney: distances from our surface to the TotalSegmentator surface")
%[text] - The histogram has **two peaks**. The peak near 0 mm is the outer surface of our kidney, which matches the TotalSegmentator kidney
%[text] - The second peak, 5–10 mm inside the TotalSegmentator kidney, is a surprise. Our kidney has surfaces that we can't see from the outside: the walls of the holes where the medulla is missing! \
%%
%[text] #### Visualize the distances
%[text] Let's show only the parts of our surface that are more than 3 mm inside the TotalSegmentator kidney:
isDeep = kidneyDist < -3; % vertices more than 3 mm inside
deepFaces = all(isDeep(fvKidney.faces), 2); % triangles whose three vertices are all deep
fvDeep = struct(faces=fvKidney.faces(deepFaces,:), vertices=fvKidney.vertices);

plotSurfaceDistance(fvDeep, mySeg.tform, kidneyDist, 6, "Parts of our surface more than 3 mm inside")
%[text] - These are the inner walls of our kidney, around the renal pyramids of the medulla. The Dice coefficient and the Hausdorff distance couldn't show us this \
%%
%[text] #### Summarize distances
%[text] Finally, we summarize the distances with a few standard numbers. We use the absolute value of the distances (abs), because we care about how far apart the surfaces are, in either direction:
kidneyDistTable = table(mean(abs(kidneyDist)), median(abs(kidneyDist)), prctile(abs(kidneyDist), 95), ...
    100 * mean(abs(kidneyDist) <= 2), ...
    VariableNames=["Mean_mm" "Median_mm" "HD95_mm" "PercentWithin2mm"])
%[text] - **Mean** and **median**: the typical distance between the surfaces
%[text] - **HD95**: 95% of the vertices are closer than this distance. Like robustHD, it ignores the most extreme vertices, and it is widely used to compare segmentations
%[text] - **PercentWithin2mm**: the percentage of our surface that is within 2 mm of the TotalSegmentator surface. Only about half, because of the inner walls \
%%
%[text] ## Can we fix our segmentation?
%[text] Our kidney is missing its medulla. Let's try a few ways to estimate the volume of the whole kidney from our segmentation.
%[text] ### Try 1: Fill the holes
%[text] The function **imfill** fills holes: regions of background that are completely surrounded by the mask.
mySeg.maskCut = mySeg.mask; % copy of our kidney mask

mySeg.fill = imfill(mySeg.maskCut, 26, "holes");
filledVoxels = nnz(mySeg.fill) - nnz(mySeg.maskCut) % how many voxels did imfill add?
%[text] - imfill added very few voxels, or none at all. The holes in our kidney aren't closed: they connect to the outside of the kidney through the hilum and gaps in the cortex. To imfill, they are just part of the background \
%%
%[text] ### Try 2: The convex hull
%[text] A **convex hull** is like shrink wrap around an object: the smallest convex shape that contains the whole object (a shape is convex if it has no dents). **regionprops3** can calculate the convex hull of our kidney:
rp = regionprops3(mySeg.maskCut, ["Volume" "ConvexVolume" "ConvexImage" "Image"]);
[~, biggest] = max(rp.Volume); % keep the kidney itself, if there are small fragments
rp = rp(biggest,:)
%[text] Here, regionprops3 returns:
%[text] - **Two scalars**: **Volume** and **ConvexVolume** (in voxels)
%[text] - **Two volumes**: **Image** and **ConvexImage**, cropped to the bounding box of the kidney \
convexVolume_mL = rp.ConvexVolume * voxelVolume / 1000
%[text] - The convex volume is even larger than the TotalSegmentator kidney. Why? \
%%
%[text] #### Display the kidney and its convex hull
figure
mmPlotMask2Surface(rp.Image{1}, fcolor="m", lightEMup=false);
mmPlotMask2Surface(rp.ConvexImage{1}, fcolor="cyan", smooth=false);
%[text] - The kidney is in there. But the hull also fills in the **hilum**, the deep notch on the medial side of the kidney, so it overestimates the volume. A kidney is not convex! \
%%
%[text] ### Try 3: The alpha shape
%[text] An **alpha shape** is like a convex hull that is allowed to have dents. Imagine rolling a ball with a radius of alpha over the surface of the object: wherever the ball can't fit into a dent, the dent gets filled in. A small alpha follows the surface closely, and a large alpha fills in more, until the alpha shape becomes the convex hull.
%[text] We build an alpha shape from the vertices of our kidney surface, using an alpha of 5 mm:
alphaKidney = alphaShape(mySeg.hp.Vertices, 6) % alpha radius = 6 mm
%[text] - **alphaShape** returns an alphaShape object. It holds the points, and the alpha radius used to build the shape \
%[text] #### Display the alpha shape
% alphaKidney.HoleThreshold = 5;
[tri,xyz] = boundaryFacets(alphaKidney);
mesh = surfaceMesh(xyz,tri);
viewer = viewer3d(BackgroundColor="white", BackgroundGradient="off", ...
    LightPositionMode="headlight"); % the light moves with the camera
surfaceMeshShow(mesh,parent=viewer)
%%
figure
hAlpha = plot(alphaKidney, FaceColor="green", EdgeAlpha=0.3, FaceAlpha=0.5);
reducepatch(hAlpha,0.25)
hAlpha.EdgeAlpha=0.1;
title("Alpha shape (cyan) and our kidney (magenta)")
mySeg.hp = mmPlotMask2Surface(mySeg.mask, fcolor="m", transform=mySeg.tform, lightEMup=false);
%[text] - The alpha shape has no holes, which is what we want when we measure a volume
%[text] - It follows the shape of the kidney much better than the convex hull \
%%
%[text] #### Compare the volumes
%[text] The alpha shape calculates its own volume. Because the vertices are in mm, the volume is in mm³:
alphaVolume_mL = volume(alphaKidney) / 1000
alphaRatio = alphaVolume_mL / totVolume_mL
%[text] - The alpha shape volume is much closer to the TotalSegmentator volume than our original segmentation. It's still a bit smaller, because it can't fill the deepest part of the renal sinus
%[text] - Try a few other values of alpha (for example, 3, 10, and 20). How does the volume change? \
%%
figure
plot(alphaKidney, FaceColor="cyan", EdgeAlpha=0.3, FaceAlpha=0.5);
mmPlotMask2Surface(totSeg.mask, fcolor="m", transform=totSeg.tform);
title("Alpha shape (cyan) and TotalSegmentator kidney (magenta)")
%[text] - The two shapes are now very similar \
%%
%[text] #### How well does the alpha shape match?
%[text] To compare the alpha shape with the TotalSegmentator kidney voxel by voxel, we need to turn it back into a mask. The function **inShape** tests whether points are inside an alpha shape. If we test the center of every voxel around our kidney, we get a mask of the alpha shape. The alpha shape is in mm, so we first convert the voxel centers to mm, with the transformation:
[r, c, s] = ind2sub(size(mySeg.mask), find(mySeg.mask)); % voxels of our kidney
[cols, rows, slices] = meshgrid(min(c):max(c), min(r):max(r), min(s):max(s)); % every voxel in a box around our kidney
centers_mm = transformPointsForward(mySeg.tform, [cols(:) rows(:) slices(:)]); % voxel centers, in mm
inside = inShape(alphaKidney, centers_mm); % true for the voxel centers inside the alpha shape

alphaMask = false(size(mySeg.mask));
alphaMask(sub2ind(size(alphaMask), rows(inside), cols(inside), slices(inside))) = true;
alphaMask_mL = nnz(alphaMask) * voxelVolume / 1000
%[text] - The volume of the mask is almost the same as the volume of the alpha shape, so the conversion worked \
%[text] Now we can measure the surface distance with **mmSurfaceDistance**, the course function that does all the steps of our surface distance map in one call. alphaMask is a plain mask, so we also give it the transformation (Tform), to measure the distances in mm:
alphaDistTable = mmSurfaceDistance(alphaMask, totSeg, Tform=mySeg.tform, Names=["Alpha shape" "TotalSegmentator"], Title="Alpha shape: distance to the TotalSegmentator kidney")
%[text] - The outside of the alpha shape matches the TotalSegmentator kidney closely, and Dice is much higher than for our original kidney
%[text] - But the histogram still has a peak 5–10 mm inside. The alpha shape filled in the dents that open to the outside, but some of the holes inside our kidney are larger than the alpha radius, so they stayed as cavities inside the alpha shape \
%[text] Unlike the holes in our original kidney, these cavities are completely enclosed. So now, **imfill** can fill them:
filledMask = imfill(alphaMask, "holes");
filled_mL = nnz(filledMask) * voxelVolume / 1000
filledDistTable = mmSurfaceDistance(filledMask, totSeg, Tform=mySeg.tform, Names=["Filled alpha shape" "TotalSegmentator"], Title="Filled alpha shape: distance to the TotalSegmentator kidney")
%[text] - The volume, Dice, and surface distances are now very close to the TotalSegmentator kidney. The peak inside is gone
%[text] - By combining two simple tools, we fixed most of what our threshold segmentation missed \
%%
%[text] Compare with table from before
disp(kidneyDistTable)
%%
%[text] # Compare the aortas
%[text] Next, let's compare our aorta with the TotalSegmentator aorta.
close all hidden % close all figures, including the uifigures
segName = "aorta";
mySeg = mmGetMedicalVolumeSegment(segMV, segT, segName=segName);
totSeg = mmGetMedicalVolumeSegment(totalMV, totalT, segName=segName);

myAorta_mL = mySeg.volume * voxelVolume / 1000
totAorta_mL = totSeg.volume * voxelVolume / 1000
diceAorta = dice(mySeg.mask, totSeg.mask)
%[text] 
%%
%[text] ## Overlay the surfaces
figure
mySeg.hp = mmPlotMask2Surface(mySeg.mask, fcolor="m", transform=mySeg.tform, lightEMup=false);
totSeg.hp = mmPlotMask2Surface(totSeg.mask, fcolor="cyan", smooth=true, transform=totSeg.tform);
legend(["Ours" "TotalSegmentator"])
%[text] - Our segmentation looks smoother than the blocky TotalSegmentator aorta. TotalSegmentator's fast mode works with 3 mm voxels, and its result is resampled back to our 1 mm grid
%[text] - Our aorta still has the stumps of some of its branches
%[text] - The TotalSegmentator aorta extends higher, through the whole aortic arch
%[text] - For a fairer comparison, we should remove the branches from our aorta, and compare the same length of the aorta \
%%
%[text] ## Remove the branches
%[text] ### Morphological opening
%[text] A morphological **opening** is an erosion followed by a dilation, with the same shape (the **structuring element**). The erosion shrinks the mask and removes anything thinner than the structuring element, and the dilation grows what's left back to its original size. So an opening with a sphere removes thin branches, but keeps the thick aorta:
mySeg.maskOpen = imopen(mySeg.mask, strel("sphere", 5)); % sphere with a radius of 5 voxels
volshow(mySeg.maskOpen);
%[text] - The branches are gone \
%%
%[text] ### Crop to the TotalSegmentator aorta
%[text] To compare the same part of the aorta, we can also keep only the voxels of our aorta that are inside the TotalSegmentator aorta, with a logical operation:
mySeg.maskCrop = mySeg.mask & totSeg.mask; % voxels in both masks
figure
mmPlotMask2Surface(mySeg.maskCrop, fcolor="m", transform=mySeg.tform, lightEMup=false);
mmPlotMask2Surface(totSeg.mask, fcolor="cyan", smooth=true, transform=totSeg.tform);
legend(["Ours (cropped)" "TotalSegmentator"])
%[text] - The two segmentations follow the same path. The TotalSegmentator aorta is longer, but this is not a contest. \
%%
%[text] ### Compare the volumes again
myCrop_mL = nnz(mySeg.maskCrop) * voxelVolume / 1000
cropRatio = myCrop_mL / totAorta_mL
%[text] - Even after cropping, the TotalSegmentator aorta is larger. Part of the difference is the aortic arch, which we cut off, and which is the widest part of the aorta \
%%
%[text] ### Surface distance map of the aorta
%[text] For the kidney, we built the surface distance map step by step. The course function **mmSurfaceDistance** does all of those steps in one call: it makes a signed distance map of the second segmentation, reads it at every vertex of the surface of the first, and shows the colored surface next to the histogram, in one window. It returns the summary numbers in a table:
aortaDistTable = mmSurfaceDistance(mySeg, totSeg, Names=["Ours" "TotalSegmentator"], Title="Our aorta: distance to the TotalSegmentator aorta")
%[text] - The bars of the histogram have the same colors as the surface, so the histogram also works as the color scale
%[text] - **Hausdorff\_mm** is the Hausdorff distance (in one direction), and **MeanSigned\_mm** is the mean of the signed distances: negative if our surface is mostly inside the TotalSegmentator aorta
%[text] - The table also includes the **Dice** coefficient, so all the numbers are in one place
%[text] - The aorta agrees much better than the kidney: most of its surface is within 2 mm, and the histogram has a single peak near 0 mm
%[text] - The peak is slightly negative: our aorta is a little thinner than the TotalSegmentator aorta
%[text] - The red spots are the stumps of the branches, which stick out of the TotalSegmentator aorta
%[text] - Type **help mmSurfaceDistance** to see its other options. For example, Direction="both" also measures the distances from the TotalSegmentator aorta to ours \
%%
%[text] ## Check your understanding
%[text] 1. Two segmentations have exactly the same volume. Does that mean they agree? Why or why not?
%[text] 2. Why was the Dice coefficient for the kidneys only about 0.76, even though both segmentations captured the whole kidney from the outside?
%[text] 3. Why couldn't imfill fill the holes in our kidney?
%[text] 4. Why does the convex hull overestimate the volume of the kidney, while the alpha shape doesn't?
%[text] 5. How would you change the Slicer threshold segmentation to include the medulla? What problems might that cause?
%[text] 6. The kidney surface distance histogram had two peaks. What does each peak represent? Why can't the Dice coefficient or the Hausdorff distance tell us this? \
%%
%[text] ## Local functions
function showComparison(ctMV, labelMV, sliceNumber, plane, colors)
% Overlay one slice of a label map on the same slice of a CT volume,
% zoomed in on the labels
ctSlice = extractSlice(ctMV, sliceNumber, plane);
labelSlice = extractSlice(labelMV, sliceNumber, plane);
imshow(labeloverlay(mat2gray(ctSlice, [-160 240]), labelSlice, ...
    Colormap=colors, Transparency=0.4))
[rows, cols] = find(labelSlice); % zoom in on the labels, with a 10-pixel margin
xlim([min(cols) max(cols)] + [-10 10])
ylim([min(rows) max(rows)] + [-10 10])
end

function plotSurfaceDistance(fv, tform, distances, limit, titleText, options)
% Plot a surface colored by the signed distance at each vertex, in its own
% window: blue = inside the other surface, white = on it, red = outside.
% Uses surfaceMeshShow (Lidar Toolbox, or Point Cloud Toolbox in newer
% releases) if it is installed. Otherwise, or with UsePatch=true, uses patch
arguments
    fv struct
    tform
    distances (:,1) double
    limit (1,1) double
    titleText string = ""
    options.UsePatch (1,1) logical = false
end
blueWhiteRed = interp1([-1 0 1], [0.2 0.4 1; 0.95 0.95 0.95; 1 0.3 0.2], linspace(-1, 1, 256));
vertices = transformPointsForward(tform, fv.vertices); % mm

if ~options.UsePatch
    try
        colorIndex = round(rescale(distances, 1, 256, InputMin=-limit, InputMax=limit)); % clips beyond +-limit
        mesh = surfaceMesh(vertices, fv.faces, VertexColors=blueWhiteRed(colorIndex,:));
    catch
        disp("surfaceMesh isn't available (it needs the Lidar or Point Cloud Toolbox), so we'll use patch instead")
        options.UsePatch = true;
    end
end

if options.UsePatch
    % patch, lit by four lights from different directions, so that every side stays lit as you rotate
    figure
    p = patch(Faces=fv.faces, Vertices=vertices, FaceVertexCData=distances, ...
        FaceColor="interp", EdgeColor="none");
    axis equal off
    view(0, 0) % from the front
    for direction = [1 1 1; -1 -1 1; -1 1 -1; 1 -1 -1]' % the corners of a tetrahedron
        light(Position=direction', Style="infinite");
    end
    lighting gouraud
    material dull % less shine
    p.AmbientStrength = 0.3; % dimmer, so that four lights don't wash out the colors
    p.DiffuseStrength = 0.45;
    colormap(gca, blueWhiteRed)
    clim([-limit limit]) % same color for +limit and beyond, and for -limit and beyond
    cb = colorbar;
    title(titleText)
else
    % surfaceMeshShow, in a 3-D viewer where the light follows the camera
    fig = uifigure(Name=titleText);
    grid = uigridlayout(fig, [1 2], ColumnWidth={'1x', 90});
    viewer = viewer3d(grid, BackgroundColor="white", BackgroundGradient="off", ...
        LightPositionMode="headlight"); % the light moves with the camera
    surfaceMeshShow(mesh, Parent=viewer, Title=titleText)
    center = mean(vertices); % start from the front
    viewer.CameraTarget = center;
    viewer.CameraPosition = center - [0 3*max(range(vertices)) 0];
    viewer.CameraUpVector = [0 0 1];

    ax = uiaxes(grid); % viewer3d has no colorbar, so we borrow one from empty axes
    ax.Visible = "off";
    colormap(ax, blueWhiteRed)
    clim(ax, [-limit limit])
    cb = colorbar(ax, Location="west");
end
cb.Label.String = "Signed distance (mm)";
end


%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[control:filebrowser:2ad7]
%   data: {"browserType":"Folder","defaultValue":"\"\"","label":"Choose your CTA Cardio Folder","run":"Section"}
%---
%[control:dropdown:1462]
%   data: {"defaultValue":"fnames(1)","itemLabels":["6 BODY BONE cropped.nrrd","Salcedo Segmentation.seg.nrrd","Total Segmentation.seg.nrrd"],"items":["fnames(1)","fnames(2)","fnames(3)"],"itemsVariable":"fnames","label":"Drop down","run":"Section"}
%---
%[control:dropdown:9705]
%   data: {"defaultValue":"fnames(1)","itemLabels":["6 BODY BONE cropped.nrrd","Salcedo Segmentation.seg.nrrd","Total Segmentation.seg.nrrd"],"items":["fnames(1)","fnames(2)","fnames(3)"],"itemsVariable":"fnames","label":"Drop down","run":"Section"}
%---
%[control:dropdown:1bab]
%   data: {"defaultValue":"fnames(1)","itemLabels":["6 BODY BONE cropped.nrrd","Salcedo Segmentation.seg.nrrd","Total Segmentation.seg.nrrd"],"items":["fnames(1)","fnames(2)","fnames(3)"],"itemsVariable":"fnames","label":"Drop down","run":"Section"}
%---
