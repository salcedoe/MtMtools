%[text] # CTACardio Multi Segmentation Comparisons
%[text] In this module, we compare kidney segmentations of the CTACardio scan. In **Part 1**, we compare the left and right kidney of one segmentation: their sizes, and, after mirroring and aligning them, their shapes. In **Part 2**, we measure the kidneys and the aorta in the segmentations of the whole class, to find out how well raters agree, and whether the left-right difference is real.
%[text] Be sure to upload your Segmentation to the Course dropbox (CREATE a ONEDrive Dropbox for data security)
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] 
%[text] ## Setup
%[text] ### Reset MATLAB
clearvars
close all hidden
%%
%[text] # Part 1: Left vs. Right Kidney
%[text] Here we compare the left and right kidneys from one project
%[text] ### Set the  paths
%[text] Choose your CTA Cardio folder
paths.project = "/Users/ernesto/MATLAB-Drive/MtMresources/data/unit3/CTACardio"; % CTACArdio %[control:filebrowser:01d8]{"position":[17,80]}
paths.contents = dir(fullfile(paths.project,"*.nrrd")); % find the slicer volume files in folder
fnames = {paths.contents.name}'; % cell array of relevant files
paths.intensity = fullfile(paths.project,fnames(2)); % CTCardio Crop .nrrd %[control:dropdown:1d7f]{"position":[42,51]}
paths.segment = fullfile(paths.project,fnames(7)); % Last Name Segmentation .seg.nrrd %[control:dropdown:5491]{"position":[40,49]}
%%
%[text] Or use course example files (uncomment first)
% paths.project = fullfile(mmSetUnitDataFolder(3), "CTACardio");
% paths.segment = fullfile(paths.project,"Salcedo Segmentation.seg.nrrd");
% paths.intensity = fullfile(paths.project,"CTACardio Crop.nrrd");
% table(fieldnames(paths),structfun(@(x) exist(x,"file"),paths),VariableNames=["path" "X"]) % make sure paths exist
%%
%[text] ### Load  medical volume and metadata
intMV = medicalVolume(paths.intensity); 
myMV = medicalVolume(paths.segment); % load segmentation volume as a medical volume
tform = myMV.VolumeGeometry.intrinsicToWorldMapping; % get the transformation matrix (mm space, correct orientation)

