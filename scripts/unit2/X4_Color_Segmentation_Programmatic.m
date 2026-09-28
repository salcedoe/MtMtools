%[text] %[text:anchor:T_48B9CDC7] # Color Segmentation using Programmatic Approaches
%[text] The Color Thresholder App is powerful, but it requires you to choose colors interactively. That works well for a few images, but it becomes tedious when you have dozens or hundreds of images to analyze. A programmatic approach replaces those clicks with a repeatable set of rules based on image data. That makes the analysis **reproducible**, but not automatically **generalizable**. A method can give the same answer every time and still fail on a new image with different lighting, colors, or backgrounds.In this script, we will build a color-based strawberry segmentation method, validate it, test it on new images, and then deliberately give it an image that breaks one of its assumptions.
%[text] 
%[text:tableOfContents]{"heading":"Table of Contents"}
%%
clearvars
close all
%[text] %[text:anchor:T_969DBF63] ## Strawberries, redux
%[text] Let's start with the strawberry image from the previous exercise. It contains several ripe red strawberries against green foliage, with some shadows, highlights, and out-of-focus regions.
%%
%[text] ### Load Image
%[text] We will store the image and the intermediate processing steps in a structure called p. We will use p(1) from the beginning because later we will add more images to the same structure array.
mmSetUnitDataFolder(2) % change folder to unit 2

p.name = 'strawberries.png';
p.rgb = imread(p.name);

figure
imshow(p.rgb)
title('Strawberries 1')
%%
%[text] ### Automating the segmentation
%[text] Manually clicking on or circling strawberries works when you have only a few images. But what if you had **hundreds of strawberry images** to analyze?
%[text] In that case, we need a way to identify the strawberries **automatically**.
%[text] One approach is to convert the image from RGB into a **color space that separates color information in a way that is easier to analyze mathematically**. We can then apply the same basic segmentation tools we have already used, such as thresholding and binarization, to one or more of the converted image channels.
%[text] L\*a\*b\* was designed to represent color in an approximately perceptually uniform space. For this exercise, its most useful feature is that lightness and the two opponent-color axes are stored separately:
%[text] - **L\*** represents lightness
%[text] - **a\*** runs from green toward red/magenta
%[text] - **b\*** runs from blue toward yellow \
%[text] For red strawberries surrounded by green leaves, the a\* channel is our best bet because the strawberries and foliage tend to occupy different parts of the green-to-red axis.
%[text] Instead of asking MATLAB to find "strawberries," we can ask a simpler question: **Can we find the red pixels that are consistent with a ripe strawberry?**
%[text] #### Convert to L\*a\*b\* space
%[text] Here we convert the RGB image to a L\*a\*b\* space using the function **rgb2lab**
p.lab = rgb2lab(p.rgb);
class(p.lab) % rgb2lab returns floating-point L*a*b* data
%%
%[text] %[text:anchor:H_A1D4EB69] #### Display the L\*a\*b\* channels
%[text] Here we display all three channels and their histograms. One thing to take into consideration is that the L\*a\*b\* channel values do not fall within typical image intensity ranges:
%[text] - L\* ranges from 0 to 100.
%[text] - a\* and b\* can contain both negative and positive values. \
%[text] So, we use `imshow(...,[])` to rescale each channel independently for display. This way, even though the channels don't contain standard image ranges, they will display like grayscale images. 
figure
tiledlayout(2,3,'TileSpacing','compact','Padding','compact')
titles = ["L* (lightness)", "a* (green to red)", "b* (blue to yellow)"];

for n = 1:3
    nexttile(n)
    imshow(p.lab(:,:,n),[]) % rescale and display 
    title(titles(n))

    nexttile(n+3)
    histogram(p.lab(:,:,n),50)
    xlabel('Channel value')
    ylabel('Pixels')
