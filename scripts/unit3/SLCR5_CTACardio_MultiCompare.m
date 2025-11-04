%[text] # CTACardio Multi Segmentation Comparisons
%[text] In this module, we compare the kidney segmentations from the CTACardio segmentation project. 
%[text] Be sure to upload your Segmentation to the Course dropbox.
%[text:tableOfContents]{"heading":"**Table of Contents**"}
%[text] 
%[text] ## Setup
%[text] ### Reset MATLAB
clearvars
close all hidden
%%
%[text] ## Left vs Right Kidney Comparison
%[text] Here we compare the left and right kidneys from one project
%[text] ### Set  paths
paths.project = "/Users/ernesto/MATLAB-Drive/MtMdata/unit3/CTACardio"; %[control:filebrowser:01d8]{"position":[17,70]}
ls(paths.project) % display folder contents
paths.segment = fullfile(paths.project,"Salcedo Segmentation.seg.nrrd");
paths.intensity = fullfile(paths.project,"CTACardio Crop.nrrd");
table(fieldnames(paths),structfun(@(x) exist(x,"file"),paths),VariableNames=["path" "X"]) % make sure paths exist 
%%
%[text] ### Load  medical volume and metadata
intMV = medicalVolume(paths.intensity); 
myMV = medicalVolume(paths.segment); % load segmentation volume as a medical volume
tform = intrinsicToWorldMapping(myMV.VolumeGeometry); % create transformation matrix (scale, rotate, translate)
segT = mmGetSlicerSegTable(paths.segment) % get slicer segmentation data
%%
%[text] ### Display using volshow
hvr = viewer3d("BackgroundColor",'white',BackgroundGradient='off');
hvs = volshow(intMV,OverlayData=myMV.Voxels,Parent=hvr,RenderingStyle="GradientOpacity");
%[text] - the default settings make the segmentations a little hard to see
%[text] - No tissue evident — just bones and ribs \
%%
hvs.OverlayAlpha = single(0.75); % increase alpha of segmentations
%%
hvs.RenderingStyle="VolumeRendering"; % changes how the volume is displayed
%[text] - default is too opaque \
%%
hvs.Alphamap = single(linspace(0,.01,256)); % adjust intensity alpha values - not the low values
%[text] - now you can see some tissue \
%%
%[text] ### Region Properties
%[text] Since the segmentation volume contains both kidneys, we can plug that right into regionprops for some quick data
catSeg = categorical(myMV.Voxels,segT.LabelValue,segT.SegName); % convert to categorical
RP = regionprops3(catSeg,intMV.Voxels,"Volume","MeanIntensity");
RP.VolumeCM3 = RP.Volume .* prod(0.1 * myMV.VoxelSpacing) % convert to cm^3 (aka mL)
%[text] - We see the right kidney is slightly larger than the left kidney
%[text] - Both kidneys have ~ equivalent HU
%[text] - This may be due to the vasculature coming off the kidneys \
%%
%[text] ### Capture extent
%[text] Next, we capture the extent of the kidneys (length, width, and height)
%%
%[text] #### Index out kidney segmentations
%[text] First, we we create two structures that contain a mask of respective kidney segmentation with some information about the segmentation
rkSeg = mmGetMedicalVolumeSegment(myMV,segT,"segName","right kidney")
lkSeg = mmGetMedicalVolumeSegment(myMV,segT,"segName","left kidney")
%%
%[text] #### Plot Segmentations 
figure;
hp1 = mmPlotMask2Surface(rkSeg.mask,fcolor = 'cyan',affTrfm=tform.A,lightEMup=false);
hp2 = mmPlotMask2Surface(lkSeg.mask,fcolor = 'magenta',affTrfm=tform.A);
legend(["rk1" "lk2"])
%[text] - Here we use the transformation vector to plot our segmentations in mm space
%[text] - We also only turn on the "lights" for the second plot (So as to not over-saturate our display) - try setting lightEMup to true \
%%
%[text] #### Center vertices
hp1.Vertices = hp1.Vertices - mean(hp1.Vertices); % center vertices
hp2.Vertices = hp2.Vertices - mean(hp2.Vertices); % center vertices
%[text] - Notice we can't  align kidneys because they are chiral (mirror-images) \
%%
%[text] #### Invert left kidney
%[text] We can reflect the left kidney around the y-axis so it better matches the shape of the right kidney
hp2.Vertices(:,2) = -hp2.Vertices(:,2); % invert flip around the y-axes
%%
%[text] #### Rotate left Kidney
hp2.Vertices = mmRotateSurfaceVertices(hp2.Vertices,'z',180); % rotate left kidney
%%
%[text] #### Align to xy plane
%[text] Here we align our surfaces to the xy plane
hp2.Vertices = mmAlignSurface2Axes(hp2.Vertices);
hp1.Vertices = mmAlignSurface2Axes(hp1.Vertices);
%%
hd = robustHD(hp1.Vertices, hp2.Vertices, 5, 'euclidean')
%%
%[text] #### Align surfaces
 hp2.Vertices = mmAlignSurfaces(hp1.Vertices, hp2.Vertices,"MaxIterations",300,"gridSize",0.5);
 hd = robustHD(hp1.Vertices, hp2.Vertices, 5, 'euclidean')
