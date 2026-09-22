%[text] %[text:anchor:T_4D637CA1] # Enhancement of RGB Images
%[text] The methods we learned for enhancing grayscale images also apply to RGB images. In some cases, we can adjust the whole image at once; in other cases, we need to adjust the color channels separately.
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] 
%[text] ## RGB Enhancement
%[text] In an RGB image, color is represented by the amount of red, green, and blue at each pixel. This can make enhancement tricky because these three channels are intertwined. Changing one channel can affect both the **color** and **brightness** of the image at the same time.
%%
clearvars
close all
mmSetUnitDataFolder(2); % Change to the Unit 2 data folder
%%
%[text] Consider this image
p.rgb = imread("Ho_Chi_Minh_City_Tet_Decorations,_washed-out.jpg");

figure
imshow(p.rgb)
%[text] - it's pretty washed out.  \
%%
%[text] The histogram shows us the problem
figure
mmHistColor(p.rgb,'stem')
ylim([0 4e4])
%[text] - everything is shifted to the right. 
%[text] - That's why its so white \
%%
%[text] ### Contrast Enhancement
%[text] We previously used `imadjust` to fix intensity distributions across the histogram for grayscale images. However, the function call for `imadjust` is very complicated. Luckily, the function stretchlim can automatically find the inputs for `imadjust. stretchlim` estimates the **lower and upper intensity limits** that can be used to improve image contrast. Rather than automatically stretching the image itself, it identifies a range of pixel values that contains most of the image data, usually ignoring a small fraction of very dark and very bright pixels. You then plug the output into `imadjust`
p.lowhigh = stretchlim(p.rgb);
p.rgba = imadjust(p.rgb,p.lowhigh,[]);
imshowpair(p.rgb,p.rgba,'montage')
%[text] - the image looks much better \
%[text] 
%[text] We can use the course function `mmHistColor` to display the three channels from the image. But its difficult to guess what channel should be adjust to correct the colors in the image. 
figure;
mmHistColor(im_rgb)
%[text] To adjust the channels of an image, we can use the **imadjust** function to modify the histogram distribution. For an RGB image, the syntax is not very intuitive, especially when we want to adjust each channel separately.
%[text] ### 
%%
%[text] %[text:anchor:H_05FD7CD3] ### Install ImageAdjuster
%[text] The **ImageAdjuster** app makes the process of using `imadjust` much easier. It is not included with MATLAB by default, so we need to install it.
%[text] %[text:anchor:H_8AA42A09] #### Add-on Tool
%[text] Run the following line to copy the word "ImageAdjuster" to the clipboard.
clipboard('copy','ImageAdjuster')
%[text] 1. Open the Home tab.
%[text] 2. Click the Add-ons button. ![](text:image:62ae)
%[text] 3. In the search box, paste the word. ImageAdjuster should appear. If not, type it manually.
%[text] 4. Search for **ImageAdjuster**.
%[text] 5. Open the ImageAdjuster page (by Brett Shoelson).
%[text] 6. Click the Add button to install it. \
%[text] ![](text:image:27e3)
%[text] - Select "Add to MATLAB".
%[text] - Select "Open Folder".
%[text] - Double-click the ImageAdjuster.mlappinstall file.
%[text] - Select Install.
%[text] - ![](text:image:5e3f)
%[text] - Return to the MATLAB drive by clicking the MATLAB Drive icon. \
%%
%[text] ### Can we fix the damn dress?
im_rgb = imread('black-blue-dress-super-169.jpg');
imshow(im_rgb)
%%
%[text] %[text:anchor:H_4138B441] ### Launching ImageAdjuster
%[text] Now for the moment of truth. Let's try to adjust the channels of the image so the color is better represented
%[text] #### **Action**
%[text] 1. Open the Apps tab.
%[text] 2. Select **ImageAdjuster**.
%[text] 3. Click the yellow folder icon.
%[text] 4. Choose **Import from Workspace**.
%[text] 5. Select the image variable, such as *im\_rgb*.
%[text] 6. Click **Process Planes Individually**.
%[text] 7. Click **Auto-Adjust**.
%[text] 8. Adjust the gamma settings and inspect the result.
%[text] 9. Click **Done / Export**. \
%%
%[text] After you adjust the image in the **ImageAdjuster** app, click **Done / Export**. MATLAB will print code in the Command Window.
%[text] - Copy the code from the Command Window.
%[text] - Replace ***imgin*** with ***im\_rgb*** and ***imgout*** with ***rgba***.
%[text] - Execute the code. \

%%
%[text] #### My Previous attempt
figure
rgba = imadjust(im_rgb,[0.24 0.20 0.12; 1.00 1.00 1.00], ...initial intensity ranges
    [0.00 0.00 0.00; 1.00 1.00 1.00], ... new intensity ranges
    [3.56 2.94 0.88]); % gamma settings for each channel
imshowpair(im_rgb,rgba,'montage')
%[text] - *maybe* blue and black \
%[text] ### 
%%
%[text] %[text:anchor:H_21991BCE] ## You've seen the 'dress', now try the sneaker
%[text] Some people claim that this sneaker is pink and white. I see gray and teal. Lets see if we can adjust the colors using 
close all
clearvars

mmSetUnitDataFolder(2)
img = imread('pink-and-white sneakers.jpg');

figure
imshow(img)
%[text] %[text:anchor:H_9E9B8A6D] ### 
%%
%[text] You can launch the app by typing its name.
ImageAdjuster(img)
%[text] - Hint: process the planes individually. \
%%
%[text] Output from ImageAdjuster:
imga = imadjust(img,[0.00 0.01 0.00; 0.62 0.83 0.80], ...
    [0.00 0.00 0.00; 1.00 1.00 1.00], ...
    [1.00 1.00 1.00]);
%%
imshow(imga)
%%
%[text] ## Converting to grayscale
%[text] Sometimes you want or need to work with a grayscale image. Here is a nice colorful image with absolutely no red in it
clearvars
close all
figure
% im_rgb = imread("peppers.png");
im_rgb = imread("Not_red_strawberries.png");
imageViewer(im_rgb)
%%
%[text] The function `im2gray` converts an RGB image to grayscale. Here is the same image converted to grayscale.
img_gray = im2gray(im_rgb);
figure
imshow(img_gray)
title('Grayscale image')
%[text] - Notice how much the grayscale version differs from the original color image.
%[text] - Notice the size change between the two variables in the Workspace. \
%%
%[text] ## Color enhancement with different color models
%[text] RGB is useful for storing color information, but it is not always the best model for editing colors. Changing one channel in an RGB image can affect both the color and the brightness at the same time.
%[text] A useful strategy is to convert the image into a different **color model**, modify that model, and then convert it back to RGB for display.
%[text] ### Fun with HSV
%[text] For example, the **HSV color model** represents color using three components:
%[text] - **Hue (H):** the type of color, such as red, green, blue, or yellow
%[text] - **Saturation (S):** how vivid or colorful the pixel is
%[text] - **Value (V):** how bright the pixel is \
%[text] Instead of asking, *“How much red, green, and blue should I change?”*, HSV lets us ask questions such as: *What happens if I make the colors more vivid without substantially changing their brightness?* Or, *Can I brighten the image without intentionally changing its hue?*
%[text] Consider the following image of a swimmer.
clear
close all
mmSetUnitDataFolder(2)

p.rgb = imread('swimmer1.jpg'); % load image into structure p

figure;
imshow(p.rgb)
%[text] ### 
%%
%[text] #### Convert to HSV
%[text] Convert the image to an HSV color model.
figure

p.hsv = rgb2hsv(p.rgb); % Create HSV version of the swimmer image
imshow(p.hsv)
%[text] - This looks unusual because it is not an RGB image, even though we are displaying it as if it were one. \
%%
%[text] #### Compare HSV to RGB
%[text] Here we compare the different channels of the two color models.
clf;
tiledlayout(2,4,"TileSpacing","none","Padding","tight")

cols = 4;

% Display RGB versus HSV images
nexttile(1)
imshow(p.rgb)
title('RGB')

nexttile(1+cols);
imshow(p.hsv)
title('HSV')

rgb_titles = {'red', 'green', 'blue'};
hsv_titles = {'hue', 'saturation', 'value'};

% Display corresponding channels
ch_idx = 1; % Channel index
for n = 2:cols
    % Show RGB channels
    nexttile(n);
    imshow(p.rgb(:,:,ch_idx))
    title(rgb_titles{ch_idx});

    % Show HSV channels
    nexttile(n+cols)
    imshow(p.hsv(:,:,ch_idx))
    title(hsv_titles{ch_idx})

    % Increment channel index
    ch_idx = ch_idx + 1;
end
impixelinfo
%[text] - Notice that the HSV channels do not look like a normal RGB image.
%[text] - Hover over the ocean in the hue channel and note the intensity values. \
%%
%[text] #### Change saturation
%[text] Saturation controls how vivid the colors are. Here, we multiply the saturation channel by a factor to make the colors less vivid or more vivid.
clf
p.hsv = rgb2hsv(p.rgb); % Convert to HSV
p.S = p.hsv(:,:,2); % Extract the saturation channel

saturation_factor = 0.4; % Set the factor level %[control:slider:044c]{"position":[21,24]}
p.S(:,:) = p.S(:,:) * saturation_factor; % Increase or decrease saturation
p.hsv(:,:,2) = p.S; % Put the modified saturation channel back into the HSV image
p.rgbS = hsv2rgb(p.hsv); % Convert back to RGB

% Display the results
figure;
tiledlayout(1,2,"TileSpacing","none","Padding","none")

ax1 = nexttile;
imshow(p.rgb) % Display the original RGB image
title('original')

ax2 = nexttile;
imshow(p.rgbS) % Display the modified HSV image
title(sprintf('Saturation Factor  %1.2f', saturation_factor))
%%
%[text] #### Change value
%[text] Value controls brightness. We can adjust the brightness by multiplying the value channel by a factor.
clf
p.hsv = rgb2hsv(p.rgb); % Convert to HSV
p.V = p.hsv(:,:,3); % Extract the value channel

Value_factor = 0.3; % Set the factor %[control:slider:3497]{"position":[16,19]}

p.V = p.V * Value_factor; % Multiply by the factor
p.hsv(:,:,3) = p.V; % Replace the original value channel

p.rgbV = hsv2rgb(p.hsv); % Convert back to RGB

figure;
tiledlayout(1,2,"TileSpacing","none","Padding","none")

nexttile;
imshow(p.rgb)
title('original')
nexttile;
imshow(p.rgbV)
title(sprintf('Value Factor  %1.2f', Value_factor))
%[text] - Note that a value of 0 is black. \
%%
%[text] #### Color swapping
%[text] We can use the hue channel to modify the colors in an image.
%[text] %[text:anchor:H_F2093759] First, let's look at the distribution of hues by plotting a histogram of the hue channel.
figure
subplot(1,2,1)
imshow(p.rgb)

subplot(1,2,2)
hues = im2uint8(p.hsv(:,:,1)); % Convert hue values to integer values to match the HSV colorbar
imhist(hues,hsv) % Use the HSV colormap
%[text] - This image contains mostly blues and reds.
%[text] - Notice that the blue tones have larger hue values than the swimmer's colors.
%[text] - This is a good example for color replacement. \
%%
%[text] #### Change hue in the image
%[text] In an HSV image, we can change the hue by changing the values in the H channel.
%[text] To select a range of hues, we create a logical mask such as H \> 0.35 & H \< 0.45.
%[text] To select the ocean, we can use the mean hue value for the whole image, since most of the water has a similar color. Then we replace all pixels in that range with a new hue value.
p.hsv = rgb2hsv(p.rgb); % Convert to HSV

% Select the hue value to use for replacement
Hue_value = 1; % What happens when you change this value? %[control:slider:0123]{"position":[13,14]}

% Change the ocean values (the ocean has a similar hue across many pixels)
p.H = p.hsv(:,:,1); % Extract the hue channel
p.Hmean = mean2(p.H); % Calculate the mean of the whole image
p.H(p.H > p.Hmean) = Hue_value; % Replace values above the mean with a new hue
p.hsv(:,:,1) = p.H; % Add the modified hue channel back into the HSV image

% Convert the modified HSV image back to RGB
p.rgbH = hsv2rgb(p.hsv); % Color-swapped image

clf;
imshow(p.rgbH)
title(sprintf('Hue Value = %1.1f',Hue_value))
%[text] - This color modification would be difficult to do directly in RGB space.
%[text] - Notice that 0 and 1 produce the same result because HSV wraps around like a color wheel. \
%[text] 
%%
%[text] ### Fun with L\*a\*b\*
%[text] In the previous example, we used HSV to modify saturation and value. However, HSV does **not** perfectly separate brightness from color. Like RGB, changing one HSV channel can still affect the others.
%[text] The L\*a\*b\* color space has a luminosity layer, L\*, that is independent of the two color channels. We can use this lightness channel to improve the contrast in an image with poor illumination.
clearvars
close all
p.rgb = imread("lowlight_1.jpg"); % Load image into the structure p
imshow(p.rgb)
%%
%[text] ### Convert to L\*a\*b\* channels and display them
%[text] First, convert the image to L\*a\*b\* and save it in the structure p. Then display each of the three channels.
p.lab = rgb2lab(p.rgb); % Convert the image to L*a*b*

figure;
tiledlayout(2,3);
p.titles = ["L (lightness)", "a (green-red)", "b (yellow-blue)"];

for n=1:3
    nexttile(n);
    imshow(p.lab(:,:,n),[]) % Extract one channel and display it. The empty brackets auto-adjust the contrast.
    title(p.titles(n));

    nexttile(n+3)
    histogram(p.lab(:,:,n))
end
%[text] 
%[text] - Notice that the L\* plane looks like a black-and-white image, but darker than the original.
%[text] - Notice the range of values. L\* ranges from 0 to 100, while a\* and b\* can be negative or positive.
%[text] - This is no longer an RGB image; it is now an L*a*b\* image. \
%%
%[text] We will modify this plane to improve the contrast of the image. First, scale the L\* plane from 0 to 1.
p.Lscale = p.lab(:,:,1)/100; % Normalize the lightness channel to the range 0 to 1
%[text] - Now we can treat Lscale as a grayscale image. \
%%
%[text] Here we try three different contrast enhancement techniques on the L\* plane.
figure;
tiledlayout("horizontal","TileSpacing","none","Padding","tight")

nexttile;
imshow(p.Lscale);
title('Original L*');

nexttile
p.imadjustL = imadjust(p.Lscale); % Apply imadjust
imshow(p.imadjustL)
title('Adjust Intensity');

nexttile;
p.histeqL = histeq(p.Lscale); % Apply histogram equalization
imshow(p.histeqL);
title('Histogram Eq');

nexttile;
p.adaptiveL = adapthisteq(p.Lscale); % Apply adaptive histogram equalization
imshow(p.adaptiveL);
title('Adaptive Histogram Eq');
%[text] - Adaptive histogram equalization often gives the strongest improvement, but we should compare all of the methods. \
%%
%[text] To incorporate these changes back into the original RGB image, we complete the following steps:
%[text] 1. Convert the adjusted L\* channel back to the 0 to 100 scale.
%[text] 2. Insert the modified plane back into the L*a*b\* image.
%[text] 3. Convert the adjusted L*a*b\* image back to RGB. \
%[text] First, we display the original image for reference.
figure
mmTightTiledLayout
nexttile
imshow(p.rgb)
title("original")
%%
%[text] Next,  we convert imadjust modifed L\* plane to rgb
p.imadjustIMG = p.lab; % copy lab for next step
p.imadjustIMG(:,:,1) = p.imadjustL * 100; % scale back to 100 and insert into L*a*b* image
p.imadjustIMG = lab2rgb(p.imadjustIMG); % convert to RGB
nexttile
imshow(p.imadjustIMG)
title("Intensity adjust")
%%
%[text] Next,  we convert `histeq` modifed L\* plane to rgb
p.histeqIMG = p.lab; % copy lab for next step
p.histeqIMG(:,:,1) = p.histeqL * 100; % scale back to 100 and insert into L*a*b* image
p.histeqIMG = lab2rgb(p.histeqIMG); % convert to RGB

nexttile
imshow(p.histeqIMG)
title("Histogram equalization")
%%
%[text] Finally, we convert the adaptiveL plane to rgb. 
p.adaptiveIMG = p.lab; % copy lab for next step
p.adaptiveIMG(:,:,1) = p.adaptiveL * 100; % scale back to 100 and insert into L*a*b* image
p.adaptiveIMG = lab2rgb(p.adaptiveIMG); % convert to RGB