end
%[text] The strawberries pop in the a\* plane. That makes sense: the green foliage tends toward lower, more negative a\* values, while the ripe red strawberries tend toward higher, more positive a\* values.
%[text] Also notice:
%[text] - The exact a\* range depends on the colors in the image. It is **not** fixed at the range seen in this particular photograph.
%[text] - The a\* histogram for this image is roughly bimodal, which suggests that a single threshold may be able to separate two major color groups.
%[text] - A bright pixel in one of these displayed channel images means that the pixel has a relatively high numerical value in that channel. It does not necessarily mean the original pixel looks bright. \
%%
%[text] #### Threshold the a\* plane
%[text] Since the strawberries have such a high contrast in the a\* plane, we will threshold that plane. 
%[text] First, we index out the raw a\* plane 
p.a = p.lab(:,:,2); 
fprintf('a* range: %.1f to %.1f\n',min(p.a,[],'all'),max(p.a,[],'all'));
%%
%[text] The image processing functions `graythresh` and `imbinarize` expect floating-point images to contain values between 0 and 1. Since the raw a\* plane contains values outside that range, we create a normalized copy for thresholding.
p.aNorm = rescale(p.lab(:,:,2)); % index out a* plane and rescale values to the range 0-1
%[text] Remember what the a\* axis means:
%[text] - lower a\* values are more greenward
%[text] - higher a\* values are more redward \
%[text] That is exactly the color distinction we are trying to exploit.
%%
%[text] #### Where should we place the threshold?
%[text] By default, imbinarize uses **Otsu's method**. Otsu's method searches for a threshold that divides the histogram into two groups while minimizing the variation within those groups. 
%[text] The function `graythresh` lets us calculate that threshold directly. It can also return an **effectiveness metric**, which describes how well the threshold separates the histogram into two groups.
[p.aLevel,p.otsuEffectiveness] = graythresh(p.aNorm);

% Convert the normalized threshold back to the original a* scale.
aMin = min(p.a,[],'all');
aMax = max(p.a,[],'all');
p.aThresh = p.aLevel*(aMax-aMin) + aMin;


figure
histogram(p.aNorm(:),50)
hold on
xline(p.aLevel,'r',sprintf('threshold = %.2f',p.aLevel), ...
    'LineWidth',2,'LabelOrientation','horizontal')
title('Normalized a* Histogram with the Otsu Threshold')
xlabel('Normalized a* value')
ylabel('Number of pixels')
fprintf('Normalized Otsu threshold: %.3f\nEquivalent raw a* threshold: %.1f\nOtsu effectiveness: %.3f\n', ...
    p.aLevel, p.aThresh, p.otsuEffectiveness)
%[text] Notice where the threshold falls: in the valley between the two major groups of pixels. In this image, those two groups correspond roughly to the greener foliage and the redder strawberries. Remember, this cutoff was calculated by`graythresh` from the image data. That makes the procedure repeatable.
%%
%[text] #### Binarize the normalized plane
%[text] Because the ripe strawberries have higher a\* values than most of the foliage, pixels above the threshold will become logical trues in the mask.
p.aMaskNorm = imbinarize(p.aNorm,p.aLevel);

figure
mmShowBurnImage(p.rgb,p.aMaskNorm)
title('Mask from the a* Channel')
%[text] 
%[text] Well, that was easy. One threshold on one channel did much of what previously required all that clicking. Converting to L\*a\*b\*  revealed a useful color distinction that was much harder to isolate in RGB.
%[text] But we should be clear here: MATLAB has **not learned what a strawberry is**. It has simply identified **pixels that fall on one side of a color threshold**.
%[text] Also, since we are thresholding based on the distribution of values in the a\*, our approache is adaptive, meaning that the threshold will change for different images (based on the distribution of a\* values). 
%%
%[text] #### Clean up noise and watershed
%[text] The raw mask still contains small regions and touching objects. We can apply the same morphological cleanup tools we used previously in the course.
minNoiseArea = 200; % pixels; appropriate for this image resolution
p.aMaskClean = bwareaopen(p.aMaskNorm,minNoiseArea);
p.aMaskClean = imclearborder(p.aMaskClean);

% The value 5 is a tuning parameter in the course watershed helper.
% Keep it consistent unless you are intentionally changing the separation behavior.
p.aWatershed = mmGetWatershed(p.aMaskClean,5);

figure
mmShowBurnImage(p.rgb,p.aWatershed)
title('Cleaned and Separated Strawberry Mask')
%[text] - Are the strawberries separated? Compare this to the watershed result you got from the SAM mask back in X3. \
%[text] **Important:** pixel-area settings such as 200 depend on image resolution and object size. If magnification or image resolution changes, the same area cutoff may no longer be appropriate.
%%
%[text] #### Final Review
%[text] Here is the full progression from RGB image to separated objects.
figure
mmTightTiledLayout("flow")
fieldsToShow = ["rgb" "aNorm" "aMaskNorm" "aMaskClean" "aWatershed"];