%[text] - not a perfect match because they are not exactly the same.  \
%%
%[text] #### Capture Bounding Box of the surfaces
%[text] Here we use range to capture the bounding boxes of the surfaces
rkSeg.bbox = range(hp1.Vertices)
lkSeg.bbox = range(hp2.Vertices)
%%
%[text] To understand how range calculates the extent of the kidney, we visualize a bounding box of the right kidney. A bounding box is determined by the minimum vertices and the range of the vertices (length of each side of the box)
drawcuboid('Position',[min(hp1.Vertices) range(hp1.Vertices)]);
%%
%[text] ## Multiple file Analyses
%[text] Use `dir` to get the names of the files
contents = dir(fullfile(matlabdrive,"ANAT6205_Dropbox","Kidneys",'*.seg.nrrd')) % returns info on *.seg.nrrd files
%%
%[text] ### Confirm Segmentation Table contents
%[text] The slicer Segmentation table contains the names of the segmentations, so its good to load all the names to ensure they match
segT = getSegTables(contents)

function T = getSegTables(contents)
% concatenate segmentation tables

T = table; % segmentation metadata
for n=1:numel(contents)
    filepath = fullfile(contents(n).folder,contents(n).name); % construct file path
    t = mmGetSlicerSegTable(filepath,addVolInfo=true); % load current segmentation table
    t.Filename = repmat(string(contents(n).name),height(t),1);
    t.LastName = extractBefore(t.Filename,("_"|" ")); % extract before an underscore or a space
    ln = replace(contents(n).name,' ','_');
    % t.LastName = repmat(string(extractBefore(ln,'_')),height(t),1);
    t = movevars(t,'LastName','Before','SegName');
    
    try
        T = [T; t];
    catch ME
        fprintf('%d. %s. %s',n,t.LastName(1), ME.message)
        continue
    end
end

end
%%
%[text] ### Calculate Kidney Properties
%[text] Here we calculate the kidney properties for all the segmentation files
rpK = getKidneyProps(contents)

function RP = getKidneyProps(contents)
RP = table; % preallocate kidney table

warning('off', 'medical:medicalVolume:noEndian')
figure("Name","Kidneys");

for n=1:numel(contents)

    filepath = fullfile(contents(n).folder,contents(n).name); % construct file path
    lastName = extractBefore(contents(n).name,("_"|" "));
    mv = medicalVolume(filepath);

    st = mmGetSlicerSegTable(filepath);  % get slicer segmentation

    catSeg = categorical(mv.Voxels,st.LabelValue,st.SegName); % create categorical
    rp = regionprops3(catSeg,"Volume");
    rp.VolumeCM3 = rp.Volume * prod(0.1 * mv.VoxelSpacing);
    rp.LastName = repmat(string(lastName), height(rp),1);
    rp = movevars(rp,"LastName","Before","LabelName");

    % split region prop tables
    laK = contains(st.SegName,"kidney","IgnoreCase",true);
    rpK = rp(laK,:); % kidney region props
    
    figure(fh1) % set current figure
    rpK.BBox = getBoundingBox(mv,st(laK,:));
    
    RP = [RP; rpK];
    waitbar(n/num,hwb,lastName)

end
warning('on')
delete(hwb)

end


function [bbox] = getBoundingBox(mv, st)

tform = intrinsicToWorldMapping(mv.VolumeGeometry); % create transformation matrix (scale, rotate, translate)
bbox = zeros(height(st),3);
clrs = 'cm'; % cyan magenta
hwb = waitbar(0,'Calculating...');

nexttile
for n=1:height(st)
    seg = mmGetMedicalVolumeSegment(mv,st,"segName",st.SegName(n));
    fv = mmGetSurface(seg.mask,"affTrfm",tform.A); % create a surface of the volume without plotting
    fv.vertices = fv.vertices - mean(fv.vertices); % center
    if contains(st.SegName,'left')
        fv.vertices(:,2) = - fv.vertices(:,2); % invert around y-axes
    end
    fv.vertices = mmAlignSurface2Axes(fv.vertices); % align to xy plane
    bbox(n,:) = range(fv.vertices);

    mmPlotSurface(fv,clrs(n),0.5); % display surface
