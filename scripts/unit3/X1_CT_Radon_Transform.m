%[text] %[text:anchor:T_79A94F48] # Tomography Examples
%[text] In this exercise, we will explore the steps involved in creating a backprojection image.
%[text] After this exercise, you should be to
%[text] 1. Explain what a Radon Transform is
%[text] 2. Explain what a sinogram shows
%[text] 3. Explain what a backprojection is in reference to a Radon Transform and a CT Scan
%[text] 4. Where a source of noise comes from in CT scans (hint, its the Radon Transform) \
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] 
clearvars
close all
%%
%[text] %[text:anchor:H_95EAF1C5] ## Radon Transform
%[text] The radon transform is the mathematical process of creating a one-dimensional representation of a 2D image. It replicates the process that is occurring in a CT machine and ultimately results in the creation of a sinogram. 
%[text] In this example, we will assume an equal number of emitters and sensors. We will start by creating a simple image and then transform that mask using the Radon transform
%[text] ### Create a Sample Image
%[text] %[text:anchor:H_6D10E356] Our sample image will be a binary image containing a rectangle 
% create the image
I = ones(50); % an image of all ones
I([1:20 30:50],:)=0; % zero out top and bottom rows
I(:,[1:10 40:50]) = 0; % zero out left and right columns

figure;