segT = mmGetSlicerSegmentInfo(paths.segment) % get slicer segmentation data
%%
%[text] ### Does your segmentation have layers? (optional)
%[text] Slicer saves a segmentation in more than one **layer** when segments overlap (for example, a kidney and the aorta). Check your segmentation in two ways:
%[text] - the size of the voxels below: three numbers means one layer. **Four** numbers means layers: the fourth number is the number of layers
%[text] - the `Layer` column of `segT` above: if every value is 1, you have one layer \
size(myMV.Voxels)
%[text] The example segmentation has one layer, so there is nothing to do. If **your** segmentation has layers, the next sections (volshow and regionprops3) won't run, because they need one label volume. You can collapse the layers in Slicer and save the file again, or use the course function **mmCollapseSegmentLayers**: remove the `%` from the line below, and run this section again.
%[text] - The result is the same as collapsing the layers in Slicer. Where two segments overlap, the segment in the **higher layer** (the `Layer` column of `segT`) keeps the voxels. The function tells you which segments lost voxels, and how many. Check that the numbers are small
%[text] - The function doesn't change your file \
% [myMV, segT] = mmCollapseSegmentLayers(myMV, segT);
%%
%[text] ### Display using volshow
hvr = viewer3d("BackgroundColor",'white',BackgroundGradient='off');
hvs = volshow(intMV,OverlayData=myMV.Voxels,Parent=hvr,RenderingStyle="GradientOpacity");
%[text] - the default settings make the segmentations a little hard to see
%[text] - No tissue evident — just bones and ribs \
%%
hvs.OverlayAlpha = single(0.75); % increase opacity of segmentations
%%
hvs.RenderingStyle="VolumeRendering"; % changes how the volume is displayed
%[text] - default is too opaque \
%%
hvs.Alphamap = single(linspace(0,.01,256)); % adjust intensity alpha values - not the low values
%[text] - now you can see some tissue \
%%
%[text] ### Region Properties
%[text] Since the segmentation volume contains both kidneys, we can plug that right into regionprops for some quick data
catSeg = categorical(myMV.Voxels,segT.LabelValue,segT.SegName); % convert to categorical
RP = regionprops3(catSeg,intMV.Voxels,"Volume","MeanIntensity");
RP.VolumeML = RP.Volume .* prod(0.1 * myMV.VoxelSpacing) % convert to mL (cm^3)
%[text] - We see the right kidney is slightly larger than the left kidney
%[text] - Both kidneys have ~ equivalent HU
%[text] - This may be due to the vasculature coming off the kidneys \
%%
%[text] #### Index out kidney segmentations
%[text] First, we we create two structures that contain a mask of respective kidney segmentation with some information about the segmentation
rkSeg = mmGetMedicalVolumeSegment(myMV,segT,"segName","right kidney")
lkSeg = mmGetMedicalVolumeSegment(myMV,segT,"segName","left kidney")
%%
%[text] #### Plot Segmentations 
figure;
hp1 = mmPlotMask2Surface(rkSeg.mask,fcolor = 'cyan',transform=tform,lightEMup=false);
hp2 = mmPlotMask2Surface(lkSeg.mask,fcolor = 'magenta',transform=tform,lightEMup=true);
legend(["rk1" "lk2"])
%[text] - Here we use the transformation vector to plot our segmentations in mm space
%[text] - We also only turn on the "lights" for the second plot (So as to not over-saturate our display) - try setting lightEMup to true \
%%
%[text] #### Center vertices
hp1.Vertices = hp1.Vertices - mean(hp1.Vertices); % center vertices
hp2.Vertices = hp2.Vertices - mean(hp2.Vertices); % center vertices
%[text] - Notice that we can't line up the two kidneys by rotating one of them. Like your left and right hands, they are **mirror images** of each other (they are *chiral*). No rotation turns a left hand into a right hand: you have to **reflect** it \
%%
%[text] ### What did we segment?
%[text] We segmented the kidneys with a **threshold** (190–300). In this CTA scan, the cortex of the kidney takes up the contrast agent and is bright, but the medulla (the renal pyramids) and the renal sinus are darker. So the threshold captures the **enhancing kidney tissue**, not the whole kidney — leaving holes where the medulla is located, Keep this in mind:
%[text] - Our volumes are the volume of the enhancing tissue, not of the whole kidney, so we can't compare them with clinical kidney volumes (or with TotalSegmentator, which fills in the whole kidney)
%[text] - But, everyone in the class used the same method, so the segmentations are comparable with each other. That's what we will compare in Part 2 \
%%
%[text] ### Compare the sizes
%[text] An easy way to compare the two kidneys is the **asymmetry index**: the difference between the left and right volumes, as a percentage of their average. An index of 0 means the kidneys are the same size; a positive index means the left kidney is larger.
%[text] $\\textrm{Asymmetry}\\;\\textrm{Index}=100\\times \\frac{L-R}{(L+R)/2}${"editStyle":"visual"}
voxelVolume_mL = prod(myMV.VoxelSpacing) / 1000; % volume of one voxel, in mL
Right_mL = nnz(rkSeg.mask) * voxelVolume_mL;
Left_mL = nnz(lkSeg.mask) * voxelVolume_mL;
asymmetryIndex = 100 * (Left_mL - Right_mL) / ((Left_mL + Right_mL) / 2)
%[text] - A negative index: in this person, the right kidney is larger
%[text] - In most people, the left kidney is slightly larger than the right. Is this kidney unusual, or is the difference just a result of how we segmented it? We will come back to this question in Part 2 \
%%
%[text] ### Length, width, and thickness
%[text] Kidney **length** (pole to pole) is the size that radiologists measure most often. To measure it, we turn each kidney so that its longest axis lines up with the x-axis, using **mmAlignSurface2Axes** (which uses the singular value decomposition, **svd**). Then we use the range of the vertices along each axis to calculate the length, width, and thickness of the kidney:
fvR = mmGetSurface(rkSeg.mask, transform=tform); % surfaces in mm
fvL = mmGetSurface(lkSeg.mask, transform=tform);
vertsR = mmAlignSurface2Axes(fvR.vertices - mean(fvR.vertices)); % center, and align the longest axis with x
vertsL = mmAlignSurface2Axes(fvL.vertices - mean(fvL.vertices));

