%[text] %[text:anchor:T_50C556DF] # Waves, frequency, and the fast fourier transform
%[text] In this live script is designed to review key concepts such as sine and cosine and basic properties of waves. We will also introduce the fourier transform, which is a fancy way to break down a complex wave into its sinusoidal components. Finally, we will perform a forward and reverse fourier transform on an image, to review key concepts that occur during MRI imaging. 
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
%[text] - sin(θ) - the length of the opposite side of the triangle \
%%
%[text] %[text:anchor:H_E028C729] ### Sine and cosine can be used to plot out a circle
%[text] - sin(θ) and cos(θ) give the x and y coordinates of a circle \
hold on
r1 = 1; % radius

theta=-pi:0.01:pi; % enter radian values from -pi to pi at 0.01 increments

plot(r1*cos(theta), r1*sin(theta),[0 0],...
    [-1 1],'--', [-1 1], [0 0],'--') % plot the circle
   
axis equal
ylabel('sine (radians)')
xlabel('cosine (radians)')

title('sine vs cosine')
axis on
%%
%[text] Notice what happens to length of the sine side of the triangle as you go around the circle
figure
bar(theta,sin(theta));
ylabel('sine(\theta)')
xlabel('\theta (radians)')
%%
%[text] %[text:anchor:H_93C89401] ## Sine over time
%[text] Plotting sine over time produces a sine wave
% set sampling parameters
T=1; %duration [s]
Fs = 8000; %sample rate [Hz] Supported by Sound Card (16000,48000,96000,192000)
N = T*Fs; %samples
t = 0 : 1/Fs : T; %samples vector

% create sine wave
freq = 200; %Frequency [Hz]
y = sin(freq*2*pi*t)*1; % sine wave

figure;

% Plot sine wave
plot(t(1:100),y(1:100)) % plot a subset of the points
% plot(t,y)
xlabel('seconds')
ylabel('power')
title(sprintf('Frequency = %d',freq))
%[text] - Here we plot only a subset of points (the first 100 points) to better visualize the wave
%[text] - this sine wave has a frequency of 200 Hz and an amplitude of 1 \
%%
%[text] Here's the full 1 second of data
plot(t,y)
xlabel('seconds')
%%
%[text] %[text:anchor:H_C0348656] ## Sounds are waves
%[text] Simple tones can be modeled as sine waves. Here we play our sound wave as a sound
sound(y,Fs)
%%
%[text] %[text:anchor:H_B151654F] ## The Fourier Transform can find the frequency in a wave
%[text] Fourier showed that any periodic signal *s*(*t*) can be written as a sum of sine waves with various amplitudes, frequencies and phases
%[text] We will apply the fourier transform to the simple sine wave that we just generated (see local function for code)
get_fourier(y,Fs)
%[text] - Notice that there is one big peak in the fourier plot (at around the frequency of our sine wave)
%[text] - Go back and change the frequency of the sine wave and repeat the sound produced and the fourier transform \
%%
%[text] %[text:anchor:H_308BFE96] ## Create a Complex  wave
%[text] lets add some noise to our sine wave by adding a second sine wave to the first sine wave at a frequency of 400. For fun, we will also play this wave as a sound
freq = 400;
y400 = sin(freq*2*pi*t); % Create new sin wave with a 
y_complex = y400+y; % add a second sine wave to our original wave
sound(y_complex,Fs);

plot(t(1:1000),y_complex(1:1000))
xlabel('seconds')
ylabel('power')
%%
get_fourier(y_complex,Fs)
%[text] - Notice there are now multiple prominent peaks, one at the original sine wave frequency and one at 400
%[text] - Use the data tips tool to see for yourself
%[text] - Try changing the frequency of the second sign wave (from 400 to 500) \
%%
%[text] %[text:anchor:H_43B505D0] ## Real world sounds - the call of the blue whale
%[text] Because blue whale calls are so low, they are barely audible to humans. The time scale in the data is compressed by a factor of 10 to raise the pitch and make the call more clearly audible. 
%[text] The following reads, plots, and plays the data:
% whaleFile = fullfile(matlabroot,'examples','matlab','data','bluewhale.au');
% [w,fs] = audioread(whaleFile);z

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
%[text] The wale call is comprise of an A "trill" is followed by a series of B "moans."
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
get_fourier(bCall,Fs,10) % Here we Correct the frequency range for the factor of 10 speed-up in the data:
title('{\bf Component Frequencies of a Blue Whale B Call}')
%%
%[text] %[text:anchor:T_B1037C2F] # 2D Fourier Transforms
%[text] So, what does this have to do with MRIs? MRIs are actually captured as fourier transforms. To see how this might work, we'll apply a fourier transform to a cross-section of an MRI dataset
%[text] First, we load an MRI dataset
clearvars
clc
close all
load mri.mat
montage(D,map)
title('Horizontal Slices');
%[text] notice the dataset is a 4D dataset
%%
%[text] %[text:anchor:H_CAF570E2] ## Grab the 15th Slice
figure;
slice = squeeze(D(:,:,:,15));
imshow(slice,[])
%%
%[text] %[text:anchor:H_2990E979] ## Fourier Transform of the image
%[text] treat each row like a sine wave
%[text] Bright colors are high values
%[text] Dark colors are low values
figure

subplot(1,3,1)
imshow(slice,[])
title('image read in')

fftS = fft2(double(slice));

% frequency
subplot(1,3,2)
% imshow(abs(fftshift(fftS)),[24 100000])
imshow(abs(fftshift(fftS)), parula(10000))
% colormap(gray)
title('Image A FFT2 Magnitude')

% phase
subplot(1,3,3)
imshow(angle(fftshift(fftS)),[-pi pi])
title('Image A FFT2 Phase')
%[text] Notice that there are two components to the Fourier Transform: a Magnitude and a Phase. The magnitude contains the frequency components of the image
%%
%[text] %[text:anchor:H_5D20CEFC] ## Display inverse fourier transform
%[text] The MRI captures a fourier transform and needs to invert that transform to create the image
%[text] This code performs  the inverse fourier transform and displays the results
% imageC = abs(fftS).*exp(i*angle(fftS))

imageC = ifft2(fftS);


figure; 

cmin = min(min(abs(imageC)));
cmax = max(max(abs(imageC)));

imshow(abs(imageC), [cmin cmax])
colormap gray
%%
web('http://matlabgeeks.com/tips-tutorials/how-to-do-a-2-d-fourier-transform-in-matlab/','-browser')
%%
web('http://www.sprawls.org/mripmt/MRI05/')
%%
%[text] %[text:anchor:T_708b] # Local Function
function y = get_sine_wave(Freq)

end

function plot_annotated_triangle(rad)
plot([0 cos(rad)], [0 sin(rad)],'-ro',... 
    [cos(rad) cos(rad)], [0 sin(rad)],'--ro',...
    [0 cos(rad)], [0 0],'--ro') % plot rad

axis off

offset = 0.025;
text(sin(rad)+offset, cos(rad)+offset,'\pi/4','Interpreter','Tex','FontSize',16)
text(0.25, -0.065,'cos(\theta)','Interpreter','Tex','FontSize',16)
text(0.79, 0.3,'sin(\theta)','Interpreter','Tex','FontSize',16)
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
title('Fourier transform of the sine wave')
grid on
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
