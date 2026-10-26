%[text] %[text:anchor:T_50C556DF] # Waves, Frequency, and the Fast Fourier Transform
%[text] This live script is designed to review key concepts such as sine and cosine and the basic properties of waves. We will also introduce the Fourier transform, which is a fancy way to break down a complex wave into its sinusoidal components. Finally, we will perform a forward and inverse Fourier transform on an image to review key concepts that occur during MRI imaging.
%[text] ### Learning Objectives
%[text] After this exercise, you should be able to
%[text] 1. Explain how sine and cosine relate to a circle and to a wave
%[text] 2. Describe the frequency and amplitude of a sine wave
%[text] 3. Explain what a Fourier transform does to a complex wave
%[text] 4. Calculate the Larmor frequency and explain why a precessing spin produces a wave in the receiver coil
%[text] 5. Explain how TR and TE turn differences in T1 and T2 into T1-, T2-, and PD-weighted images
%[text] 6. Explain how a gradient lets frequency encode position
%[text] 7. Explain what k-space is and how an MRI image is reconstructed from it \
%[text] 
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] %[text:anchor:H_70BCFD9B] ## Clear workspace
clearvars;
close all;
clc;
%%
%[text] %[text:anchor:H_10910D06] ## Remember, sine and cosine?
%[text] SOHCAHTOA: Sin (theta) = opposite over hypotenuse, Cos (theta) = adjacent over hypotenuse 
%[text] The following plots the sine and cosine of pi/4
rad = pi/4; % radian

figure;
plot_annotated_triangle(rad)
%[text] - sin(θ) - the length of the opposite side of the triangle
%[text] - cos(θ) - the length of the adjacent side of the triangle \
%%
%[text] %[text:anchor:H_E028C729] ### Sine and cosine can be used to plot out a circle
%[text] - cos(θ) and sin(θ) give the x and y coordinates of a point on a circle \
hold on
r1 = 1; % radius

theta=-pi:0.01:pi; % enter radian values from -pi to pi at 0.01 increments

plot(r1*cos(theta), r1*sin(theta),[0 0],...
    [-1 1],'--', [-1 1], [0 0],'--') % plot the circle
   
axis equal
ylabel('y = sin(\theta)')
xlabel('x = cos(\theta)')

title('The unit circle')
axis on
%%
%[text] Notice what happens to the length of the sine side of the triangle as you go around the circle
figure
bar(theta,sin(theta));
ylabel('sine(\theta)')
xlabel('\theta (radians)')
%%
%[text] %[text:anchor:H_93C89401] ## Sine over time
%[text] Plotting sine over time produces a sine wave
%[text] A computer can't store a smooth, continuous wave. Instead, it *samples* the wave: it records the wave's value at many evenly spaced moments in time. To do this, we need three variables:
%[text] - **T** – the duration: how long the wave lasts, in seconds (here, 1 second)
%[text] - **Fs** – the sample rate: how many samples are recorded per second, in Hz (here, 8000)
%[text] - **t** – the time vector: a list of the times (in seconds) when each sample is recorded. It starts at 0 and counts up to T in steps of 1/Fs seconds (0, 0.000125, 0.00025, ... 1). So, t has T × Fs + 1 values \
%[text] Then, `sin(freq*2*pi*t)` calculates the value of the wave at every time in t.
% set sampling parameters
T = 1; % duration of the wave [s]
Fs = 8000; % sample rate: number of samples per second [Hz]
t = 0 : 1/Fs : T; % time vector: the time of each sample, from 0 to T in steps of 1/Fs [s]

% create sine wave
freq = 200; %Frequency [Hz]
y = sin(freq*2*pi*t)*1; % sine wave

figure;

