rhd = robustHD( hp1.Vertices, hp2.Vertices, 5, 'euclidean')
%%
[hp2.Vertices] = mmAlignSurfaces(hp1.Vertices, hp2.Vertices,MaxIterations=300);
%%
PCr = pointCloud(hp1.Vertices); % creates a point cloud object of the Right femur
PCl = pointCloud(hp2.Vertices);

fixed = pcdownsample(PCr, 'gridAverage',0.1);
moving = pcdownsample(PCl,'gridAverage',0.1);

tform = pcregisterndt(moving,fixed,1);

%%

regMat = pcregistercpd(moving,fixed);
%%
PCl_aligned = pctransform(PCl,regMat);
hp2.Vertices = PCl_aligned.Location
%%

regMat= pcregistericp(moving,fixed);
%%
regMat = pcregistercorr(moving,fixed,1,.1)
%%
pcshowpair(moving,fixed)
%%

% transform
[regMat] = pcregistericp(moving, fixed);
PCl_aligned = pctransform(PCl,tform);
%%
% % Define a 3D point cloud (example data)
% points = [1 2 3; 4 5 6; 7 8 9];

% Create a rigid transformation to invert around the y-axis
% The reflection matrix for inversion around the y-axis is:
% [ -1  0  0  0;
%   0  1  0  0;
%   0  0  1  0;
%   0  0  0  1]
reflectionMatrix = [-1 0 0 0; 
                     0 1 0 0; 
                     0 0 1 0; 
                     0 0 0 1];

% Create the rigid transformation object
tform = affinetform3d(reflectionMatrix);
lkSeg.maskReflect = imwarp(lkSeg.mask,tform);
%%
figure
hp1 = mmPlotMask2Surface(RP.Image{1},fcolor = 'cyan');
hp2 = mmPlotMask2Surface(reflectedVolume,fcolor = 'magenta');
legend(["rk1" "lk2"])
%%
% moving = single(reflectedVolume);
% fixed = single(RP.Image{1});
[dispField,regVol] = imregdeform(single(rkSeg.mask),single(lkSeg.maskReflect),PixelResolution=myMV.VoxelSpacing, ...
    NumPyramidLevels=6,GridRegularization=0.01);
%%
figure
mmPlotMask2Surface(lkSeg.mask,"fcolor",'cyan',lightEMup=false,centerVerts=true);
hp2 = mmPlotMask2Surface(regVol,fcolor='magenta',centerVerts=true)
%%
hp2.Vertices = mmRotateSurfaceVertices(hp2.Vertices,'z',90)
%%
dispMag = vecnorm(dispField,2,4);
%%
volshow(dispMag)
%%
[optimizer,metric] = imregconfig("monomodal")
%%
reflectionMatrix = [-1 0 0 0; 
                     0 1 0 0; 
                     0 0 1 0; 
                     0 0 0 1];

% Create the rigid transformation object
tform = affinetform3d(reflectionMatrix);
lkSeg.maskReflect = imwarp(lkSeg.mask,tform);
%%
movingRegistered = imregister(single(rkSeg.mask),single(lkSeg.maskReflect),"affine",optimizer,metric);


%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
