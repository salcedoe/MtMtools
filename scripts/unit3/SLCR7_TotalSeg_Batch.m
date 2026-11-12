%[text] # Kidneys and Femurs of Ten Donors
%[text] In SLCR5 and SLCR6, the whole class segmented **one** body, and we asked how closely we agreed. In this exercise, we turn it around: one tool, **TotalSegmentator**, segments **ten** bodies, and we ask how the bodies differ.
%[text] The scans come from a research project in our anatomy lab: CT scans of donors to the University of Colorado anatomical donation program, taken before dissection. We use ten of them: five women and five men, 56 to 97 years old. With the course function **mmTotalSegmentator**, we segment the femurs and the kidneys of every donor in one batch, measure them, collect the measurements in one tidy table, and then answer four questions:
%[text] 1. **Are the left and right organs the same size?**
%[text] 2. **Do women and men differ?**
%[text] 3. **Do the kidneys get smaller with age?**
%[text] 4. **How tall were the donors?** \
%[text] **Before you start:** mmTotalSegmentator uses the copy of TotalSegmentator that is installed in 3D Slicer. Install 3D Slicer and its TotalSegmentator extension, and run TotalSegmentator once in Slicer (this downloads the AI models). If TotalSegmentator doesn't run on your computer, you can still do the whole exercise with the segmentations we provide (see **Setup**).
%[text] The functions that measure and plot the organs are at the end of this script, under **Local functions**.
%[text:tableOfContents]{"heading":"Table of Contents"}
close all hidden
clearvars
warning("off", "medical:medicalVolume:noEndian") % Slicer's NRRD files trigger a harmless warning
%%
%[text] ## Setup
%[text] ### Example: Segment Liver in CTACardio
%[text] First, though, let's revisit the CTACardio project we've been working on. When prompted, choose the CTACardio Cropped Intensity file (or whichever intensity file you happen to have)
[file,location] = uigetfile(fullfile(userpath,".nrrd"));
scanFile = fullfile(location, file);
structures = "liver";
segFile = fullfile(location,"Liver segmentation.seg.nrrd")
%%
%[text] **Run** **`mmTotalSegmentator`**
tic
mmTotalSegmentator(scanFile, Structures=structures, OutputFile=segFile); % saves the segmentation file
seconds = toc
%%
intMV = medicalVolume(scanFile); % ct intensity file
segMV = medicalVolume(segFile); % liver segmentation
hvwr = viewer3d(BackgroundColor='white',BackgroundGradient='off');
hvs = volshow(intMV,parent = hvwr,OverlayData= segMV.Voxels,RenderingStyle="GradientOpacity");
hvs.OverlayAlpha = single(0.5); % opacity of segmentations
hvs.Alphamap = single(linspace(0,0.5,256)); % adjust intensity alpha values - not the low values
%%
%[text] ## Example: Batch run cadaveric tissue
%[text] ### Setup: First, create a project folder
%[text] TotalSegmentator writes one segmentation file for every scan. These files need a folder of their own (where you have file write privileges). So, each of you need **your own folder** to store your own TotalSegmentator files. And please **don't** save anything in the shared class folder (SlicerDropbox), or you'll make a mess of things. Everyone will be using that SlicerDropbox folder to load the Intensity files, so please don't add, change, or delete any files there
%[text] To begin, create a new, empty folder, for example **TotalSeg\_Batch** using the Live Script control below.
%[text] If you do this right, you will 1) Set the `projectFolder`, and 2) The function `checkProjectFolder` will create a new subfolder inside the `projectFolder`, called **`segmentations`**. That's where everything will be stored. 
clearvars
cd(userpath)
projectFolder = "/Users/ernesto/Desktop/TotalSeg" % TotalSegBatch %[control:filebrowser:87c3]{"position":[17,50]}
segFolder = checkProjectFolder(projectFolder) % Checks folder/ adds subfolder
%%
%[text] ### Next: Find the scans
%[text] The ten scans are in the shared class folder: MATLAB Drive / SlicerDropbox / TotalSegDemo. Each file is named after the donor ID, for example "TS27 Body.nrrd". The wildcard **\*** in "TS\* Body.nrrd" matches any text. Then **matches** keeps only the names that are exactly "TS", two digits, and " Body.nrrd", so we find only the ten scans, even if someone saved other files in the folder (like "TS27 Body copy.nrrd"). The ID ("TS27") is the part of the name before " Body":
scanFolder = fullfile(matlabdrive, "SlicerDropbox", "TotalSegDemo"); % path to the MATLAB drive folder
scanFiles = dir(fullfile(scanFolder, "TS* Body.nrrd")); % only files ending in .nrrd
scanFiles = scanFiles(matches({scanFiles.name}, "TS" + digitsPattern(2) + " Body.nrrd")); % only the original scans
numScans = numel(scanFiles)
IDs = string(extractBefore({scanFiles.name}', " Body")) % "TS27 Body.nrrd" -> "TS27"
%[text] The local function **checkScans** checks that every scan is there, and that its size (in bytes) hasn't changed. If a scan is missing or damaged, it tells you which one, so that you can let your instructor know:
checkScans(scanFiles)
%%
%[text] The file **TotalSegDemoDonors.csv** has the sex and age of each donor:
donorT = readtable(fullfile(scanFolder, "TotalSegDemoDonors.csv"), TextType="string"); % load the table
donorT.Sex = categorical(donorT.Sex, ["F" "M"])
%[text] - These scans are whole-body CT scans: each one is about 512 × 512 × 600 voxels. Their voxels are about 1 mm wide, but **3 mm** thick. Keep this in mind when you look at the lengths: a length along the body can't be more precise than a few mm \
%%
%[text] ## Segment one scan
%[text] Before we segment all ten scans, we segment **one**, and check the result. With `Structures`, TotalSegmentator segments only the four structures we need, instead of all 117. This is faster, because it first crops the CT to the region of these structures. 
k = 1; % the first scan
scanFile = fullfile(scanFiles(k).folder, scanFiles(k).name);
segFile = fullfile(segFolder, IDs(k) + " segmentation.seg.nrrd");

structures = ["right femur" "left femur" "right kidney" "left kidney"]; % the structures we want to segment
    tic
    mmTotalSegmentator(scanFile, Structures=structures, OutputFile=segFile); % saves the segmentation file
    seconds = toc

segT = mmGetSlicerSegmentInfo(segFile)
%[text] **plotOrgans** plots the surfaces of the four structures of a segmentation file:
plotOrgans(segFile, IDs(k))
%[text] - Did TotalSegmentator find all four structures?
%[text] - The segmentation file stores the same segment names and colors as the TotalSegmentator module in Slicer. Open the scan and the segmentation file in Slicer: does the segmentation line up with the scan? \
%%
%[text] #### Did that work?
%[text] Or Did it take too long?
%[text] TotalSegmentator should take about a minute per scan on a computer with a GPU (a Mac with Apple silicon, or a computer with an NVIDIA graphics card), and several minutes per scan without one. If you feel like this is not going to work on your computer, you can toggle the check below to use the segmentations we already generated before the show. 
useCourseExamples = false; % true: use the segmentations that we provide %[control:checkbox:0666]{"position":[21,26]}
if useCourseExamples
    segFolder = fullfile(scanFolder, "segmentations");%#ok<UNRCH>
end
%%
%[text] ## Segment every scan
%[text] Now the batch. As in the SynthSeg exercise, the **for** loop runs the same steps once for each scan:
%[text] 1. Build the name of the output file from the ID of the donor
%[text] 2. If the output file already exists, skip the scan. This way, if you run the section again (or use our segmentations), you don't redo the work
%[text] 3. Otherwise, run TotalSegmentator, inside a **try/catch** block, so that one failed scan doesn't stop the whole batch
%[text] 4. Record what happened in a log \
%[text] Notice how we create the log: `strings(numScans, 1)` and `nan(numScans, 1)` make columns with one row per scan **before** the loop. This is called **preallocation**. Inside the loop, we only fill in row `k`.
%[text] Without a GPU, this section can take half an hour or more.
status = strings(numScans, 1); % one row per scan
runTime = nan(numScans, 1);
errorMessage = strings(numScans, 1);
for k = 1:numScans
    scanFile = fullfile(scanFiles(k).folder, scanFiles(k).name);
    segFile = fullfile(segFolder, IDs(k) + " segmentation.seg.nrrd");
    fprintf("Scan %d of %d: %s\n", k, numScans, IDs(k))
    if isfile(segFile)
        status(k) = "skipped (already done)";
        continue % go straight to the next scan
    end
    try
        tic
        mmTotalSegmentator(scanFile, Structures=structures, OutputFile=segFile, Verbose=false);
        runTime(k) = toc; % seconds
        status(k) = "done";
    catch err
        status(k) = "failed";
        errorMessage(k) = err.message; % save the error, and keep going
    end
end
batchLog = table(IDs, status, runTime, errorMessage, VariableNames=["ID" "Status" "Seconds" "ErrorMessage"])
%[text] - Did any scan fail? If so, read the error message, fix the problem, and run the section again. Only the failed scans will run \
%%
%[text] ## Look at every segmentation
%[text] "Done" in the log only means that TotalSegmentator didn't crash. It doesn't mean the segmentation is right. So we look at all of them, side by side:
tiledlayout("flow", TileSpacing="tight")
for k = 1:numScans
    nexttile
    plotOrgans(fullfile(segFolder, IDs(k) + " segmentation.seg.nrrd"), IDs(k))
end
%[text] - Does every donor have two femurs and two kidneys? Does any structure look broken, or much too small?
%[text] - Look for tiny specks far from the organs. These are a few stray voxels that TotalSegmentator labeled as femur or kidney. How would they change the **length** of a femur, if we measured from end to end? (This is why measureOrgans keeps only the largest connected piece)
%[text] - The kidneys of an older person are often smaller, and can have cysts. TotalSegmentator labels kidney cysts as a separate structure (which we didn't ask for), so a large cyst can leave a hole in a kidney \
%%
%[text] ## Measure every organ
%[text] The local function **measureOrgans** loads one segmentation file and measures each of the four structures. It returns a 4-row table: one row per organ and side, with the **volume** (mL) and the **length** (mm, along the long axis of the structure, with mmAlignSurface2Axes, as in SLCR4). Before it measures, it keeps only the largest connected piece of each structure, so that a few stray voxels far away don't change the length.
%[text] To collect the measurements of all ten donors, we build the table row by row, as in SLCR5 and SLCR6:
%[text] - `organT = table()` starts with an empty table
%[text] - Inside the loop, `organT = [organT; newRows]` adds the 4 rows of donor `k` at the bottom: the semicolon stacks tables **on top of each other**
%[text] - If a file fails, try/catch prints a warning and skips it, so its rows are simply missing \
organT = table(); % start with an empty table
for k = 1:numScans
    segFile = fullfile(segFolder, IDs(k) + " segmentation.seg.nrrd");
    try
        newRows = measureOrgans(segFile, IDs(k));
        organT = [organT; newRows]; %#ok<AGROW> % add the rows at the bottom
    catch err
        warning("%s: %s", IDs(k), err.message) % skip this file
    end
end
organT = join(organT, donorT, Keys="ID") % add the sex and age of each donor
%[text] `organT` is a **tidy** table: one row per organ (one organ of one donor), and one column per variable. **join** added the Sex and Age columns, by matching the ID of each row with the ID in `donorT`.
%[text] - How many rows does `organT` have? Why?
%[text] - Adult kidneys are usually 10–12 cm long, and adult femurs 40–50 cm. Do these numbers make sense? \
%%
%[text] ## Look at the measurements
%[text] As always, we look at the data before we summarize it. **mmBoxSwarm** plots a box plot with one dot per organ:
tiledlayout(1, 2)
nexttile
isFemur = organT.Organ == "Femur";
mmBoxSwarm(organT.Side(isFemur), organT.Length_mm(isFemur));
ylabel("Length (mm)")
title("Femur length")
nexttile
isKidney = organT.Organ == "Kidney";
mmBoxSwarm(organT.Side(isKidney), organT.Volume_mL(isKidney));
ylabel("Volume (mL)")
title("Kidney volume")
%[text] - Is there a dot far away from the others? Which donor is it? (Hint: `sortrows(organT(isKidney, :), "Volume_mL")`)
%[text] - For the femur we plot the length, and for the kidney the volume. Why do you think we chose these? \
%%
%[text] ## Are the left and right organs the same size?
%[text] To compare the two sides of each donor, we need one row per **donor**, with a column for each side. **unstack** turns the tidy table into a **wide** table. We do it once for the femur length, and once for the kidney volume:
femurW = unstack(organT(isFemur, ["ID" "Sex" "Side" "Length_mm"]), "Length_mm", "Side");
kidneyW = unstack(organT(isKidney, ["ID" "Sex" "Side" "Volume_mL"]), "Volume_mL", "Side");
femurW.Difference_mm = femurW.Left - femurW.Right;
kidneyW.Difference_mL = kidneyW.Left - kidneyW.Right;
kidneyW
%[text] For each organ, we summarize the left − right differences: the mean difference, the mean difference as a percentage of the mean size, how many donors have a larger **left** organ, and the p-value of the **signrank** test (the Wilcoxon signed-rank test: is the median difference 0?):
dFemur = femurW.Difference_mm;
dKidney = kidneyW.Difference_mL;
sideT = table(["Femur length (mm)"; "Kidney volume (mL)"], ...
    [mean(dFemur); mean(dKidney)], ...
    100 * [mean(dFemur) / mean([femurW.Left; femurW.Right]); mean(dKidney) / mean([kidneyW.Left; kidneyW.Right])], ...
    [nnz(dFemur > 0); nnz(dKidney > 0)], ...
    [numel(dFemur); numel(dKidney)], ...
    [signrank(dFemur); signrank(dKidney)], ...
    VariableNames=["Measure" "MeanDifference" "MeanDifference_pct" "NumLeftLarger" "NumDonors" "pValue"])
%[text] - Are the two femurs of a person the same length? How big is the difference, compared with the 3-mm thickness of the voxels?
%[text] - Is one kidney usually larger? Which one? The right kidney sits just below the liver. Can you think of a reason why it might be the smaller one?
%[text] - With 10 donors, the smallest possible p-value of the signrank test is 0.002: you get it when all ten differences have the same sign. Remember from SLCR6: a small p-value tells you that the difference is **consistent**, not that it is **large** \
%%
%[text] ## Do women and men differ?
%[text] Now we compare people, not sides. First, we average the two sides of each donor, with **groupsummary**: one row per donor and organ.
donorOrganT = groupsummary(organT, ["ID" "Sex" "Age" "Organ"], "mean", ["Length_mm" "Volume_mL"])
%[text] The **ranksum** test (the Wilcoxon rank-sum test, or Mann-Whitney U test) compares two **independent** groups: here, five women and five men. (signrank compares two measurements of the **same** person.)
isF = donorOrganT.Organ == "Femur";
isK = donorOrganT.Organ == "Kidney";
femurF = donorOrganT.mean_Length_mm(isF & donorOrganT.Sex == "F");
femurM = donorOrganT.mean_Length_mm(isF & donorOrganT.Sex == "M");
kidneyF = donorOrganT.mean_Volume_mL(isK & donorOrganT.Sex == "F");
kidneyM = donorOrganT.mean_Volume_mL(isK & donorOrganT.Sex == "M");
sexT = table(["Femur length (mm)"; "Kidney volume (mL)"], ...
    [median(femurF); median(kidneyF)], [median(femurM); median(kidneyM)], ...
    [ranksum(femurF, femurM); ranksum(kidneyF, kidneyM)], ...
    VariableNames=["Measure" "MedianWomen" "MedianMen" "pValue"])
tiledlayout(1, 2)
nexttile
mmBoxSwarm(donorOrganT.Sex(isF), donorOrganT.mean_Length_mm(isF));
ylabel("Mean femur length (mm)")
title("Femur")
nexttile
mmBoxSwarm(donorOrganT.Sex(isK), donorOrganT.mean_Volume_mL(isK));
ylabel("Mean kidney volume (mL)")
title("Kidney")
%[text] - How much longer are the men's femurs, in mm and in %?
%[text] - Do the kidneys differ as clearly as the femurs? Look at the overlap of the two groups in the plot
%[text] - With 5 people in each group, the smallest possible p-value of ranksum is 0.008: you get it when all five men are larger than all five women. Why is it hard to show a difference with groups this small? \
%%
%[text] ## Do the kidneys get smaller with age?
%[text] In older adults, the kidneys slowly lose tissue. Our donors were 56 to 97 years old. Do the older donors have smaller kidneys? We plot the mean kidney volume of each donor against age, with a different color for women and men:
figure
kT = donorOrganT(isK, :);
gscatter(kT.Age, kT.mean_Volume_mL, kT.Sex, [], "o", 8, "filled")
xlabel("Age (years)")
ylabel("Mean kidney volume (mL)")
title("Kidney volume and age")
%[text] The **Spearman correlation** measures how well the two variables rise or fall together. It goes from −1 (the older the donor, the smaller the kidneys, without exception) to +1:
[rho, pAge] = corr(kT.Age, kT.mean_Volume_mL, Type="Spearman")
%[text] - Do the older donors have smaller kidneys? How strong is the correlation?
%[text] - Men are usually larger than women, and have larger kidneys. Could the mix of women and men hide (or create) an effect of age? Look at the colors in the plot
%[text] - Kidneys also change after death, and with embalming. Would that affect all the donors in the same way? \
%%
%[text] ## How tall were the donors?
%[text] As in SLCR6, we estimate height from the length of the femur, with the formulas of Trotter and Gleser (1952). This time we have both sexes, so we need both formulas:
%[text]{"align":"center"} $ \\textrm{women: height (cm)}=2\\ldotp 47\\times \\textrm{femur (cm)}+54\\ldotp 10\\quad (\\pm 3\\ldotp 7\\textrm{ cm}) $
%[text]{"align":"center"} $ \\textrm{men: height (cm)}=2\\ldotp 38\\times \\textrm{femur (cm)}+61\\ldotp 41\\quad (\\pm 3\\ldotp 3\\textrm{ cm}) $
%[text] These formulas give the height of a young adult. We all get shorter with age (the discs between our vertebrae get thinner), so Trotter and Gleser suggested to subtract 0.06 cm for every year over 30. We use the mean length of the two femurs of each donor:
heightT = donorOrganT(isF, ["ID" "Sex" "Age" "mean_Length_mm"]);
femur_cm = heightT.mean_Length_mm / 10;
isMan = heightT.Sex == "M";
heightT.Height_cm(~isMan) = 2.47 * femur_cm(~isMan) + 54.10;
heightT.Height_cm(isMan) = 2.38 * femur_cm(isMan) + 61.41;
heightT.HeightAtDeath_cm = heightT.Height_cm - 0.06 * (heightT.Age - 30)
%[text] - What were the shortest and the tallest donors? Does the range look reasonable for older Americans?
%[text] - How much did the age correction change the estimate for the oldest donor?
%[text] - The formulas were made with the "maximum length" of dry bones. Our length, along the long axis of a segmentation with 3-mm thick voxels, is close to it, but not the same. How much would a 3-mm error in the femur length change the height? \
%%
%[text] ## Check your understanding
%[text] 1. Why did we segment and check **one** scan before we ran the batch? Why did we look at every segmentation before we measured?
%[text] 2. Why is each file inside a try/catch? If one segmentation file can't be read, what happens to the loop, and to `organT`?
%[text] 3. Why did we use **signrank** to compare the left and right sides, but **ranksum** to compare women and men?
%[text] 4. In SLCR6, ten raters measured one femur. Here, one tool measured twenty femurs. What kind of question can each design answer? \
%%
%[text] # Local functions
%[text] These functions use functions from the course toolbox (MtMtoolbox).
function segFolder = checkProjectFolder(folder)
% Stop with a clear error if the folder is a shared class folder
% (MtMresources or SlicerDropbox), or if we can't save files in it

if strlength(folder)==0
    error("No folder selected. Run this section again and select your project folder.")
end

if contains(folder, ["MtMresources" "SlicerDropbox"])
    error("This folder is inside a shared class folder (MtMresources or SlicerDropbox). " + ...
        "Run this section again and choose a folder of your own, for example in your Documents folder.")
end

if ~exist(folder,"dir")
    error("This folder doesn't exist: %s\nRun this section again and select an existing folder, or create a new one.", folder)
end

testFile = fullfile(folder, "write_test.tmp");
fid = fopen(testFile, "w"); % try to create a small file
if fid == -1
    error("You can't save files in this folder: %s\nRun this section again and choose a different folder, for example in your Documents folder.", folder)
end
fclose(fid);
delete(testFile)

segFolder = fullfile(folder, "segmentations"); % new folder where your TotalSegmentator output will go
if ~isfolder(segFolder)
    mkdir(segFolder); % create the folder if it doesn't exist
    fprintf("Adding new folder: %s\n", segFolder)
end
disp("projectFolder successfully setup.")
end


function checkScans(scanFiles)
% Check that all ten scans are there, with their original size in bytes.
% Warns about any scan that is missing or has a different size
expected = table(["TS27"; "TS30"; "TS31"; "TS35"; "TS39"; "TS40"; "TS42"; "TS46"; "TS50"; "TS53"], ...
    [107775222; 99342229; 111621211; 140617847; 134091046; 129823023; 133053302; 130546614; 132566763; 121876781], ...
    VariableNames=["ID" "Bytes"]);
found = string(extractBefore({scanFiles.name}', " Body"));
ok = true;
for n = 1:height(expected)
    k = find(found == expected.ID(n));
    if isempty(k)
        warning("The scan of %s is missing. Let your instructor know.", expected.ID(n))
        ok = false;
    elseif scanFiles(k).bytes ~= expected.Bytes(n)
        warning("The scan of %s has changed (%d bytes instead of %d). Let your instructor know.", ...
            expected.ID(n), scanFiles(k).bytes, expected.Bytes(n))
        ok = false;
    end
end
if ok
    disp("All 10 scans are there, and unchanged.")
end
end


function T = measureOrgans(segFile, id)
% Measure the right and left femur and the right and left kidney of a
% TotalSegmentator segmentation file. Returns a tidy table with one row per
% organ and side:
%   Volume_mL: number of voxels x the volume of one voxel
%   Length_mm: the length along the long axis of the structure
% Keeps only the largest connected piece of each structure
warning("off", "medical:medicalVolume:noEndian")
mv = medicalVolume(segFile);
st = mmGetSlicerSegmentInfo(segFile);
organs = ["Femur" "Femur" "Kidney" "Kidney"];
sides = ["Right" "Left" "Right" "Left"];
volume = nan(4, 1); % preallocate one row per structure
len = nan(4, 1);
for n = 1:4
    segName = lower(sides(n) + " " + organs(n)); % for example "right femur"
    if ~any(st.SegName == segName)
        warning("%s: no ""%s"" segment", id, segName)
        continue
    end
    seg = mmGetMedicalVolumeSegment(mv, st, segName=segName);
    mask = largestComponent(seg.mask);
    volume(n) = nnz(mask) * abs(det(seg.tform.A(1:3, 1:3))) / 1000; % mL
    fv = mmGetSurface(mask, transform=seg.tform); % surface in mm
    verts = mmAlignSurface2Axes(fv.vertices - mean(fv.vertices)); % center, and align the long axis with x
    len(n) = range(verts(:, 1));
end
T = table(repmat(string(id), 4, 1), categorical(organs', ["Femur" "Kidney"]), categorical(sides', ["Right" "Left"]), ...
    volume, len, VariableNames=["ID" "Organ" "Side" "Volume_mL" "Length_mm"]);
end


function plotOrgans(segFile, titleText)
% Plot the surfaces of the femurs and kidneys of a segmentation file, in
% patient coordinates (mm), seen from the front
warning("off", "medical:medicalVolume:noEndian")
mv = medicalVolume(segFile);
st = mmGetSlicerSegmentInfo(segFile);
for segName = ["right femur" "left femur" "right kidney" "left kidney"]
    if any(st.SegName == segName)
        seg = mmGetMedicalVolumeSegment(mv, st, segName=segName);
        fv = mmGetSurface(seg.mask, transform=seg.tform);
        mmPlotSurface(fv, seg.color, 1);
        hold on
    end
end
hold off
mmSetSurfacePlotProps;
view(0, 0) % from the front (in LPS, the patient's left is on the right of the plot)
axis off
title(titleText)
end


function mask = largestComponent(mask)
% Keep only the largest connected piece of a mask
CC = bwconncomp(mask, 26);
if CC.NumObjects == 0
    return
end
[~, big] = max(cellfun(@numel, CC.PixelIdxList));
mask = false(size(mask));
mask(CC.PixelIdxList{big}) = true;
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[control:filebrowser:87c3]
%   data: {"browserType":"Folder","defaultValue":"\"\"","label":"Choose a Batch Folder","run":"Section"}
%---
%[control:checkbox:0666]
%   data: {"defaultValue":false,"label":"useProvided","run":"Section"}
%---
