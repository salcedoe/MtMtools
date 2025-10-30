function  mmVolShowPair(seg1,seg2,segTitle)
%MMVOSHOWPAIR - brings up a tiled layout of two volshow viewers,
%side-by-side. Designed to work with structures created by mmGetMedicalVolumeSegment
%
% INPUTS:
% - seg1 and seg2: two structures containing a mask and affine transform field
% - segTitle: title for the display window

arguments
    seg1 struct
    seg2 struct
    segTitle {mustBeText} = "My Seg Comparison"
end

fig = uifigure(Name=segTitle); % special figure that can hold volshow viewers
g = uigridlayout(fig,[1 2],Padding=[0 0 0 0]); % like tiledlayout, but different. 1x2 tiles

% create viewers
hvr1 = viewer3d(parent=g,BackgroundColor="white",BackgroundGradient="off",CameraZoom=1); % set background color to white and turn off gradient
hvr2 = viewer3d(parent=g,BackgroundColor="white",BackgroundGradient="off",CameraZoom=1); % set background color to white and turn off gradient

% add volshow to viewers
volshow(seg1.mask,Parent=hvr1,Transformation=seg1.tform);
volshow(seg2.mask, Parent=hvr2,Transformation=seg2.tform);
end

%[appendix]{"version":"1.0"}
%---