sizeTable = array2table([range(vertsR); range(vertsL)], ...
    VariableNames=["Length_mm" "Width_mm" "Thickness_mm"], RowNames=["Right kidney" "Left kidney"])
%[text] - A normal adult kidney is about 10–12 cm long \
%[text] To see how **range** measures the size, we draw the bounding box of the right kidney. Its corner is the minimum of the vertices, and its sides are the range of the vertices:
figure
patch(Faces=fvR.faces, Vertices=vertsR, FaceColor="cyan", EdgeColor="none", FaceAlpha=0.5)
axis equal
view(3)
camlight
drawcuboid(Position=[min(vertsR) range(vertsR)]);
xlabel("Length (mm)"), ylabel("Width (mm)"), zlabel("Thickness (mm)")
%[text] - **Careful:** svd finds the axes of the kidney, but it may return a set of axes that **mirrors** the kidney. That doesn't matter for measuring the size (a reflection doesn't change the range), but it means we can't use this alignment to compare the *shapes* of the kidneys. For that, we need the next step \
%%
%[text] ### Mirror and align the left kidney
%[text] To compare the shapes, we reflect the left kidney across the midline of the body (in patient coordinates, x becomes −x), so that it becomes a "right" kidney. Then we line it up with the right kidney using **ICP** (iterative closest point), a rigid registration: it rotates and moves the left kidney, without changing its size or shape, until its surface fits the surface of the right kidney as closely as possible.
%[text] The course function **mmMirrorAlign** does all of this, and puts the aligned left kidney on the voxel grid of the right kidney, so that we can compare them like two segmentations of the same structure. It also returns the **RMSE** (root-mean-square error): the typical distance between the two surfaces after alignment, in mm. To see why the mirroring matters, we also align the left kidney **without** mirroring it:
[lkOnRk, rmseMirrored] = mmMirrorAlign(rkSeg, lkSeg);
[~, rmseNotMirrored] = mmMirrorAlign(rkSeg, lkSeg, Mirror=false);
table(rmseNotMirrored, rmseMirrored, VariableNames=["RMSE_NotMirrored_mm" "RMSE_Mirrored_mm"])
%[text] - The mirrored left kidney fits the right kidney better: rotating alone can't make up for the mirror image \
figure
mmPlotMask2Surface(rkSeg.mask, fcolor="cyan", transform=tform, falpha=0.5, lightEMup=false);
mmPlotMask2Surface(lkOnRk.mask, fcolor="magenta", transform=tform, falpha=0.5);
legend(["Right kidney" "Left kidney (mirrored and aligned)"])
%%
%[text] ### Where do the kidneys differ?
%[text] Now we can map the distance between the two surfaces with **mmSurfaceDistance**, as in SLCR2 and SLCR3. Neither kidney is the reference, so we measure the distances in both directions:
lrDistTable = mmSurfaceDistance(rkSeg, lkOnRk, Names=["Right kidney" "Left kidney (mirrored)"], Direction="both", Title="Right vs. mirrored left kidney")
%[text] - **MeanSigned\_mm** is positive from the right kidney to the left: on average, the surface of the right kidney is *outside* the left kidney. That is the difference in **size** that we measured above
%[text] - Look for the places where the distance is largest. Some are on the outer surface (the shape of the poles and the hilum), and some are on the **inner walls** around the medulla, which come from the threshold, not from the anatomy of the kidney
%[text] - The **Dice** coefficient is low, even though the surfaces are only a few mm apart. With holes inside the kidneys, the overlap of the two segmentations is small, so Dice is a poor measure for these segmentations \
%%
%[text] ### Check your understanding
%[text] 1. Why can't we line up the left and right kidneys with a rotation alone?
%[text] 2. Why is it OK to use the svd alignment to measure the length of a kidney, but not to compare the shapes of the two kidneys?
%[text] 3. The surface distance map mixes differences in size with differences in shape. How could you separate the two?
%[text] 4. Is the difference between the two kidneys real, or could it come from how we segmented them? What would you need to know to answer this question? \
%%
%[text] # Part 2: Compare the class segmentations
%[text] Everyone in the class segmented the **same** CTA scan, with the same method. So the differences between our measurements don't come from anatomy: they come from us, the **raters**. This is called **inter-rater variability**, and every study that uses manual segmentations has to measure it. In this part we will:
%[text] 1. Load everyone's segmentation, and measure the left and right kidney of each one
%[text] 2. Measure how well the raters agree (**inter-rater reliability**)
%[text] 3. Use the whole class to answer the question from Part 1: is the difference between the left and right kidney real?
%[text] 4. Do the same for the aorta: its length and diameter \
%%
%[text] ## Load the class segmentations
%[text] ### Find the files
%[text] Everyone uploaded their segmentation as "LastName Segmentation.seg.nrrd" into the class folder. **mmGetSlicerSegmentInfoAll** reads the segment information of every file in a folder:
paths.class = fullfile(matlabdrive, "SlicerDropbox", "Kidneys"); % the class folder
[classSegT, contentT] = mmGetSlicerSegmentInfoAll(paths.class);
contentT(:, ["ID" "VolSize" "PixelSpacing"])
%[text] - Everyone cropped the scan a little differently before resampling it to isotropic voxels, so every segmentation has its own size (VolSize) and maybe its own voxel size (PixelSpacing). That's fine: we measure each segmentation on its own voxel grid, in mm \
%%
%[text] ### Check the segment names
groupsummary(classSegT, "SegName")
%[text] - Did everyone use the same names? A computer sees "Right Kidney" and "right kidney" as different names. Our local functions (at the end of this script) ignore upper and lower case \
%%
%[text] ## Measure the kidneys
%[text] The local function **measureKidneys** loads the left and right kidney from one file, and measures each one the same way we did in Part 1: the volume, and the length, width, and thickness (with mmAlignSurface2Axes). It also checks for **swapped labels**: in patient coordinates (LPS), x increases toward the patient's **left**, so the left kidney must have a larger x than the right kidney. If it doesn't, measureKidneys swaps them back and tells us.
%[text] We collect the measurements in a **tidy** table: one row per observation (one kidney of one student), and one column per variable. Tidy tables are easy to group, summarize, and plot.
%[text] How the loop works:
%[text] - `kidneyT = table()` starts with an empty table
%[text] - measureKidneys returns a 2-row table for each file (the right and the left kidney). `kidneyT = [kidneyT; newRows]` adds these rows at the bottom: the semicolon stacks tables **on top of each other**
%[text] - `try ... catch`: if a file has a problem (for example, a missing kidney), MATLAB jumps to `catch`, prints a warning, and goes on with the next file, instead of stopping the whole loop \
%[text] This section takes a minute.
numFiles = height(contentT);
kidneyT = table(); % start with an empty table
for k = 1:numFiles
    file = fullfile(contentT.folder(k), contentT.name(k));
    try
        newRows = measureKidneys(file, contentT.ID(k)); % the right and left kidney of this file
        kidneyT = [kidneyT; newRows]; %#ok<AGROW> % add the rows at the bottom (this copies the table each time: fine for 20 rows, but preallocate for thousands)
    catch err
        warning("%s: %s", contentT.ID(k), err.message) % skip this file, and keep going
    end