nexttile
imshow(p.adaptiveIMG)
title("Adaptive Histogram Eq")
%%
%[text] ### Challenge
%[text] How would you fix the dress using L\*a\*b\* ?
p.rgb = imread('black-blue-dress-super-169.jpg');
imshow(p.rgb)
%%
%[text] # 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[text:image:62ae]
%   data: {"align":"baseline","height":28,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADoAAAApCAYAAABk+TodAAAFAElEQVR4Ae2W61MTVxjG\/dB2Ov3QcTpt1WmlXqB2GKoVSxUZolNRRgXBVuuIWkEQiqDEFhS8gQqkQDOgRMCIGG5eEE2IYII0CUETboHUEDUhMYiSDWLbf+FpdttlYhnojOxKrPlw5t0558m77+88756caQRB4HUY014HSJLRA\/p\/c9rjqMfRV\/SU9rQuW617tb0fnFO3qSHrtb60\/\/CX5miveRDfld1BdGUnNLZhtFkd2Hahg5oj19jaWDov66CWR0+QK9EhkNeM6\/oBWJ79CdPTP\/Db0DNoncBlahMCsmWUhtTShTEdWQcN4TUhS9xDAf4bUmkeQpNxEPW9NsRWONs5p\/HVBfVKrkFmfZfTwZHnnHSFLL9txo4yJUgt007S+Vh3dHZ8BTQWOxKFSggVRqpdXSEP13VgXY4UOTf0ILV0YUxH1kFnxZSNOnleZcTmfCmqNSYIW+9jfY4YqbUaFCvvI1\/eB1LLNCCdj3XQmdtO\/X3wDAxDabbjpvObjDsjR\/TpmxAo7o1CHnc6SmrpwpiOrIPO2FwArQvkNb0NtR0WnHN+l7STJGT6dR1ILdOAdD7WQT+MyBl1ciJI7uVOkFq6MKYja6Bi7TWEFYTgo8hMxBdKUKM1jetkUrUGnANVmLMhE+IQX\/TVM3\/6Mg6qN+kRfSYK0aVboXogRe8jBX7gC\/DpplzsL28Z067f5kngFZkNbm4NTLpO2G5dQ9Om5WjavgY2vY4xhxkDtQxYkHXpKIIyA1ClLoftdz36R9QwjjRCP3wRjYZirEjMwBc7Cpwn7R0kV6rhuzUfoQmF6OrUwX6vB\/aeNhBaGQjVVdzlp6Iu2AutR\/fhscU8aWDGQJcdWoL8Bh7MDuMYyG6iBNqhn9H6JB251\/fBJ5IL34gjqBK3YshqHgNJyEVwSARwXMlDW8Jq1HLmuA\/oghQf8KX5MNo1zznpCtkymAjBnTCs5i1EbfiXMDRcmhByWHQYql3BKPd\/131AvZPmo93ajP2i3RC0HKPa1RXySl8MIvn+4F4NQtoNDhS8dGjPFkAcFw6DiE+1q6uTfdk7Idm4ENasb3D561nuAzonYT5MIwoYntajqv0YYs+Go0KTApn1J6TUhGL3haUo1oWiULcGO6uW4tbJH2E3dIDoUkCVtQfShPWwirJhFWZAGhWI7rQIEL9sB3F8Hao5H7gP6MexcylIHXGO+h5Vj9OQ1bAWW04tQUlnKISGtRTkSe0qrD+9GLLMZAqSUEtA3KrBYF0h5ElhkMeHYLAofhSSOLgMF5ZPdx\/QmTs\/gStk86MYNDyMwMUHYc9BHlSvxCr+IjQe2g0a0iEthaOuAI7KI3CUODfgHydJSHuyD4SB77gP6PvbZ486ORFkUgsHQXl+aDjwPeXkf0E+3jUDgoC33AfUK8YXSefXQmLaMa6TJGRYxRJ8xvVDUfhidBelTugkCXll5Zs48dV77gPa\/7AfKYJUeMfPc17Qg8e0a9SlZZi3dz6lIbUD\/WZUH0oEf4037p6IGtOuqsjpOPr5G5SG1E727svYhYEuRNnVilVpG+DH9UGanIM9jUFYlLGAmiPXaB0d9W2\/grdlBUrXeeHBXn\/cj5uL3KVvU3PkGq2bbGQclC6oUnYR3tH+1CCf6fnxoqJOhP3B86hBPo+ne9F51kBftCC2fucBZWtnpyqvx9Gp2nm23utxlK2dnaq8HkenaufZeu9ftM7nxtjasdQAAAAASUVORK5CYII=","width":40}
%---
%[text:image:27e3]
%   data: {"align":"baseline","height":98,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMIAAAB6CAYAAADteIwpAAAgMUlEQVR4Ae3dB9Ad1XUH8C9OnD4TZ5xJ7CSTGWfi8QQnGY8zwwRjB9GbqBK9NxWqRIfQu8HYFNM7GDCmY8CIJhCIJkwVvYgmmpAAAUIgwc3+rjiPfU9PBVmf9N7TvTP7dt\/u3VvO\/f\/PObfsbl8qoUigSCD1FRnMXQLXPT4prXfmY2nACb9PA04sW1fLoGrDzc4fn+6Z8N5sjV6IMJtIvjxxyYNvpj\/Z5bbUN+yWsvWKDIbenL6x1x2zkaEQ4UvcNx3N+Ozz9N\/HPpD6hlckQIay9Y4MhtycNjlvfFN7FyI0iePLPx\/P+Cx9+\/\/uSn073do7AChkntWWlXX738pNqodChLo0aseI8I8H3F2I0IvkqYiwXNXfq4dChLo0aseFCD3sDhYi1JA+j8OuJMKOlRtnmx8tLt7c3D7Xd+5RMhQizAP9tctdR4QKtEsdeV\/6\/lH3VQCeCxmqeF8fMTpdPO7NtHHVYcwjYnXiVOT4xt53JsPGhkp7crCgEKGG9HkcdhURKnD\/WQXu8a9\/mJ59+6P0F7uPnrM2F3fk6PTsW9PSXtc8l\/qq4cQmC1IR4e\/3G5Pe+fDTNPicx5uJUt2brQhLUt\/mZV3qROuE40KEeaC\/drmriFAN8a5w8kNpyrQZ6e0PPk2rnfbI7JocWHeshoKHz7IWj0\/8MO1+1bNfEsEwsTgVSP6mGmef+N70tP7Zj31JhIoEf14R7N8OvSd955D229d2u72ZVJ0A+nZlKESoIX0eh91GhIvHvZFOv\/u1dMbdE5OJwKa+QgVwRLnxiXfS2BfeS\/te93x65q2P0ogrvyBCpd03PPfxNPrZKen2Z6akPa5+Lr1eEWG9JiLcmr5ZuUx3vfBuemvqJ+nN2japsh6nVfl+rR3oOvFcIcI80F+73DVEqED8D\/vflTX4gJMeSv9z\/IMZpP984BdDvxUJfnDM\/em9j2ek0+6amAaf9Vi6qCLN51Vdd7n8mdS37U1p4BmPpg+mz0yHj5qQNqoIcUNFmM8+\/zytUy0taepDVFZj4OmPJJON9fDS5I\/Tv1ZWYq6d704iRCFCvfnmftw1RKgadfhlT6en3vwofb1yTf5419vT41VfYWcgH1b5\/9V25tjX8pKC3ImuZlX1IV58Z9osi1D9v+XpKemiByoror9Q\/f+nikT6CE0WIYA8\/OZ02E0TGsKbXs23rH5q5YpV5Wjqa0T8TtwXIjTab54HXUGEym\/njtxduTtnjp2YvrXvmPTtfcak0+96Ld034f30tV1vS39UXR\/z\/LvpmFtemgXWakTpT6uOtT7CbpVrJM4Lk6al7S95ahYRKgvzzSqd11r7CAHo6v6\/rDrbt1UulHDojS\/O3h+JuJ26L0SYJ\/4bEbqCCJXb81+V2zN95meJezL+jQ\/TE9X20pSP06czq7VSx43LIL3zuXfTUTfPmQjPT\/oobddKhHdbOst1UFcu0n8efX86656Js0aojCDVr3f6cSFCA+fzPOgKIlQNevztr6QHX5mavl\/NIZhHyHMJR9yb7n\/p\/XTC6FdS33Y3VX2D19LYF9+bNb8wZFT6qz3uyMRhEfp2GJVuenJyuvCBN7Jb5P+\/HDQ2TfloDq5RgNxcheFUW5zrln0hwjzx34jQ8USoAPi31SiOEZw8+lMBOI8UGQLdflTuI\/Dzxfn3ihiTK2BznzauOsNGlYSRhk+rzvJqpz6cpladZe6T9fqjnpqcrw+qjxq1A3k3kkA9ChFy+87XT8cToXJH\/qOaRQZqGrxpxKa69q1qJMm1H\/y0WkpedYKXq1ZbXj9+UuImjawswXG3vZzWrkaL8sxxRZ5B5zyWbq38fr7\/kEufSifd+UoegWoahm1Hhm48V4gwXxzIkTqeCADIPTHS085Hj2v24ppIM2kmbgWEfB\/rEUDOE2pfTqrNMd2I3837QoQeI0I3g3Fxlr0QoRChYQEWJxAXd94LkwifVzOPvbqlat512qczy4M5ixuw\/ZX\/H0KEXgV9u3oFEWY9qmnGlC9dtu6TwRyGdisizNejmu3AsSSdQ4TpM2am7xxcrdexYrOQoLdkUBFh5VMeavKTZ3tUc0EA\/9lnn6Ve2j6v6lM5fmnEFdV6nWpMvm+nigx5AqmyCmXf3TLQlkNHpVPHvJqJAO9CgwjzIkAvAX1+6kIe73w4PW1xwfj017tX6+wzGRCibN0hgzZKqxo6\/rvqWYt9rn0ufVItS2H5A\/d9cdBu3w4wM2fOTEvKlj6fVdfn3vogjZ\/4ftm6QgZTq3Zq3p54fWqatX2QXp48LROgTgLYb0uEVgLUgT9jxoy0JG0zq\/qmz2ZWcitbd8mg0viff7El2n+WBUCAOr7DADQRoR4hwO8c4H\/66aeN7ZNPPknttunTp6eyFRksDgy0w6NzddzCMTzXsR2YbxAhTkQke4m89dZb6cUXX0zPP\/98Y3vuuedS2YoMugEDddzCMTzDdR3nsJ+J0EoCzMGml19+Ob300kvpgw8+aGsB5sTCcr69xSxyWbxy+fDD6lmNCs82bQHnQYi+OglciA1z3CBiCUUCvSIBeJ8wYUJ6++23G1iH+UwEYA8ChE\/FjEydOrVX6l\/qUSTQkMD777+f3f3AeiZCmAZ\/XGAydHb4Vh999FHj5nJQJNArEoBr+A5XFe77whrUSfDxxx+nZ599thChV1q+1KNJAoigox+jWwjRFy5RWAIkmDZtWiFCk+jKn16SACJQ9HAO7wiRiRDWIEgg4jPPPFMsQi+1fqlLQwJ1fAcZMhHCGjgpkmGmp59+uhChIbpy0EsSgHH4hnPHcN9XtwZBAqNFTz31VCFCL7V+qUtDAnAO3+bHggyZCHwkbpEISPDee++lJ598shChIbpy0EsSgHP4NowK7\/731d0i7AgiPPHEEz1PBAuuWET7dmFe19vdU851vgSCCBQ+vMN9JkJYA6YCS959993UzUS488478\/DYvJpk0qRJaeutt06PPfZY26jM52abbZbEW9jBhOV1112XJk6c2DbpV155JV+3zKU1OHfbbbc1zfrfd9996YorrkhXX311+u1vf5tuuOGGfHzVVVelG2+8MSehTceOHdua3Gz\/AeTmm2\/OIKlfNCt7zz33pGuuuSZJV\/nvvffe7GPX43X6MSKQBZzDO9zPRgRCmDJlSho\/fnzXVVADmD5fZpll0h577JFXGs6tUd588820+uqrp3HjxrWN9uijj6aVVlopidcaCO+UU07J67Far83P\/4svvjh997vfTccdd1zb6Iceemj63ve+l6688srZrrv2wx\/+MLdRXDz33HPTrrvumvbee++07rrrphVWWCHtvvvueTvkkEOy1ZMX4s\/JAkZal1xySVpqqaUymeKcPe9hyy23TOutt17aa6+9ctobb7xx2nbbbdMbb7xRj9rRx4gA33AO75kI7foHkydP7loinHfeeWn99ddPgwYNymul2rUId8j8yTvvvJPWWmut9OCDDzZF0+AmGvmRq6666mxEACSaHEloRJqyHtwvj7mFSy+9NBMWqGimerDOa80110zLLrts1ur1a8q84YYb5vqdcMIJ9UuN4xNPPDENGTKk8T8Ofv7zn6cddthhrkRQ7mHDhqWNNtoojRw5siluEOH888+PJLMMlefUU09tnOv0gyACnId71IcIho+if6BRRHj88ce7ziJoKK4MV2DPPfdMZ555ZlObAP8FF1yQG3mbbbZJv\/zlLzPgfv\/7Wd\/cJSDg2mCDDTIYHLMYrRaBe7HFFluk5ZZbLsf91a9+lfOR\/8knn5zTV45f\/OIXWdBNhfjij3u22mqrHPf6669vinLhhRfm9OXB3amH3\/zmN2no0KHpjjvuSIMHD57NfRFXuRGhVfPPDxEefvjhrEjsWRbDjBGCCMpXD7vssks69thj66c6+lg7wzecw7t+QhMRon\/QrUTgv2o8pAYuYNT\/icDNWHnlldPvfve7xO056KCDstZ96KFZbzQA4rXXXjvdfffd2V3iagB7KxHISV6rrbZa9pWtZGQVuB7AC0TS5zLsv\/\/+Tb58lAURdtxxx3TOOeek4cOHN+LQyNwPrhPtXScCKwXgF110UbZotPaoUaMiycY+iNBqqeaHCEcddVQ68MADc1ojRozIyiISRgSu1U9\/+tM8\/AhMyrnppptm6xnxOn3fSgTt2ZYIzG83WoSDDz44HX744bkdMH2dddZJOpECUADYaaedlv\/7AfA11lgjIQLCcJPq2hmYEaed\/0tG3BegFyziWnHFFTMB8onqx3qWVVZZJYMmzsUeERBFn0Y6fFaBq6Xcr732Wtp8882biMBVGzhwYKODfdJJJ2U\/vVXzLygRyIyrFh1qJOP2AI6ACMipvNttt122aAMGDEgHHHBAI06O2OE\/QQRtqM5tiaAD0Y1EMLKjgXT0ABAwaVwdRYGVoO1vv\/32RjPxxQHrkUceSa+++mp2g6xBiUAZtOsjuB5+fPQvpCstHa8IgANYMWoT5+0RgSal5XU8f\/azn+XLLMgxxxyTz3PR6p1lrhaLY\/mLchodQrTWkaUFJYKRJq4gxSD9+++\/P6c\/ZsyYXDb14c6dccYZWZ7qSm7cTGXullAnArw3EUGlnAgiGFLUd+iWcO2116Yf\/\/jH2R3iEtl0moEfsTUit8mwYAQuDSuACKwDEBgyjUBLzy8RaHJEJMMIBI4ccyLCJptskqMCms69IT3lJXsE0QcIIiAyV4i1iPqxGD\/5yU9Sq8++IERgMY0ysYDSjTxYOS6kQIasar2z7DzlQ9bK3A1Bu5AxXPQUETQi3\/n444\/PHR9gtNHaGijAtNtuu6XDDjus0VZcDQ1PA+pIGwo8++yzG9dpecOQrX0EEZAIcaKjHdal7rMDeDuN7X4WARHkC2C0KqDreAKUQYw6EW699dZMNNo\/6qeTp7wsi\/gR5kYEHe12wbwG0nMlpRt5jB49OveFuIfKhQj6KBG4ZazuvEajIn4n7HuWCDT6clWntq7NQ+DhTuiEAi1gHnHEEbmTijxLL710Yx6B5jYk6p7TTz89a8Uf\/ehHbfsI+hT855122qnhU1922WXZAhitMq7PAv3617+OojTtaVVuExII\/ps34O4I0mdNjBIBm3xCM+cIX\/zoSyy\/\/PIp3Benddq5MK2dZedpeH0LAwM2HWguoONw1erpKwdlcl41LK0cLAXSmkNxDyuin2XwoFvCfBOBv91NrhE\/HZDajd3rjOog03IC7c8qGB0xkWY4lZ8bwbAkwAEI4gB03BtxYi\/f\/fbbL8+0xjkjTjrsRl5uueWWOD3b3r00a7gTLMpZZ53VGG5lKdQp3CTkYsFaA3Cak7jrrrsal8ysB4EaJ6sDcfRFDHXGduSRR+YOOqvpvnaBO2kmWVkvv\/zyTDQjR9JSh9Y+Srs0OulcEAHO5+oadRsROknIpSydL4FChM5vo1LCRSCBQoRFIOSSRedLoBCh89uolHARSKAQYREIuWTR+RIoROj8NiolXAQSWOKJYKjRxJP9wgrmAVrH6xdG2gujrHMq28JIe2HUsZ6GoW9DxosidAwRrAE3Y2m21N7SghhP709BEICJIAutFkbQcFaP9sc4Ohkp64Iuc0EC8xBmjFuD5RrWC1ll3BrUaWEqitb047886sD3tFt9UjDi9ce+Y4jwwgsv5EVaJnhsJmVsC9ro8yssALAMwyTKwggaE1gnVJN2CztY4qCsGm1BAsUC7BYftgZpenjHWpt6YC0tq64vHKxfX5jHJhDlFcFy8\/qCyDjfH\/uOIoLZ3tAIGg0R6jOxZnMtBzZTG5pLA3lQJKzH66+\/3liSDJQsi0oCJkFbOmC21LogARHMGAcRpGN5hgZo1Zzyt\/rS\/dKqB6s\/zUAjtCez5NcamHpps3j1694wbt2OBX3Srq9jivJQDlbQWjPUjgjk8MADD7Qtm1WjyoYAZqODCNw38qB1nbM8ok4E+SiPVaSeh2aRhHbtUK8ruUtPncjL4kNyjqCN5UsOURb5WukqL\/UgKzPXPATLZJRf2\/ZX6CgiAFDdAgCx9T0aTCNYTObZANP7tK41NQSsAYMYlkcgkGA2XDwgsbxAPAvgrP9x7F75BRE0IHPsfgCgPZFOQBRlsfbopptuytoznknQ0NIDFssNLFFodY24JdJ1HckA2lIJwVIG\/5XNdcexhMND8eoNNOoGKK1E4NZF2TxgRLMHaKz3UTZ5ksHRRx\/dILh6uE\/aFvxZIlEnAvkAovPikoF2sOyj3g715Sjqg7zcQ2nLl5Z3D1kjgXJYnUrG1jhZtkIxkb28KDvy8l\/bqBMZWe+lTfsjdDQRaErkYJ6BHygi0GJhRgnVAzMADzRBKEBzTbCP5dYaSgPQ3tImbG4HC8AqOScAOuFLF9FofQExLXOmpaUFeGE9NDYgK3s9WKhGCwICwgUhxQH+ePhHespP+2t0+YcmBm5reVqJUC+b+\/UDENgxEsTzFMrmUdQJlbVCNG5WAAsByKFOBGVTbveQj0BrA2gEYI52iHPy1Q6xCtd\/pGAN1Z+CCxnT9LFk3DPf8orAItTbXNto5\/4IHU0EZpNGj04eIEWgcQmXYJlfKzS5FjQXDSIusMUKSIvQxIugoZhcDRJgp4loqwgAW\/f3mWwrR21Agwi0MSIAmaDRNRiwtQZEYo1s0o28+MLSEpCM5eDuWVB33hcrPF1DCPm2EsE1iwWVS9pWlCICjV7vU3A3aGYkDSUjP0FcyqGVCAiDTHFeeertwCq7T70jOGYR6it\/vVKGdREoIHVXXm3I0gnaVF6RFiswurJWEcSLh57i3MLadxwRaKAI+gehbWiNuhBoTGDWkDQ3IQE7zQxEtKxz4cu7Fo9oAng7IiBK5KcMSKaRaVyaiH8NEAClkWgzAAoiuUd5aPRWIoS2824i5EM6ZRIQIUZH3K+uQEQRAG6AlVZuRwSPhqqPclIaQCa9IHm4WeojPWVjXeoARuS5EUHaApmGpvdfGbmQZBohiFB\/yB9BlQmZw4IqnzZlwQTkRISoLxlzrSIsMUQgBH4ocAElbRa+tv+AqFGRhTYJV4fgXCNgwnWde0IrhXbhGvHlBY0GEGER5KOBuAnuQyaAEj\/IphHdI22dWYDUJxBoSQ0mb9qOH97qGnFP3MOCqIPGD9IhLRdDUBcNHu6D8sQxGUi71SKMrrSmciob4qsPkgryUc4oGx8cEZCZVQJq17gt+h+h+fPN1Y+8uCvqo2yUibzUAXnUIeQQ95A5WbHO0kY6dacEyE4++gTamTIQVxBPGyK8NqIg6mmry5zeNxV5L+i+YywCIWlAboUNcOtgos0AH+BtHsME1gjMrnMR+JZhip3jb4ZFIWSdQ+CUhvxiHoHZl77G9txBWBSNA6C0JteF1uYvCyySe5h5mk\/DtnYgAU+ZNLR0xVMG4OLWBUn9p9HDreAeAaw0aUhlbSUCUNbL5jgeBQU899LalId6hVyRlvVSdnmKF5o\/V6z6ISv1VG51AnIup3tsre3gPnHOq5QD4JIVBTf6CxfHNa4rK6oswG7vPBmRif9Iog7hMkqXzBC2P0LHEIHAgZIGqQO8tdIKHB23+jUAIswI\/tsiIFL9OqHHdcfyjyB\/xHBPPYgvb+fFd18E51wTRz6RdlyPPdCqoxD3t5bN\/\/r94uuwC5F3\/lP7WdCyqasyqc\/8pB1ZAmq7dnBd\/aOPwGqI2xrUJ\/pVdfk7lm6Up95mrXJpTfMP+d8xRPhDKlHu7SwJAC9rwaXrllCI0C0t1UXlpM2NkIW72Q1FL0TohlYqZex3CRQi9LuISwbdIIFChG5opVLGfpdAIUK\/i7hk0A0SKETohlYqZex3CRQi9LuISwbdIIFChG5opVLGfpdAIUK\/i7hk0A0S+MpEMDVu5rBsRQa9hAG49vyKhZcWflrm0fhijotOuCCCBWmWE1uIVrYig17CAFzD93wRAWOYEFPoZSsy6CUMtHWNmDyrAK1vF8HqROtGLAl2roQigV6TgJWwFgk2WQQPiXiww8Mm1vR7DsBDFtaWi1hCkUCvSYCb53FSDyY1+gie\/eUveQjCRzQ80OLpKA+QdNOKwl5rrFKf\/pOAB5I8GtxEhFbXKDrMTEdxjfqvMUrKi08CXCMGoMk18kSUC62jRjrL8VTR4ityyblIYOFLoG1nuRBh4Qu6pNjZEihE6Oz2KaVbRBIoRFhEgi7ZdLYEChE6u31K6RaRBAoR+lnQZl9N3xt46I9gstOLseTTH8HgiNc61l8v0x\/5LO40e5IIxoK9iMtHvo844ojGG90Wh7ANPGy44YZ5sqY\/8vemuM0337zxjqTWPAyFe1GWj6Dvscce+aVbhsPnN3jB1jrrrNPz80c9SQRvcBswYEA69NBD89vbDjnkkDRw4MD8ynEviVqUARE22GCDfiXCZptt1pYISOAV9WussUZWDN4ghzRbb7114\/sQ85IFIqy99tqFCDGZZqKhW+YRvLt01VVXbXrBlNc7rr766o0X7wYAaAIvsmX+60F963Mm4tU1qTfEmZbnMpiSN9EovrydjzAnInhNpHznNFPPnULodi6Vc67J16sa50QEy2OWX375Jjl4x+umm26aX6+pjBRDfDTFXrrqGqFOBJaWKxaBOxbvMI1z3brvSYsQRGh9T6Z3jgJBzI57W\/M222yTXRfuy0EHHZSBqYEPOOCA\/J7RaFivWt9rr70avrLlJjvuuGN+PeWBBx6Y9t9\/\/3x90KBBabXVVmu817+VCNL2OsT11lsvbbLJJrk88W0EeZnqP\/jgg\/M1adHg3nYdwZIX97k2dOjQvG211VZtLcK+++6bXaK4N\/bIs+666+ayI9zGG2+cv7uw3XbbZWXBYsTLl4MIXtvo3bRkEMF7VQcPHtz0uv241m37JYoIvhmwyiqr5PUkAAdQXrBLw7IIgHDYYYflNuR7b7\/99vkBJJoeUdwb2h5pvFlaGDlyZHYfvFma1vTS2\/XXXz9bCKt4uUbxwQt7PjfriiReiLvyyis3Xm7rJbi77LJL1rS0LzDvsMMOmYAaC2i9EZs1mFC91dq1dn0E+W655ZbpvOplvK3BujEWk1VChGWXXTZxHx17QfBGG23U+GBHEEHeXmVPBmE9fTAEodtZrdY8O\/3\/EkUEQAU6JPCGZ4Csv6DWG6m5T9wHbovrAAc4tP+uu+6a3\/5MqwMLYAiA6+3OEYCcVUAKrkedCFtssUV+a3bEtdeJBW4B+DUKkHJTAJmPDtgWPwJwkFF8b4hu5xohmTJ6A3ZrsKBS+YAe+KUZXwMS96ijjkp77713vi2IwC2kEFgAb+UWxDn22GPzcbf\/LFFE8K59AKDBuCdDhgxpGnYEDETQn+D7b1W5HKOr15l7FbuOJg3IDQIaIEMYARF8xyCCj4rIh\/8cRPD6dGnqtFvSXg++P7DbbrvlU4ZCjfDQ9IhH2yOkji\/ysjRAHoHlakcE8bl9XlXfGhBY+fSDaHfH9Y96IOWee+6ZbwsiRF\/Gdw6UlYJgDXxFqBdCTxOh9XtbhlL51TQ6raa\/UB9FoilXWmmlhn8M3IA\/bNiw\/FASkG677baZGFwW6QjzQ4RwjeRJi9eD0a199tknn9I3oWnD3fBMCCKwCEC55pprNq65YW6dZfUdPnx4Pat87DsI3EJk8V2Kr0IEMtK\/8O0D1q1Oytky6qITPU0ELorA3fBVGkOqwCRwfQAgvizjHE3ISsT3GXx\/bYUVVsh9h2hwbgw\/2YdHInwVIvjgBk0dLplOqeHN+OgIKxRuknJwU1yXPw2OCEEqQNZXQS5EaQ3qb9TIAycxIeYpQ1YvvtYj\/69CBGVCLv0KHx8RKATuZpQhjuXJPYy8W8vXSf97kgh8a6DnMvDtuRf89ABbNAD\/mbal3TUuQBlxisAvXnHFFRtDjc7T5ksvvXTTF3FYGaNKEYzyyJ8vz+KstdZamYiuA8nOO++cO7JGmoz+cDeAWgByebJCSKkOwGyERkBoPv2IESOyJeKz0+4Bwhyp9oMEiKTjj7COkStGzriDyoogEQwYcMsEigLxuUIRdOiXWWaZvH7fOW4T+YqL4OrE\/SJL7lO9\/xFpdNq+J4mgUkaIPGLqqSN+bPjzrQ3gE03ABYABtnocw5VcoggAIb0ArvOGaX3cMIK85E+L05a+O6ZTGkGnU9\/D57FYnVaNyaXj+wMT4kirPofhOkK6l4+vE92aRuRlP6EaXUIIxK8PxboWsqrPD+gvhDWl0eVTJxqZsmrhVrqmrCwWuSiv+9TTt+fC+smvU0NPEqFThd3t5QoXiJXVR+ilUIjQS63Zz3Xh+hjK5bbFKFI\/Z7nIki9EWGSi7v6MzG1wk+puVPfXalYN5psIfD5+I7+vhCKBXpNAEAHO9QP1ydq+8rEQodeavtSnLoFChLo0yvESK4G5EsGwFxPBVLAIZhWLa7TEYqWnK44I8N3WNQoiGCEoROhpHCzxlasTAd6b+gh1IpjYwZiYkVziJVcE0FMSCCLAeVsiGCpzQQSvfJzTDG1PSaVUZomTAFzDdxAB7vOoEc2PJU6IpJ9goZolyvXlBUucxEqFe04C8AzX8fgrvGciWGEYRLAcOIhgfT3WuIkPpeNctiKDbsYAbwee4Rq+KXx4h\/u+ViLUR46sqHSjhV8WpHnqy6KvcePG5c2CNE901TeLzspWZLAoMVDHn2O4DIzCK9zCLxzDM1zXR4waRLByEtN1mOv9BCsM3WRFppWPHuywpt0KR8tumRcbN8pmVWbZigwWBwYCg4FJ+IRTeIVb+IVjeIbrev8A7vssq0WEcI\/q\/QSsYUIsWQ4yvPrqqzlxa9tlZJNpbFGQsp+lJIoc+l8Ogb0AP0zCJxLAa5AAjuE5rEH0D\/SPMxHq7tGcrEKQwVp7idvCQshQxmUrMlicGIDDsACBUXilxIME7axBJoIHLhAh3CMn+Uz6CjGU6uawDFYlSlgGmGaLTGOPIGUrMlgUGAjMxT4wGQSA13YkgG84h3fdgj5E4B6FVaj3FepkYE6izyBhW5ACMWJTgLIVGSxKDAT2Yh\/gh9HoE8Bv9AvgWheA9wPvugX\/D8DvMlGFP11tAAAAAElFTkSuQmCC","width":156}
%---
%[text:image:5e3f]
%   data: {"align":"baseline","height":282,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUMAAAEaCAYAAACLsjU4AABqe0lEQVR4AeydBXwWV9bG+337rW+723bbrSulQKkAxd3d3d3d3Yu1tIWixaV4gWIFgsVJQkIICQkREuKOFVjv853nvpnwJiQQaEggOfn9Tsbv3Dnvuf95rszMU09l8wfgr2JNxFaInRGLE7sl9rOY\/qkH1APqgcfZA+QUeUVukV\/kGHn212yQd\/dq2fk5saliIWL6px5QD6gHCpIHyDXy7bm76We3RnYoLUaK6p96QD2gHijIHiDnStvh786sbCglFlmQr16vTT2gHlAP2HmAvCt1h4IyJyueFTtrt5POqgfUA+qBwuABcu\/ZdCDKAuvQ+qceUA+oBwqjB6YYGMqVPy8WVhg9oNesHlAPqAfEA+Tf86wis7tZh8uIE\/RPPaAeKJQeIP+aEIbLcnr5\/wwNwc0Na\/DTjEm4PmEkbn79OW6fPIb\/3r6d0yQy7Hfjxg1ER0fj0qVLCA0NRWRkJJKTk\/Gf\/\/wnw345XbDSCwsLy5X0cnrewrbfzz\/\/jLi4OMTExOBf\/\/pXnl\/+v\/\/9b+zcuROrVq3ClStXcP36dTO\/ffv2h46dPL8IPeHj5oFlhKHH\/XL1s8Dpp62bcKtrW\/y7bVOgcyugS2v83KEF\/tG2CW5MHI1\/Rl6+XzLp2\/\/73\/8aCIaEhBgAsmBZhcsC4+0HACzTi4qKAtPjNHN6hOODpJeeUZ3J0gP\/\/Oc\/MWjQIHTu3Nn4O8udHmAlf7dvvvkGzs7OOTqK5+\/fvz8aNGiAiIgIxMbGomHDhujZsye4Tf\/UAw\/hAQ\/CMP5+BxKEt1s0ALq3B3p2sE0530Pme3bEf9s3w7XBffHvxIT7JWW2Uw1SCSYkJCA+Pj4dXoQY13H7xYsX8Y9\/\/OO+6VGlUFHeKz0CkulpQbmvO3O0A3+Xrl27omnTprh82XYTvHXrVvrvdfXqVaPYMidGFZmYmAgqeOuPtYD9+\/ejSpUqWLhwoblp8Te1\/rgvj7H\/7Tg\/ZMgQNGvWzJyfcdO8eXP069cvw35WGjpVD+TAA\/GEIR9Zyfbvn2EhRhEaEBKAWZkA8T\/tmuGnlUul9fFOIGeVKIObSoDQYxDzrp7ZCEgCjhC73x+rSAQhC8z90iNk9e+Xe4Aw7N69uwEQfyP6nnCaPn06Vq5ciS5duqBbt27YuHEjqNr5d+LECQwePBgdOnQwxy5evBg\/\/fSTWd+mTRs0btwYnHIfVn2vXbuGRYsWmX3bt29vlKiDg4OE188GeArDX\/47agoZPHCLMLwnvdhG+B9Wje0VYVZA7NYON\/t2w79TUzKcIfMCgUTQEXiZIWi\/zO2EnL0iyJwWl1kYmWZ2ILTStNLLjzaurPL9JK+zhyF9T6MyY7W1b9++GD16tKm2NmnSxChy+r5FixYGhGzrmzZtGmrXro0dO3bAz88PQ4cONcf27t0bX3\/9Nagy2R5Ys2ZNTJgwAQQnj2\/ZsqU5F9WkwvBJjqDHMu8\/E4b3\/Ptp+iRbG2FWALRfJ1Xmv7dvjn9cDLxnemy\/I7juBy8qR8KQ6uFefw+aHgua\/v0yD2SGITtSCKq2bduamxzV4Lhx41C3bl0cP37cALF+\/fog7Hx8fBAh7Xz83ago+Xfq1CkDvhUr+Cy97Y\/xERwcbOKE+40dO9ak5+bmZnZQGFqe0mlueeC+MLw+YZR0lrTJunpsD0OpKt9u3Rh\/Dzh\/z7yxikylkFMYshqc3R+rTCwwOU2P574fXLM7l66\/44GsYEjlNmDAgPTe5WXLlhnAHTp0yKz74osvTFW4Vq1aYLV35syZBopM9dixY2bfpUulmSXtLzAwEFOmTDFVblafqTIbNWoEFxcXs4fC0PKUTnPLA\/eFIYfP\/Nyhua2zxB5+Wczf7toO\/4q+9+PNVAVUEjmF4f16gZkeq8I5Te\/vf\/97bvmu0KaTHQwHDhyY3oliD0M6in5nJ9aBAwcwZswYAz\/Cjn8WDJcsWWKW2ZRBsNarVw+7du0ybcysLlNpKgyNi\/TfI\/DAfWF4++RxGT7DNsOO2atD9ip3bo0bk0bj5\/sMbUhKSkJ4eLjpQLHa8zJPCTYaq1JWA3x2187qdE7S4zk4bMe+pzK7NHX9vT3wIDBkp0dAQIBpS6Q65G+we\/duUCGy7ZB\/jo6Opg2R1Wh2tLA3msN22FvNZVaj2fHCNkmF4b1\/G9368B64Lww5oPrGpDFm+EyWQCQIRSXekt7kv3u43zcnHDDL6iob3Vm9zQqEBByrv+xVvN8fVQT3pdrMLj2u5z4sZPr3yz1AGBJW7AG2OrBYjWXnCbfxjyqvatWqYDWZ6p7VYio7Ao3th7169TKdJ9yXvzervdzONNlGuG3bNjPPTpROnTqZMYTsdLHGIlKFstrMoT28cfI4wvR+HW48n\/6pB7LywH1hyIP+JQOqOY6Qw2cgvcbW+EL0aI+fZQD2rXZNcWPntvsOq7EycPPmTQQFBZmCRFCxMFjGwCa4OM3pH9sBs0uPsGV6PI\/+5Y4HqNbZuWWN3SSAOG+vvPl7XrhwIf2GxpsgfwfCzNfX964bE4dc8TdkOtyXfzyHp6en+e34+zE9a4wiawPcn\/DlDTHz+XPnSjWVwuSBHMGQDvlPchJ++napGT7DXmN2ltwWMLJq\/PfTth6+B3Ec25A4xIYqkdVhBj6N8zlRhJnPRfVBlcD0rLSs9FQRZvaWLqsH1AOZPZBjGFoH\/ic1Ff8Mvmh6jdlZ8nPaXdza\/qBT3tl5t+cgWw57uV8b4f3St0+PgPyl6d3vfLpdPaAeKBgeeGAYFozL1qtQD6gH1AMZPaAwzOgPXVIPqAcKqQcUhoX0h9fLVg+oBzJ6QGGY0R+6pB5QDxRSDygMC+kPr5etHlAPZPSAwjCjP3RJPaAeKKQeUBgW0h9eL1s9oB7I6IGn7Aco67xt4Lf6Qf2gMVD4YuApfoBJTX2gMaAxUNhj4Ck++qamPtAY0Bgo7DGgMNSbgd4MNQY0BiQGFIZaELQgaAxoDCgMtWpU2KtGev1aBqwYUGWoqkBVgcaAxoAqQ70rWndFnWosFPYYUGWoqkBVgcaAxoAqQ1UDhV0N6PVrGbBiQJWhqgJVBRoDGgOqDPWuaN0Vc2N6VT7d8NjZ1Wta0BX2OYoBVYYaKDkKlHvCUj7BGh8ThW0LR2LpmDZYPq4dVkzogJUTOuLbiZ2walInrJ7cGaundMaaqV2wdmpXrJvWDeundcf66d2xYUYPbJjZE5vFNsyQ5WldsWmmrJN5s86s72H25TE8lmkwLabJtHkOnovn5LmXj20n+WiP\/WsXIDEu9pdfo8ZJgfehwlCD\/BcHeap8JOyc21GsHtcK22Z2xsFFQ+CwcrTYGByjfTsWx1aNxfHVY3GCtmo8Tq6mTcDJNWJrJ+Lkuklw2jAFB77uhw3jmmLfV4NwcPFAOK2fItsn2fbhvjxGjmUaTItpMm1zDjkXz8lzH1w0GNtmdcGm2X0Q4u8N5vGeQNc4KPT+URhqIfhlhUBUYZyowg2z+mDLlNY4vmQAPDeMhfeWSTiTbpNlfjK8t0612Rbb9AyXt00Xmwaf7TPg98PnOL1lNnbP6Qr3LbPguWMu\/PZ+LttnmH24rzmGx6WlwTSZts1s5+S5PSQPx5b0x9YZ7bFn5SzEx8X8suvUOCnw\/lMYapD\/oiCn4vJ1c8A3Q+rhh3kdcWpZP7itHgL3NUPhtkqM0zXDjLmvHQFj62S6bqSx0+tHgeaxYTR8dsyE6+YZ2DGrM1w3TcPpbbMNJE\/LNms\/6zh3ppGWnpW+OZec05xb8sC8\/DC3I1aOb4OLfmdUHWqs3zPWFYYaIPcMkHtXLaWtMDYaWxcMwXqp2h5a2B2nlg+A88ohd+zboXAWc1k1LM2Gw2U1bQRcaWtGGnNbNwpeW6fDef1UbJ3ewVSP3QSMXlunwVW2WfvxGB5r0lgl6aSly3MYszs383Loi+7YOKklDqxbgIR4bTu89+9ZuDsUFYYKw4eE4VWkpqTg9JHtWDyoNvZ81kGUWH8BHJXgcJutlamoN9odRTcK7qIE3deL2qPi2zDGmMemsTi7axZcN07Hlqnt4LJRlKFUlbmO26z9eAyPNWkIJK10rfO48Zxp52deTi7tj92St2WjmsPv9ElVhxrv2ca7wlCDI9vguJ+KiLoUKr237bF8SC0cWNAVjssHwuXbIWlGNXhHEbqKGjS2xk4Nrh0loEwzAdyZ7TPhvGEqNk9pY1OG382UdTPgJtvS95P901Ui00pL11KI5pxUomn5cBR1uH9+F6wYVgdbvhiF2OjIh77e+\/lDtz\/ZylJhqDB8CDjYVKHzge+woFcV7JjeGse+6SNgGibteFRmbCOkKsysDO+oQpsytKlCqj6bMpwNl03TpVrbGo6iDN23zhZlODuTMhyTpgwzqsO7laEtL1SHzNvOGa3x5cC60r55XNWhxnyWMa8w1MDIMjDup3IiQoOkY6IDVgytjYOiCk8u6Zuuxmyq7I4ytNSbrY0wC2XI6q6oP+8ds2R4zTSsH98SJ6Xt0PW7WWYdt7FN0VKHGZVhZnVIVXhHGTIvzBvzuHJ4PWz5chxiIsMf6prv5xPdrspQA6swAVWG0qQkJ+HIlm\/wWbcK2D6tFU5801d6jtmDbGuv49RdqrDua6XHWOy0gMxm7BWmiRKkyfAXY9Im6LlpHM59PwfOogzXjmsBR4Gi+9bPzDpuo3JM31+OZRomrXWSXlr61vnMue3ywrwxj9unt8HCIY1x+vgPSJH2ToXXkw2v3P79VBkWJpDlwrVeFRgmxsdh0ZBGWDq4Bo5ID7LLykECP6mWGggShA8Iw40Cw43j4Pf9XIHhLKwZ2wJOm2bCfds8s47bPGSfB4XhnfxIT7bkkXldPrw+Vk3tgaTEBPBacrtAaXpPLmAVhrkAiMJUAAiQBBnA\/Fn3ivKkSEMcnN8Z++d1EpPp\/E7SkSJTqZJaxo6Vg593s5kMczkoQDq0sAcOfUnrKfO0Xvjxy144uXIUDi0ZhWVD6+OgTI+sGCfrRppt3Mfsy2N4rKTBtA4yzbT0eS7rvJyavEieTN4kf8zr+rENMbdXVQN0heGTC65HUeYUhgrDB1JHNhjGYmaX8pjdpQw+71EB87qXx3yxBTL\/ec+K+LxXJXzRqzK+6FMZC\/tUxZd9q+KrftXxdf9qWDSgBhYPrIFvBtUUq4Ulg2uJwqyNpUPrYOWIhlgxshG+HlATK0c2NvMrRzQw27gP9+UxPJZpMC2mybR5Dp6L5+S5mQfmhXli3phH5nV259KY1bWCwlDj\/q64VxhqUNwVFPe6695RhpWxfW4v8zwxnwvms8LHvh2HE2smyrPC8tyxPE98XJ4jPrV2sqybBEfpELE9fzxNplPgJOMJHeW5Y+dNM0z7oPPmmaYH2VWG07jII3nsPOE8e5XNNmlDNPvKMTzWpCHrmOYpSZvn4Ll4Tp6beTB5YZ5M3saavG6b0xNzelRRGGrc3xX3CkMNiruCIkcw7FYJP8zvivO75LnhrRNxdps8eyzPBPtunyLLk3F2xzQz9d0hzx7L88O+O2fAZ5tM5ZE7n+3T4SuDqX1k27nv5ZE72eb7\/WdyzCyc2zPHDKc5t0eeSxbzkXXcxn3MvnKMOZZpMC2mKdvMOcy57M7NvEieTN4kj+d3TcfeeV0wp3tlhaHG\/V1xrzDUoLgrKHIEQ6lqbp3cHB5r5TG4lQPg+u1gOK8YaHqVnVcOlueTObRGpmul80KGuvA5Yld5dI49vq7sYJGnUNzY0yxjDM10o4wflJ5hD+k5dls3Bl6bx8NTzI29xbLNfl8ea9JgWiZNeTxPzmHOxXPKuU0epBeZeTJ5kzyelrxundRMesErKgw17u+Ke4WhBsVdQZFTGG4RsLivHixPnvQz0HGUx\/HYa2t7EmUwnFbKEynywgSnFYPNgGw+s8wxh87yZIqrwJHPF3P8oJkawMlQHIGj65pRMtRGHsGTHmQXeXbZTbZl2FeOdRL4nVw6BDsndsOeMZ1xYkpXuHwzQM5lewrG5IF5kTwRiMyjm+R1y8SmCkON+SxjXmGogZFlYGQHxPQ2Q1GGNhgOeSQw9BKFmB0MXeWNNz+uGS+P143Fqi7N8UOTcvDoVwPu0mN8apkNhk58NPAuGA5RGGq8ZxvvCkMNjmyDIysgZoChVJPd1xCGor6MIhwg1VUqxUEyFUUo61ykyuok1WY+qse3yrjKYGxnqdq6ShWXb59hNdhMZTA2FaG7qEHXtfI0ymaBoQDRRdbx2WTuw2q0OV6OXfH1NEwbOQ4rG1eDd\/PncXnUu\/AYXx\/HpncTCMq5TR6YF75Fh2q1v3m1GAGu1WQdUpNVbCsMFYYPDUO2GZ4WGDqtsFWPnQQ8bJ9zWjFI2vKkve5bmcr7DE31WNoJTbuewNBFwOgm6o5g46N2Zipvo3GVlzBQDboJDM9+x6dOxpl17twm+\/KNNS5SrT64ahzGjZiA7vW747s2pZG66EVc2\/wmzgz4BEd7N4WLVMudmQfmRfJEhcg8EtzaZqggzAqEXKcwVBj+Ahi2EBiK8ssShny\/4L1gaHv7zN0wlA6UtWPg+914geH4u2B4fN0ELF7+OXp0Ho9eH9TF0a7F8G+Ht3HLtQjOD34Xx9rXguPnbCMUFUp1mgGG7EBprspQYz7LmFcYamBkGRjZ3T3tq8lbpwgMpbfYaYWteszOCypC02EinSTOosxc5TE9Z4ES32LD12yxV9jqDOELF9zlGWMzNb3K7Dm29Sb7bZmQBkN5O43pVJGOFFGNG9bMQ5d569Cw9ihMf\/MjnO35Jv7rWgw3\/T5A2LR34dS+Co6M6IoTC6XN0OSFbYhUqwNEGQ4zPeBaTVZ1mFV8KwwVhg8Nw21TWsrQGoFdlkNr+GbrO0Nr+IqtjENrbO8otB9aw\/ZDqkH3dWNxfusEGVozwbQpesjQGhepOu\/e9BlGLPkWZQevQt3i3bD6tbcQ3uc1\/MejJG6FfoLYRUXh1rwU9reoB4fpvQyYXeyG1jCvWye3UGWoMZ9lzCsMNTCyDIys7pxcZ68Mt00VGK6ToTIyhMa0EUrbnG2MnyhBaRekMuM7DfnCVQNDGUrjLm1+VlshX8l1Wt5cY6ZsK5TxhYTh6fUCw20T78Bw8xgcWjsFI1dtRLnp2\/FB48no9kJl7HvjZcQOeBP\/PP0xbl0uheS1xeDRqCj2li8Hh4ldJE8y1lHyZMvbQJNXqllVhqoMs4pvhaHC8LGDId9O4y8wPL15Eg6vnozv1szF5BXfosLXh\/FM\/y2o\/HFrzPzjqzj5jsCwfxHcdiyFm8Gf4MrGYjjb8G0c+LAkjgxrJ9Vzdt4oDLMq+Lru7huCwlBh+AthKENlclEZeooyNJ8a3TYFe9bPx2dLlqLlgu34cN4xvDDtGN5s\/zk6vFMWS\/\/wDFyKvYbYftJeuP8T\/OT5Ca6tLoagJm\/B4aPiONi1CY590df2BAp7tiWPHvJFPVWGd0NAwWjzicJQYfgYwPBOx4lpJ5TvIG\/dvBgjVuxEnbk\/4K2x+\/CX4T\/gpe4rUb1ad4x67W1sevbP8Cz1JuL7FsdPGz7E9QMf4driEghv9S6cPy2O\/c1q4eDYjnCSQdiu8hSMwlAheD\/oKwwVhr8QhrnVZsghNTKOcNUobP5qAkbOWojyozfj5V6b8FqHpXinzTx8Wq0P2hcpi5kvvYzvX\/sbzlUqgsQ+JXD96w9wZa3YgpKI7lQUHhWKYn+l0tjXs6nAcIAZbG2D4XBVhhrv2ca7wlCDI9vgyOpO+mg6UKQXWTpQnL4dge1zhmJ034GoWb8fPqjUFyU\/7Y5PK\/dC+doDUO+j+uj\/wmtY+Le\/4mDR1xBQsxgSe3+Aa7MEhF\/J9LOSiOsl7YaV38XBj4phX7u6cFpKGLLtUDtQsvo9dd0dxawwVBj+Ahi2yKY3mW+OYW8ye5Hv1Zs8El7rR+L4mgnYKx95X7Z8CcbPXoKWAz9HqVpDUbZ4A9R6vTTqFK+OGuVaoUWxChjz\/PNY\/tJfcbTE27hQrzgSepbAtUkCwzkf4OrMkkjq\/z4CaryDI++\/g32NquHEvF7m0cA7MNRB1wrAOwC094XCUGGYhzAcJvAcBWd53vjk+on4ce1U00myfPW3mL16J\/ouO4HmX7mg7rxTqD1qI+q0Gota5VqgRsk6qFOiOjq\/VRzTXnwR6199GSc\/fBdBDYohoXdxXBn\/AVKmf4DUaTIdXAxhDWTwdfG3sa9aBRwY2Aqnvpa36qQrQ4WhPQB0\/g4YFYYKwzyBId9nyCdPXNaPx8F1s7Bq3QrMWL8bQzY4osc6D3Re5YGWS7zQ5JszMvVE68WuaDz7EKr1XoTqlTqh+RsfYNDzz2HB317AtrfegkvpoghpLDCUDpTUcSWQPFlgOLUkUkeVQFSbovAs\/Q72f1wS39ergmMzuykMNc7vG+cKQw2S+waJvXrI2Gb4INXkkdi3ZoZAcBWmrtuP\/htc0H79eTTZEIb6GyLQcFUQWnzjgXaLnNF1mRs6rAtAwxX+qDl4LRqWaoLuz\/4N45\/5Pb559SXsee89eJYvjvAWxZHUT5ThOFGEhOH0krg6QdoNexSHb5UiOFjkXWz\/+EM4TOpohthwgPjWKaoM7X9PnVdl+EAA0IC5EzAPC0NXqR5vXvsVpq\/7Ae02+KP+xmjU2hiHehsi0XRDKFqtOY\/2y06j81IXUYmeaLXSB\/WmH0Cj+gPQ+aW3MOSZP2HWC89i9Ztv4MfiReFbuRgiWxdHcv+0arJUkVOlI+XqlBJIlLGHF+sWwfH33sT37xeVZ5XbmBfNEobbFIYa+9kIIFWG2ThGAXgHgPa+eFgY8gUNh1ZPweb1izBzw1503uAnMIxFrQ2xaLo+DK1Xn0e7Vd5ov8oHrdb5o8F8B9TtMBmt3\/0EA\/74e4x79mkseOUVbH77HRwvWVQ6SYohqn0xJA+UavKED5DMNsNZxXFtclGkDngPUY3fxun3X8O+d6UjpX1dHJvf3bxUQmGY9e9q\/xsX1nmFocLwgZTCL4Gh7fX+Y7B\/3Wf4asNm9F\/vhvYbAtBIqsmN1l1G4zVBqL\/MDzXmHEfNLrPRtERl9PrT0xj7zO8wS9oKV7whnSLvFcHpMu8hpEFRxHaRavKQEkgRGKZMExDOKIprU4viysj3Ed\/1PfiXfQNH33oDu6uXx8HhreR1Y8NUGWq8ZxvvCkMNjmyDIyuF8PAwlLfWSAfKaXmpq4u8qPXU+klYv\/YbTN1wEL02+aLN5lA0X3UODWYfQPV2U1Dvvcro9se\/YPzTv8Pcl1\/A0tfewK533oPzR+\/Dv3pRRLYqKsNqBIbDBYbj35fOE1GJMrQmcXYpxE4vh+iRZXGxRQk4ffg2dhcvhh\/a1oGrvP1a2wxVGWYV11ynMFQY5ikMrbfWnJY3XJ9cOxa7NizE4o2bMG3TYQxfsQ8DR89G53I10Pn3z2DYb36LeS88h9XSe7zz7SI4UaIo\/KSt8FLTYoiTl7omSOdJyrBi0oHyHhKmfYiwudUR8GVz+H3TCWcXdoDvhCZwb1YGB2XM4d5q8iabyZ3lFV587X8l\/Tqexv1dca8w1KC4Kyiyu3Ny\/S9VhhYMzRuuZbgNX+XvIB+G37FpEVav\/Aorpw3G500q4DN5CcOC5\/+KNS++jP1F3oPjB+\/Dt8L7uCTDaWI6SydJ72JIlTfWXBv+DhKmlkLIgno4+00HUX\/yElcZ7O0qr\/0\/LS90dRvdFMdqfIL91cpgX+d65oNQc7orDO\/1GxfWbQpDhWE+wnAkPEQh8n2GrhvHw2ntOBmQPRqH5\/bAru71sFOqxEfefB1nSr2LQOkwCW9eAjHd5KmTfiWkk0RAOPhNpI59H2ECQq+VveWbzPKiWT71Ik+\/mO8m8y3bi\/rg5MDG+LFZRextVglbRC0qDLWqnBXwFYYKw3yF4Wl57b\/1cld3ebkrX+FF1eg2tye821VCUN2iiG7+LuJl7GDCsA+ROKokkkdKZ8nQt5E8uijCPqsO3yWdZEC3QJDtkfYw5DPJ8qZr5y9749ioljjUtwG2mu8mqzLMCgaFfZ3CUGGYSzCUL9Klv+na9mlQfi70zrdP2IEyTN50LV\/F42c\/+VU8GW6TDkO+8Zqv\/ZdvoHDbWYFa6IymiBtTFjekTfDG7BLyVpqP5BlkeUvNNBk+I88jR8ysDJ\/F7eG2apBNEZov8PFD9WnK0LygwfaVPMdFfXFqTjdtM9R4zzbeFYYaHNkGR1ZKIfs2w4eEofkQVNrr\/y0YikI8I0D0X94VMd9Ux63l7+P2uuK4uVbeXbisKK5\/LtXlBVURsKgN3PmhJz7qx49NZQdD+RYLn03m0BrtTdYqclZxzXUKQ4Xh4wdDqTp7bh4P741DEb65AW7tKoZ\/7SuCf+95S17kWgyxSysi8JtW8FrNj9SnfXEvBzDUx\/EUhNmBUGGoIHwgEDJg8kQZGhhOgNemsQja2g4pP5TD7UMlcGPfh4jZUg2Bq1vDY2U\/25hFGbvIj03lRBkqDBWGCkOF3gNDL7ugsYfh9mn2X8fLxWpyGgw9N43Duc09ELmrHpJ\/KC\/TOvDb3AWe623tgmaYjlGGCsPsfi9dn\/MbgFaTFZQPBMp0GHariENLhuLIon44+EV3HPq8G378sofMy3RhTxyU5UMyPSBTbj+wQJZlun9B1\/TpwS96YJ8sH\/y8u5lyn\/3zO8u+XbF\/Xhc5tisOzOsgabfHwfmtcXBBe\/wwtz32yT5753TEvnmcyrp5HbHnM27rZJvKtt2zZVmme2a1s01l+4EFXbBhbAP9VKjGfJYxrzDUwMgyMLJTFDYYxpqnOGZ1LA3azA6lxD6R+bSptZw2tbbfmX5i9ucxd1n7tHV20xntS2GGLFvTmdzW\/mNz7Awz\/Vi2ybLZ5+7p7M5lMKtTaXzWqQymtfsQs7tV1idQNO7vinuFoQbFXUGRHQit9ampqYgMC0J4cICxiOALyHMLSTtnTqbcx84iwy6C12Bdj05zXpUsyL5SGCoMHwoK165dx7XrT6hJ3gtyodZrezi4KwwVhgoGjQGNAYkBhaEWBC0IGgMaAwrDh5PTWg1Rv2kMFLwYUGWoqkBVgcaAxoAqw4J3d3sSFQuH6+TUnsTr0zw\/GeVMlaGqgnxVBRzikpSUhMTExPsa99MhMU8GWJ7EG4DCUGGYbzBMSUmBi4sLhg8fjrZt24i1vaeNGCGvAXN1BY97Egub5vnxBrnCUGGYL2BhtTguLg7Dhg\/F9C9Gwfn8XkTFXkZMbNRdFi3rvQJPYPaXkzBixHDEx8ebarXC5fGGy5P2+ygMFYb5BsOoqCi0aNUUO7zmwCl6DdxiN2drzjHrsdNrPlq2boaY6BiFocZtrsetwlCDKteDKieKgMowOioajZvKixN2dMaRS4vhELFUbMlddkzWHwlbbPZr0qwRYmIUhjnxse7zYMpZYagwzHcYTt3UxsDwWMRyHItYdpcdv7zcwJD7KQwfrIArEHPuL4WhwjDfYThtc9scwZD7KQxzXrgVhA\/mK4WhwjDfYTh1cxv8GPYljoZ\/I7Y4k30Dh\/Al+DH0K3A\/heGDFXAFYs79pTBUGOY7DKdsboX9IfNxKGyh2BeZbKGAciH2B8\/H5E2tFIYar48sXhWGGlyPLLjupUrsO1Amb2qJPRdnYV\/InGyN2yfJfqoMc6507uV\/3Xa3HxWGCsN8h+GkTc2wK3Aydl+clmbTZZrRdgZOwcSNzRWGGq+PLF4Vhhpcjyy47qU+7JXhhI1NsS1gLHYETsjWtsr2CRubCAwb6tAajdlHErMKQw2sRxJY9wIht9nDcPzGxth8fgS2BIzK1jafH47xGxorDDVeH1m8Kgw1uB5ZcN0LiPYwHLehIdafG4iN5wdnYUNk3RDZPgjcT5Xh3W1d9\/Kzbsu5vxSGCsN8h+HYDQ2w+mxvrD3XN1vj9rHrGygMNV4fWbwqDDW4HllwZadKqAqvXbtmnjHm43hj1tfFCu9u+PZs92xthXdX2a+egWFsbKw5nulkdw5dn3NFpL6y+UphqDDMU6DwfYSJCYlIEAsJDkGV6pUwel0dLD3TAcu87a2jLN+xpV4dMEr2q1ajMkJDw5AQn2DS0fcbKvRyC+YKQ4VhnsGQ7yF0cnLC0GFD0ap1S9SuXRtF3n8bS072wVKfdvjmTJtsbalPeyw53hfvFn0TtevURus2reX1X8Pg7OysL3zVGM6VGFYYaiDlSiDd7+7MKi3fXzhk6GCMm98LB3yW40zoURwP2ITdQdOx1Ps+MJTtOy5MwmG\/b+U4Bzj4bcTE+QMMWPX9hqoO7xd\/OdmuMFQY5hkMo+U9hM1aNsbMPS2x4mwXrPHriVXnumOZT8dsFaG9WmQ1+ttz3cxxK892xazdrdC8ZVPExsTq+w01jn9xHCsMNYh+cRDl5K5rKcNevXuidK130fvzivjSrQUWe7cWENKyryLbb+P+C11byPEVULqmpNOnt775WmM4V2JYYaiBlCuBlBMgss3w6NGjaN6iGYp+8irajC2FuQ5NcgxCQnGuQ1Nz3Hsfv4KWLZvjmMMxbTPUGM6VGFYYaiDlSiDlBIbch1\/BO3LkKLp164pyFUqjfKN38dnhnAFx9o+NUb5BEZSrWAbduneDw1EH82W9nJ5b99O2xXvFgMJQYZinMGQwJicnI\/JyJPbs2YMWLZuhbN13MWlHPSz2yrq6zPWTdtaT6vU7Rg3u3bsXkZGRJp17BbduU\/g9SAwoDBWGeQ5Dth\/SbCrxCFpItfmTqm9hxNqaWOTRKkO1mcsj1tXEJ9Xflo9HtTDVbH4\/2UrjQYJd91U43isGFIYKwzyHoX1AEmxHjhwx7Yglyr+BAYuq4Cv3Vlji0wZfubUyyx9UfFMUpA2EVJUEoX0aOq+Qy40YUBgqDPMdLATi4cNH0EwUYrFPX0PHSWUwRzpKOkwsgxJlX88AwtwIek1D4ZlVDCgMFYb5DkMGpgVE9jS\/XfwlvPjG03i72EsKQo3PPItPhaEGW54FW1Z3Y\/t1BCKH3nSXnuKaNWqie4\/u2mOs8Zln8akw1GDLs2CzB19282wTjI6ONr3NnHJsYnb76nqt7uZmDCgMFYaPHWz4ei\/LcjPYNS2F571i4JHA0Br2oFPbEBL1g\/pBYyB3Y+BeUHvYbY8EhvHyrrrYuPisLV7Wq6kPNAY0Bh4mBoQr5MvDAu9ex+U6DG9cv46Rny1Gg56j0KTPODX1gcaAxkCuxUD9HqMwYvZi3LhxPdeB+Ehg2G\/SfFRo3R9V2w9GlXaDULntAFRqY7MKrfqhvFi5lpb1lXm1X+4D8Sf9mtnEz2XFv2VbWNZH5tUezAeW72xT81tl9rMu3x179j5JL+9Wubeb2u8n8+RDVlahdT982rwPeo+f9+TAsP\/kBagkAKzecUiaDZXpMNToNAzVOgxB1Q4CSYJSrLLAslLbgagosKzQeoA4ob\/NqS3741MpwKWb9cnSSjXtg8JtveX6e+OTJr3xceNe+LBh9yytZINuKC370a8Vxb9qD+8D3uDLSUx+3LgH6NfsfK7rs45Fe7981Kg7bNZDYriHxHIvKee9UKZZbwM83qx40yEU6XdaxTb9zU29z4T5Tx4Ma3YehtbD5qDfrNUYuXArxizajtFfb8eor7ZhZJqN+HIrRsi24V9swbDPad9h6ILNYt9h8PzNGDRvEwbO3Yj+czag32cb0GfWOrH16DVzHXrOWIse09egezbWTdYXVOs8eSU6TVqJFqMWo0afz1CscT+8XrUtXqvcKoOVbNAVn6\/cgouhEUhOuYrUq9fUHtAHyanycgmxmLgEOHn4oOe4OXi3ZocMfs7s98K2\/LrE3etVWt9lb1Rtg7eqtcU7NdqjSM32eK9WB7xfpxOK1+uMDyQ2CUjeXAo8DLtP\/sYAcIDArM24pWg4ZCHqDfwcdQd8jjoDFhir3X8BavWbj5p950mhnofqfeaiWu+5qNprDir3\/AwVu89G+W6zULbLTHzaeTpKd5yGTzpMxUftp6Bku8ko0WYSirWeiPdbjsd7zcfh3WZj8U7TsXir8Wi83nA0XmswEq\/UH4GXafXsbbgsP\/lWvM1k1Bn8JZqPWoJiTYbi6Y8a4o8l6+APH9TBi+Wa4Uen07jx0y3cvHkTqTJmL0EardUewgcJCfJM9BXcvn0bSSmp+Pzb7\/Bc6Ubi57rG3\/R5wTZeZ0b704f18MzHDfCXUg3xfJlG+OunTfBC2ab4W\/lmeLlCC7xaqaWB45sCxLert5MbSCGEIdsMmw2cIepukzxfugINBn0h4JuP2v3no0bfuTbg9ZmDamJVe89BlV6fCfhmo1KP2ajYYxYqdJ8lAJyJsl1noIwAsFSnafi4vQBQ4FdS4FdC4Fes5QQUbTEeRZqNS4ffGw1HGfi9Wn8kXq47DC\/WHooXag3G8zUG4dnqg\/DnagPxjNjTVfrjj5X74fcV+z7x9sdK\/cw1lWw3BfWHLsLfqnbF\/xSpjv8rWgPTv15rVCAHLsfExJjBzBzIrPZwPqAP+R2Xmzd\/QkJyKjqNmIFfvVcd\/\/Nu1QJv\/yvXyZj6TbFa+G3xWvi93GwJx6c\/qo8\/f9LA3BgUhpkGLbM3mTDsOO5rtB7zjVGCdQSCBCGtpsCwhqi\/6gJCWjWBYVWBYRWBYWWBYSWBYUWBYQWBYTmBoVGDAkOqwY\/bT8aHbSfhgzYTUbzVhAxq8O0mo\/Fmo1GiBkfa1KCovr\/VIRCH4K81B+M5AeJfBIQEYkGCIYH+O7E\/Ve6P91pMQJlOU\/F\/xWpL0NaE2xk\/owIVfg8Hv+z8xu82X71yFU5evgYOT71TBU8JEAuyKQwzge5eY3SsbRYMGw+aa6rFdVkdVhjmiQL9owCRzQO\/er+WgaGP3wWjZLIr1Lr+4SGZEB8H34BA\/EZUksJQlWGW43wIw\/6TRQH2nJ7WPqgwzMvq+B9EJT5VpIapynj7nhcYxmq1+BE0DdCvZ876qTLUanL2zzhaMKyRTzB8tcEI02HykrQZvmDaDG3V5L9UH5htNZnVzN9W6IPflheT6e\/ELIClr+e2NLO2cT9rHfez1ufrVPJhg2FNU1hjY2MQFRWVL2avPO3zwPX2bZjWtuzWc7t9Wpy3jsmvKf3qdfacwlBh+PjCsJi0JX6Q1snyXvPxeLX+cNNm+Ia0JT5fY3CWbYZsbyM42bvMdsZnqg5IBxuX2RtNuL4i2znP\/f9QqS+el7ZIq0eax3N9voJQoP77xwiGERERuHjxIji1oMVvl3BdYGCgMc5fvnzZfNMkq\/U8jseEhISY\/YOCgsw811lp5sdUYagdKFlWja32Qk7zUxmy88QzIByxSVcREZcM\/5BoGb\/4nelQ8fAPM0N1\/iC9r\/YdKARYy9Hf4KDLOYREJsDdL9SMdSQEqfxOngnC5bgUpF67ieiEVETEJqO49GZ\/LEN71u93QVBEHILluAMuvmgyfJH07A7IoCzzHI6PCQwJuG3btqFZs2b47rvvDBCpBoODg9GoUSPUq1cPjRs3RufOnbF7925cuHABDRs2RP369TOsDw8Px\/HjxzFs2DCTVvPmzTFixAizLj+BqDBUGD72MLx4OR7tJyw3Yw6bj1gER58g0zMdEBZtxi9mhmE9GfZzzDMAnWQQM9Vjxe6fyfIFM9j7uZqDzPAcjlW8FJMkveELzPLTVQYY+I1bvNOMa3xF1GdbGUd51N0fRWXIz6\/L9co\/hfgYwJDV2NDQUIwePRpjx47FyJEjDQTZC0tFSOB5enqaeYKwV69eOHPmDBo0aAAvLy+z\/vvvvzfrfX190bNnT2zcuBH+\/v44f\/48Nm3ahAEDBhiFmF9VZoWhwvCxhyGVWv3BC\/EXGVfIau350GgZ2zgPfiFRWcJw40E39JInWViF\/k353lL97WeO3+t4FsVaTcSvyvYUpdcXhGzpTtPxv2V6mn2oIDtP+Vaq1UOlWm1rj+S4xnwfv2gHQy+fc9I2Jy9KlSplXpuHhwc6duwIV1dXdOjQAW5ubqbdjzCkAmR1N14GgBNuVI\/cn4qRVWWu9\/PzM+sJx3bt2uHHH380QL106RLCwsLMflb1Oq+vjeejXz19dGiNjjO8x5Cb\/K4mE4ZGGcqAbA74PiHV3HJdZhgo8smWzMrQNzgSFXrMxv+VvaPmWI0+J+vLdJ5h1vMYwvDTtGVWfVm1dvS5iP1Ovpi2Yg+aj1yMv9Yakr9V5ExthvkBQ7bfEVgrVqzA7NmzjcrjdPny5WY9YUgFSGUYEBCALVu2oG\/fvkYZEpKEH9ezas31rD5zn06dOpmq8pIlS3Dw4EGTVn5A0DqnwlCV4WOvDC9cikVC6nVESjsf1eAAeab5Ven0uHApJktl+LAwJCDZqcKq8xB5lnr3cW+MW7TDdMTka89yPitDwpDqjlVfQuzcuXOm7ZBVXapBbqtevTrq1q1rFGLXrl2xf\/9+UwXmerYlEopcv2\/fPtPWSAVIQB44cADLli3DkCFDsG7dOrA90YJTXk8VhgrDxx6GVIbtxi9HEXlOmc8qs6rMx\/GCwmPlsb85psrLR9isjo2NB9zQW176YF9NrivPT+896SPVZFv7X1bK0L5KTCX5ujwKeOZChHle+td2KtM6T55N8xmGBNexY8dQp06ddOARfLVq1YKDg4NRepYyJBxpFuzs2wwJTfZCcxvnLdhxHavUbdu2NccSvta2vJwqDBWGjz0Mg6U623DIl\/L43eD0cYaEYbBAsunwrw203pSnNN6QR\/f+JBCrLeA74RVo3gDDdVXk8UAHjwDw5RLsQOE4QsIwJCohvZrM5V3HvUxV+TWOa5QXQLAKftDZ1zwi+OtyvdNhm2cQZBXZvposj+OxTSs6OsoAhVB51EYYseNk7ty5YHWW7X6s5nLK5Xnz5uHs2bNG+VHpsfPDAhiXCUPubw84VqvZWUKQch92olAxDhw4MB2Sj\/q6skqffvXw1jZDbTN8jNsMvS6Eo\/6ghab9zno2mTD0OB+GmMQriIxPMcbhMh\/Kyw3YadJYIEklSJC6+IZgqLxGzBpaQ8AQfky3lLwxx2pb\/FTaIZftPAHfoMsIi040bYc15e07HKrDQdx5DkHrnJYyzCcYUsUNHjzYQM+CGqeEINezTbBNmzYGbFxP0BCIhGDr1q3NlMsWgFgVJgjZK92qVSs0bdoUo0aNgrOzc\/o+1r55OVUYqjJ8AGU4LV8ex+PbbN5sNNpUjy0Y8kUNHIPIFzlwG+f5pIoBl8CDz\/Sy8+OlusPxoukdvjPo2oLaC7Kd+1nLBORzki7bDTnw+gV5IUS+9yQTiOV72Z5AyQcYEkasxnIsYVZgsqq+1tR+Hx7HKjOn9uvt06RKJDSzOj7zMY96WWGoMMwhDBegWrdJqCev7crrFzWw2mreYSiAsofhs\/I4Hp8seVrMQEueILHAxql5tE7AaHscL+M2bs+qUyTjMY\/H43i\/\/bSLwLC6eTY5r6vJFoDslZ21jlNrvTW132a\/PfN6axuPsyyrffJyncJQYZhDGMp7C\/Pp2eTC+Aove6j\/vkLvdGXo4X1W2t8ijdqi4lLLPR\/Qr6fPnNVnk\/XZ5Ps\/m1y9x1TUlVd31ek3F7X7zkEteXchrUbv2ajeazaq9ZxlrKpMq\/SYicrdZ6BStxmo2HU6KnSdhvJdpqGsvJuvTMcpKC3vMfyk3UR81GYCSrYahxItx6FYi7Eo2mw0ijQZhXcaj8RbDUfgjQbD8Fq9YXi1njxnXGcwXqw1CC\/UGIjnq\/XHs1X74c+V++IZsT9VlMHVFXrhd+VkQHVBs7I9FIZ5AH6FoSrDHCpDWzW5Tt\/PBISzBYKzULO3zar3nCEQnIGqPaYbq9J9Gip3m4ZKXacKCKeiQpcpqNB5Msp3moyyHSehTPsJKNVuPD5uMw4fthqLD1qMRvHmo\/F+s5F4r8kIvNt4ON5uOBRv1h+C1+sNxqt15cmTOgPxUq3+eLFGP\/y1Wl88V7UP\/lK5F56p2BNPi\/2xfA\/8vlw3\/PbTrgXQWE22vcJLlWHuKcHMqlphqDDMMQyrdpuA2n1molbvGajZa7qpNrPqTMVYrftUVO02xViVrpNRWaxSl0mo2HkiKnSaiPIdJ6Cc2Kftx6N0u7H4pM0YfNRqNEq2HIkSzYejWLPhKNpkGIo0HoJ3Gg7GW\/UH4Y16A\/Fanf54pXY\/vFJLBkTX6IMXqvXC81V64tnKPfDnit3xdPmu+JPYH8p2we8+7YTflO5YAK1DepuhwlBhmFtv39Y3Xd9jCI39m2rs522P4y1A1S7jUFsgWKvXNHnR61TU6DHFWPVuk03nStWuk0Cr0mUiKneegEqdJqBix\/Go0HEcyncYh3Ltx+LTdmNQus1ofNJqJD5qOQIlBYQlmg41Hz4q2mgwijQchHfqD8Rb9frjjTr98FqtvnilZh+8UqM3XqrWEy9U6YHnK3XDsxW74s\/lu+Dpsp3wJ7E\/lOmI35Vuj9980q4AWtt0GJ4+4yMdDpfNkxocoqKWez6gX929fMwbxfVN1\/qm6yxVImHIb6BU7jQaNXtMQo3uk1C920RU6zrBWJXO4wV+4wR+NqvYcSwqdBiD8u3HoFy70SjbbhQ+bTsKZdqMRKlWI\/Bxy+H4sPlQfNB0CIo3HoT3Gw7Aew0G4N36\/fF23b54s3YfvF6rF16t0ROvVOuBl6p2x9+qdMMLlbrguQqd8JdyHfFM2fb4U5l2+EPptvh9qTb47cet8euPWuJXJVsUQGuOp96ugl+\/X0MKq7fC8BHdBAhDN09v+UhSdTz1ViXxeeWCbfKNl\/8tUs18FIqxZT4KVaJ22keh6uEvaR+Fer5MY\/lCXhP8rVzztC\/kySdEK7fGm\/IZW\/OFPPlk6Hu1OqZ9LrQLPqhv+\/70x417yveTe6JUE\/l+snznO\/37yfLt5HJpH5kvLx+RLyPfUX+iPiI\/cvYiNOo7Gc0HzjRfyWs6YDqa9LdZo37T0LDvVDRIs\/p9pqBe78mo20s+edlzEmr3nIhaPSagVvcJqNF1PKp1GYsqncagUsfRAs2RAswRKNt2BMq0HoZSLYfikxZD8FGzQSjZZCBKNO6PYo36oVjDfihavw\/erdsbb9fphTdr9cDrNbrj1erdBJhd8XLVLgLMTgLMjgXSni3VSIKxGVw9zpgxe6oIc08RWr7kMB6X017i56Z4Vj6VWdDNQE4+Bcq4ekk+BfpKRbtPgVZrg3fkU6B3vovcEcXqdkaJ+l1QsmE387F4gq60fCj+U\/lIPD8QX75VX\/NR+MptB6Jq+0Go3nEIaojV7DgUNTsNQy355nrtLsNRp+sI1O020li97iNl\/XAMm\/H1k\/EReVaZIyRQQkLDEBoWbiwk7BLSLVTmM1iY2Tc4JAzBIaF3TI6\/KMv2FhQcAtrFYFkvFnRRlsUCaUHBuCAWeNFmF4IuyvIdCwgMQga7EAT\/AmuBCLgQaN7sYhVeneY+EPl2HvrZvxAZr9dmQbggZepCoJQxmpS1zGXPWub0oim3LK\/BxqxlU5ZZ7jOVd7KADMls3I98sW+ay635p3IrIft0+BJPPmrFZ08zG9dnZ9aAWk6tfcw8l60Bt+IIzptlmY9Uu9sHUoVjNS5zD6gu536HCv1cKI3lLrtrt8okt6fN25dZaz59msaErMq\/xQH7Kb9dbc+b3Jp\/JDDkRVGJZFf47qdSeMe93z66PfeVjvpUfZqfMZCTck+mEIy5BUD7dHIdhlevXjXPj\/r4+OBhzdvb+6GPfdhz6nEP\/3up79R3uREDOSn33IfPp5Mz9iDLjflchyEzlZCQAFaVKWczG9erqQ80BjQGHjYGyJfcgF\/mNB4JDBMTE813LPgtCzX1gcaAxkBuxgD5khlkubGsMFRg6w1LY+CJioEnDoaUslmaUD0hNyxB0snuHIVlfW74kWkUFn\/d4zpZwHLD1Je5VL7vEZdPPgx5cdKGGC+vPoqXLvdfagnyQfLCG3jiS2l7zR1fRkpahdmXCaZd2zYEjMPBsjMOE8tum7U+2qRVeONSBBBjSUaTJEgZNxYlU3uz1qdNM3BAhuFw2XZclOGFEU6ZbmJPPgzFSXFnPBC7bxfidm5G3K5fYLu3IM7xGBLCwwonEKVQxp12Reze7b\/Mj\/wN9mxDnMspWwBmCrrCUKgJQX7A\/vDRozj4449Z26EfsW\/\/vqy32R1z5KiD+bxBTCG9UcdfCkPsyaOI\/X4TYnesk9hci4QfViNx3yrE7\/4Wl75bjsgtK5C4fSUStq5E3OYVCFm\/DEFrlyNm\/UpErxPbsBoxW9YhhnF55rS56WeOwycbhtImE3fqKBJPHMaNyAjckueXb924kSO7\/dMN\/F3Mfv+bKclI8XJH3KG9iA8NsVW7C0tBlptKrMNBJDsfx09xMRn8Yu+jnM7fTExAipsT4g7vswHxHtWTzEH5JC+zQHG82iknJxxzOo2TvmE45R+Jk+czGtcd9QnBmm17cdIvwuyT3X4nz4bAwckVLi5yoxLl\/iT758HyLjWVsFBEyM3Ze+d6XA48imvRjrgZdQo3L5\/E7YiTSDh3CD9uX4tzR3bglq8Dbp5xQLzjQRzetAaOWzfjyoljSJKvKsY7HJP4Po5ouclE7d2JuJNHkCD8sM\/PEwXDpKSkO+0vMh9\/1htJLifxU2I8bt26LXYrbcr5e9jt20i9eh3JV67hp5tyjCzbjpX5mzeR4uOBeCnIiXJ3T7Q\/pwQ6HVbgTIAf7+WBJDdH3LqSitvij5vih6z9eStH25gGwZns4YJ4D1ckSlNGgfNbFrHA3k0fn7M47uqBU+cv44B3BHZ5hGGLS0hGcw3FppMB+GbTbuz3CMYBr1Ds8wzNsM9WOWa3xyUc8rksaUXghIsHzskXAVmAC7wvWe6k\/CW4OyLo2G5sFeDt3bMBcREn8FOCE26J3Y5xQnLwMTge2gqvo7tw64KwwO8EAo\/vw+bVogZFJF0VPlxxckTySUfEHT+Ji4ePwH3nTkQf3IsEX+8M5Zt8yY3e48xpPLLe5HSSSyDGysVeCfLHTSl0LLw5tdsCzQ0HTmP+xqO4HJOIv0vBvR4Ti+vSeXLzp5\/wU0oK4o8dQrzclbJqW0jPQ0FRjfEyblNU4XWpJls+5DXeyMKvP4l\/HmTbDUkn7ugBad+Rthr5zQqc7+xigIDid49PnnLEqXOh2OMRiu2uwdiWpYXgO8cALN\/6Aw55heCwdxgOnQnLuK\/LRWx1DsI2lyBJKwQnvQPh6OhoemgLsh\/NtTFWpHoc7bBXPqfrhsDwU9KksAW7dm7A5WAHGxDjnXA14hTOOO6Bww9bcCvYUQB3DA67t+HY99tw3Uu2yw0+2fEULosyPLXze2xeuxb7tmxB+OFDNnVoF5P8\/TKDLDeWHwkM71KGJ44gXqq0V+NicUNgyMKbEyPwdjicwZKdjogUGN6U6nL8gQNI8fTCdRnczbQSBLT8MRKTkgv+XThBqgsC\/xvJSbghvqEPqXCuXbuWpT+z23Zdmim4jdP030HSiBcYJgpoC7rKZnzGSnPDCYHhEZ9L+N4tGLuytRBsdwrA2p2H4B4YCc+L0XALjMIu10DsdLHZDtm+8aCLmLOx7w4KZE9JO6wAuOArQyl38vhs9LG9CEr0QGTSaUSIEnQU8O2SNukgv8O4FuuEGzHOuOB1CAd2b8XNMBeEehzG91I9jjrtgCtnnBDtdAIue\/dgx8aNOLB1G\/xFGcY6uyLm5AnESxm3j8knShlmhmGcNKpevRyB61J4WQAfxK7IYzepV65Kgb+OVHlLRtwP+3FV1Mt1gQHTSzjlYDpS7J1VYANQYBgvN5ZrSYnpvrSAd5dPCUopjNfo7yz8ftdxcnOJP\/4jEkUxFXRf2mAYi5OOTjgoam+Pe\/A9LATfOwvs9hyGZ1AkvIOj4REUhb2nRQW622y36wVsOewm5mps22FnOEmVr3DAUKrJ4ZcQdeIAAhLO4JIAMTZFgBjpiP37t2PHju9w2nkfUi47IzzgOPaJEkwOcYbnyX1Sbd6LOJ9T8DiyH7u2bcH2776Dx\/4D0qTmhmRXdyS6nUasKOy4kw4ZYvKJgmFycjKYYWMyHyfUT5GeXxZMqpgHtevX5RhJJ0F661J8z+Fa6hVbWpJevKSdGBGOJPtzWucuaFPp7GBgXJWp5UtCjc9pZvCpgI3+ipMhDlelSnFNlOS11NQM+\/AxyQzHyXYTdKKYCrovGZ+8\/lNOzqYdcL9nCO5lP7gHYtuB4\/AJjoJvaAzOCBAPerH90Gb7PYKw67hHun1\/3F06UVyMKkwvBwUtFq3rYbmTlydEnjoM\/4SzCEs8g+hUL4RFuuC4tAme93OAw9G9OO6wD37eDjh2ZC\/8vRywf+8unPhRmh72fo8TB\/chwNEBTgf348iePYhydkHqaU8keXghztlZ1KFDhpjk75cb1eLMaeRJNTnG1RHR0iuUItXkq6LwWAgf1JL9ziNeqjUJkdKmlZRinHFVwBojw0LiBYYFXc0YtStKL9rpOFJlymunD1mo+aOm+1MC5ar\/eVxzPCnVXmmYPu6Aa6dO4KrfOVwVRWntx95O++OupKaYtDl+szD4Mk6u31kUyI+ewfhR1CHtyJkQHPMJNeYgPchc5vqDpwOx+\/Ap+IREp8PQwSdMepnTzDsYB1287pizB9zc3QuNMkzg1widHOAf54fgeF9EJPviQpg7Dh\/ej\/hEL2mS8MAZr2M4KNA7eOAHAeJ+7PthD05Jk0+YjzOuBHrimr8XEs64w+3IYRyTprDLbm5IOeONOJlGO4rgEfhaNb4nShkys1bGeRFRbs5IlsGUrPJmpnHm5aumYGf8FGmK9FbFSXd7Smgojridx3YHL2lDZFvZVURL2vHyY9g7K\/3coooK1LxAMMr5FFKkumz5klBLFVVn\/CggTPXxRqqzI1LP+SL2QoD4LASp5\/2Q6iLrpCf6Slrjc4bjxOep0hnFtAsTDF2lGnZUgHfUOxTHz4bhbKgM+k2OQXyKfKw+IUyUYLCsD8Vhz4vY6+CMEzL85uQ5GYLjdwke0n5omWfQJfiGOYs5GfO56AQPDxkjJ79XgYq\/rMqTlO8EaQILdzkBv+hABMYFIjjOH94XTuO4qL2oZD\/EJJ1DTPxZeQGzG44cPYQjhw8iJMAFV6K8pflMLMwb14K9EX\/OE+7Hj+Hk4cNwOnoEkZ6eSPDwQLSLjBixY8oTBcPM1eQoGSDMdgUWWsuu2M1b6zhNkI6Q+MQkpEjhNOv5A3h4IvHsWaTK\/CnpqTvg5IuoWFYPr0gDrKsZH1fQq3amuiXXH8kbi1SNUwkw8ReVofGVgDDF30\/aWpyRcinUqPBYqSYnSw90Ck1uGMnuLkg5Z\/Nj+nFpv0OKHB\/FYUqi3guDL9m8cFoK2wlRgKcEcOcvRckQrnikXI1FYqo8JZUi7WCJF2X9RdnnIg6ddIeTQNDpfDic\/cOlqhyVbt4hEfCPcBdzM+YX5oYz3l4GhOZ3k4JcYKcSN4kSZyHOJ+EV6Ifz0SHwjw6Gp\/8ZuJ5xRYj48FJiEKKTAxARdRaOUrNxlHb+874Cw7izuBrri6uRvrgWIYrSzxNuUouJ8zsD\/9MuMn8Slz3cEe3umiEmn6hqcmYYRsqTJ5elECdJFSyFwBPYxSckITk5xRRkFmYb\/FLg7B2EQy7nECmwS5WqW9J5fyRI73GyKCAea9JmwU87JtJT7sDyiF9hKMBJhKGHG5IIN\/EFfUCo0SfJbCoQmCUHXUAy10lhJwyT0ua5nBxyUfYRmIaFgNVEHmf5MVkKbORpNzPOMEluSAW28KaBiTD0lGqYswytORscgYRk8dkVuRGkypi5lMuISw4TRXMRl+MvwPtiII7J2EG3gHC4X4jA6cDL8A2JSbdzoigvXPYU8zDmf8nDvI+TqrCg+5HljsOxAp1O4ZQMNnfne0wlvk7L2EAPf18ExIQiMOYiQmMvIDDkrChmF4SFesPL0wVBAZ64mnAeV+PPS83RD4G+HvCThymuhvkj+aIsCzdOS6\/8JU8ZWyvnsXzJuM1co8yN5UfSZsgCZgqoZDpZ5qM46FqGbFDNXJHBwh7nQ3HC8wKi42zvJbOUIbd5+Us1RNRfjGxLFTWTIAGbLM629sk8Zdoc9MnzpJ+T5y2IJgU5ShRHslS\/LGXIQk31l3j2DBL9zooilBuOVKNp8eJzowzTlqkQE\/3PIdHb0zwDmpJyR6kbZShpJzG9gui7TNfEKuzZc37wCQpHdGK0QFA6jgSEianSJp0SITC8hNikENkm35KJ8ReVI4VcoOkTctlUp\/3Do2BZQMRlBEf5pltQxFmcl6YJFt4C70spdxyBEO59BudCpenAxxfuorhPe4md8YKXrw88zsi8NBu4y83WP+CM3ICDcDn8HLy9ZSjOJbZlyyiRSH\/4ynJ0iB+uRAbiyuVAuWlfwGU\/b0QLWO3LN\/mSG\/DLnEbewFAa76neeBFUe76Bl+B+Lhix8VKo0xROukIRtUhlkiwBlig9x5yyoFrbM0+j\/Hzlx4jJ4KwCG4CEoe9ZJElBtpRhvCi8xKAAxPuekZuG+FhgZlk8bxKsRtutS5bAjT\/njRhWqZmO\/Ca0ZOlxttIusP6zAyJV24XACwiPkfbmFBlbKZYgbYVUhfHJ4YhLojIkDKXgxgbAVwpxaLQ\/wgSMoTHnEShtXfYWEh4Iy4KlEAcEBBQeGMoIhHCJy8DIBFyIEMXsHwhvadbyCwlBwOVwXIwKlw6VIJw7fxZxidKEkxIiZTpYvtwYAL9zPoiKCMDlS\/7wl5v5lbiLSBUlmRotFhWM5NAAxIrCfKJhaBUyFtoYCbpo3ilZKE1V16bi0vdJK5C2ZQGhFOIkf2n8F2V4LxBy\/xjpJGBV0IJD1mlmrI4\/sftIYY4OkCqEBTEp0HHBgYj380GyDF0ybYOWCpRpogSppRLtp8kSoDESeAlS\/UthWrzZWGlLmk+sfzLE0b1\/c6q2sEshAj4CMFJgaJvaYGgpQwFiYggi44MQGCxtWrFBiIijBQoY\/ezsPMIjQ9LtUkQwgqXzhTeVAu9LKc8sf5H+cpOITsRFgaGffEHvgnwZM0Rqd2ESh6Gx0bggcRoaHiz+FpEjyjspJVz6B+RbRxHylUoZ\/RB8MQDhYYHSLxCGK9J5dSXeZsmRFxEn2zKX78yqLjeWH5kyTA8CcVasBEaOgCXBkywqL0k+K5gcFZ0BhLY2g7uDK\/bixXTIpp\/zAQrFE3WM+CcmKBBJ0myQxFcdhV6UHuPzSBS4ZQYh4ZcdDE0VWtoYEwLPIyEkSNKSzhUJWKbNtsMnyicP+VtTCUdcDkN8kkCQQEwzFtb4ZIFhEtWhVJWlcEbHByPkUoBAMTTNBHyxgXYWhMjoS+l2OUo+kysjHwqDHwkpipyooCBcioyTT\/vKJ37lU8CXYhNxKU4sPhFhIm6CgqX9NVZedSZNEjGJUYhJkK9cxkbgcqTsLzflIIm98EtSW4wOk5u9iCCx1ETGZRjipBOLTTr2\/swN+GVO45HAMHO7Xrx8KY8Oy7w+wzLvotGiZKgG5U6TYZs4\/FJkLC6G8+kIaTyVZWt7nDwKlCxqxlou6NO4MHltmUAwUSwp4pJpr2Eve1ZmfH6PbRz3mSQgZVq0OBZg+R0Kug95fSxYUdFUKRJTGUyqy8k06VEmGJMiBIiX5ImKEJleTrfoBHkEzbJ4UdpxUsDTLDo2UqqAlwuFH40vJcZizPeMo3BJyjofnY2Mkw45AeHlmDhcEl+ESTkNlym\/vsf5MBldEi435EsyDZOYviQ1m9hYft423FhszGW5MUszT4LcqKSanTkmM4MsN5bzBIYJovISxBHZqg6qEfY0yx0kJRtlEh2bgIjoeNOeaH+H4IskeUxmZxXUZXO9BByvWcx0pqTNW+us6QNtkzRN2gKJguo7++tiDMVKZ1NiirS5ZjBZJ2MNbSZxK2CMTxJFI4UzNi7aZvFSSFMT0y0pJUFAKIrH3iSe7c9XkOdTRGXHSvmOknIeJYImWgDI6Z1lmZeyHSN9BDHSLBMr8UqLkdoL3ycZI78DX5ybnCLNaCl8axI\/lmVbFyvrE6SdO7P\/cgN+mdN4JDDMfBJTKCX4Mq83Co8FWRzEAszlu\/YxPdAZB2Hb72PG3GWV9n2Os0\/jSZo31yvq7QqvWSzVbt5aZ00fdBvTfpjf4Eny3528pkotgx1R0kZqZ8mpCQI5e5PedSmkCYlSSGV\/y1KviO\/tzFqfPpWby51zZR+\/BWEfDthnMxh76BPkjVIcOmdenJIsPpbqbaI8MWYGoMt+ZpnrJG75diQOpk5KkYHbbLtOFRZcsTNZTuZvJI+f5oWf8gSGdNZdF0Pwcb0dAE0jqd3yXcdkAbgs085iv5yk9STsk\/l6ecfMLt8Pui1z2tmlW1DWG7Uhw7lSszMZ+cDRD7QUM73TPMNhYPaWWbncy\/cFxX\/218HYueMDPhCQ2SzfWevTltN8T6XO38Hep9Y8\/W9\/rkc1nycwfFSZ13QLtuLQ31d\/37yMAYVhAVaReRlIei4F15MeAwpDhWGeVEGe9IKi+S\/4sFcYKgwVhhoDGgMSAwpDLQhaEDQGNAYUhgVf+mv1Tn9jjYGcxYAqQ1UFqgo0BjQGVBnm7I6hd1b1k8ZAwY8BVYaqClQVaAxoDKgyLPh3O1U0+htrDOQsBlQZqipQVaAxoDGgyjBndwy9s6qfNAYKfgyoMlRVoKpAY0BjQJVhwb\/bqaLR31hjIGcxoMpQVYGqAo0BjQFVhjm7Y+idVf2kMVDwY0CVYSFXBT\/99BNu3LiRrgwyLysEHh0Erl69imvXroFT9fOj83NOfaswfAxgePPmTdBy+qPl5n6HDx+Go6Mjrl+\/bs5vLbOQZnUe5pPAzGrbo1p369Yt3L59Oz2P1nkIEWvbLwEKryer9K3z5PaUeeX5+LnSKPnSIZfz6\/fP7Wt7ktNTGOYjDK0CPHbsWEyfPj1XVALhQLtfUPLcfNV6mTJl0KpVK1M4uVy6dGm0bt36rjSs\/YcNG4Z58+blGIg5zU9W+eU5+W2MIUOGmDy5ubmln5fb+CH4QYMGoVOnTvJFtQjjv6zSudc65m\/79u0m\/ePHjz9yKDHfsbGx6NevHypWrIhixYqhRo0a2LNnz12wv1e+dVvuK0mF4WMAww8\/\/BBVqlRJhyGrrVRqVGeWarRXaixQVDMsyNzOZRYOHrdx40Z8++23Zr2l9nhs5v15DOH36aefGhBQqVhwbNOmTbYw7NWrF6ZNm5YOpazyauWH51+zZg3WrVtnYGt\/DdxmXZuVz8wFnPsTHG+99RaeeuopjBkzxqTD\/XjskSNHzPr\/+7\/\/Q0BAgNmWOS0uZ15nnYf5pFWtWtWk06VLF5OutZ1T6\/qYBs9JP1rXZ21nPrPbzn15HH8rHst9qQYnTZqE1atXY\/369ShXrhzefPNN89F5+7Tt86HzuQ+\/zD5VGD4GMCSQateunQ5DX19fU7ipfH788Ufs27fPKCQWJKuwnDp1Chs2bMDBgwfN5xZZGAMDA1GqVCljTk5O8mHuIFNIWfioeqz9mS73fxAYWoHj4+Nj8sa8cJ23t7c5T7x8WY95OXDggKn+ESLnz59H8eLFUalSJTg7OyM4ODgd8PzIOtXQ7t27ERIScheEmDbPQRgyjf\/93\/\/F+++\/jxj5BCfXE95UV\/\/zP\/+DP\/\/5z+Zcp0+fTj+Hdby\/vz\/Onj2bpVImpOjHp59+Gi+99BKee+45XLhwIb0Nlf7x9PS0fddXvvX7\/fff4+TJkyYt5oHbPTw8cInfAZZv\/9pv5+\/EfazfkL4\/duyY+R0tQPIa+LdkyRK8+OKLxm\/W72v5W6ePHoKWjxWGjxEMCSgWIFabKlSogLp16+Ivf\/kLfvWrX6FHjx4GhIQMFRIBUKJECbzxxhvYu3cv\/vWvf2Hq1Kn43e9+Z4zr58yZg7\/\/\/e\/o0KEDXnnlFbz33nv49a9\/jT59+pjz8GtmD6IMk+XzjqxGMz0WZC7z+OrVq6NatWp49tlnTV4HDx5slBCr\/7\/97W\/xhz\/8wSifL7\/8Ev\/5z3+wa9cuvPbaa0bxvf322yZvBAnhZAUmp\/QFYUgIUjnz2nit\/\/jHPxAp38vm9RC0f\/3rX+Hn52eq\/MyLdSyr2KyGspqdOW3uYwG1SJEiWLt2rVGHzCN9xnPzm77cVq9ePXzwwQfmPPwt+vfvn36Teffdd1G\/fn3zWzAf3D5w4EBzPNsEqbL5G\/K34nWcOXMmHbY8B\/PIpopPPvnEfF1OYZh38LOPNc4rDB9DGNapU8cUzL59+xqlwsL1+9\/\/3igoKg2CkO1k\/\/73v41SstQStxGkNWvWNBBhYaR6OXr0KMLDw03hZ0Hm8WxjY8F7UBhSebZr1y4dhmz3ojobPny4UYhdu3Y1CosgYUEvX748GjduDCpHwpeK8OWXXzbruJ15Zhsl13EbAWEFqQXDd955x4Ce4ORNgUBl1ZvrWWWnsuP1zZ071yhIV1dXc3PYsWMHfvOb35gOIlZRrXQ5Zdo8hoqMVVbeiAgrwp6Q5zKvgcDlPqzuU8EOHTrU\/Db0KfNPGHI788PtvBHQHydOnDC\/Hav3bGNlni\/Lh9Z5DM9P3zNPAwYMMDcKKkze6OzzqPN5C0aF4WMIQ6osKkMW2J9\/\/hmrVq0C28WsKlyDBg0MACZOnGgKIBUOCxf3J0hplsrkOm5ndXbnzp1G1f3pT38y4MkNGBIePB8LNvNKZfXHP\/7RFHymT+XWokULs535oAJklZdVZCowGqvX1jp7Bce8W22GixcvNqBhVZaqsFGjRqaavHz5cnO+ixcvmmYC3jTGjx9vYEgIV65cOR0+9nBhXngslTLBxXONHDkyHXTcThhSYY8YMcLAjO1+VKAEHK+TNxoq3NGjR5sbE49hEwe3L1q0yGynMuU+CxcuNNdiXR+n+\/fvxzPPPGOqzzzWPn86n7cgpL8Vho8hDFklbNKkialqskq4cuVKU2gJQxYitr1RgbEKysLKQsX1hA\/BxOo1CzeNBZZq5tVXXzUAYTWSypBtXLkBQ1bvOnbsaID7z3\/+E1988QUIW6ogBpgFQ6oego\/VUYKdbXUEKI3tm1y3XjoT7KFgD0PChdAiNGfMmGGuh+psxYoVBob0DY9t3ry5UWsuLi4mH+xMsk+TeeJ102rVqmXAVbJkSXz00UfGlwQZ1RrzasGQ1X2mwRsM1R\/zQLVnwZDwtbYTylSG8+fPNwBlmyPBzeozbxxeXl5GAdJXVP5sq6RiZn4UgHkPQHufKwwfUxiyABFwmWFIqLB9kMaq1euvv26qxhb8CENWla1jqcRYwDnl37Jly0zbW25VkwnD9u3bG3BnBUNWo3kthAWN4xiZH4KP1Xzad999Z9Y5ODiYfFsBag9DQpbXzrY3Kk+elwChYuQyYUhfcZgM2xbLli1rfMOqMNOx0uSUACYsud+ECROwbds2bNq0CaxW80bEtj92isTFxRlAso32v\/\/9L3h97EBh\/plnNkNQ9Y0bNy59OzuqrO3MD6+PU3aC8XwcCsTfhtfCtNgGap83nc8\/ICoMHwMYsmATYFbVlgBho7wFNFbnWMDYW8yeYVaPOayEBY\/tVc2aNTOFi4WcipFwYJWY7XSEA49lgeY6qhMus3Cy4LENkNVYgopK5+OPP0bLli0N3OwLJsHDtjQOA2IbH\/fnMlWVNRSHsFiwYEE6bJkf7suOFZ6P1Vu2EbIJgG1x7F2lumNbHa+Z7Wn24LJgSOBQifGP4GH+p8u4TFbLv\/rqK6OQObSG5yPACEzuw+otq7b218F55p2dSFRl3J\/55jqmZ4F56dKl5vqYT6pqthlynGN1UdZsq+S1sK2WbYbMH9sMuZ3DdLiOqpJVarZHErwELavkhK81JGrz5s3GX1SGmfOoy3kPRYXhYwBDwogQs2BIpdW7d29TuFld27Jli+kVZRWNBZBtYawes4eYQ3LYHkilQRhwCAuB9re\/\/c2AgoWKnS2EJntECSuqJgKJYOWAa6oVFlDCkNVMdgIQxPYF0oJh06ZNTbWb+xOGrM5zIDb3Z17ZvskqJ2HBfQg8npfgoSqloiUkeA2EDEFC5chhOLwG+3MShoQVAcSmAkKLPuBwHFbzeT5CiIC2hu1QhRGCrMqy+k2f2KfJ62CahBZ73+2vk+cjxOgbjqe0YEe1yLGAzC99x+o6r43+Y6cO07K2c8omAML13LlzppmA6p2\/FX9XKk6eh9dCP\/PatJqc9+CzjwlrXmGYjzC0fgQWBnt1kHmZ+9lvtwotAcBt9hDhPBUW266owrgvAUCIcJmFlDBgNdlK1z7trM5t5TMn+2c+nvnh+ZgfViut\/BL8rMLSOG9\/Dfbny3xO7str4HVZ+1n553UyHXYwEWBcpln7WVPuT5Bntc1ax32sNkOqOUKVPuR6zvP8hCFhPnny5Lu281zW+XmNhDfzTrPPh5V3a51O8w+MCsPHAIYPUwBYGFmwrMJrnwbXZd5mQZH7cbs9TOyPfRTzWeWH52EecjMfhBSr3awiU6ESmg97PcwXYcf2QypfqlCus\/zNeapf9m5TiWbebn9e7kuzX6fz+Qe97HyvMHxCYZjdD1qY1\/MGwKdQWKWmqrPA9TA+4bFUsuxYYdODvaJjetZ2Pv6Y1faHOacek7+AVBgqDAuUYmE1me2GuaXEqPgytzta0CIQ77Xd2k+n+Qu5nPpfYagwLFAwzGng635PBqDy8ndSGCoMFYYaAxoDEgMKQy0IWhA0BjQGFIZaVcjLaoieS+PtcY4BVYaqClQVaAxoDKgy1Dv143yn1rxpfOZlDKgyVFWgqkBjQGNAlaHeefPyzqvn0nh7nGNAlaGqAlUFGgMaA6oM9U79ON+pNW8an3kZA6oMVRWoKtAY0BhQZah33ry88+q5NN4e5xhQZaiqQFWBxoDGgCpDvVM\/zndqzZvGZ17GgCpDVQWqCjQGNAZUGeqdNy\/vvHoujbfHOQZUGaoqUFWgMaAxoMpQ79SP851a86bxmZcxoMpQVYGqAo0BjQFVhnrnzcs7r55L4+1xjgFVhqoKVBVoDGgMqDLUO\/XjfKcuTHnjl\/auXSvcRh\/k52+uylBVQbYBmJqaClpycnKhNssPj6KgXhMAEAKxcQkIvxyNsIioQmkRUTFISEw2n3jNLygqDBWGWcKQAEhISEBsbKyxmJgYFEazrp++oE9yE4hUghGRMThw\/DS+3PD\/7Z0JUBRXGseZYYCBAYbhGG5EBIzi7abY2lQla9SYZFE0JNFS110rMYmuMR6g3J4YNRojBvDceKTceBGMcSHB1cQTo1GjVrLxSAQUPBBFo+v93+9740yhwSg9I2DmddWb7n5nv6+\/9+vvHd2zAcnZ+UiavQaJ7N63E0d15Tpn5BQg719f4Kud+wQUGwOIEoYShr9q4FVVVQJ8bBHyn6TfunUL9rpx3VkGZ86cETJh2dgCiGwR\/vfocWR\/XIg+49ehU\/o3aDmpFNFZp+zPTalA64lH8Me0rzF4aj5W\/XsrTlaeFhazLWT9sHlIGEoY3tW42fpha4gVSG53S4BlwrKx1kJkEB4vO4m5HxfhmdRCREw+hcgPgOg59u0iZ91EVPphvDKxAPlF22loxjYPHglDCbm7IPewCsHdwcrKyrspIM8sEmDZnD59WpFszfeAu4Cf\/6eELMICNJ90ClEEwqjZj6eLnkvXTRA3X\/+952b\/h91HkhyiUw9hxMy12HfoMGouXLBK1maZP8xeWoYSmhZlY4uHxwVramosjd\/aA+5iMjwuXbpkbVZWpb958yYKCgqwb98+q\/Jh2bCMlFqHDMLKU2fwwbJCdEwrQfP3gRZWukiCEVuW1uZTr\/QErYhpVxAwaCXCUg6L8iOmXbact1B6PZRvOOX7fGYh1hXvoK6yhKGlgT4M0WUc2ywR4gZeWlqKa9euWQUMTvztt9\/i1VdfRdu2bREREYHo6Gh07doVW7dutTpvJRlcvnwZYWFhSEpKUpLckubq1atCRkphyF3kshOVyMzJR9T4YwgnEDafpdBR2mZTqqFrlwDjwBWIIAApzuvONUQQWCMISA\/Kh+OEZZ6AytkdPi99iBYf0nlGOZ3r4JuQg4jsB+dxvzLCZgKxaduxdM3GBh03lJahtAwtDx6eHPjpp59w\/fp1S+NXclBcXAy9Xo+OHTvio48+QmFhIRYuXIiEhATk5+crydLqNAzDFi1aIDk52aq8+EHBMlI6kcIwLD1RgdTstYgYX4YwglAzavyKHMEwJLMCKkcX6LtnIpxgyPmEE6iaURiDlv3M\/pYyqEyzv4jL5fN1zLgBwwtT4f9mMZoTzIQf51crH0t8UfZJqF0N8E7IRXPqLodknKBzLzrPQzhB1VJePesXQvE7k9X8z9VfShhKS882ll595WgLGHJ3mK3Bli1birWJ9yMPj00yJOfPn48NGzaIGVuOe\/v2bezZswdlZWUi\/dq1a7F+\/XpLuDm\/48ePY82aNQK2W7ZswY0bN8xBOHjwoPDfuHGjxb9JwbDcBMPwzDKEvAeEzlDoCBpBGZVQa\/XQ95iEMIJg6LQb8H97J4IzT1PYSfgOXAW\/IV8iZPoNhHJZlCZ4cg18\/1YA75cXUlgxQt69KvyNb26G2sUDbp3\/CuPQzQieUCX8g1KPU\/xPCXLzYXzrK4ROv4lQgmdQugmGhj65CCP4BaWZYGh4Kc90LQrrFUTpOqWWYLGEYeOAoL7g+D3GZxgePXrUKsuwpKQEDg4OmDWLWst9NrY8+\/Tpg8jISHTu3BkajQZjxowRIGTLq1WrVujevbsICwwMhEqlEt1bBiVvS5cuhZeXl+j2dujQAW3atBFjeBw2b948+Pv7IzY2VsQZPny4yPfKlSs2swxZRtZahilkGYZllCGQGn7QdIWO4BaQboKhx3OTEEwwDMg8C0ePAGhbx0NjbAU1HTuo1NDHzUIw3ZJAAqFLVDeo3f3hHBYLp9BY+KeWgwHk2nEAHNQaqHV+0PjHwHfodgRMvCDiafzbCD8O94qfK8ryTzPBUE8wDCYL1D\/VBEN9nzwEk+WotF7+JI8OKQTDVdIytHTbfo\/Aacp1sgUMP\/nkEwFDtvrut\/FkxnfffQfe8zZs2DAEBQWBgcWg7NSpE5ycnDBnzhwxsz1gwAAEBASIsUy2GLkL\/uyzzwogcXq+bl4P+PPPPwsAzp1LfTba2KLUarU4cOCAyNdW3WRbwTAkvQzc8AOmKXQEMGNaJVRkGbp3n4RAApAxg2Do1QwqJzfo+y6HcUIFnFt0gVNgBwSSVegz8qC4P\/qXlyCIxOQ\/5SoCpt5AAOfFafXBprxm3BbX5T\/5CnxHHhDhAZTeqdlTwnFefqkmGHr2zkUggdgvhcYQtV7wJBgGEniV1suP5NFewlBahY0JS1vAcMWKFaKxFRUVCSD91g9bkUuWLEGvXr1gNBrxyy+\/CGi1bt0agwYNsiSdPHkyDAaD6PKuXr1a5L9u3TpLuPmAy2Yrsl+\/fnjnnXcwePBgEXflypXCOmxqMAxKK4PvuwSRqQodQcMnxQRDHcHQyLBLOyusPrc\/p8BIQDISILVPDoHGtyUYMr4Z5+BojBEWo+6F6fDNvAAjAZnDfDKqodaHQPdcFoxkdfJ1ibAp1+D12kZ4vrwImsD20IQ8CSPB0yf5JFQ0ZugenyvK8kk2wdCjd54lvZK6eVO57ZKlZSitwkac0LEFDLdt2yYA9N571JruszH0GHY8uztw4ED06NFDWH5mGHI3efTo0ZbUEydOhLe3t7AkFy9eLPLnccJ7twULFkCtVqN\/\/\/7g7jG7UaNGiTFIHlNsajAMSC0DN3yfLIWOQGpINsHQrdsk+JLIvVMJhjojdC++D18CFvu5\/OF1OPo9Icph+BpGH4Fz+\/5wcHSGJqgjDKO+hy8B0Tv9nIChW\/csce4j8j8Bp4hnofaJhDb2DWgC2kJDXWuObxhngqGuVy58CcSGcSYY6uLzRNlK6+VF8mgzTsJQwvAxhyGvo+OxwKioKPFu873AYiitWrVKAI0nSnjLzs4Wlh8vW+FuMsNw5MiRlqRmGPJ44s6dO0XaadPIlLln42U7PF7JEyv3bgzapgZDYzJ1+acAXpMVOoKGfpwJhtquk2AgQOlTzkJFMHR9fiYMJCL2cyYYqgmGohwqz0CQNBAk3V\/fQmOETtA+k2ZKm2qCofbP6SLcm9Jqn0mFysWT8q2CN80wO7cfAMdAAiiFeY41wdCtZ67I0zPJBEO3XnkwEEiV1suD5BEzVk6gSBg+5jBkCDGMnJ2dERMTA7bkGFLLli1DXFycWFrDY3kMLV7zx0tuGH7cvd20aZPoCjO02Kozb5mZmXB3dxfdaIYpd6t5LJCtT+6OZ2VlibFFBmnPnj2FFcnl7tixQ8xW7927V0A2NDQUiYmJ5mwV7RnIthoz9BtXBm74npMUOgKbx1haWuPkCpcu46En+HkknxHjdtrnpsOTgMR+zh3\/DrV3BDwpvvs\/DsDlqUToXvsarvELSe5qaONyoKe4nuP\/B8egzlD7RkM3uBieEy5SvhPoXqmgfX4WtC\/MItD6CcvTfcQPd8rWQfuXudATHD0SaZ0hjVVq4z6EJ1m8SuulI3m0ljCUY4aNPWZoi3WGTBle1sKLrMPDw8XsLi+87tu3L3788UexTGbo0KFiMfbTTz+N5cuXg\/fx8fECeBxv9mwakb+zLVq0CN26dQMvj+GNP5owZMgQYYHyEp7evXuLt1w4jD8uwSBlf17o3aVLF+zatUuMGfIMdk5ODkdTvDEMjx07ZtVschmtM+TZZO+xZXCjhq+bqNBx2nFVcGzeBS7xi+FOANKlnIdjZA+4JHwMHcOP\/Jy7ZkET8wp0BF63EUdEuMonGirvKDg9NRa69EtgAHF87YANUAe0J3hGwfWN3dAlV0HzRG+oDBFwpL1LwnKo\/dvBKXYEhVVT2V3h0neNqeyxZ+BIXWqXfvkiL6X10pI8nkiSlqG0DBvZMrQVDM20uUDvlpaXlwvImf3M+9qv6LHFx93k+mw8+3y\/NAwtMzzrk+eD4nK+1i66ZhjyomtD0nFoJ9CSlvFWOE5PIHMlgIh8zOe18+Wwe8PTrsCVHQHStXZczivjGlxTLpny43Qczud8zPHTr1Kc6yZ\/jm9Oz\/va5wrr5UzpWibulIuuG9Mysvey+RUzXsz8KCDyIMg8LuEsG5aR0tfxeEz1xMlTmDhvHYyjf4BzJk1wNIYj4Liwq6vsusJqx619XFd6K\/006bfQLmkLlhdskm+g2DuUGqv+3MB5HR93Q+VWtwRYNiwj5TCsJvlWYcGqYsSM2gR16k04ZdD6PemEDDQEUqfEaryY9hm+2LJHfPm6odqDfDe5EbulDXWT61MOvybHEwTcHZTb3RJgmbBsrP2EF3+WasuuAxg0JR\/ub38PVTrgKB0c6YGgSrmG0OHbkJH7GQ4fK5UwrE\/jlXFtO+nEFg9\/uYYbPX9+S24mCbAsjhw5YtUXa8y6ep4ewPx\/HysLt6NnegH0bx+EauwVOKQCDml26LjeKbegHlON4OHbMWxmAb7+5iDNHzTsH0RJy1Bahr+atOLF1zwudujQIfGKG5+bGzLD0h6cub5cd37Nj2XBMqktC3McJXv+es0J+rT96qKdeGvGp\/hTUhEiR+9CszH7yO23M7cPLcdsQ\/eU9UjL+QybSw6i6lw1+KGhRLZK00gYNrDAld6ohk7Hjb6iokJYiPwVmP3794PX6\/F3Cu3BcV25zlx3tpJZFrYCofle8mTKmbPnsOfgEawu3IFc+kOk7OVF+MCO3Byqazb9\/cGC1Rvx+ebd+OFoaYNbhOb7IWEoYfibT18GADt7\/btQc\/2VTpiYG9r99ufPV4txsXPUJTxNEyuV7E7blztFdeaHAn\/Vmi3m+8nqUftLGEoYNpryPWrlftzyZzDarWsC7VDCsAnchMet0crrbdixLCnvhpG3hKGEobQMpQ5IHSAdkDCUDUE2BKkDUgckDBvG\/JbdHClnqQNNXwekZSitAmkVSB2QOiAtw6b\/tJIWhbxHUgcaRgfYMrwthd0wwpZylnKWOtBkdeC2Ay0mvSxvUJO9QbL7IruwUgcaRgcuMwwr+bUgCUQJRKkDUgfsUQeYf8xBhuEu\/hqxPQpB1lk2fqkDUgfu8K+Exwxz+PPrUimkUkgdkDpgjzpwh385DvQCfhydyEmUhhmXkA8dKWepA01MBy5evHibOehABz70NDgqrUNpFdijVSDrbN96f4d7R5mD9Pe1DjxumMFf8pWKYd+KIe+\/vP\/2pgPMPZpASRcg5B8aQDSQEPbyXy\/amzBkfSUApA7Ypw7c4d1e5p8FhnxAfeZO5FkqgWifiiGBIO+7PekAc66mpqaUuXcXCM0nBMNOFGE3m45yDFE2DntqHLKu9qHvzDXmG3OOQNjZzL469+Xl5d7Uh84gMB6mQUUBRTpu0D9zloppH4op77O8z49aB3hBNfOLIcg8Y64x35hzdQKwLk\/6AxxfutA4SpxHEyy76biCnHx1r4ktC3jUyiTzl8B6jHWAeVXB\/GKO0XEcc60u3rHf\/wH0royn2i+FGQAAAABJRU5ErkJggg==","width":323}
%---
%[control:slider:044c]
%   data: {"defaultValue":0.2,"label":"Slider","max":2,"min":0,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:3497]
%   data: {"defaultValue":1.9,"label":"Slider","max":2,"min":0,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:0123]
%   data: {"defaultValue":0.4,"label":"Slider","max":1,"min":0,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
