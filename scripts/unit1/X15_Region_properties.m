%[text] %[text:anchor:T_185EE406] # Region properties
%[text] Great. So we made some masks. Now what?
%[text] Now we measure stuff. 
%[text] In the context of measuring stuff, masks are referred to as regions, and the stuff you are measure as the region properties. Properties can be things like count, area, length, or circularity, or image intensity in a given region. 
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] %[text:anchor:H_247859AB] ## Measuring Masks
%[text] ### Example: Estimate Pixel Size in the Moon Image
%[text] In this example, we will estimate the size of a pixel in the image of the Moon (assuming each pixel is square) by creating a mask of the moon and then grab information readily available on the internet.
%[text] First, we recreate the mask
close all
clc
clearvars
mmSetUnitDataFolder(1)
img = imread("FullMoonGray.png");
moon_mask = imbinarize(img);
moon_mask = imfill(moon_mask, 'holes'); % notice that we overwrite the mask with its cleaned up version
moon_mask = bwmorph(moon_mask, 'close');

figure
imshowpair(img,moon_mask)
title('Mask Overlay on Moon')
%%
%[text] To estimate the size of the pixel, we need a known distance on the actual moon and the same distance, in pixels, on the image of the moon. One such distance is the [diameter of the moon](https://share.google/LyjnTIcw0lhwth3Uk), which is 2150.1 miles.  On our image, we can measure the sam diameter of the moon in pixels. If we divide the distance in miles by the distance in pixels, then we can use the handy ratio of miles/pixel to estimate the size of a pixel in our image. 
%[text] To measure the diameter of the moon, we could simply draw a line from one edge of the moon to the other, making sure that we pass through the exact center of the moon. Or, for a little more precision, we could capture the mask of the moon, calculate the area of this mask, and then calculate the diameter from the Area, using geometry:
%[text] $\\begin{array}{l}\nA=\\pi r^2 \\\\\nr^2 =\\frac{A}{\\pi }\\\\\nr=\\sqrt{\\frac{A}{\\pi }}\\\\\nd=r\*2\n\\end{array}${"editStyle":"visual"}
%[text] Here are those calculations in MATLAB:
moon_area = sum(moon_mask(:)); % add up all trues in the mask to calculate area
moon_radius = sqrt(moon_area / pi);  % calculate the radius from area
moon_diameter_px = moon_radius * 2; % diameter in pixels
%[text] Plus, we create a new variable called ***moon\_diameter*** that contains the diameter of the moon in miles. 
moon_diameter_miles = 2159.1
%%
%[text] To estimate the size of a pixel, we need to divide the miles by the pixels to get miles-per-pixel, as follows:
pixel_size = moon_diameter_miles / moon_diameter_px; % calculate miles per pixel

% create a nice little table
calculations = table(moon_area, moon_radius, moon_diameter_miles, moon_diameter_px, pixel_size) % display results
fprintf('A pixel in the moon image is approx. %1.4f miles wide (and tall)!\n', pixel_size)
%%
%[text] %[text:anchor:H_808CA1E9] ### Diameter of Tycho Crater
%[text] Now that we know the size of a pixel, we can use this information to measure things on the moon, like the diameter of the Tycho Crater. Use the ruler in **imageViewer** to measure the longest diameter of the crater. Be sure to measure through the center of the crater.
%[text] Tips:
%[text] 1. Right-click on the ruler added to the image and set "Show Distance Label" to "Label off"
%[text] 2. Resize the ruler by dragging on the end points
%[text] 3. Roughly size the ruler to the crater
%[text] 4. Turn on the Zoom Tool and zoom in on the crater. Turn Zoom Tool back off.
%[text] 5. Resize the ruler to better match the longest diameter of the crater
%[text] 6. Do not close window or all of your work will be lost. You can dock the figure if you like \
%[text] The Crater is indicated by a red asterisk
figure(Visible="on");
imshow(img)
text(1015, 1863, '*','Color','r') % plot an asterisks on the image
%[text] The function **imdistline** lets you draw a line on the image. 
d = imdistline
%%
%[text] %[text:anchor:H_97E09439] ### How big is the Tycho Crater?
%[text] Once you have the ruler the way you want it, run this code block. 
%[text] Here we calculate the width of the crater by multiplying the length of the ruler by size of a pixel (pixels are square in this image)
pixel_distance = d.getDistance % pull the length (in pixels) off the ROI line you just drew
crater_width =  pixel_distance * pixel_size % Multiply to get length in miles
%[text] 
%%
%[text] %[text:anchor:H_A3B9967E] ### Actual Tyco Crater Size
%[text] Were you right?
URL = 'https://www.google.com/search?client=safari&rls=en&q=tycho+crater+size&ie=UTF-8&oe=UTF-8'
web(URL,'-browser')
actual_crater_width = 85 * 0.621371 %  convert to miles
%%
%[text] %[text:anchor:H_0274D207] ## Example: Coins
%[text] Here we load the coin image to measure the region properties. Useful information to measure would be Count, Area, and Location.
%[text] To load the image, I copied the segmentation function over from the Segmentation Exercise to save us some time. You can find this function, [segmentCoins](internal:M_5e11), at the bottom of this live script. 
close all
clearvars
mmSetUnitDataFolder(1);
img = imread('coins-gradient.tif');
imgc = imcomplement(img);
mask = segmentCoins(imgc); % automatically segments and performs morphops

figure;
imshowpair(img,mask)
%[text] - We can use this mask to calculate properties of the coins, like area and location \
%%
%[text] %[text:anchor:H_C21BB709] ## Calculate region properties of the mask
%[text] Once we have create the mask of the coins, we plug the mask into the **regionprops** function to calculate the region properties.
%[text] Here we indicate that the function should calculate Area, Bounding Box, Centroid, and Equivalent Diameter. There are many more properties you can calculate, as indicated in the [regionprops documentation](https://www.mathworks.com/help/images/ref/regionprops.html). 
rp = regionprops('table',mask,["Area", "BoundingBox","Centroid","EquivDiameter"])
%[text] - The first input `table` means that the function should return a table. So, `rp` is a table contain the properties of the coins
%[text] - Since there are 8 rows in the table, there are 8 regions identified, which corresponds to the number of coins in the image
%[text] - Here we calculate Area, Centroid, and BoundingBox, and Equivalent Diameter \
%%
%[text] %[text:anchor:H_EFC8FC84] ### Location of Coins in the Image
%[text] The Centroid property returns the X and Y coordinates of the centers of each coin. Objects are identified column by column, left to right, so the order of the rows in the table is roughly equivalent to the column major order of the coins. 
%[text] We can use the centroid to label an object with its row number using the function **`text`**, as follows:
figure
imshow(img) % display image
n=1; % set row number
x = rp.Centroid(n,1); % X coordinate of n object found
y = rp.Centroid(n,2); % Y coordinate of n  object found
text(x,y,num2str(n),HorizontalAlignment='center',Color='cyan') % adds text to image
%[text] - notice that even though we created the region properties on the mask, the properties are still relevant to the original image. \
%%
%[text] A bounding box is basically a box that surrounds the region. We can add a bounding box to the image using the function **`rectangle`**. 
rectangle('Position',rp.BoundingBox(n,:),EdgeColor='magenta') % adds bounding box to image
%%
%[text] With a FOR LOOP, we can label all the identified objects
figure
imshow(img)
for n=1:height(rp) % iterate for the number of rows in rp
    x = rp.Centroid(n,1); % centroid of first object found
    y = rp.Centroid(n,2); % centroid of second object found
    text(x,y,num2str(n),HorizontalAlignment='center',Color='cyan') % add a text to the image at the x,y coords specified
    rectangle('Position',rp.BoundingBox(n,:),EdgeColor='magenta') % add bounding box
end
%[text] - notice the ordering is actually a little unexpected
%[text] - Likely ther may be a piece of 3 that is a little further to the left of 4, and 5 of 6 \
%%
%[text] %[text:anchor:H_5692FF35] ### Property visualization
%[text] Since we calculated  bunch of properties, we should visualize these properties. 
%[text] Since we are about to create figures, we should run our figure publication function to standardize the appearance of our figures
mmSetFigPublication(14)
%[text] - This function sets the default figure color and font size \
%%
%[text] ### Bar Plots
%[text] Bar plots are a useful way to visualize and compare the properties of our coins. Before plotting though, we should order the rows of the table ascending values to improve the aesthetics of the bar plot. 
%[text] In this example, we sort by equivalent diameter
rp = sortrows(rp,"EquivDiameter")
%%
%[text] And Here we visualize the data as bar plots.
figure;
nexttile
bar(rp.Area)
ylabel('Area')

nexttile
bar(rp.EquivDiameter)
ylabel('Equiv Diameter')
%[text] - Notice that the values are fairly different for the different coins \
%[text] 
%%
%[text] %[text:anchor:H_D7630262] ### Automatically Create Categorical Labels
%[text] Wouldn't it be nice to label the data by coin? Since the coins have standardized dimensions, we can use the equivalent diameter of the regions to identify the different coins. 
%[text] The function **discretize** can help with this by binning the properties into different categories.
%[text] For the function **discretize**, you input the property you want to bin, the number of bins that you want to create, and a list of categories for each bin, and the function does the rest, rather amazingly.
%[text] We'll use the equivalent diameter column since its values are very different for the different coins, with dimes being the smallest and quarters the largest. These are easy to bin to different categories using our handy **discretrize** function.
%[text] Here we discretize the Equivalent Diameter column into 4 bins and create a new column called **Coin.**
rp.Coin = discretize(rp.EquivDiameter,4,"categorical", ...
    {'dime','penny','nickel','quarter'})
%[text] - Note, the order of the inputted categories is critical to make this work, since this bins by diameter
%[text] - I listed the coins in order of their diameter from smallest to largest \
%%
%[text] Here we group the properties by coin and plot a swarmchart
figure

nexttile
swarmchart(rp.Coin,rp.Area)
ylabel('Area')

nexttile
swarmchart(rp.Coin,rp.EquivDiameter)
ylabel('Equiv. Diameter')
%[text] - now we can really see that these properties are different between the differnt coins (as to be expected) \
%%
%[text] %[text:anchor:H_FF4CE32B] ## Visualize region properties
%[text] We can use our new Coin column to properly label the coins.
figure
imshow(img)
for n=1:height(rp) % iterate for the number of rows in rp
    x = rp.Centroid(n,1); % centroid of first object found
    y = rp.Centroid(n,2); % centroid of second object found
    coin = rp.Coin(n); % get coin name
    text(x,y,coin,HorizontalAlignment='center',Color='cyan')
    rectangle('Position',rp.BoundingBox(n,:),EdgeColor='magenta')
end
%%
%[text] %[text:anchor:H_E58624C6] ### Exercise: Estimate pixel diameters in the image
quarter_diameter = 0.955; % google, in inches
s = groupsummary(rp,"Coin","mean","EquivDiameter")
factor = 0.955 / s.mean_EquivDiameter(4) % calculate inches per pix
%[text] - row 4 contains the info for the quarter masks \
%%
s.mean_EquivDiameter(1) * factor % row 1 contains info for the dime
%[text] - google says this is right \
%[text] 
%%
%[text] %[text:anchor:H_134347DA] ### Exercise: Calculate mean intensity of the coin
%[text] You can also use regionprops to calculate properties on the image being masked. For example, we can calculate the mean intensity of each coin.
%[text] To do so, you input both the mask and the image into **`regionprops,`** 
rp = regionprops('table',mask,img,["Area","Centroid","EquivDiameter","MeanIntensity"])
%[text] 
%[text] `rp = regionprops(``'table'``,mask,img,``'all'``)`
%[text] - The first input tells regionprops to return a table. If you forget this input, you get a structure (and all confused).
%[text] - By including the image data as the third input, regionprops can calculate properties like mean and max intensity of the dots. \
%[text] 
%%
%[text] Since we reset the `rp` table with this new function call, we need to recalculate the coin column
rp.Coin = discretize(rp.EquivDiameter,4,"categorical", ...
    {'dime','penny','nickel','quarter'})
%%
%[text] Now we can summarize our findings, grouping by coin
s = groupsummary(rp,"Coin","mean","MeanIntensity")
%[text] - While the mean intensities are fairly similar for the coins, pennies have lowest intensity, which makes sense, since their copper color is darker than the silver color of the other coins \
%%
%[text] %[text:anchor:T_AD4BFD9B] # Functions
function [BW,maskedImage] = segmentCoins(X) %[text:anchor:M_5e11]
%segmentImage Segment image using auto-generated code from Image Segmenter app
%  [BW,MASKEDIMAGE] = segmentImage(X) segments image X using auto-generated
%  code from the Image Segmenter app. The final segmentation is returned in
%  BW, and a masked image is returned in MASKEDIMAGE.

% Auto-generated by imageSegmenter app on 11-Sep-2023
%----------------------------------------------------


% Adjust data to span data range.
X = imadjust(X);

% Threshold image with adaptive threshold
BW = imbinarize(im2gray(X), 'adaptive', 'Sensitivity', 0.740000, 'ForegroundPolarity', 'bright');

% Clear borders
BW = imclearborder(BW);

% Fill holes
BW = imfill(BW, 'holes');

% Open mask with default
radius = 8;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imopen(BW, se);

% Create masked image.
maskedImage = X;
maskedImage(~BW) = 0;
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