end
kidneyT.Side = categorical(kidneyT.Side, ["Right" "Left"])
%[text] - %\#ok\<AGROW\> - this comment means ignore the warning that we are building the table row by row
%[text] - Who had swapped labels?
%[text] - The volumes vary from person to person, even though everyone segmented the same kidneys. Most of this comes from the low end of the threshold range: a lower threshold includes more of the medulla \
%%
%[text] ### Look at the measurements
measures = ["Volume_mL" "Length_mm" "Width_mm" "Thickness_mm"];
figure
tiledlayout("flow")
for m = measures
    nexttile
    mmBoxSwarm(kidneyT.Side, kidneyT.(m));
    title(replace(m, "_", " (") + repmat(")", 1, contains(m, "_"))) % "Volume_mL" -> "Volume (mL)"
end
%[text] - For which measurements do the left and right kidneys differ the most, compared with the spread between raters? \
%%
%[text] ## Inter-rater reliability
%[text] How closely do the raters agree? Think of ten people measuring the length of the same table with a tape measure. They won't all get exactly the same number. The question is how far apart their numbers are, and whether that matters.
%[text] ### Why not the ICC?
%[text] The statistic you will see most often in papers is the **intraclass correlation coefficient** (ICC). The ICC asks: are the raters' differences small **compared with the differences between subjects**? An ICC near 1 means that the raters disagree much less than the kidneys differ from each other, so you can tell the kidneys apart no matter who measures them. To calculate it, the raters must measure many different subjects (for example, the kidneys of 30 patients). We all measured the same two kidneys, so we can't calculate a meaningful ICC. Instead, we describe the disagreement between raters directly.
%[text] ### Three ways to describe the disagreement
%[text] For each kidney and each measurement, we calculate:
%[text] 1. **SD** (standard deviation): how far a typical rater is from the class average. About two-thirds of the raters are within ±1 SD of the average. The SD is in the units of the measurement (mL or mm)
%[text] 2. **CV** (coefficient of variation): the SD as a **percentage** of the average, 100 × SD / mean. A 5-mL SD is small for a 100-mL kidney (5%), but it would be huge for a 10-mL structure (50%). Because the CV has no units, we can compare volumes (mL) with lengths (mm). As a rule of thumb, a CV below 5% means good agreement, and above 10% poor agreement
%[text] 3. **RC** (reproducibility coefficient): the answer to the question "if a classmate and I both measure this kidney, how far apart could our numbers be?" Two raters' measurements differ by less than the RC 95% of the time. The RC is $1\\ldotp 96\\times \\sqrt{2}\\times SD${"editStyle":"visual"}: the difference between two raters varies more than one rater does (by a factor of $\\sqrt{2}${"editStyle":"visual"}), and 95% of the values of a normal distribution are within 1.96 SD of the mean \
reliabilityT = table();
for side = ["Right" "Left"]
    for m = measures
        x = kidneyT.(m)(kidneyT.Side == side);
        reliabilityT = [reliabilityT; table(side, m, mean(x), std(x), 100 * std(x) / mean(x), 1.96 * sqrt(2) * std(x), ...
            VariableNames=["Side" "Measure" "Mean" "SD" "CV_pct" "RC"])]; %#ok<AGROW>
    end