for fieldName = fieldsToShow
    nexttile
    imshow(p.(fieldName))
    title(fieldName,'Interpreter','none')
end
%%
%[text] %[text:anchor:H_SCOREGT] ### Compare against the ground truth
%[text] In X3 we created a hand-drawn ground-truth mask and used **Jaccard** and **Dice** to quantify agreement. We can use that same reference mask here.
load('strawberry-mask-ground-truth.mat','maskGT'); % the hand-drawn mask from X3

fprintf('Jaccard: %.3f\n', jaccard(maskGT, p.aMaskClean));
fprintf('Dice:    %.3f\n', dice(maskGT, p.aMaskClean));

figure
imshowpair(maskGT, p.aMaskClean)
title('Magenta - a* mask only, Green - ground truth only, White - overlap')
%[text] - Compare these numbers to the table you built in X3.
%[text] - How does one threshold on the a\* plane stack up against all that clicking in the Color Thresholder? \
%[text] These scores tell us how well the method agrees with the ground truth **for this image**. They do not yet tell us how well the method will perform on new photographs.
%[text] This gives us two different questions:
%[text] - **Reproducibility:** does the same procedure give the same result when repeated?
%[text] - **Generalizability:** does the procedure still work on new images acquired under different conditions? \
%%
%[text] **Counting objects is not the same as recognizing objects**
%[text] We can use regionprops to count the connected components after watershed separation.
rp = regionprops('table',p.aWatershed,'basic');