tiledlayout(1,2)
nexttile
imagesc(I); % plot the image as an axes
axis xy
axis square
xlabel("30 X 10 rectangle")
hold on
colormap(gray)
%%
%[text] %[text:anchor:H_05100547] ### Radon transform
%[text] Here we transform the image into a 1D representation from 3 different angles:
theta = [0 45 90]; % angles to calculate transform
[R,xp] = radon(I,theta); % create the radon transform
nexttile
plot(xp, R) % plot the radon transforms
legend(arrayfun(@num2str,theta,'uni',false))
title('View from to of Image')
xlabel('Radon Transforms for Three angles')
axis square
%[text] - In the Radon Transform, we "look" at the image from different angles — not from above, but in the same plane as the image (As if we live in [Flatland](https://youtu.be/MGv8MMi8QO0?si=uMjufzfE3alQbnjp))
%[text] - Each "View" is plotted out as a line
%[text] - In plot, y-axis indicates 'Height' along the transformation angle. e.g. 90˚ has a "height" that is the length of the rectangle (from 10 to 40 along the x-axis  in  the image) \
%[text] 
%%
%[text] %[text:anchor:H_EF58F7A7] ### Show simulated rotations of the image 
%[text] Here we pair the simulated rotated image with the corresponding transform immediately below the rotated image. In this example, the view is always from above the image
figure;
tiledlayout(2,3);

for n=1:3
    ir = imrotate(I,theta(n)); % rotate image
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
    ylim([0 30])
end
colormap(gray)
sgtitle('Radon Transform with View from Top of Image')
%[text] The bottom row shows the 1D transform of the image along the indicated angle. Envision a flash light shining up from below the image into a viewer above. The height of the profile is where the light is getting blocked. So, the transform is basically what the shadow might look like on the far side of the image
%%
%[text] %[text:anchor:H_76AE8EBC] ### Changing Intensity
%[text] What happens to the transform if we change the intensity of our rectangle (i.e. radiodensity)?
Idim = I;
Idim(logical(I)) = 0.5; % set the intensity values to 0.5

theta = [0 45 90]; % angles to calculate transform
[Rdim,xp_dim] = radon(Idim,theta);

clf; % clear figure
% tiledlayout(1,3)
nexttile
imshow(Idim)
title('dim')

nexttile
imshow(I)
title('full brightness')

nexttile
plot(xp_dim, Rdim)
legend(arrayfun(@num2str,theta,'uni',false))

ylim([0 30])

nexttile
plot(xp, R)
%[text] - The heights of the lines in for the Dimmer Image are lower
%[text] - So, these 1D plot represent intensity along the Y-axis \
%%
%[text] %[text:anchor:H_6916CAB3] ## Sinogram
%[text] A sinogram takes the 1D transforms and plots them as an image where: 
%[text] - **x-axis**: is the transformation angle
%[text] - **y-axis**: is the width of transformation
%[text] - \*\*colormap: \*\*is the height of transform (considering intensity) \
%[text] In the following plot, we plot the **three transforms** as a single image. Envision rotating the plots from the previous code block 90˚ and viewing them from the side where the y-axis from the previous image is plotted as a color on the heat color scale. In this image, white corresponds to 30. 
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
%[text] - In the Sinogram, the radon transform outlines are filled in \
%%
%[text] %[text:anchor:H_A217EB63] ### Sinogram of the dimmer box
%[text] Here, we only calculate 3 radon transforms: 0, 45, 90
clf;
imagesc(theta,xp_dim,Rdim,[0 30]);
title('R_{\theta} (X\prime)','Interpreter','tex');
xlabel('\theta (degrees)','Interpreter','tex');
ylabel('X\prime','Interpreter','tex');
set(gca,'XTick',0:20:180);
% axis equal
colormap(hot(30));
colorbar
%[text] - the dimmer box will have dimmer colors in the sinogram \
%%
%[text] %[text:anchor:H_89BC10FE] ## Refine the Sinogram
%[text] Here, we add more rotations of the image.
%[text] Here, we'll plot 180 transforms of the brighter box: 
theta = 0:180; % angles to calculate transform
[R,xp] = radon(I,theta);
imagesc(theta,xp,R);
title('Sinogram: R_{\theta} (X\prime)','Interpreter','tex');
xlabel('\theta (degrees)');
ylabel('X\prime');
set(gca,'XTick',0:20:180);
colormap(hot);
colorbar
%[text] - Now we have a transform at every degree (theta)
%[text] - At 90˚, we have a long, skinny thing in reference to our emitter
%[text] - at 0˚ and 180˚, we have a short, wide thing in reference to our emitter \
%%
%[text] %[text:anchor:H_C8DDA6BB] ## Inverse Radon Transform
%[text] To recreate the image from the sinogram radon transform, we use the inverse radon transform with the function **`iradon`**. This is also known as a backprojection.
clf
IR = iradon(R,theta);
imshowpair(I,IR,'montage')
title('Original | Reconstruction')
%[text] - Notice that the reconstructed image is not a perfect reconstruction of the original data.
%[text] - **Remember** - CT's are mathematical reconstructions, NOT ACTUAL IMAGES. The artifacts found in a CT often arise from the process of recreating Images from backprojections. \
%%
%[text] %[text:anchor:H_700FF51E] ### Change the colormap of the backprojection
%[text] The parula colormap highlights the noise in the backprojection
imshowpair(I,IR,'montage')
colormap(gca, "parula")
%%
%[text] %[text:anchor:H_7F35EE42] ## Radon Transform of Intensity and multiple shapes
%[text] So far, we have simply captured the radon transform of a rectangle with a single intensity, at a single location
%[text] The following image has three rectangles at three different locations
I(36:44, 11:39) = 0.5;
I(6:14, 11:39) = 0.25;

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
    ir = imrotate(I,-theta(n));

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
    ylim([0 30])
end
colormap(gray)
%[text] - Interestingly, the transform looks nearly the same at 0˚. Just the height is different (its an integral of intensity data inside the three rectangles).
%[text] - At oblique angles, the transforms are far more complicated
%[text] - Only at 90˚are can three separate rectangles evident.  \
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
%[text] The presence of three rectangles is evidently at around 90˚. Notice that the color is brightest for the center rectangle (which is also brightest in the original image)
%%
%[text] %[text:anchor:H_5A30C062] ## Reconstruct the Image
%[text] Using backprojection
clf
IR = iradon(R,theta);
axp = imshowpair(I,IR,'montage');
title('Original | Reconstruction')
colormap (gca, parula)
%[text] Noise is an inevitable part of the process
%%
%[text] %[text:anchor:T_76315318] # Create a Shepp-Logan Head Phantom
%[text] A Shepp-Logan Head Phantom is a standard phantom used for testing radon transformations 
figure
clearvars
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
%[text] %[text:anchor:H_F0FE5F00] ## Create Sinogram for the Shepp-Phatom
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
%[text] the sinogram is fatter at 90˚ because the original image contains an oval that is wider at the perpendicular angle
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
%[text] Metal (bright pixels) inevitable adds noise to the backprojection 
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
%[text] You try it: recreate a backprojection from a sinogram
%[text] %[text:anchor:H_78B71E26] ## Clean up
clearvars
close all
mmSetUnitDataFolder(3)
load("sinogram_example_data2.mat")
%[text] - or just double-click on the singram\_example\_data2.mat file in the data folder \
%%
%[text] %[text:anchor:H_8C43281F] ## Load and display
%[text] %[text:anchor:H_6123337B] Display the sinogram.
%[text] - The first input into `radon` should be R \
figure('Visible','on','WindowStyle','docked');
theta = 0:179; % angles to calculate transform
imagesc(theta,xp,R);
%%
%[text] %[text:anchor:H_D18DDD4F] ## Lets find out
%[text]  Perform a backprojection (using iradon) and display
P = iradon(R,theta);
imshow(P)

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
