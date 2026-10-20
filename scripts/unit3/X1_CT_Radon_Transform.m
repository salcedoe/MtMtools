%[text] %[text:anchor:T_79A94F48] # CT Reconstruction and the Radon Transform
%[text] In this exercise, we will explore the steps involved in creating a backprojection image.
%[text] After this exercise, you should be able to
%[text] 1. Explain what a Radon Transform is
%[text] 2. Explain what a sinogram shows
%[text] 3. Explain what a backprojection is in reference to a Radon Transform and a CT Scan
%[text] 4. Explain where noise in CT scans comes from (hint: it's the reconstruction from the Radon Transform) \
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] 
clearvars
close all
%%
%[text] %[text:anchor:H_95EAF1C5] ## Radon Transform
%[text] The Radon transform converts a 2D image into a set of 1D projections — one projection for each viewing angle. Each projection adds up (integrates) the image intensities along parallel lines, much like X-rays passing through the body in a CT machine. Stacking these projections side by side creates a sinogram. 
%[text] In this example, we will assume an equal number of emitters and sensors. We will start by creating a simple image and then transform that image using the Radon transform.
%[text] ### Create a Sample Image
%[text] %[text:anchor:H_6D10E356] Our sample image will be a binary image containing a 30 × 10 rectangle (30 pixels wide, 10 pixels tall) 
% create the image
I = ones(50); % an image of all ones
I([1:20 31:50],:)=0; % zero out top and bottom rows (keeps rows 21-30)
I(:,[1:10 41:50]) = 0; % zero out left and right columns (keeps columns 11-40)

figure;

tiledlayout(1,2)
nexttile
imagesc(I); % plot the image as an axes
axis xy
axis square
xlabel("30 × 10 rectangle")
colormap(gray)
%%
%[text] %[text:anchor:H_05100547] ### Radon transform
%[text] Here we transform the image into a 1D representation from 3 different angles:
theta = [0 45 90]; % angles to calculate transform
[R,xp] = radon(I,theta); % create the radon transform
nexttile
plot(xp, R) % plot the radon transforms
legend(arrayfun(@num2str,theta,'uni',false))
title('Radon Transforms for Three Angles')
xlabel("x' (distance from center)")
ylabel('sum of intensities')
axis square
%[text] - In the Radon Transform, we "look" at the image from different angles — not from above, but in the same plane as the image (As if we live in [Flatland](https://youtu.be/MGv8MMi8QO0?si=uMjufzfE3alQbnjp))
%[text] - Each "View" is plotted out as a line
%[text] - In the plot, the y-axis is the sum of the intensities along each ray (the "height" of the profile). For example, at 0° each ray passes through the 10-pixel height of the rectangle, so the profile is 10 high and 30 wide. At 90°, each ray passes through the 30-pixel length, so the profile is 30 high and 10 wide. \
%[text] 
%%
%[text] %[text:anchor:H_EF58F7A7] ### Show simulated rotations of the image 
%[text] Here we pair the simulated rotated image with the corresponding transform immediately below the rotated image. In this example, the view is always from above the image.
%[text] **Predict:** before you run this section, sketch what you think the 45° transform will look like.
figure;
tiledlayout(2,3);

for n=1:3
    ir = imrotate(I,-theta(n)); % rotate image clockwise to match radon's counterclockwise viewing angle
    ax = nexttile(n);
    imagesc(ir); % display image (as a plot)
    grid on
    ax.GridColor = [1 1 1]; % make the grid white
    axis xy
    title(num2str(theta(n)))
    
    nexttile(n+3)

    plot(xp,R(:,n)) % plot the radon transform
    if n==2
        xlabel('distance from center')
    end
    ylim([0 35])
end
colormap(gray)
sgtitle('Radon Transform with View from Top of Image')
%[text] The bottom row shows the 1D transform of the image along the indicated angle. Envision a flashlight shining up from below the image toward a viewer above. The height of the profile tells you how much material the light had to pass through (the sum of the intensities along that ray). So, the transform is like the shadow on the far side of the image — the thicker or denser the object, the darker the shadow.
%%
%[text] %[text:anchor:H_76AE8EBC] ### Changing Intensity
%[text] What happens to the transform if we change the intensity of our rectangle (i.e., radiodensity)? **Predict** before you run the next section.
Idim = I;
Idim(logical(I)) = 0.5; % set the intensity values to 0.5

theta = [0 45 90]; % angles to calculate transform
[Rdim,xp_dim] = radon(Idim,theta);

clf; % clear figure
tiledlayout(2,2)
nexttile
imshow(Idim)
title('dim')

nexttile
imshow(I)
title('full brightness')

nexttile
plot(xp_dim, Rdim)
legend(arrayfun(@num2str,theta,'uni',false))
title('dim transforms')
ylim([0 35])

nexttile
plot(xp, R)
legend(arrayfun(@num2str,theta,'uni',false))
title('full brightness transforms')
ylim([0 35])
%[text] - The profiles for the dim image are half as high as the profiles for the full-brightness image
%[text] - So, the height of a 1D profile depends on both how thick the object is and how bright (dense) it is \
%%
%[text] %[text:anchor:H_6916CAB3] ## Sinogram
%[text] A sinogram takes the 1D transforms and plots them as an image where: 
%[text] - **x-axis**: is the projection angle (θ)
%[text] - **y-axis**: is the position along the detector (x′)
%[text] - **color**: is the height of the transform (the summed intensity) \
%[text] In the following plot, we plot the **three transforms** as a single image. Envision rotating the plots from the previous code block 90˚ and viewing them from the side where the y-axis from the previous image is plotted as a color using the `hot` colormap. In this image, white corresponds to 30. 
%[text] Here, we plot a sinogram with only 3 radon transforms: 0, 45, 90
figure; 

tiledlayout(2,3)

for n=1:3
    nexttile(n)
    plot(R(:,n),xp)
    title(num2str(theta(n)))
    xlim([0 30])
end

nexttile([1 3])
imagesc(theta,xp,R,[0 30]);
title('Sinogram - R_{\theta} (X\prime)','Interpreter','tex');
xlabel('\theta (degrees)','Interpreter','tex');
ylabel('X\prime','Interpreter','tex');
set(gca,'XTick',0:20:180);
colormap(hot);
colorbar
%[text] - In the sinogram, each column is one of the 1D profiles above, with its height shown as a color \
%%
%[text] %[text:anchor:H_A217EB63] ### Sinogram of the dimmer box
%[text] Here, we only calculate 3 radon transforms: 0, 45, 90
figure;
imagesc(theta,xp_dim,Rdim,[0 30]);
title('R_{\theta} (X\prime)','Interpreter','tex');
xlabel('\theta (degrees)','Interpreter','tex');
ylabel('X\prime','Interpreter','tex');
set(gca,'XTick',0:20:180);
% axis equal
colormap(hot(30));
colorbar
%[text] - The dimmer box has dimmer colors in the sinogram \
%%
%[text] %[text:anchor:H_89BC10FE] ## Refine the Sinogram
%[text] Here, we add more rotations of the image.
%[text] Here, we'll plot 180 transforms of the brighter box: 
theta = 0:179; % angles to calculate transform (180° is the same view as 0°)
[R,xp] = radon(I,theta);
imagesc(theta,xp,R);
title('Sinogram: R_{\theta} (X\prime)','Interpreter','tex');
xlabel('\theta (degrees)');
ylabel('X\prime');
set(gca,'XTick',0:20:180);
colormap(hot);
colorbar
%[text] - Now we have a transform at every degree (θ)
%[text] - Near 90°, the band is narrow but bright: the rays pass through the long (30-pixel) side of the rectangle
%[text] - Near 0° and 180°, the band is wide but dim: the rays pass through the short (10-pixel) side of the rectangle \
%%
%[text] %[text:anchor:H_C8DDA6BB] ## Inverse Radon Transform
%[text] To recreate the image from the sinogram, we use the inverse Radon transform with the function **`iradon`**. This is also known as a backprojection. By default, `iradon` performs a *filtered* backprojection: it sharpens each projection with a filter before projecting it back across the image.
clf
IR = iradon(R,theta);
imshowpair(I,IR,'montage')
title('Original | Reconstruction')
%[text] - Notice that the reconstructed image is not a perfect reconstruction of the original data.
%[text] - **Remember** - CTs are mathematical reconstructions, NOT ACTUAL IMAGES. The artifacts found in a CT often arise from the process of recreating images from backprojections. \
%%
%[text] %[text:anchor:H_700FF51E] ### Change the colormap of the backprojection
%[text] The parula colormap highlights the noise in the backprojection
figure
imshowpair(I,IR,'montage')
colormap(gca, "parula")
%%
%[text] ### Filtered vs. unfiltered backprojection
%[text] **Predict:** what do you think the reconstruction will look like if `iradon` skips the filter?
IRnofilt = iradon(R,theta,'linear','none'); % backprojection without a filter
figure
tiledlayout(1,3)
nexttile
imshow(I,[])
title('Original')
nexttile
imshow(IRnofilt,[])
title('Unfiltered')
nexttile
imshow(IR,[])
title('Filtered (default)')
%[text] - Without the filter, every projection is "smeared" back across the whole image, so the rectangle is blurry and surrounded by a bright halo
%[text] - The filter sharpens each projection before it is smeared back. This removes most of the blur, but it also adds some ringing noise \
%%
%[text] %[text:anchor:H_7F35EE42] ## Radon Transform of Intensity and multiple shapes
%[text] So far, we have simply captured the radon transform of a rectangle with a single intensity, at a single location
%[text] The following image adds two more rectangles, with intensities of 0.5 and 0.25, below and above the original rectangle
I(36:45, 11:40) = 0.5;
I(6:15, 11:40) = 0.25;

figure;
imshow(I)
%%
%[text] Calculate radon transform of new image
theta = [0 45 90]; % angles to calculate transform
[R,xp] = radon(I,theta);
%[text] Display results
figure
tiledlayout(2,3)
for n=1:3
    ir = imrotate(I,-theta(n)); % rotate image clockwise to match radon's viewing angle

    ax = nexttile(n);
    imagesc(ir);
    grid on
    ax.GridColor = [1 1 1];
    axis xy
    axis square
    title(num2str(theta(n)))
    
    nexttile(n+3)
    plot(xp,R(:,n))
    title('Radon Transform')
    ylim([0 35])
end
colormap(gray)
%[text] - Interestingly, the transform at 0° has the same shape as before. Only the height is different (it's the sum of the intensities in all three rectangles).
%[text] - At oblique angles, the transforms are far more complicated
%[text] - Only near 90° are the three separate rectangles evident \
%%
%[text] %[text:anchor:H_D0999311] ## Generate the Full Sinogram
%[text] Transform the rectangles across the full 180˚
figure
theta = 0:179; % angles to calculate transform
[R,xp] = radon(I,theta);
imagesc(theta,xp,R);
title('Sinogram: R_{\theta} (X\prime)','Interpreter','tex');
xlabel('\theta (degrees)');
ylabel('X\prime');
set(gca,'XTick',0:20:180);
colormap(hot);
colorbar
%[text] The presence of three rectangles is evident at around 90°. Notice that the color is brightest for the center rectangle (which is also brightest in the original image)
%%
%[text] %[text:anchor:H_5A30C062] ## Reconstruct the Image
%[text] Using backprojection
figure
IR = iradon(R,theta);
imshowpair(I,IR,'montage');
title('Original | Reconstruction')
colormap (gca, parula)
%[text] Noise is an inevitable part of the process
%%
%[text] %[text:anchor:T_76315318] # Create a Shepp-Logan Head Phantom
%[text] A Shepp-Logan Head Phantom is a standard phantom used for testing radon transformations 
clearvars
figure
tiledlayout(1,2,'Padding','compact')
P = phantom; % Create the Phantom - Just an image

nexttile
imshow(P)  % show the phantom

theta = [0 45 90]; % angles to calculate transform
[R,xp] = radon(P,theta); % radon transform

nexttile
plot(xp, R)
legend(arrayfun(@num2str,theta,'uni',false))
title('Radon Transform for Three angles')
axis square
%[text] - The transforms are even more complicated \
%%
%[text] %[text:anchor:H_F0FE5F00] ## Create Sinogram for the Shepp-Logan Phantom
%[text] 180 degrees of rotation
figure
theta = 0:179; % angles to calculate transform
[R,xp] = radon(P,theta);
imagesc(theta,xp,R);
title('Sinogram: R_{\theta} (X\prime)','Interpreter','tex');
xlabel('Parallel Rotation Angle - \theta (degrees)');
ylabel('Parallel Sensor Position - x\prime (pixels)');
set(gca,'XTick',0:20:180);
colormap(hot);
colorbar
%[text] The sinogram is fatter at 90° because the original image contains an oval that is wider at the perpendicular angle
%%
%[text] %[text:anchor:H_A1E7E23F] ## Reconstruct Phantom
%[text] Backproject the image from the sinogram
PR = iradon(R,theta); % inverse radon (or backprojection)
imshowpair(P,PR,'montage')
title('Original | Reconstruction')
colormap (gca, parula)
%[text] - Notice the wavy lines - that is classic backprojection noise \
%%
%[text] %[text:anchor:H_A2D38023] ## Add some "metal" to our phantom
P(220:230, 100:150) = 1;
imshow(P)
%%
%[text] %[text:anchor:H_7C9D40FE] ## Sinogram with metal mouth
%[text] Metal (bright pixels) inevitably adds noise to the backprojection 
tiledlayout(2,1)
nexttile
imagesc(theta,xp,R);
colorbar
title('Original Sinogram')

nexttile
theta = 0:179; % angles to calculate transform
[R2,xp] = radon(P,theta);
imagesc(theta,xp,R2);
title('Metal Mouth Sinogram: R_{\theta} (X\prime)','Interpreter','tex');
xlabel('Parallel Rotation Angle - \theta (degrees)');
ylabel('Parallel Sensor Position - x\prime (pixels)');
set(gca,'XTick',0:20:180);
colormap(hot);
colorbar
%[text] You can see the bright metal as an upside down "smile" running across all angles of the sinogram
%%
%[text] %[text:anchor:H_0AF1B827] ## Backproject and Compare
%[text] 
tiledlayout(1,3,'TileSpacing','none','Padding','tight')

nexttile
imshow(P)
title('Original')
colormap(gca, parula)

nexttile
imshow(PR)
title('Reconstruction')
colormap(gca, parula)


nexttile
PR2 = iradon(R2,theta);
imshow(PR2)
title('Reconstruction with Mouth')
colormap(gca, parula)
%[text] - Notice the extra background noise around the reconstructed mouth (horizontal lines) \
%%
%[text] %[text:anchor:T_EDA8D371] # Exercise - Backprojection
%[text] You try it: recreate an image from a mystery sinogram. (The answer key is in a separate file.)
%[text] %[text:anchor:H_78B71E26] ## Clean up
clearvars
close all
mmSetUnitDataFolder(3)
load("sinogram_example_data2.mat")
%[text] - or just double-click on the sinogram\_example\_data2.mat file in the data folder \
%%
%[text] %[text:anchor:H_8C43281F] ## Load and display
%[text] %[text:anchor:H_6123337B] Display the sinogram.
%[text] - The sinogram is stored in **R**, and the detector positions are stored in **xp**
%[text] - R has one column per angle, from 0° to 179° \
figure;
theta = 0:179; % angles used to create the sinogram
imagesc(theta,xp,R);
xlabel('\theta (degrees)');
ylabel('x\prime');
%[text] **Predict:** looking at the sinogram, what shapes do you think are in the original image?
%%
%[text] %[text:anchor:H_D18DDD4F] ## Let's find out
%[text] Perform a backprojection (using **iradon**) and display the result.
%[text] - The first input into **iradon** should be R, and the second should be theta \
% YOUR CODE HERE


%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":12}
%---