fprintf('Blobs found: %d\n',height(rp));
largeObjectArea = 2000; % pixels; another image-dependent criterion
fprintf('Blobs larger than %d px: %d\n',largeObjectArea,sum(rp.Area > largeObjectArea));
%[text] If the raw blob count is higher than the number of strawberries you see by eye, inspect the Area values. Small artifacts can survive cleanup, and watershed can occasionally split one berry into multiple regions.
%[text] Counting connected components is easy. Deciding which components represent meaningful biological objects requires an additional criterion and validation.
%[text] #### Did we get more strawberries than we counted in X3?
%[text] Look at the `Area` column. Most blobs are in the thousands of pixels, but a couple are tiny. Those are noise specks that survived `bwareaopen`, and the watershed happily split a few berries in two as well. Counting blobs is easy; counting *objects* means deciding what counts as an object.
fprintf('blobs found: %d\n', height(rp));
fprintf('blobs larger than 2000 px: %d\n', sum(rp.Area > 2000));
%[text] - Filtering on area gets us much closer to the number you get by eye. \
%%
%[text] ## More and More strawberries
%[text] Does our approach scale? Let's test the same idea on two different strawberry photographs containing different shadows, highlights, fruit sizes, ripeness levels, and foliage.
%[text] **SIDEBAR: Structure arrays**
%[text] We will store the additional images by transforming `p` into a structure array, using the following syntax:
p(2).name = 'strawberries2.jpeg';
p(3).name = 'strawberries3.jpeg';
%[text] - Notice where the parentheses are located (right after the variable name)
%[text] - To explore more, double-click on `p.` Notice it's table like appearance in the Variable editor
%[text] - Double-click on one of the elements in `p`
%[text] - The tab tells you how to index that element \
%[text] Think of these arrays as if the whole structure is one element. So to access anything in a specific structure, you have to specify the 'element' you want to access by indexing after the variable name: `p(1).rgb, p(2).rgb, or p(3).rgb`
%[text] Why not a table? Well in a structure, you can have one field that is a string array vector, and another field that's a whole image (the rows don't need to match). And you can have different sized images in different elements of the structure (`p(1).rgb, p(2).rgb,` and `p(3).rgb` can all be different sizes`)`
%%
%[text] ### Automating our Strawberry finder pipeline
%[text] Here is the payoff for creating a structure array. We can now LOOPify the whole thresholding process (since we are using the same approach for both images).
%[text] The loop below performs the same L\*a\*b\* conversion, per-image normalization, Otsu thresholding, and binarization on both new images.
% threshold strawberries 2 and 3
for n = 2:3 
    p(n).rgb = imread(p(n).name); % read image
    p(n).lab = rgb2lab(p(n).rgb); % convert to lab
    p(n).a = p(n).lab(:,:,2); % index out a plane
    p(n).aNorm = rescale(p(n).a); % rescale
    [p(n).aLevel,p(n).otsuEffectiveness] = graythresh(p(n).aNorm); % get level and effectiveness

    aMin = min(p(n).a,[],'all');
    aMax = max(p(n).a,[],'all');
    p(n).aThresh = p(n).aLevel*(aMax-aMin) + aMin; % convert level

    p(n).aMaskNorm = imbinarize(p(n).aNorm,p(n).aLevel); % create mask
end
%%
%[text] And we can display all our results in one figure
figure
tiledlayout(2,3, "TileSpacing","tight","Padding","tight")
for n = 1:3
    nexttile(n) % plot image in first row
    imshow(p(n).rgb)
    title(sprintf('Strawberries %d',n))

    nexttile(n+3) % plot mask in second row
    mmShowBurnImage(p(n).rgb,p(n).aMaskNorm)
    title(sprintf('Adaptive a* mask %d',n))
end
%[text] As you can see, our approach identifies the **ripe red** fruit rather than every object that happens to be a strawberry. Unripe green strawberries may blend with the foliage in the a\* channel.
%[text] That is not necessarily an algorithmic mistake. It reveals what our rule actually means. We did not build a general "strawberry detector." We built a detector for pixels that are relatively red-ward within each image.
%[text] There is also more noise in the new strawberry images. Also to be expected due to variations in the a\* values.
%%
%[text] %[text:anchor:H_NOTRED] ## The "not red" strawberries
%[text] Now let's deliberately challenge our method with the color-illusion image. Remember, the strawberries look red to most, but the pixel data are strongly shifted away from redward colors seen in our other strawberry photographs.
%[text] Can we use the L\*a\*b\* color model to segment the "red" in not-red-strawberries image? Ideally, we should get no mask, since there is purportedly no red in this image
p(4).name = 'Not_red_strawberries.png';
p(4).rgb = imread(p(4).name);

figure;
mmTightTiledLayout
nexttile
imshow(p(4).rgb)
title("Not Red Strawberries")
%[text] - Again, no red was used in the making of this image. Even though your brain tells you that there is red.
%[text] - This image is going to be a little harder, because there doesn't look like there is any green either (or is there?)  \
%%
%[text] ### Ask the pixels instead of your eyes
%[text] We can also make a simple RGB check. If a pixel is strongly red in RGB terms, its red channel should be larger than both its green and blue channels.
R = p(4).rgb(:,:,1);
G = p(4).rgb(:,:,2);
B = p(4).rgb(:,:,3);

redDominantFraction = mean(R > G & R > B,'all');
fprintf('Pixels where red is the strongest RGB channel: %.1f%%\n',100*redDominantFraction);
%[text] This image is a useful reminder that human color perception is context-dependent. What we perceive as "red" does not always correspond to a simple red-channel or a\* criterion in the recorded pixel values.
%%
%[text] ### Threshold the not-red strawberries
%[text] If our algorithm really means "find red strawberry pixels," we might expect little or no foreground here. Let's run **the same adaptive pipeline** first.
p(4).lab = rgb2lab(p(4).rgb);
p(4).a = p(4).lab(:,:,2);
p(4).aNorm = rescale(p(4).a);
[p(4).aLevel,p(4).otsuEffectiveness] = graythresh(p(4).aNorm);

aMin = min(p(4).a,[],'all');
aMax = max(p(4).a,[],'all');
p(4).aThresh = p(4).aLevel*(aMax-aMin) + aMin;

p(4).aMaskNorm = imbinarize(p(4).aNorm,p(4).aLevel);

nexttile
mmShowBurnImage(p(4).rgb, p(4).aMaskNorm)
title("Not Strawberries mask")
%[text] - Hmm, that's weird - We're getting a mask even though there is reportedly no red in this image
%[text] - Also, only half of the strawberries are masked, even the parts that are not red (the white insides)
%[text] - And some of the white plate is masked too \
%[text] So, What's going on here?
%%
%[text] ### Back to the Histograms
%[text] Remember, our approach relied on the fact that the a\* plane had bi-modal distribution between the green and red values. And based on that distribution, Otsu's method selected a cut-point to separate the green and red pixels. So, the key is to compare the **original a\* values**, before each image was independently rescaled to 0-1.
%[text] Let's plot all the histograms of the original a\* values to review the process.
figure
tiledlayout(numel(p),1,'TileSpacing','compact','Padding','compact')

for n = 1:numel(p)
    nexttile
    histogram(p(n).a(:),60) % 60 bins for all histograms
    hold on
    xline(0,'k--','a* = 0','LabelOrientation','horizontal')
    xline(p(n).aThresh,'r',sprintf('Otsu = %.1f',p(n).aThresh), ...
        'LineWidth',2,'LabelOrientation','horizontal')
    xlim([-45 80])
    ylabel('Pixels')
    title(extractBefore(string(p(n).name),'.'),'Interpreter','none')
end
xlabel('Raw a* value')
%[text] Real, Strawberry Images:
%[text] - All have values in the a\* plane above 0, in the red zone
%[text] - Have nice, bimodal distributions, making the cut-off easy for the Otsu method to determine
%[text] - All have threshold values above 0 \
%[text] Fake, not red image:
%[text] - Most values below zero, in the green zone
%[text] - Does not have a bimodal distribution (just a sharp peak)
%[text] - As a negative threshold \
fprintf('Original strawberry a* range: %.1f to %.1f\n', ...
    min(p(1).a,[],'all'),max(p(1).a,[],'all'));
fprintf('"Not red" image a* range: %.1f to %.1f\n', ...
    min(p(4).a,[],'all'),max(p(4).a,[],'all'));
%[text] So, for the real strawberry photographs, the a\* distributions extend well into positive values because the images contain strongly redward pixels. The "not red" image is very different. Its a\* values stay close to the green/neutral side of the axis and barely extend into positive values.
%%
%[text] **Why did Otsu still produce a mask?**
%[text] Because Otsu does **not** know what red is, and it does not know what a strawberry is.
%[text] Otsu's job is simply to find the best mathematical split in the values it is given. It does not first check whether two biologically meaningful classes actually exist.
%[text] There is another subtlety: we used rescale independently on every image. That means the smallest a\* value in each image becomes 0 and the largest becomes 1.
%[text] So a normalized value of 0.8 does **not** necessarily represent the same physical color in two different photographs.
%[text] Our adaptive pipeline therefore asks:
%[text] **Which pixels are relatively more redward than the other pixels in this image?**
%[text] That is different from asking:
%[text] **Which pixels satisfy the same absolute red/green color criterion in every image?**
%%
%[text] **Adaptive threshold versus a fixed color criterion**
%[text] To see the distinction, let's take the raw a\* threshold learned from the first strawberry image and apply that same raw threshold to the "not red" image.
%[text] This preserves the meaning of the original L*a*b\* values instead of stretching every image to fill 0-1.
fixedAThresh = p(1).aThresh;
p(4).fixedMask = p(4).a > fixedAThresh;

figure
mmTightTiledLayout

nexttile
mmShowBurnImage(p(4).rgb,p(4).aMaskNorm)
title('Per-image adaptive Otsu mask')

nexttile
mmShowBurnImage(p(4).rgb,p(4).fixedMask)
title(sprintf('Fixed raw a* threshold > %.1f',fixedAThresh))
%[text] - no mask in the fixed approach \
%[text] The two approaches answer different questions:
%[text] - **Adaptive Otsu after per-image rescaling:** finds the higher-a\* group relative to each individual image.
%[text] - **Fixed raw** **a\*** **threshold:** applies the same color criterion to every image. \
%[text] A fixed threshold is not automatically "better." It may be less tolerant of changes in illumination, camera processing, or acquisition conditions. But it preserves a consistent color meaning across images.
%[text] If you want one segmentation rule to work across an entire dataset, you need to decide which behavior you actually want and then **validate that choice on multiple images**.
%%
%[text] ## What did we actually learn?
%[text] The first strawberry image worked well because ripe strawberries and foliage occupied substantially different parts of the a\* axis. The same general strategy also worked reasonably well on similar photographs.
%[text] The color-illusion image exposed the assumption underneath the method. Automatic thresholding will still return a numerical answer even when the groups it creates do not correspond to the objects we care about.
%[text] The main lessons are:
%[text] - A segmentation algorithm finds **numerical classes**, not semantic objects.
%[text] - Reproducible code is not necessarily generalizable code.
%[text] - Per-image normalization is useful for adaptive segmentation, but it removes the absolute meaning of the original channel values.
%[text] - A threshold should be validated on images beyond the one used to develop it.
%[text] - Parameters such as area cutoffs can also depend on acquisition scale and image resolution. \
%[text] A useful rule to remember is:
%[text] **A segmentation algorithm will usually give you an answer if you ask it a numerical question. Your job is to make sure the numerical question corresponds to the biological or physical question you actually care about.**
%[text] 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
