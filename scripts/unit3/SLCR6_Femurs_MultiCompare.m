%[text] # Femur Compare
%[text] In the [Femur Segmentation exercise](https://salcedoe.github.io/MtMdocs/slicer/CTFemurSegment_9553F/), everyone in the class segmented the femurs of the same cadaver: 9553F, an older woman with a total knee replacement in her left knee. In this exercise, we analyze the segmentations of the whole class, step by step. We find everyone's files, measure each femur, collect the measurements in a table, check them, and then answer three questions:
%[text] 1. **How closely do we agree?** If ten people segment the same femur, how far apart are their measurements?
%[text] 2. **Is the left femur really different from the right?**
%[text] 3. **How tall was she?** And how much does our disagreement change the answer? \
%[text] Be sure to upload your segmentation ("LastName Segmentation.seg.nrrd") to the class folder: MATLAB Drive / SlicerDropbox / Femurs
%[text] ## The natural experiment
%[text] Our class data has a built-in experiment. Everyone used the same scan, the same ROI file (PelvisFemurROI), and the same Crop Volume settings. But the two femurs were made differently:
%[text] - **The right femur** was made by TotalSegmentator, and then smoothed. Nobody edited it by hand
%[text] - **The left femur** was also made by TotalSegmentator, but then everyone cleaned it up by hand at the implant: a Boolean subtraction, a slice cut at the base of the femur, the Islands tool, and the Scissors \
%[text] So, when our measurements disagree, we can ask **which part of the workflow caused the disagreement**: the automatic tool, or the hand editing?
%[text] The functions that load and measure the femurs are at the end of this script, under **Local functions**. You don't need to change them, but read their descriptions: they tell you exactly what each one measures.
%[text:tableOfContents]{"heading":"Table of Contents"}
close all hidden
clearvars
warning("off", "medical:medicalVolume:noEndian") % Slicer's NRRD files trigger a harmless warning
%%
%[text] ## Find the class files
%[text] The function **mmGetSlicerSegmentInfoAll** loads the metadata of every segmentation file (.seg.nrrd) in a folder:
paths.folder = fullfile(matlabdrive, "SlicerDropbox", "Femurs"); % the shared folder with the .seg.nrrd files
[segT, contentT] = mmGetSlicerSegmentInfoAll(paths.folder);
%[text] The function returns two tables:
%[text] - `segT`: one row per segment of every file (SegName, LabelValue, Color, ...)
%[text] - `contentT`: one row per file, with the size of its volume (VolSize) and its voxel size (PixelSpacing) \
%[text] Most of you named your file "LastName Segmentation.seg.nrrd", but not everyone put a space before "Segmentation". The local function **studentName** finds the last name either way:
contentT.StudentLastName = studentName(contentT.name); % add last name column to table
contentT(:, ["ID" "StudentLastName" "name" "VolSize" "PixelSpacing"]) % show a subset of the rows
%[text] - Everyone used the same ROI and the same Crop Volume settings. Did everyone get the same voxel size (PixelSpacing)? If not, which Crop Volume setting do you think was different? (Hint: look for a voxel size that isn't the same in all three directions) \
%%
%[text] ### Check the segment names
groupsummary(segT, "SegName")
%[text] - Did everyone use the same segment names? A computer sees "Right Femur" and "right femur" as different names. Our local functions ignore upper and lower case, and accept "Implant" or "femoral implant" for the femoral implant \
%%
%[text] ## Measure one femur
%[text] Before we measure all the femurs, we measure **one**, and check that the result makes sense. Problems are much easier to find in one femur than inside a loop over twenty.
%[text] - **loadFemur**(file, side) loads the "right" or "left" femur of a segmentation file. It checks the position of the two femurs: if their labels were swapped, it swaps them back and tells you
%[text] - **plotFemur** plots the femur upright, so we can check it by eye
%[text] - **measureFemur** measures the femur on its own voxel grid: its **length** along its long axis (with mmAlignSurface2Axes, as in SLCR4), its **shaft diameter** at the middle of the femur (with mmCrossSectionProfile), and its **volume** (the number of voxels × the volume of one voxel) \
k = 1; % the first file
side = "right";
file = fullfile(contentT.folder(k), contentT.name(k));
seg = loadFemur(file, side);
plotFemur(seg, contentT.StudentLastName(k) + ", " + side)
oneT = [table(contentT.StudentLastName(k), side, VariableNames=["StudentLastName" "Side"]), measureFemur(seg)]
%[text] The square brackets join two tables side by side: a table with the name and the side, and the table of measurements from measureFemur.
%[text] - Most adult femurs are 40-50 cm long, and their shaft is about 2.5-3 cm wide. Do these numbers make sense?
%[text] - Change `side` to "left" and run the section again. How does the left femur look different? Why is it shorter? \
%%
%[text] ## Measure every femur
%[text] Now we measure both femurs of every student, and collect the measurements in a **tidy** table, `femurT`: one row per femur (one femur of one student), and one column per variable (StudentLastName, Side, Length\_mm, ShaftDiameter\_mm, Volume\_mL). With 10 students, `femurT` has 20 rows. Tidy tables are easy to group, summarize, and plot.
%[text] How the loop works:
%[text] - `femurT = table()` starts with an empty table
%[text] - `newRow` is the 1-row table of one femur, built as in the section above: the comma in `[table(...), measureFemur(seg)]` joins two tables **side by side**
%[text] - `femurT = [femurT; newRow]` adds the new row at the bottom: the semicolon stacks tables **on top of each other**
%[text] - `try ... catch`: if a file has a problem (for example, a missing femur), MATLAB jumps to `catch`, prints a warning, and goes on with the next femur, instead of stopping the whole loop \
%[text] This takes a minute or two.
femurT = table(); % start with an empty table

for k = 1:height(contentT)
    file = fullfile(contentT.folder(k), contentT.name(k));
    for side = ["Right" "Left"]
        try
            seg = loadFemur(file, side);
            newRow = [table(contentT.StudentLastName(k), side, VariableNames=["StudentLastName" "Side"]), measureFemur(seg)];
            femurT = [femurT; newRow]; %#ok<AGROW> % add the row at the bottom (this copies the table each time: fine for 20 rows, but preallocate for thousands)
        catch err
            warning("%s, %s femur: %s", contentT.StudentLastName(k), side, err.message)
        end
    end
end
femurT.Side = categorical(femurT.Side, ["Right" "Left"]) % Right first in plots and tables
%[text] - Did loadFemur swap anyone's labels? Did any file produce a warning? What was the problem?
%[text] - Is any ShaftDiameter\_mm missing (NaN)? Read the message that measureFemur printed. Why can't we measure the diameter of that femur? \
%%
%[text] ## Look for mistakes
%[text] Before we summarize the measurements, we look for mistakes. A mistake left in the data inflates the spread between raters, and then our summary describes the mistake, not the raters.
%[text] ### Plot the measurements
%[text] **mmBoxSwarm** plots a box plot with one dot per femur:
measures = ["Length_mm" "ShaftDiameter_mm" "Volume_mL"];
figure
tiledlayout("flow")
for m = measures
    nexttile
    mmBoxSwarm(femurT.Side, femurT.(m));
    title(replace(m, "_", " (") + ")") % "Length_mm" -> "Length (mm)"
end
%[text] - Which side has more spread? Is there a dot far away from all the others? \
%%
%[text] ### Find the outliers
%[text] Sort the left femurs by volume, from the largest to the smallest:
leftT = femurT(femurT.Side == "Left", :);
sortrows(leftT, "Volume_mL", "descend")
%[text] Now look at all the left femurs side by side. Does one look different?
figure
tiledlayout("flow", TileSpacing="tight")
for k = 1:height(contentT)
    nexttile
    try
        plotFemur(loadFemur(fullfile(contentT.folder(k), contentT.name(k)), "left"), contentT.StudentLastName(k))
    catch err
        title(contentT.StudentLastName(k) + ": " + err.message)
    end
end
%%
%[text] ### Decide what to exclude
%[text] An outlier isn't always a mistake. Only exclude a measurement when you can explain **what went wrong** in the segmentation. For example, a left femur that was never cleaned up at the implant isn't a measurement of the femur at all: it includes the bone that TotalSegmentator guessed inside and below the implant.
%[text] Enter the names of the students whose **left** femur should be excluded, and write the reason in the comment. If there are none, use `strings(0)` (an empty list).
excludeLeft = strings(0); % for example ["Name1" "Name2"]. Why?
femurT(ismember(femurT.StudentLastName, excludeLeft) & femurT.Side == "Left", :) = [];
%[text] - Whose left femur did you exclude, and why?
%[text] - We removed only the **left** femur of these students. Why not their right femur, too? \
%%
%[text] ## How closely do we agree?
%[text] Think of ten people measuring the same table with a tape measure. They won't all get exactly the same number. The question is how far apart their numbers are, and whether that matters.
%[text] ### Why not the ICC?
%[text] The statistic you will see most often in papers is the **intraclass correlation coefficient** (ICC). The ICC asks: are the raters' differences small **compared with the differences between subjects**? To calculate it, the raters must measure many different subjects (for example, the femurs of 30 patients). We all measured the same two femurs, so we can't calculate a meaningful ICC. Instead, we describe the disagreement between raters directly.
%[text] ### Three ways to describe the disagreement
%[text] For each femur and each measurement, we calculate:
%[text] 1. **SD** (standard deviation): how far a typical rater is from the class average. About two-thirds of the raters are within ±1 SD of the average. The SD is in the units of the measurement (mm or mL)
%[text] 2. **CV** (coefficient of variation): the SD as a **percentage** of the average, 100 × SD / mean. A 5-mm SD is small for a 500-mm femur (1%), but it would be huge for a 25-mm shaft (20%). Because the CV has no units, we can compare lengths (mm) with volumes (mL). As a rule of thumb, a CV below 5% means good agreement, and above 10% poor agreement
%[text] 3. **RC** (reproducibility coefficient): the answer to the question "if a classmate and I both measure this femur, how far apart could our numbers be?" Two raters' measurements differ by less than the RC 95% of the time. The RC is $ 1\\ldotp 96\\times \\sqrt{2}\\times SD $: the difference between two raters varies more than one rater does (by a factor of $ \\sqrt{2} $), and 95% of the values of a normal distribution are within 1.96 SD of the mean \
%[text] "omitnan" skips the missing values (NaN):
reliabilityT = table();
for side = ["Right" "Left"]
    for m = measures
        x = femurT.(m)(femurT.Side == side); % all the raters' measurements of this side
        avg = mean(x, "omitnan");
        SD = std(x, "omitnan");
        reliabilityT = [reliabilityT; table(side, m, avg, SD, 100 * SD / avg, 1.96 * sqrt(2) * SD, ...
            VariableNames=["Side" "Measure" "Mean" "SD" "CV_pct" "RC"])]; %#ok<AGROW>
    end
end
reliabilityT
%%
%[text] ### Read one row of the table
%[text] Here is the first row (the length of the right femur) in words:
r = reliabilityT(1, :);
disp(compose("The average length of the right femur is %.1f mm. A typical rater is within %.2f mm of the average (SD). " + ...
    "That is %.2f%% of the length (CV). Two raters will usually (95%% of the time) differ by less than %.2f mm (RC).", ...
    r.Mean, r.SD, r.CV_pct, r.RC))
%%
%[text] ### Compare the two femurs
%[text] The CV puts all the measurements on one scale:
figure
cvRight = reliabilityT.CV_pct(reliabilityT.Side == "Right");
cvLeft = reliabilityT.CV_pct(reliabilityT.Side == "Left");
b = bar(categorical(measures, measures), [cvRight cvLeft]);
legend(b, ["Right femur (automatic)" "Left femur (edited by hand)"], Location="northwest", AutoUpdate="off")
yline([5 10], "--", ["good" "poor"])
ylim([0 max([12; cvRight; cvLeft])])
ylabel("CV between raters (%)")
title("How much do the raters disagree?")
%[text] - Which femur do the raters agree on better? Which part of the workflow adds most of the disagreement?
%[text] - Nobody edited the right femur by hand. Why don't all the right femurs have exactly the same measurements? (Hint: look at the voxel sizes at the start of this script, and think about the smoothing)
%[text] - The length of the left femur varies more than its diameter. Which step of the cleanup decides the length? \
%%
%[text] ## Is the left femur really different?
%[text] In this section, we ask three questions:
%[text] 1. **Direction**: do the raters agree on which femur is longer?
%[text] 2. **Consistency**: is that agreement more than we would expect by chance?
%[text] 3. **Size**: is the left-right difference bigger than the disagreement between two raters (the RC)? \
%[text] To compare the two femurs of each student, we need one row per **student**, with a column for each side. **unstack** turns the tidy table into this **wide** table:
wideT = unstack(femurT(:, ["StudentLastName" "Side" "Length_mm"]), "Length_mm", "Side")
%[text] Then we calculate each student's left-right difference (left − right, so a negative difference means the right femur is longer), and:
%[text] - **NumRightLonger**: how many raters found the right femur longer (question 1)
%[text] - **pValue**: the **signrank** test (the Wilcoxon signed-rank test) tests whether the median difference is 0 (question 2). A small p-value means that the raters consistently find a difference in the same direction
%[text] - **RC\_mm**: the RC of the length of the left femur, the one edited by hand (question 3) \
d = wideT.Left - wideT.Right; % each student's left - right difference
rcRight = reliabilityT.RC(reliabilityT.Side == "Right" & reliabilityT.Measure == "Length_mm"); % RC of the right length
rcLeft = reliabilityT.RC(reliabilityT.Side == "Left" & reliabilityT.Measure == "Length_mm"); % RC of the left length
table(mean(d, "omitnan"), nnz(d < 0), nnz(~isnan(d)), signrank(d), rcLeft, ...
    VariableNames=["MeanDifference_mm" "NumRightLonger" "NumStudents" "pValue" "RC_mm"])
%%
%[text] ### Plot each student's two femurs
%[text] Each line is one student: it connects their right femur with their left femur. If all the lines slope the same way, the raters agree on the direction.
figure
plot([1 2], [wideT.Right wideT.Left]', "-o", Color=[0.5 0.5 0.5])
xlim([0.5 2.5])
xticks([1 2])
xticklabels(["Right" "Left"])
ylabel("Length (mm)")
title("Femur length")
%[text] - Do all the lines slope the same way? Is the difference bigger than the RC?
%[text] - Before you conclude that this woman had legs of different lengths: what happened to the lower end of her left femur? \
%%
%[text] ### Add the implant
%[text] During a total knee replacement, the surgeon saws off the lower end of the femur, and replaces it with the metal femoral implant. So our left femur segmentation is missing its lower end, and it **has** to be shorter. To compare the two legs fairly, we measure the left femur **together with** its implant: `loadFemur(file, "left", WithImplant=true)` combines the left femur and the femoral implant into one segmentation.
withImplant = nan(height(wideT), 1); % one length per student
for k = 1:height(contentT)
    name = contentT.StudentLastName(k);
    row = find(wideT.StudentLastName == name); % this student's row of wideT
    if isempty(row) || ismember(name, excludeLeft) % skip the excluded femurs
        continue
    end
    try
        seg = loadFemur(fullfile(contentT.folder(k), contentT.name(k)), "left", WithImplant=true);
        T = measureFemur(seg);
        withImplant(row) = T.Length_mm;
    catch err
        warning("%s: %s", name, err.message)
    end
end
wideT.LeftWithImplant = withImplant;
dImplant = wideT.LeftWithImplant - wideT.Right; % each student's (left + implant) - right difference
table(mean(dImplant, "omitnan"), nnz(dImplant < 0), nnz(~isnan(dImplant)), signrank(dImplant), rcLeft, ...
    VariableNames=["MeanDifference_mm" "NumRightLonger" "NumStudents" "pValue" "RC_mm"])
%[text] Plot the three lengths of each student:
figure
plot([1 2 3], [wideT.Right wideT.Left wideT.LeftWithImplant]', "-o", Color=[0.5 0.5 0.5])
xlim([0.5 3.5])
xticks(1:3)
xticklabels(["Right" "Left" "Left + implant"])
ylabel("Length (mm)")
title("Femur length, with and without the implant")
%[text] **Two things to know about these results:**
%[text] - **The p-value tells you about the direction, not the size.** With 8 raters, the smallest possible p-value of the signrank test is 0.008 (1 / 128); with 10 raters, it's 0.002. You get it whenever **all** the raters find a difference in the same direction, whether the difference is large or tiny. A small p-value means "the raters consistently see a difference", not "the difference is large"
%[text] - **A difference can be consistent but smaller than the RC.** Each rater measures both of their own femurs the same way. A rater who smooths a little more gets slightly different femurs on both sides, but the **difference** between their two femurs barely changes. (A tape measure that reads 1 cm too long makes both of your measurements too long, but not the difference between them.) So every rater can see the same small left-right difference, even though two raters disagree by more than that about each femur \
%[text] **Questions**:
%[text] - With the implant, how big is the left-right difference now? Compare it with the RC of the length
%[text] - Did anyone have no femoral implant segment? What happened to their row?
%[text] - All of these measurements come from one person. Can we conclude anything about left and right femurs **in general**? \
%%
%[text] ## How tall was she?
%[text] Forensic anthropologists estimate height from the length of the long bones. For women, Trotter and Gleser (1952) found:
%[text]{"align":"center"} $ \\textrm{height (cm)}=2\\ldotp 47\\times \\textrm{femur length (cm)}+54\\ldotp 10 $
%[text] The estimate has an error of about ±3.7 cm (the standard error of the formula), even with a perfect measurement. (Note: the formula uses the "maximum length" of the dry bone, measured on an osteometric board. Our length, along the long axis of the segmentation, is close to it, but not exactly the same.)
%[text] We use the average length of the right femur. Our lengths are in mm, so we divide by 10 to get cm:
rightLength_mm = mean(wideT.Right, "omitnan"); % the class average
height_cm = 2.47 * rightLength_mm / 10 + 54.10
%[text] How much does the estimate change between raters? Each student's own estimate:
heights_cm = 2.47 * wideT.Right / 10 + 54.10;
table(min(heights_cm), max(heights_cm), 2.47 * rcRight / 10, 2.47 * rcLeft / 10, ...
    VariableNames=["Lowest_cm" "Highest_cm" "HeightRC_RightFemur_cm" "HeightRC_LeftFemur_cm"])
%[text] The last two columns turn the RC of the length (mm) into an RC of the height (cm): with the formula, every mm of femur adds 0.247 cm of height. HeightRC\_RightFemur\_cm is how far apart two raters' height estimates could be, if they used the right femur. HeightRC\_LeftFemur\_cm is the same, if they had used the hand-edited left femur.
%[text] What if we had used the left femur, **without** its implant?
heightLeft_cm = 2.47 * mean(wideT.Left, "omitnan") / 10 + 54.10
%[text] **Questions**:
%[text] - How tall was she, in cm, and in feet and inches?
%[text] - How much do the estimates of different raters differ? Compare this with the ±3.7 cm error of the formula. Which source of error matters more?
%[text] - How much shorter is the estimate from the left femur without its implant? Why does this matter for a forensic case? \
%%
%[text] ## Check your understanding
%[text] 1. How closely did the class agree on the right femur? On the left femur? Use the CV and the RC, and explain what they mean in plain words
%[text] 2. Is the left femur different from the right? Explain the role of the implant
%[text] 3. How tall was she, and how sure are you?
%[text] 4. Why did we measure one femur before we measured all of them? Why did we look for mistakes before we summarized? \
%%
%[text] # Local functions
%[text] These functions use functions from the course toolbox (MtMtoolbox).
function name = studentName(fileName)
% The student's last name, from the name of a segmentation file:
% "Garcia Segmentation.seg.nrrd" -> "Garcia", "PatelSegmentation.seg.nrrd" -> "Patel"
name = extractBefore(string(fileName), ".seg.nrrd");
name = strtrim(erase(name, ["Segmentation" "segmentation" "_"]));
end


function seg = loadFemur(file, side, options)
% Load the right or left femur of a Slicer segmentation file
%   seg = loadFemur(file, "right")
%   seg = loadFemur(file, "left", WithImplant=true)
% Ignores upper and lower case in the segment names, and swaps the femurs
% back if their labels were swapped. With WithImplant=true, adds the femoral
% implant (a segment named "femoral implant" or "implant") to the femur.
% Returns a structure like mmGetMedicalVolumeSegment (fields mask, tform,
% spacing, segName, color)
arguments
    file {mustBeTextScalar}
    side {mustBeTextScalar}
    options.WithImplant (1,1) logical = false
end
side = lower(string(side));
if ~ismember(side, ["right" "left"])
    error("The side must be ""right"" or ""left"", not ""%s""", side)
end
warning("off", "medical:medicalVolume:noEndian")
mv = medicalVolume(file);
st = mmGetSlicerSegmentInfo(file);
st.SegName = lower(strtrim(st.SegName)); % "Right Femur" -> "right femur"
if ~all(ismember(["right femur" "left femur"], st.SegName))
    error("No ""right femur"" and ""left femur"" segments. Found: %s", join(st.SegName, ", "))
end
rf = mmGetMedicalVolumeSegment(mv, st, segName="right femur");
lf = mmGetMedicalVolumeSegment(mv, st, segName="left femur");

% swapped labels? In LPS coordinates, x increases toward the patient's left
xRight = centroidX(rf);
xLeft = centroidX(lf);
if mv.VolumeGeometry.PatientCoordinateSystem == "RAS+" % in RAS, x increases toward the right
    [xRight, xLeft] = deal(-xRight, -xLeft);
end
if xRight > xLeft
    [rf, lf] = deal(lf, rf);
    [rf.segName, lf.segName] = deal("right femur", "left femur");
    [~, fileName, ext] = fileparts(file);
    fprintf("%s: the left and right femur labels were swapped. Swapped them back.\n", studentName(fileName + ext))
end
if side == "right"
    seg = rf;
else
    seg = lf;
end

if options.WithImplant
    isImplant = contains(st.SegName, "implant") & ~contains(st.SegName, "tibia");
    if ~any(isImplant)
        error("No femoral implant segment. Found: %s", join(st.SegName, ", "))
    end
    implant = mmGetMedicalVolumeSegment(mv, st, segName=st.SegName(find(isImplant, 1)));
    seg.mask = seg.mask | implant.mask;
    seg.segName = seg.segName + " + implant";
end
end


function T = measureFemur(seg)
% Measure a femur on its own voxel grid. Returns a table with one row:
%   Length_mm:        the length along the long axis of the femur
%   ShaftDiameter_mm: the equivalent diameter at 50% of the length
%                     (mmCrossSectionProfile). NaN if the voxels aren't cubes
%   Volume_mL:        number of voxels x the volume of one voxel
voxelVolume_mL = abs(det(seg.tform.A(1:3, 1:3))) / 1000; % from the voxel size of this file
volume = nnz(seg.mask) * voxelVolume_mL;

fv = mmGetSurface(seg.mask, transform=seg.tform); % surface in mm
verts = mmAlignSurface2Axes(fv.vertices - mean(fv.vertices)); % center, and align the long axis with x
len = range(verts(:, 1));

try
    [~, S] = mmCrossSectionProfile(seg, Plot=false);
    diameter = S.At.EquivDiameter_mm;
catch err % for example, voxels that aren't cubes
    fprintf("%s: no diameter. %s\n", seg.segName, err.message)
    diameter = NaN;
end
T = table(len, diameter, volume, VariableNames=["Length_mm" "ShaftDiameter_mm" "Volume_mL"]);
end


function plotFemur(seg, titleText)
% Plot a femur upright (its long axis along z), centered at 0
fv = mmGetSurface(seg.mask, transform=seg.tform);
v = mmAlignSurface2Axes(fv.vertices - mean(fv.vertices)); % long axis along x
fv.vertices = mmRotateSurfaceVertices(v, 'y', 90); % long axis along z
mmPlotSurface(fv, seg.color, 1);
mmSetSurfacePlotProps;
axis off
title(titleText)
end


function x = centroidX(seg)
% The x coordinate (mm) of the center of a segment
[r, c, s] = ind2sub(size(seg.mask), find(seg.mask));
p = transformPointsForward(seg.tform, mean([c r s], 1)); % tform works on [column row slice]
x = p(1);
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
