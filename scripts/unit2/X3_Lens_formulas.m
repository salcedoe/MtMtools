%[text] # Exploring Lens Equations
%[text] The location of an image relative to the position of the object can easily be calculated using math (**Thin Lens  formula)**
%[text] Suppose you have a simple bi-convex thin lens system, in air, with a focal length of **60 mm?**
%[text] How does this affect the location and magnification of the image, relative to the lens?
%[text] Let's find out...
%[text:tableOfContents]{"heading":"**Table of Contents**"}
%[text] 
%%
%[text] ## Plot Lens and object
%[text] Let's create a figure to illustrate the positions of the object and the image to the lens
%[text] We'll start with a point in object space that is **107 mm** from the center of the lens  and **30 mm** above the optical axis.
clear
close all
figure;
%[text] Set the position of the object
So = 107; % distance from the center of the lens
Ho = 30; % height of object above the axis
Fl = 60; % focal length of the lens
%[text] Plot the Object as a line above the principle axis of the lens
plot( [-So -So], [0 Ho],'o-',... the object
    [-Fl -Fl], [-5 5],'k',...    the focal plane tick (in object space)
    [0 0], [-50 50], '--k',...   center of lens
    [Fl Fl], [-5 5],'k',...      the focal plane (in image space
    [-150 150], [0 0],'k') %     optical axis

text(-60, 10, sprintf('F = %d', Fl))
text(-107, 35, sprintf('So = %d', So))
text(5, 45, 'lens')
%[text] Plot grid lines to indicate possible locations for the image
hold on
plot([So So], [-50 50], '--r',...
    [0 150], [-Ho -Ho], '--r',...
    [0 150], [Ho Ho], '--r')
%%
%[text] ## Predict Image location
%[text] ### Where is the image going to be located?
%[text] Above or below the optical axis?
%[text] ## What is the magnification of the image?
%[text] Smaller or greater than the height of the object?
%[text] ## Thin Lens Formula
%[text] The Thin Lens formula is a follows:
%[text] $\\frac{1}{S\_o }+\\frac{1}{S\_i }=\\frac{1}{f}${"editStyle":"visual"}
%[text] Where
%[text] - $S\_o${"editStyle":"visual"} = The distance of the object from the lens
%[text] - $S\_i${"editStyle":"visual"} = The distance of the image from the lens
%[text] - $f${"editStyle":"visual"} = The focal length of the lens \
%[text] So, it follows that:
%[text] $\\frac{1}{S\_i }=\\frac{1}{f}-\\frac{1}{S\_o }${"editStyle":"visual"}
%[text] Which in MATLAB is written like this:
inv_si = 1/Fl - 1/So % inverse of Si
%[text] And to get the actual distance of the image from the lens, you simply invert ***inv\_si***
Si = 1 / inv_si
%%
%[text] ## Magnification
%[text] Now that we have the location of the image along the optical axis, we need calculate its magnification, so we can determine the height of the object. Linear magnification is easily calculated based on the ratio of the image and object distances, as follows:
%[text] $M=-\\frac{S\_i }{S\_o }${"editStyle":"visual"}
%[text] The magnification is negative because the image is inverted. You can also calculate magnification based on the focal length of the lens a
%[text] In MATLAB, this formula looks like this:
M = -Si/ So
%%
%[text] ## Calculate height of the image
%[text] Recall that magnification is also calculated as the ratio of the height of the image to the height of the object, as follows
%[text] $M=\\frac{H\_i }{H\_o }${"editStyle":"visual"}
%[text] We previously set the height of the object, Ho, to 30. So,...
Hi = M * Ho
%%
%[text] ## Plot the object and the image in one figure
%[text] Now we have all of the information we need to plot the object and the image together using the following code
figure;
plot( [-So -So], [0 Ho],'o-',... object
    [-Fl -Fl], [-5 5],'k',...    focal length (object side)
    [0 0], [-50 50], '--k',...   center of lens of axis with arbitrary height of 50
    [Fl Fl], [-5 5],'k',...      focal length (image side)
    [-150 150], [0 0],'k',...    optical axis (with arbitrary length of 300)
    [So So], [-50 50], '--r',... Zones
    [0 150], [-Ho -Ho], '--r',... Zones
    [Si Si], [0 Hi], 'go-')

text(-Fl, 10, sprintf('F = %d', Fl))
text(-Si, Ho+5, sprintf('So = %d, %d', So, Ho))
text(5, 45, 'lens')
text(Si-50, Hi-5, sprintf('Si = %1.1f, %1.1f', Si, Hi))
%%
%[text] Therefore , the image will be focused to a point in image space that is **greater than** 107 mm from the lens and **greater than** 30 mm **below** the optical axis.
%%
%[text] ## Try it yourself
%[text] Try changing either So, Ho, or Fl and then run the block. The blues lines indicate location and height of the object on the image side
%[text] 
Fl = 29;  %[control:slider:9af3]{"position":[6,8]}
Ho = 62; % height of object %[control:slider:329a]{"position":[6,8]}
So = 110;% distance from lens %[control:slider:6d10]{"position":[6,9]}

plot_results(So, Ho, Fl) % see function below for a better description
%[text] - What happens when you move the object closer to the focal plane?
%[text] - What happens to the image height when you increase the focal length? \
%[text] What happens as you approach the focal length? What happens when So = the focal length? What happens when So is less than the focal length?
%[text] How does changing the focal length change Magnification
%%
%[text] # Plot Function 
%[text] For clarity, I have moved all of the plotting code into a function. You can now use access this function from any code block in this live script simply by using the following syntax:
%[text] ```matlabCodeExample
%[text] plot_results(So, Ho, Fl)
%[text] ```
%[text] As you can see, you will need to input the Object Distance, the Object, Height, and the Focal. The function will then take care of making the calculations to properly plot the image
function plot_results(So, Ho, Fl)

% Calculate Image location
inv_si = 1/Fl - 1/So;
Si = 1 / inv_si
M = -Si/ So;
Hi = M * Ho;

% Calculate axes parameters
Xl = So+Si+10; % axis length
Yl = Ho*2+5; % height of lens


% plot results
plot( [-So -So], [0 Ho],'o-',... object
    [-Fl -Fl], [-5 5],'k',...    focal length (object side)
    [0 0], [-Yl Yl], '--k',...   center of lens of axis 
    [Fl Fl], [-5 5],'k',...      focal length (image side)
    [-Xl Xl], [0 0],'k',...      optical principle axis
    [Si Si], [0 Hi], 'go-')    % image

text(-Fl, 6, sprintf('F = %d', Fl))
text(-So-2, Ho+2, sprintf('So = %d, %d', So, Ho))
text(5, 45, 'lens')
text(Si+2, Hi-2, sprintf('Si = %1.1f, %1.1f', Si, Hi))

% add reference grid lines
hold on
plot([0 Xl], [-Ho -Ho], '--b', [So So], [-2 2], '-r')
hold off
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:9af3]
%   data: {"defaultValue":35,"label":"Slider","max":100,"min":0,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:slider:329a]
%   data: {"defaultValue":30,"label":"Slider","max":100,"min":0,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:slider:6d10]
%   data: {"defaultValue":70,"label":"Slider","max":200,"min":60,"run":"Section","runOn":"ValueChanging","step":1}
%---
