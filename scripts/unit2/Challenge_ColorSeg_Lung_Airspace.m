%[text] # In-Class Challenge: How Much Air Is Left?
%[text] **Measuring alveolar airspace in normal lung and lung cancer**
%[text] In this challenge you will design your own segmentation pipeline, apply it to a set of 18 lung tissue images, and use the results to answer a biological question. There is no step-by-step recipe this time. You already have every tool you need from X3 through X6.
%[text] **Groups:** Work in pairs.
%[text] 
%[text:tableOfContents]{"heading":"Table of Contents"}
%%
%[text] ## Background
%[text] The lung is built for gas exchange. At the microscopic level, most of a normal lung section is **empty space**: the alveoli, separated by very thin alveolar walls. In an H&E-stained section, that empty space looks pale gray or white because there is no tissue there to take up the stain.
%[text] Lung carcinomas grow into and replace this architecture. As tumor cells proliferate, they fill the alveolar spaces and the tissue becomes solid. Pathologists see this immediately by eye, but "it looks more solid" is not a measurement.
%[text] Your job is to turn that observation into a number.
%%
%[text] ## The Question
%[text] **What fraction of each image is airspace, and does that fraction differ between normal lung, adenocarcinoma, and squamous cell carcinoma?**
%%
%[text] ## The Data
%[text] You have 18 H&E images of human lung, all taken at 20x magnification (1200 x 1600 pixels):
%[text] - **6 normal lung**
%[text] - **6 adenocarcinoma** (2 well, 2 moderately, and 2 poorly differentiated)
%[text] - **6 squamous cell carcinoma** (2 well, 2 moderately, and 2 poorly differentiated) \
%[text] The images come from the LungHist700 dataset: Diosdado J, Gilabert P, Seguí S, Borrego H. *LungHist700: A dataset of histological images for deep learning in pulmonary pathology.* Scientific Data 11, 1088 (2024). https://doi.org/10.1038/s41597-024-03944-3. Licensed under CC BY 4.0.
%[text] The code below loads all 18 images into the structure array `p`, the same way we built `p(n)` for the strawberries in X4. Each element has three fields to start with:
%[text] - `p(n).name`: the file name
%[text] - `p(n).group`: "Normal", "Adenocarcinoma", or "Squamous"
%[text] - `p(n).rgb`: the image \
clearvars
close all
unit2dir = mmSetUnitDataFolder(2) % change folder to unit 2
imgFolder = fullfile(unit2dir,"LungHist700","images");

fileNames = ["nor/nor_20x_902.jpg"    "nor/nor_20x_904.jpg"    "nor/nor_20x_2.jpg" ...
         "nor/nor_20x_301.jpg"    "nor/nor_20x_6.jpg"      "nor/nor_20x_305.jpg" ...
         "aca_bd/aca_bd_20x_1.jpg" "aca_bd/aca_bd_20x_7.jpg" ...
         "aca_md/aca_md_20x_7.jpg" "aca_md/aca_md_20x_76.jpg" ...
         "aca_pd/aca_pd_20x_33.jpg" "aca_pd/aca_pd_20x_9.jpg" ...
         "scc_bd/scc_bd_20x_34.jpg" "scc_bd/scc_bd_20x_46.jpg" ...
         "scc_md/scc_md_20x_51.jpg" "scc_md/scc_md_20x_62.jpg" ...
         "scc_pd/scc_pd_20x_14.jpg" "scc_pd/scc_pd_20x_2.jpg"];
groups = [repmat("Normal",1,6) repmat("Adenocarcinoma",1,6) repmat("Squamous",1,6)];

T = table(fileNames', groups','VariableNames',{'Name','Group'})
%%
%[text] ## Load and Review Selected image
n=4 %[control:spinner:45c4]{"position":[3,4]}
img = imread(fullfile(imgFolder,T.Name(n))); 
figure
imshow(img)
title(T.Name(n),'Interpreter','none')
%%
%[text] ### Display all images
figure
tiledlayout(3,6,"TileSpacing","none","Padding","tight")
for n=1:height(T)
nexttile
img = imread(fullfile(imgFolder,T.Name(n))); 
imshow(img)
text(100,100,num2str(n),'Color','white')
end
sgtitle('Row 1: Normal    Row 2: Adenocarcinoma    Row 3: Squamous cell carcinoma')
%[text] Take a look at all of them before you start. Each row is one group: normal, adenocarcinoma, squamous cell carcinoma.
%%
%[text] ### Packages all images into structure p
for n = 1:numel(fileNames)
    p(n).name = fileNames(n);
    p(n).rgb = imread(fullfile(imgFolder,fileNames(n)));
end
%%
%[text] #### Visualize images packaged in p
figure
montage({p.rgb},'Size',[3 6],'ThumbnailSize',[300 400]) % creates a montage of all the images loaded into p

