function  mmVolShowPair(vol1,vol2,options)
%MMVOSHOWPAIR - brings up a tiled layout of two volshow viewers,
%side-by-side. Designed to work with structures created by mmGetMedicalVolumeSegment
%
% INPUTS:
% - seg1 and seg2: two structures containing a mask and affine transform field
% - segTitle: title for the display window

arguments
    vol1
    vol2
    options.SegTitle {mustBeText} = "My Seg Comparison"
    options.RenderStyle {mustBeText} = "VolumeRendering"
end

fig = uifigure(Name=options.SegTitle); % special figure that can hold volshow viewers
g = uigridlayout(fig,[1 2],Padding=[0 0 0 0]); % like tiledlayout, but different. 1x2 tiles

% create viewers
% hvr1 = viewer3d(parent=g,BackgroundColor="white",BackgroundGradient="off",CameraZoom=1); % set background color to white and turn off gradient
% hvr2 = viewer3d(parent=g,BackgroundColor="white",BackgroundGradient="off",CameraZoom=1); % set background color to white and turn off gradient

hvr1 = viewer3d(parent=g, CameraZoom=1); % set background color to white and turn off gradient
hvr2 = viewer3d(parent=g, CameraZoom=1); % set background color to white and turn off gradient

if isstruct(vol1) && isstruct(vol2)
    % add volshow to viewers
    volshow(vol1.mask,Parent=hvr1, ...
        RenderingStyle=options.RenderStyle, ...
        Transformation=vol1.tform);
    volshow(vol2.mask, Parent=hvr2, ...
        RenderingStyle=options.RenderStyle, ...
        Transformation=vol2.tform);
elseif ndims(vol1) == 3 && ndims(vol2)== 3
    volshow(vol1, Parent=hvr1, ...
        RenderingStyle=options.RenderStyle)
    volshow(vol2,Parent=hvr2, ...
        RenderingStyle=options.RenderStyle)
end

%[appendix]{"version":"1.0"}
%---