% Plot sine wave
plot(t(1:100),y(1:100)) % plot a subset of the points
% plot(t,y)
xlabel('seconds')
ylabel('amplitude')
title(sprintf('Frequency = %d Hz',freq))
%[text] - Here we plot only a subset of points (the first 100 points) to better visualize the wave
%[text] - this sine wave has a frequency of 200 Hz and an amplitude of 1 \
%%
%[text] Here's the full 1 second of data
plot(t,y)
xlabel('seconds')
ylabel('amplitude')
%[text] - At this scale, the 200 cycles are packed so tightly that the wave looks like a solid block \
%%
%[text] %[text:anchor:H_C0348656] ## Sounds are waves
%[text] Simple tones can be modeled as sine waves. Here we play our sound wave as a sound
sound(y,Fs)
%%
%[text] %[text:anchor:H_B151654F] ## The Fourier Transform can find the frequency in a wave
%[text] Fourier showed that any periodic signal *s*(*t*) can be written as a sum of sine waves with various amplitudes, frequencies and phases
%[text] We will apply the Fourier transform to the simple sine wave that we just generated (see the local function **get\_fourier** at the end of the script for the code)
%[text] **Predict:** how many peaks do you expect to see, and at what frequency?
figure;
get_fourier(y,Fs)
%[text] - Notice that there is one big peak in the fourier plot (at around the frequency of our sine wave)
%[text] - Go back and change the frequency of the sine wave and repeat the sound produced and the fourier transform \
%%
%[text] %[text:anchor:H_308BFE96] ## Create a Complex  wave
%[text] Let's make a more complex wave by adding a second sine wave, with a frequency of 400 Hz, to our first sine wave. For fun, we will also play this wave as a sound
freq = 400;
y400 = sin(freq*2*pi*t); % create a new sine wave with a frequency of 400 Hz
y_complex = y400+y; % add the second sine wave to our original wave
sound(y_complex/2,Fs); % divide by 2 to keep the values between -1 and 1 (larger values get clipped)

plot(t(1:1000),y_complex(1:1000))
xlabel('seconds')
ylabel('amplitude')
%%
%[text] **Predict:** how many peaks will the Fourier transform of this complex wave have?
figure;
get_fourier(y_complex,Fs)
%[text] - Notice there are now multiple prominent peaks, one at the original sine wave frequency and one at 400
%[text] - Use the data tips tool to see for yourself
%[text] - Try changing the frequency of the second sine wave (from 400 to 500) \
%%
%[text] %[text:anchor:H_43B505D0] ## Real world sounds - the call of the blue whale
%[text] Because blue whale calls are so low, they are barely audible to humans. The time scale in the data is compressed by a factor of 10 to raise the pitch and make the call more clearly audible. 
%[text] The following reads, plots, and plays the data:
mmSetUnitDataFolder(3)
[x,Fs] = audioread("bluewhale.au");
%%
figure;
plot(x)
xlabel('Sample Number')
ylabel('Amplitude')
title('{\bf Blue Whale Call}','Interpreter','Tex')
sound(x,Fs)
%[text] A complex waveform!
%%
%[text] %[text:anchor:H_04F3E9F8] ## Whale Call analysis
%[text] The whale call is composed of an A "trill" followed by a series of B "moans."
%[text] The B call is simpler and easier to analyze. 
%[text] - We'll use the previous plot to determine approximate indices for the beginning and end of the first B call.
%[text] - We'll correct the time base for the factor of 10 speed-up in the data: \

bCall = x(2.45e4:3.10e4);
tb = 10*(0:1/Fs:(length(bCall)-1)/Fs); % Time base