end
reliabilityT
%%
%[text] ### Read one row of the table
%[text] Here is the first row (the volume of the right kidney) in words:
r = reliabilityT(1, :);
fprintf("The average volume of the right kidney is %.1f mL. A typical rater is within %.1f mL of the average (SD).\n" + ...
    "That is %.1f%% of the volume (CV). Two raters will usually (95%% of the time) differ by less than %.1f mL (RC).\n", ...
    r.Mean, r.SD, r.CV_pct, r.RC)
%%
%[text] ### Compare the measurements
%[text] The CV lets us compare all the measurements on one scale:
labels = replace(measures, "_", " (") + ")"; % "Volume_mL" -> "Volume (mL)"
figure
b = bar(categorical(labels, labels), [reliabilityT.CV_pct(reliabilityT.Side == "Right") reliabilityT.CV_pct(reliabilityT.Side == "Left")]);
legend(b, ["Right kidney" "Left kidney"], Location="northeast", AutoUpdate="off")
yline([5 10], "--", ["good" "poor"])
ylim([0 max(12, max(reliabilityT.CV_pct) + 1)])
ylabel("CV between raters (%)")
title("How much do the raters disagree?")
%[text] - Which measurement do the raters agree on best? Which one worst?
%[text] - Why do the raters agree so much better on the length than on the volume? (Hint: which part of the kidney does the threshold change, and which part decides the length?)
%[text] - If the CV of the width is very different for the two kidneys, look for one rater with an unusual width in the swarm plots above. The width depends on which axis svd picks as the second-longest. If a kidney's cross section is nearly round, a small change in the segmentation can make svd swap the width and the thickness \
%%
%[text] ## Left vs. right: is the difference real?
%[text] In Part 1, we found that the right kidney was larger than the left in one segmentation. Now we have many measurements of the **same** two kidneys, so we can ask three questions:
%[text] 1. **Direction**: do the raters agree on which kidney is larger?
%[text] 2. **Consistency**: is that agreement more than we would expect by chance?
%[text] 3. **Size**: is the left-right difference bigger than the disagreement between two raters? \
%[text] ### Look at each rater's two kidneys
%[text] In this plot, each line is one rater: it connects their right kidney with their left kidney. If all the lines slope the same way, the raters agree on the direction:
figure
tiledlayout("flow")
for m = measures
    wideT = unstack(kidneyT(:, ["StudentLastName" "Side" m]), m, "Side"); % one row per student, columns Right and Left
    nexttile
    plot([1 2], [wideT.Right wideT.Left]', "-o", Color=[0.5 0.5 0.5])
    xlim([0.5 2.5])
    xticks([1 2])
    xticklabels(["Right" "Left"])
    title(replace(m, "_", " (") + repmat(")", 1, contains(m, "_")))
end
%[text] - **Careful:** each plot has its own y-axis. A difference of less than 1 mm can look as steep as a difference of 15 mL. Always read the numbers on the y-axis
%[text] - Do all the lines slope the same way for every measurement?
%[text] - Compare how steep the lines are with how far apart they are. A steep slope and a narrow bundle of lines means a clear difference; a shallow slope in a wide bundle means the difference is hard to see \
%%
%[text] ### Calculate the left-right differences
%[text] **unstack** turns the tidy table into a wide table, with one row per student and one column per side. Then we calculate each student's left-right difference (left − right, so a negative difference means the right kidney is larger), and for each measurement:
%[text] - **MeanDifference\_LminusR**: the average left-right difference
%[text] - **NumRightLarger**: how many raters found the right kidney larger (question 1)
%[text] - **pValue**: the **signrank** test (the Wilcoxon signed-rank test) tests whether the median difference is 0 (question 2). A small p-value means that the raters consistently find a difference in the same direction
%[text] - **RC** and **BiggerThanRC**: the RC between raters, for both kidneys together, and whether the left-right difference is bigger (question 3) \
differenceT = table();
for m = measures
    wideT = unstack(kidneyT(:, ["StudentLastName" "Side" m]), m, "Side"); % columns: StudentLastName, Right, Left
    d = wideT.Left - wideT.Right; % each student's left-right difference
    pooledSD = sqrt((var(wideT.Left) + var(wideT.Right)) / 2); % the SD between raters, for both kidneys
    RC = 1.96 * sqrt(2) * pooledSD;
    differenceT = [differenceT; table(m, mean(d), nnz(d < 0), numel(d), signrank(d), RC, abs(mean(d)) > RC, ...
        VariableNames=["Measure" "MeanDifference_LminusR" "NumRightLarger" "NumRaters" "pValue" "RC" "BiggerThanRC"])]; %#ok<AGROW>
end
differenceT
%%
%[text] ### Read the table
%[text] The same results, in words:
for k = 1:height(differenceT)
    r = differenceT(k, :);
    if r.BiggerThanRC
        sizeText = "bigger than the RC (%.2f): two raters disagree less than the kidneys differ.";
    else
        sizeText = "smaller than the RC (%.2f): two raters can disagree by more than the kidneys differ.";
    end
    fprintf("%s: on average, left - right = %.2f. %d of %d raters found the right kidney larger (p = %.3g). The difference is " + sizeText + "\n", ...
        r.Measure, r.MeanDifference_LminusR, r.NumRightLarger, r.NumRaters, r.pValue, r.RC)
end
%[text] **Two things to know about these results:**
%[text] - **The p-value tells you about the direction, not the size.** With 10 raters, the smallest possible p-value of the signrank test is 0.002 (1 / 512). You get it whenever **all** the raters find a difference in the same direction, whether the difference is large or tiny. A small p-value means "the raters consistently see a difference", not "the difference is large"
%[text] - **A difference can be consistent but smaller than the RC.** Each rater measures both of their own kidneys with their own threshold and their own cuts. A rater who uses a low threshold gets two larger kidneys, but the **difference** between their two kidneys barely changes. (A tape measure that reads 1 cm too long makes both of your measurements too long, but not the difference between them.) So each rater can see the same small left-right difference, even though two raters disagree by more than that about each kidney. The RC answers a different question: "if someone else segmented these kidneys, could their numbers be on the other side of my numbers?" \
%[text] ### Questions
%[text] - For which measurements is the left-right difference bigger than the RC? What does that mean?
%[text] - Find a measurement with a small p-value whose difference is smaller than the RC. Explain how both can be true
%[text] - All of these measurements come from one person. Can we conclude anything about left and right kidneys **in general**? \
%%
%[text] ## The aorta
%[text] The normal diameter of the descending aorta is about:
%[text] - **Proximal**: 21–25 mm
%[text] - **Mid**: 18–20 mm
%[text] - **Distal**: 15–19 mm \
%[text] The local function **measureAorta** measures the aorta of each file the same way we did in SLCR2:
%[text] 1. A morphological **opening** removes the stumps of the branches
%[text] 2. **bwskel** thins the opened aorta to its center line (the skeleton)
%[text] 3. The **length** is the longest path along the skeleton (**bwdistgeodesic**)
%[text] 4. The **diameter** at each point of the center line is twice the distance to the wall (the Euclidean distance transform, **bwdist**). Diameters along the aorta are not normally distributed, so we use the **median** \
aortaT = table(); % start with an empty table, and add one row per file
for k = 1:numFiles
    file = fullfile(contentT.folder(k), contentT.name(k));
    try
        newRow = measureAorta(file, contentT.ID(k));
        aortaT = [aortaT; newRow]; %#ok<AGROW> % add the row at the bottom
    catch err
        warning("%s: %s", contentT.ID(k), err.message) % skip this file, and keep going
    end
end
aortaT
%%
%[text] ### How well do the raters agree?
figure
tiledlayout(1, 2)
nexttile
mmBoxSwarm([], aortaT.Length_mm);
title("Aorta length (mm)")
nexttile
mmBoxSwarm([], aortaT.MedianDiameter_mm);
title("Median diameter (mm)")

aortaReliabilityT = table();
for m = ["Length_mm" "MedianDiameter_mm"]
    x = aortaT.(m);
    aortaReliabilityT = [aortaReliabilityT; table(m, mean(x), std(x), 100 * std(x) / mean(x), 1.96 * sqrt(2) * std(x), ...
        VariableNames=["Measure" "Mean" "SD" "CV_pct" "RC"])]; %#ok<AGROW>
end
aortaReliabilityT
%[text] - Is the median diameter in the normal range? Remember that our threshold captured the **lumen** (the contrast-filled blood), not the wall of the aorta. Which parts of the aorta did we segment?
%[text] - Which do the raters agree on better, the length or the diameter? What could make the lengths differ? (Hint: where did each person start and stop the aorta?) \
%%
%[text] ### Check your understanding
%[text] 1. Everyone segmented the same scan. Where do the differences between our measurements come from?
%[text] 2. Why can't we calculate an ICC from our class data? What data would you need?
%[text] 3. What would have happened to the left and right columns of the table if measureKidneys hadn't checked for swapped labels?
%[text] 4. All of our segmentations come from one person. How would you design a study to find out whether the left and right kidneys differ in general? \
%%
%[text] ## Local functions
function T = measureKidneys(file, lastName)
% Load the right and left kidneys of a Slicer segmentation file, and measure
% each one: volume, length, width, and thickness. Ignores upper
% and lower case in the segment names, and swaps the kidneys back if their
% labels were swapped. Returns a tidy table with one row per kidney
warning("off", "medical:medicalVolume:noEndian")
mv = medicalVolume(file);
st = mmGetSlicerSegmentInfo(file);
st.SegName = lower(strtrim(st.SegName)); % "Right Kidney" -> "right kidney"
if ~all(ismember(["right kidney" "left kidney"], st.SegName))
    error("No ""right kidney"" and ""left kidney"" segments. Found: %s", join(st.SegName, ", "))
end
rk = mmGetMedicalVolumeSegment(mv, st, segName="right kidney"); % right kidney segmentation
lk = mmGetMedicalVolumeSegment(mv, st, segName="left kidney"); % left kidney segmentation

% swapped labels? In LPS coordinates, x increases toward the patient's left
xRight = centroidX(rk.mask, rk.tform);
xLeft = centroidX(lk.mask, lk.tform);
if mv.VolumeGeometry.PatientCoordinateSystem == "RAS+" % in RAS, x increases toward the right
    [xRight, xLeft] = deal(-xRight, -xLeft);
end
if xRight > xLeft
    [rk, lk] = deal(lk, rk);
    fprintf("%s: the left and right kidney labels were swapped. Swapped them back.\n", lastName)
end

T = [measureKidney(rk, lastName, "Right"); measureKidney(lk, lastName, "Left")];
end


function T = measureKidney(seg, lastName, side)
% Measure one kidney: one row of the tidy table
voxelVolume_mL = abs(det(seg.tform.A(1:3, 1:3))) / 1000; % from the voxel size of this file
fv = mmGetSurface(seg.mask, transform=seg.tform); % surface in mm
verts = mmAlignSurface2Axes(fv.vertices - mean(fv.vertices)); % center, and align the longest axis with x
dims = range(verts); % length, width, and thickness
T = table(string(lastName), string(side), nnz(seg.mask) * voxelVolume_mL, ...
    dims(1), dims(2), dims(3), ...
    VariableNames=["StudentLastName" "Side" "Volume_mL" "Length_mm" "Width_mm" "Thickness_mm"]);
end


function x = centroidX(mask, tform)
% The x coordinate (mm) of the center of a mask
[r, c, s] = ind2sub(size(mask), find(mask));
p = transformPointsForward(tform, mean([c r s], 1)); % tform works on [column row slice]
x = p(1);
end


function T = measureAorta(file, lastName)
% Measure the length and the median diameter of the aorta of a Slicer
% segmentation file. Returns one row of a table
warning("off", "medical:medicalVolume:noEndian")
mv = medicalVolume(file);
st = mmGetSlicerSegmentInfo(file);
isAorta = lower(strtrim(st.SegName)) == "aorta";
if ~any(isAorta)
    error("No ""aorta"" segment. Found: %s", join(st.SegName, ", "))
end
seg = mmGetMedicalVolumeSegment(mv, st, segName=st.SegName(find(isAorta, 1)));
if max(seg.spacing) - min(seg.spacing) > 0.01
    warning("%s: the voxels are not cubes (%s mm). The length and diameter will be off.", lastName, mat2str(seg.spacing, 3))
end
voxelSize = mean(seg.spacing); % mm

mask = largestComponent(seg.mask);
% sizes in mm, converted to voxels, so that they're the same for every voxel size
radius = round(5 / voxelSize); % opening: a sphere with a radius of 5 mm
minBranch = round(20 / voxelSize); % skeleton branches shorter than 20 mm are removed
maskOpen = largestComponent(imopen(mask, strel("sphere", radius))); % remove the stumps of the branches
edt = bwdist(~mask); % distance from each voxel to the wall of the aorta, in voxels
skel = largestComponent(bwskel(maskOpen, MinBranchLength=minBranch)); % center line of the aorta

% length: the longest path along the skeleton. From any skeleton voxel, the
% farthest skeleton voxel is one end of the aorta. From that end, the
% farthest skeleton voxel is the other end
D = bwdistgeodesic(skel, find(skel, 1), "quasi-euclidean");
[~, farthest] = max(D(:), [], "omitnan");
D = bwdistgeodesic(skel, farthest, "quasi-euclidean");

T = table(string(lastName), max(D(:), [], "omitnan") * voxelSize, 2 * median(edt(skel)) * voxelSize, ...
    VariableNames=["StudentLastName" "Length_mm" "MedianDiameter_mm"]);
end


function mask = largestComponent(mask)
% Keep only the largest connected component of a mask
CC = bwconncomp(mask, 26);
[~, big] = max(cellfun(@numel, CC.PixelIdxList));
mask = false(size(mask));
mask(CC.PixelIdxList{big}) = true;
end



%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[control:filebrowser:01d8]
%   data: {"browserType":"Folder","defaultValue":"\"\"","label":"select CTACardio folder","run":"Section"}
%---
%[control:dropdown:1d7f]
%   data: {"defaultValue":"fnames(1)","itemLabels":["CTACardio Crop segmentation.seg.nrrd","CTACardio Crop.nrrd","CTACardio.nrrd","Lung segmentation preview.seg.nrrd","Lung segmentation.seg.nrrd","Resampled Volume.nrrd","Salcedo Segmentation.seg.nrrd"],"items":["fnames(1)","fnames(2)","fnames(3)","fnames(4)","fnames(5)","fnames(6)","fnames(7)"],"itemsVariable":"fnames","label":"Drop down","run":"Section"}
%---
%[control:dropdown:5491]
%   data: {"defaultValue":"fnames(1)","itemLabels":["CTACardio Crop segmentation.seg.nrrd","CTACardio Crop.nrrd","CTACardio.nrrd","Lung segmentation preview.seg.nrrd","Lung segmentation.seg.nrrd","Resampled Volume.nrrd","Salcedo Segmentation.seg.nrrd"],"items":["fnames(1)","fnames(2)","fnames(3)","fnames(4)","fnames(5)","fnames(6)","fnames(7)"],"itemsVariable":"fnames","label":"Drop down","run":"Section"}
%---