%%
%[text] ## Rules
%[text] 1. **One rule for every image.** Your final pipeline must run on all 18 images inside a FOR loop with the same settings. No hand-tuning individual images.
%[text] 2. **Any tool from X3 to X6 is fair game.** You may use the Color Thresholder app to explore, but your final mask must come from code.
%[text] 3. **Visually inspect your masks with your own eyes.** A number that comes from a bad mask is a bad number.
%[text] 4. **Don't store everything.** Eighteen full-size L\*a\*b\* images take up close to 1 GB of memory. Keep intermediate images as temporary variables inside the loop and only save the mask in `p`. Add your data to T. \
%%
%[text] ## Deliverables
%[text] By the end of class, this live script should contain:
%[text] 1. **A mask for each image:** `p(n).mask`, a logical image where `true` means airspace.
%[text] 2. **An airspace fraction for each image:** T`.AirFraction(n)`, a value between 0 and 1. Be sure to preallocate the AirFraction column with zeros before the FOR LOOP.
%[text] 3. **A summary results table** called groupStats with that contains the mean and standard deviation of AirFraction by group
%[text] 4. **Figure 1:** a `boxchart` of `AirFraction` by group. Be sure to overlay the individual data points on the boxcharts
%[text] 5. **Figure 2:** three burned-mask images (use `mmShowBurnImage`), an example image from each group, so we can see what your mask actually captured.
%[text] 6. **Answers** to the questions at the end of this script. \
%%
%[text] ## Suggested Workflow
%[text] You don't have to follow this order, but it is how most image analysis projects go:
%[text] 1. **Explore one image.** Pick a normal image. Which color channel makes the airspace stand out most clearly from the tissue? Look at the histograms.
%[text] 2. **Explore a second image.** Now pick a tumor image. Does the same channel still work? Do the histograms look the same?
%[text] 3. **Choose a threshold.** Decide how you will separate airspace from tissue. Think about what we learned in X4 about per-image (adaptive) thresholds versus a fixed color criterion.
%[text] 4. **Clean the mask.** Decide which cleanup steps make sense for *this* problem. Not every step we used for strawberries and M&Ms is appropriate here.
%[text] 5. **Loop over all 18 images.** Save `p(n).mask` and T`.airFraction(n)`. Don't add any L\*a\*b\* images to your `p` structure (they will take too much space)
%[text] 6. **Check the masks.** Burn a few masks onto their images. Fix your pipeline if needed, and rerun the loop.
%[text] 7. **Summarize.** Build the table, make the boxchart, and answer the questions. \
%%
%[text] ## Your Pipeline
%[text] ### Step 1: Explore
% Your exploration code here


%%
%[text] ### Step 2: Segment all 18 images
%[text] Hint: This loop should run for as many elements as there are in `p`
% Your FOR loop here


%%
%[text] ### Step 3: Check the masks (Figure 2)
% Your burned-mask figure here


%%
%[text] ### Step 4: Summarize (table T and Figure 1)
% Your table and boxchart here


%%
%[text] ## Questions
%[text] Answer each question in a text line below it.
%[text] **Q1.** Which color channel and which threshold did you use? Explain why that channel separates airspace from tissue in an H&E image.
%[text] *Your answer:*
%[text] **Q2.** What is the mean airspace fraction for each group? Does airspace differ between normal lung and the two tumor types? Between adenocarcinoma and squamous cell carcinoma?
%[text] *Your answer:*
%[text] **Q3.** Find one image where your mask counts something as "airspace" that is **not** alveolar air. What is it, and why did your pipeline include it?
%[text] *Your answer:*
%[text] **Q4.** Try Otsu's method (`graythresh` on the rescaled channel) on one normal image and one tumor image. What happens on the tumor image, and why?
%[text] *Your answer:*
%[text] **Q5.** We can report airspace as a fraction, but not as an area in µm². What information would we need to do that?
%[text] *Your answer:*
%%
%[text] ## Hints
%[text] **Stop!** Only read a hint when you are stuck. Try to solve each problem on your own first.
%[text] ### Hint 1: Which channel?
%[text] The airspace is bare glass with no stain on it, so it is close to a **neutral gray or white**. Hematoxylin (purple) and eosin (pink) both push pixels toward the red/magenta end of one of the L\*a\*b\* color axes. Which axis is that, and where should a neutral gray pixel fall on it?
%[text] ### Hint 2: Why is Otsu giving strange results?
%[text] Otsu's method **always** splits an image into two groups, even when one of those groups barely exists. In a normal image the two groups are airspace and tissue. In a solid tumor with almost no airspace, what are the two groups that Otsu finds instead? Review the section *Adaptive threshold versus a fixed color criterion* in X4.
%[text] ### Hint 3: Choosing a fixed threshold
%[text] Plot the histogram of your chosen channel for one normal and one tumor image on the same axes:
%[text] `histogram(chan1,'Normalization','probability','DisplayStyle','stairs')`, then `hold on` and repeat for `chan2`.
%[text] Find the peak that belongs to the unstained airspace, and place your threshold in the valley between that peak and the stained tissue. Then check that the same value works on a few other images.
%[text] ### Hint 4: Cleaning the mask
%[text] `bwareaopen` is useful for removing tiny specks. But think carefully before you use `imfill` or `imclearborder`:
%[text] - Your mask is **airspace**, not objects. What would `imfill(mask,'holes')` fill in?
%[text] - Airspace runs off the edge of almost every image. What would `imclearborder` remove? \
%[text] ### Hint 5: Airspace fraction
%[text] The fraction of `true` pixels in a mask is `nnz(mask)/numel(mask)`. 
%[text] - nnz - counts the trues in the mask (number of non-zero values).
%[text] - numel(mask) - total number of pixels in the mask (total number of elements) \
%[text] ### Hint 6: Table and boxchart
%[text] Be sure to preallocate the AirFraction before the for loop:
%[text] `T.AirFraction = zeros(height(T),1);`
%[text] To keep the groups in a sensible order on the plot, convert `Group` to a categorical array with a specified order:
%[text] `T.Group = categorical(T.Group, ["Normal","Adenocarcinoma","Squamous"]);`
%[text] Then use `boxchart(T.Group, T.AirFraction)`. To get the group means, try `groupsummary(T,"Group","mean","AirFraction")`.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:spinner:45c4]
%   data: {"defaultValue":1,"label":"n","max":18,"min":1,"run":"Section","runOn":"ValueChanging","step":1}
%---