figure;
plot(tb,bCall)
xlim([0 tb(end)])
xlabel('Time (seconds)')
ylabel('Amplitude')
title('Blue Whale B Call')
%%
%[text] %[text:anchor:H_1DF6BE14] ## Fourier transform on whale call
figure;
get_fourier(bCall,Fs,10) % correct the frequency range for the factor of 10 speed-up in the data
title('{\bf Component Frequencies of a Blue Whale B Call}')
%%
%[text] # From Waves to MRI Signals
%[text] So far, we have used the Fourier transform on sounds. An MRI scanner also records a wave, but the "sound" comes from spinning hydrogen nuclei (protons). In this part, we connect the sine waves above to the MRI lecture: the Larmor frequency, the signal the coil records, image contrast, and how a gradient lets frequency tell us *where* a signal came from.
%%
%[text] ## The Larmor frequency
%[text] In a magnetic field, each proton precesses (wobbles like a spinning top) at the **Larmor frequency**:
%[text]{"align":"center"} $ f\_0 = \\bar{\\gamma} B\_0 $
%[text] - $ B\_0 $ is the strength of the main magnetic field, in tesla (T)
%[text] - $ \\bar{\\gamma} $ is the gyromagnetic ratio — the ratio of a particle's magnetic dipole moment to its spin angular momentum. For hydrogen it **is 42.58 MHz per tesla** \
%[text] We can do the math to calculate ratio for Hydrogen Protons in a 1.5T MRI machine:
gammaBar = 42.58; % gyromagnetic ratio of hydrogen [MHz/T]
B0 = 1.5; % field strength of the scanner [T]
f0 = gammaBar * B0 % Larmor frequency of hydrogen [MHz]
%[text] - At 1.5 T, protons precess at about 64 MHz, in the range of FM radio. That's why the scanner is like a radio tuned to one station
%[text] - Try changing B0 to 3 (a 3 T scanner) and rerun this section \
%[text] Electrons also have spin, but their gyromagnetic ratio is about 28,025 MHz per tesla:
gammaBarElectron = 28025; % gyromagnetic ratio of the electron [MHz/T]
fElectron = gammaBarElectron * B0 / 1000 % Larmor frequency of the electron [GHz]
%[text] - At 1.5 T, electrons precess at about 42 GHz (microwaves), so a receiver tuned to 64 MHz never hears them \
%%
%[text] ## Precession makes a wave (RF, that is)
%[text] [MtMdocs precession video](https://salcedoe.github.io/MtMdocs/imaging/MRImaging/#precession)
%[text] Remember that $ \\cos(\\theta) $ and $ \\sin(\\theta) $ give the x and y coordinates of a point on the unit circle. After the 90° pulse, the magnetization, M, lies in the x-y plane and precesses around the z axis. So, the tip of M traces out the unit circle:
%[text] - $ M\_x = \\cos(2\\pi f t) $ and $ M\_y = \\sin(2\\pi f t) $
%[text] - The receiver coil records $ M\_x $ over time, and that is a cosine wave \
%[text] 64 MHz is far too fast to plot, so here we slow precession down to 5 Hz. (The scanner does something similar: it subtracts the Larmor frequency from the signal, leaving only the small differences.)
Fs = 1000; % sample rate [Hz]
t = 0 : 1/Fs : 1; % time vector [s]
f = 5; % slowed-down precession frequency [Hz]
Mx = cos(2*pi*f*t); % x component of M
My = sin(2*pi*f*t); % y component of M
figure;
tiledlayout(1,2)
nexttile
plot(Mx, My, LineWidth=2)
axis equal
xlabel('M_x = cos(2\pi ft)')
ylabel('M_y = sin(2\pi ft)')
title('The tip of M during precession')
nexttile
plot(t, Mx, LineWidth=2)
xlabel('Time (s)')
ylabel('Signal in the coil (M_x)')
title('...is recorded as a wave')
%[text] - The left plot is the unit circle from the beginning of this script
%[text] - The right plot is the same motion, viewed over time: a cosine wave with a frequency of 5 Hz \
%%
%[text] ## The signal fades: the free induction decay
%[text] The signal does not last forever. As the spins fall out of phase with each other (T2 decay), the wave shrinks:
%[text]{"align":"center"} $ \\textrm{signal}(t) = \\cos(2\\pi f t) \\cdot e^{-t/T2} $
%[text] This fading wave is called the **free induction decay** (FID). Here we compare a tissue with a long T2 to one with a short T2, and take the Fourier transform of each.
%[text] **Predict:** how will the Fourier transform of the short-T2 signal differ from the long-T2 signal?
f = 50; % precession frequency [Hz]
T2long = 0.2; % long T2, like fluid [s]
T2short = 0.02; % short T2 [s]
fidLong = cos(2*pi*f*t) .* exp(-t/T2long); % FID with a long T2
fidShort = cos(2*pi*f*t) .* exp(-t/T2short); % FID with a short T2
figure;
tiledlayout(2,2)
nexttile
plot(t, fidLong, t, exp(-t/T2long), '--')
xlim([0 0.5])
xlabel('Time (s)')
title('FID, long T2 (200 ms)')
nexttile
get_fourier(fidLong, Fs)
xlim([0 100])
nexttile
plot(t, fidShort, t, exp(-t/T2short), '--')
xlim([0 0.5])
xlabel('Time (s)')
title('FID, short T2 (20 ms)')
nexttile
get_fourier(fidShort, Fs)
xlim([0 100])
%[text] - Both peaks are at 50 Hz, the precession frequency
%[text] - The short-T2 peak is lower and wider: a signal that fades quickly contains a wider range of frequencies
%[text] - The dashed line is the T2 decay curve, $ e^{-t/T2} $ \
%%
%[text] ## Contrast: TR, TE, and weighting
%[text] Each tissue has its own T1 and T2. We can't change those, but we can choose our timing:
%[text] - **TR** (repetition time): how long we wait between 90° pulses. During TR, $ M\_z $ recovers with T1
%[text] - **TE** (echo time): how long we wait after the pulse before we listen. During TE, $ M\_{xy} $ decays with T2 \
%[text] For a spin echo, the brightness (signal) of each tissue is approximately
%[text]{"align":"center"} $ S = PD \\cdot (1 - e^{-TR/T1}) \\cdot e^{-TE/T2} $
%[text] where PD is the proton density (how much hydrogen the tissue has). Use the sliders to change TR and TE. The relaxation times are approximate values at 1.5 T.
TR = 3350; % repetition time: time between 90° pulses [ms] %[control:slider:b7e1]{"position":[6,10]}
TE = 115; % echo time: time from the 90° pulse to the echo [ms] %[control:slider:c4d2]{"position":[6,9]}
sequence_parameters(TR, TE)
%[text] - The T2 decay curves start where the T1 recovery curves were at TR. A tissue that hasn't recovered has less signal to give \
%[text] Try these settings:
%[text] - **T1-weighted:** short TR (500 ms), short TE (15 ms)
%[text] - **T2-weighted:** long TR (3000 ms), long TE (100 ms)
%[text] - **PD-weighted:** long TR (3000 ms), short TE (15 ms) \
%[text] Answer these questions:
%[text] 1. Which tissue is brightest on the T1-weighted setting? Which is darkest?
%[text] 2. What happens to CSF when you switch from T1-weighted to T2-weighted? Why?
%[text] 3. Why does a short TE remove most of the T2 differences?
%[text] 4. On the T1-weighted setting, gray matter and white matter look almost the same. Set PD to 1 for every tissue and rerun the section. What changes? (Real T1-weighted scans often use extra tricks, like inversion recovery, to make gray and white matter look more different.) \
%%
%[text] Function to generate above plots
function sequence_parameters(TR, TE)
tissues = ["Fat" "White matter" "Gray matter" "CSF"];
T1 = [260 790 920 4000]; % T1 of each tissue [ms]
T2 = [80 80 100 2000]; % T2 of each tissue [ms]
PD = [0.9 0.7 0.8 1.0]; % relative proton density of each tissue
S = PD .* (1 - exp(-TR./T1)) .* exp(-TE./T2); % signal (brightness) of each tissue
tissueColors = [0.85 0.47 0.18; 0.40 0.47 0.55; 0.43 0.70 0.80; 0.12 0.50 0.65]; % one color per tissue
figure;
tiledlayout(1,3,"TileSpacing","compact")
% T1 recovery: how much Mz is ready when we pulse again, at TR
nexttile
tRecover = 0:5000; % [ms]
hold on
for i = 1:numel(tissues)
    plot(tRecover, PD(i)*(1 - exp(-tRecover/T1(i))), LineWidth=2, Color=tissueColors(i,:))
end
xline(TR, '--k', 'TR')
hold off
xlabel('Time (ms)')
ylabel('M_z')
title('T1 recovery')
legend(tissues, Location="southeast")
% T2 decay: how much Mxy is left when we listen, at TE
nexttile
tDecay = 0:300; % [ms]
hold on
for i = 1:numel(tissues)
    plot(tDecay, PD(i)*(1 - exp(-TR/T1(i)))*exp(-tDecay/T2(i)), LineWidth=2, Color=tissueColors(i,:))
end
xline(TE, '--k', 'TE')
hold off
xlabel('Time (ms)')
ylabel('M_{xy}')
title('T2 decay')
% brightness of each tissue: taller and lighter bars are brighter
nexttile
b = bar(categorical(tissues, tissues), S, FaceColor="flat", EdgeColor="none");
b.CData = repmat((S/max(S))', 1, 3); % gray level of each bar matches its brightness
set(gca, Color='k')
ylim([0 1])
ylabel('Signal')
title(sprintf('TR = %d ms, TE = %d ms', TR, TE))
end
%[text] 
%%
%[text] %[text:anchor:T_B1037C2F] # 2D Fourier Transforms
%[text] So, what does this have to do with MRIs? An MRI scanner does not take a picture directly. Instead, it measures the spatial frequencies of the tissue, and stores them in what is called **k-space**. The image is then reconstructed from k-space using an inverse Fourier transform. To see how this works, we'll apply a 2D Fourier transform to a cross-section of an MRI dataset
%[text] First, we load an MRI dataset
clearvars
clc
close all
load mri.mat
montage(D,map)
title('Axial Slices');
%[text] - Notice that D is a 4D array: 128 rows × 128 columns × 1 color channel × 27 slices
%[text] - The third dimension (color) has a size of 1, because the images are grayscale \
%%
%[text] %[text:anchor:H_CAF570E2] ## Grab the 15th Slice
figure;
slice = squeeze(D(:,:,:,15));
imshow(slice,[])
%%
%[text] %[text:anchor:H_2990E979] ## Fourier Transform of the image
%[text] The 2D Fourier transform (**fft2**) breaks the image down into 2D sine waves (stripes) that run in every direction, with different frequencies.
%[text] - In the magnitude plot, the center shows the low frequencies (large, smooth features) and the edges show the high frequencies (fine details and edges)
%[text] - We plot the log of the magnitude, because the center values are so much larger than everything else that the rest of the plot would look black \
figure
tiledlayout(1,3,Padding="tight")

nexttile
imshow(slice,[])
title('image read in')

fftS = fft2(double(slice));

% frequency
nexttile
imshow(log(1 + abs(fftshift(fftS))), []) % log scale, so the small values are visible
title('FFT2 Magnitude (log scale)')

% phase
nexttile
imshow(angle(fftshift(fftS)),[-pi pi])
title('FFT2 Phase')
%[text] Notice that there are two components to the Fourier Transform: a Magnitude and a Phase. The magnitude tells you *how much* of each frequency is in the image, and the phase tells you *where* those waves line up. You need both to rebuild the image.
%%
%[text] %[text:anchor:H_5D20CEFC] ## Display inverse Fourier transform
%[text] The MRI scanner collects k-space data and must invert that transform to create the image
%[text] This code performs the inverse Fourier transform (**ifft2**) and displays the results
imageC = ifft2(fftS);

figure;
imshow(abs(imageC), []) % [] scales the display from the min to the max value
%[text] How close is the reconstruction to the original image?
maxDifference = max(abs(double(slice) - abs(imageC)), [], 'all')
%[text] - The difference is tiny (just rounding error). The Fourier transform does not lose any information \
%%
%[text] ## Explore k-space
%[text] In MRI, k-space is the 2D Fourier transform of the image. The center of k-space holds the low spatial frequencies (overall brightness and contrast), and the outer edges hold the high spatial frequencies (fine details and edges).
%[text] **Predict:** what will the image look like if we keep only the center of k-space? What if we keep only the edges?
kspace = fftshift(fftS); % shift so the low frequencies are in the center
[rows, cols] = size(kspace);
[X, Y] = meshgrid(1:cols, 1:rows);
r = hypot(X - (cols/2 + 1), Y - (rows/2 + 1)); % distance of each point from the center of k-space
centerMask = r <= 10; % keep a small circle (radius of 10 pixels) in the center

lowImage = abs(ifft2(ifftshift(kspace .* centerMask))); % reconstruct from the center only
highImage = abs(ifft2(ifftshift(kspace .* ~centerMask))); % reconstruct from the edges only

figure
tiledlayout(2,2,"TileSpacing","tight","Padding","tight")
nexttile
imshow(log(1 + abs(kspace)) .* centerMask, [])
title('k-space: center only')
nexttile
imshow(log(1 + abs(kspace)) .* ~centerMask, [])
title('k-space: edges only')
nexttile
imshow(lowImage, [])
title('Image from the center')
nexttile
imshow(highImage, [])
title('Image from the edges')
%[text] - Center only: the overall shape and contrast are preserved, but the image is blurry
%[text] - Edges only: only the outlines (edges) of the structures remain
%[text] - Try changing the radius of centerMask (e.g., 5 or 25) and rerun this section \
%%
%[text] A review of how MRI images are formed (Sprawls, *MRI: Physical Principles*):
web('https://www.sprawls.org/mripmt/MRI05/')
%%
%[text] # Exercise - Fourier Transforms
%[text] You try it: use the Fourier transform to uncover a mystery sound and a mystery MRI. (The answer key is in a separate file.)
%[text] ## Load the exercise data
clearvars
close all
mmSetUnitDataFolder(3)
load("fourier_exercise_data.mat")
%[text] This loads three variables: 
%[text] - **y\_mystery** (a sound wave) and **Fs** (its sample rate)
%[text] - **kspace\_mystery** (MRI k-space data) \
%[text] Or just double-click on the fourier\_exercise\_data.mat file in the data folder
%%
%[text] ## Exercise 1: The mystery tone
%[text] y\_mystery is a mix of several sine waves. Listen to it:
sound(y_mystery/2, Fs) % divide by 2 to keep the values between -1 and 1
%%
%[text] ### Plot the mystery wave
%[text] Plot y\_mystery the same way we plotted the 200 Hz sine wave in the "Sine over time" section:
%[text] 1. Set the duration, **T**, to 1 (y\_mystery is 1 second long)
%[text] 2. Create the time vector, **t**, from T and Fs. It should start at 0 and count up to T in steps of 1/Fs
%[text] 3. Check your work: t should have the same number of values as y\_mystery (use **numel** to compare them)
%[text] 4. Plot only the first 1000 samples of y\_mystery against t, so you can see the shape of the wave
%[text] 5. Label the x-axis (seconds) and the y-axis (amplitude) \
% YOUR CODE HERE

%[text] - How is this wave different from the 200 Hz sine wave we plotted earlier? \
%%
%[text] ### Find the frequencies
%[text] **Predict:** how many different tones do you think are mixed together?
%[text] Use the local function **get\_fourier** to find the frequencies in y\_mystery.
%[text] - The first input into **get\_fourier** should be the wave, and the second should be the sample rate \
% YOUR CODE HERE

%[text] Answer these questions:
%[text] 1. How many sine waves are in y\_mystery?
%[text] 2. What are their frequencies (in Hz)? (Use the data tips tool)
%[text] 3. Which frequency is the loudest? How can you tell? \
%%
%[text] ## Exercise 2: The mystery MRI
%[text] kspace\_mystery is the k-space data from an MRI scan, just like the data an MRI scanner collects. Let's look at it first:
figure;
imshow(log(1 + abs(fftshift(kspace_mystery))), []) % log scale, low frequencies in the center
title('Mystery k-space')
%%
%[text] ### Reconstruct the image
%[text] **Predict:** can you tell what was scanned just by looking at k-space?
%[text] Now reconstruct the image from kspace\_mystery and display it.
%[text] - Use the inverse Fourier transform (**ifft2**), then display the **abs** of the result with **imshow**
%[text] - kspace\_mystery has not been shifted, so you can pass it straight to **ifft2** \
% YOUR CODE HERE

%[text] - What part of the body was scanned? \
%%
%[text] ### Reconstruct from the center and the edges of k-space
%[text] Now recreate the 2 × 2 figure from the "Explore k-space" section, but this time with kspace\_mystery. Follow these steps (you can copy and adapt the code from the "Explore k-space" section):
%[text] 1. **Shift k-space:** use **fftshift** to move the low frequencies of kspace\_mystery to the center. Save the result as **kspace**
%[text] 2. **Measure the distance from the center:** get the number of rows and columns in kspace with **size**, make X and Y coordinate grids with **meshgrid**, and use **hypot** to calculate **r**, the distance of every point from the center of k-space
%[text] 3. **Make the mask:** create **centerMask**, a logical mask that is true where r is 10 or less. (`~centerMask` gives you the edges.)
%[text] 4. **Reconstruct two images:** multiply kspace by centerMask (center only) and by ~centerMask (edges only). For each one, use **ifftshift** to undo the shift, then **ifft2**, then **abs**. Save the results as **lowImage** and **highImage**
%[text] 5. **Make the figure:** create a 2 × 2 **tiledlayout**. In the top row, show the center and the edges of k-space (use `log(1 + abs(kspace))` times each mask). In the bottom row, show lowImage and highImage. Give each tile a title \
% YOUR CODE HERE

%[text] Answer these questions:
%[text] 1. What happens to the image when you keep only the center of k-space?
%[text] 2. What happens to the image when you keep only the edges of k-space?
%[text] 3. Try a radius of 5, 20, and 40. What is the smallest radius at which you can still recognize the anatomy?
%[text] 4. An MRI scan is faster when it collects less of k-space. Based on your results, what is the trade-off of a faster scan? \
%%
%[text] %[text:anchor:T_708b] # Local Functions
function plot_annotated_triangle(rad)
plot([0 cos(rad)], [0 sin(rad)],'-ro',... 
    [cos(rad) cos(rad)], [0 sin(rad)],'--ro',...
    [0 cos(rad)], [0 0],'--ro') % plot rad

axis off

offset = 0.025;
text(cos(rad)+offset, sin(rad)+offset,'(cos\theta, sin\theta)','Interpreter','Tex','FontSize',16)
text(cos(rad)/2 - 0.1, -0.065,'cos(\theta)','Interpreter','Tex','FontSize',16)
text(cos(rad) + offset, sin(rad)/2,'sin(\theta)','Interpreter','Tex','FontSize',16)
text(0.1, 0.065,'\theta','Interpreter','Tex','FontSize',16)
end

%%
%[text] %[text:anchor:H_8513] ### Get Fourier
%[text] - Use fft to compute the DFT of the signal.
%[text] - Correct the frequency range for the factor of 10 speed-up in the data
%[text] - Nyquist frequency: half of the sampling rate of a discrete signal processing system \
function get_fourier(y,Fs,correction)

m = length(y);      % Window length
n = pow2(nextpow2(m));  % Transform length
fy = fft(y,n);       % DFT of signal

% set frequency range
if nargin>2
    f = (0:n-1)*(Fs/n)/correction;  % Frequency range with correction
else
    f = (0:n-1)*(Fs/n);  % Frequency range
end

p = fy.*conj(fy)/n;       % Power of the DFT

% Plot the first half of the periodogram, up to the Nyquist frequency:

% figure;
plot(f(1:floor(n/2)),p(1:floor(n/2)))
xlabel('Frequency (Hz)')
ylabel('Power')
% set(gca,'XTick',[0 50 100 150 200]);
title('Fourier transform (power spectrum)')
grid on
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:b7e1]
%   data: {"defaultValue":500,"label":"TR (ms)","max":5000,"min":100,"run":"Section","runOn":"ValueChanged","step":50}
%---
%[control:slider:c4d2]
%   data: {"defaultValue":15,"label":"TE (ms)","max":200,"min":5,"run":"Section","runOn":"ValueChanged","step":5}
%---