end
[~,fname] = fileparts(st.Properties.UserData.Filename);
fname = extractBefore(fname,("_"|" "));
title(fname)
mmSetSurfacePlotProps % properly format surface display

end
%%
%[text] ## Calculate Aorta Properties
%[text] Our Aorta diameters for the descending aorta should range as follows:
%[text] - **Proximal**: 2.1-2.5 cm
%[text] - **Mid**: 1.8-2. cm
%[text] - **Distal**: 1.5-1.9 \
%[text] Let's see how our techniques works
%[text] First, we calculate the properties for the first file
[rpA, seg] = getAortaProps(contents(1)); % just the first file
%%
%[text] #### visualize the results
figure;
tiledlayout("horizontal")
nexttile
mmPlotMask2Surface(seg.maskMO,"affTrfm",seg.tform.A);
title('Morpholocial Clean-up')
nexttile
plot(seg.Radii*2*.1)
xlabel('distal - proximal')
title('diameter along axis')
nexttile
histogram(seg.Radii*2*.1)
title('data not normal')
disp(rpA)
%[text] - since data not normal, we are going to capture the median, min, and max diameters
%[text] - For the min diameter, we are going to calculate the median value for the first 25 points (the most distal points) so as to avoid outliers \
%%
%[text] ### Calculate All the Aortas
rpA = getAortaProps(contents)

function [RP, seg] = getAortaProps(contents)
% Returns region props for aortas in segmentation files found in contents

warning('off', 'medical:medicalVolume:noEndian')
figure("Name","Aorta");

num = numel(contents); % number of files
VNs =["LastName" "Volume" "DiameterMedian" "DiameterMin" "DiameterMax"]; 
RP = table(strings(num,1),zeros(num,1), zeros(num,1), zeros(num,1),  zeros(num,1), VariableNames=VNs);
seg = struct; % returns last structure for troubleshooting

hwb = waitbar(0,'Calculating...');
for n=1:numel(contents)

    filepath = fullfile(contents(n).folder,contents(n).name); % construct file path
    lastName = extractBefore(contents(n).name,("_"|" "));
    
    % load segmentation file
    mv = medicalVolume(filepath);
    % tform = intrinsicToWorldMapping(mv.VolumeGeometry); % create transformation matrix (scale, rotate, translate)

    % extract aorta segmentation
    st = mmGetSlicerSegTable(filepath); % get slicer table
    la = contains(st.SegName,"aorta","IgnoreCase",true); % find aorta

    if ~any(la)
        fprintf('%s missing aorta.\n',lastName)
        RP(n,:) = []; % remove row from table
        continue
    end

    % get aorta segmentation
    seg = mmGetMedicalVolumeSegment(mv,st,"segName",st.SegName(la)); 

    % transform and clean-up volume
    seg.mask = bwareaopen(seg.mask,100); % remove any small noise
    seg.maskMM = imwarp(seg.mask,seg.tform); % warp volume into mm space (in case of anisotropic voxels)
    seg.maskMO = imopen(seg.maskMM,strel('sphere',5)); % remove extraneous vasculature using opening 

    %calculate diameter
    seg.edt = bwdist(~seg.maskMM); % Euclidean Distance Transform
    seg.skel = bwskel(seg.maskMO,MinBranchLength=20); % create skeleton from trimmed aorta
    seg.Radii = seg.edt(seg.skel); % get radii

   
    % create region props table
    rp = table(string(lastName), ...
        sum(seg.maskMM(:))/1000, ... % corrected to cm3
        median(seg.Radii) * 2 * 0.1, ... % cm
        median(seg.Radii(1:25)) * 2 * 0.1,... % median of the first 25 points
        max(seg.Radii) * 2 * 0.1 ,...
        VariableNames = VNs); 
    RP(n,:) = rp;

    % display results
    nexttile
    mmPlotMask2Surface(seg.maskMM,fcolor="cyan",falpha=0.15,lightEMup=false);
    mmPlotMask2Surface(seg.skel,fcolor='m',falpha=1);
    
    title(lastName)
    waitbar(n/num,hwb,lastName)
end
warning('on')
delete(hwb)
end



%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[control:filebrowser:01d8]
%   data: {"browserType":"Folder","defaultValue":"\"\"","label":"select CTACardio folder","run":"Section"}
%---
