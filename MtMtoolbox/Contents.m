% MTMTOOLBOX
% Modern Human Anatomy (MtM) MATLAB Toolbox
% CU Anschutz School of Medicine
% Ernesto Salcedo, PhD
% Version 1.0, 15-Aug-2026
%
% Volume & image I/O
%   mmReadImgND                 - Read a multidimensional image stack (via Bio-Formats)
%   mmReadRAWimage              - Read a raw image captured with a Sony DSLR camera (.dng)
%   mmSetUnitDataFolder         - Set the current folder to a Unit data folder on the MtMdata shared drive
%
% Plotting & visualization
%   mmAddScaleBar               - Add a scale bar to an image axes
%   mmShowBurnImage             - Display an image with a mask burned in
%   mmShowHist                  - Pair an image with its histogram (per-channel for RGB)
%   mmShowStruct                - Display a set of images stored as fields of a structure
%   mmHistColor                 - Overlay RGB channel histograms as stem or area plots
%   mmBoxSwarm                  - Plot data as a box chart with a swarm or violin overlay
%   mmTightTiledLayout          - Create a tiled layout with no tile spacing or padding
%   mmSetFigPublication         - Set default axes font size and figure color for publication
%
% Color & general utilities
%   mmGetChannelMap             - Return a 256-color colormap for a named channel
%   get_fwhm                    - Full-width at half-maximum of a waveform, with polarity
%
% Surfaces, meshes & 3D geometry
%   mmGetSurface                - Generate a face-vertex isosurface from a 3D volume
%   mmCalcSurfaceAreaFromMesh   - Calculate the surface area of a triangulated mesh
%   mmAlignSurface2Axes         - Align a surface's direction of greatest variance to the x-axis
%   mmAlignSurfaces             - Register two point clouds with iterative closest point (ICP)
%   mmRotateSurfaceVertices     - Rotate surface vertices about the x, y, or z axis
%   mmCreateRotationMat         - Create an affine rotation matrix about the x, y, or z axis
%   transformPoint3d            - Transform 3D points with an affine transform (MatGeom)
%   robustHD                    - Compute a robust (outlier-resistant) Hausdorff distance between two point sets
%
% Slicer segmentation & volume processing
%   mmGetSlicerSegmentInfo      - Read segment names, layers, labels, and colors from a Slicer .seg.nrrd file
%   mmGetSlicerSegmentInfoAll   - Load Slicer segmentation metadata from every .seg.nrrd file in a folder
%   mmGetMedicalVolumeSegment   - Return the mask, color, and transform of a selected segmentation
%   mmGetWatershed              - Watershed-segment a binary 3D volume
%   mmGetTextureFilters         - Generate standard texture filters (std, range, entropy) of an image
%
% Volume Visualization
%   mmPlotSurface               - Plot a face-vertex structure as a patch
%   mmPlotMask2Surface          - Build an isosurface from a mask volume and plot it
%   mmPlotAllSeg                - Plot every segmentation in a Slicer segmentation volume
%   mmSetSurfacePlotProps       - Set lighting, aspect ratio, and axis labels for a surface plot
%   mmVolShowPair               - Display two volshow viewers side by side for comparison
%   mmSetVolShowColors          - Apply a medical colormap and background color to a volshow viewer
%   mmSaveViewer3D              - Save a viewer3d figure to an image file
%
% Apps
%   mmSliceView                 - App Designer app for interactive slice viewing
%