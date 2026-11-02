function [T, S] = mmSurfaceDistance(A, B, options)
%MMSURFACEDISTANCE Compare two segmentations by the distance between their
%   surfaces, like CloudCompare: color one surface by its signed distance to
%   the other, plot a histogram of the distances, and return a summary table
%
% For every vertex of the surface of A, the function measures the distance
% to the surface of B: negative if the vertex is inside B, positive if it is
% outside B. The distances are in mm, even if the voxels are not cubes.
%
% INPUTS
%
% - A, B (required):    the two segmentations to compare. Either
%                       - structures from mmGetMedicalVolumeSegment (with
%                         fields mask and tform), or
%                       - 3D logical masks of the same size. Also provide
%                         Tform or VoxelSpacing, or the distances will be in
%                         voxels
%
% Name-Value options
% - Names:        string array with the names of A and B. Default ["A" "B"]
% - Direction:    "AtoB" (default) measures the distances from A to B.
%                 "both" also measures the distances from B to A (use this
%                 when neither segmentation is the reference)
% - Tolerance:    distance (mm) at which the surfaces count as agreeing.
%                 Default 2
% - Limit:        color limit (mm). Distances beyond +-Limit get the
%                 darkest color. Default: the 95th percentile of the
%                 absolute distances, rounded up
% - Smooth:       true smooths both masks before building the surfaces
%                 (useful for blocky segmentations). Default false
% - ReduceFactor: fraction of the surface triangles to keep (reducepatch).
%                 Default 0.3
% - BinWidth:     histogram bin width (mm). Default 0.5
% - Title:        title of the figure window. Default ""
% - Plot:         false skips the figure. Default true
% - UsePatch:     true plots the surfaces with patch instead of
%                 surfaceMeshShow. Patch is also used automatically if
%                 surfaceMeshShow isn't available. Default false
% - Tform:        affinetform3d from voxels to mm (for mask inputs)
% - VoxelSpacing: [row col slice] voxel size in mm (for mask inputs)
%
% OUTPUTS
%
% T: table with one row per direction, with the variables
%      - Direction: for example "A → B"
%      - Mean_mm, Median_mm: typical absolute distance between the surfaces
%      - HD95_mm: 95th percentile of the absolute distances (robust
%        Hausdorff distance)
%      - Hausdorff_mm: largest absolute distance (Hausdorff distance, in this
%        direction)
%      - PercentWithin<Tolerance>mm: percent of the vertices within the
%        tolerance
%      - MeanSigned_mm: mean signed distance. Negative: the surface is
%        mostly inside the other segmentation
%      - Dice: Dice coefficient of the two masks (same for both rows)
% S: structure array with one element per direction, with the fields
%      - name: for example "A → B"
%      - fv: face-vertex structure of the measured surface, in mm
%      - distances: signed distance (mm) at each vertex of fv
%
% EXAMPLES
%
%   T = mmSurfaceDistance(mySeg, totSeg, Names=["Ours" "TotalSegmentator"]);
%   T = mmSurfaceDistance(t1Seg, t2Seg, Names=["Tumor1" "Tumor2"], Direction="both");
%
% Surfaces are displayed with surfaceMeshShow (Lidar Toolbox, or Point Cloud
% Toolbox in newer releases), if it is available. Needs the Image
% Processing Toolbox.
%
% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado Modern Human Anatomy
% UPDATED: 11/01/2026

arguments
    A
    B
    options.Names (1,2) string = ["A" "B"]
    options.Direction (1,1) string {mustBeMember(options.Direction, ["AtoB" "both"])} = "AtoB"
    options.Tolerance (1,1) double {mustBePositive} = 2
    options.Limit double = []
    options.Smooth (1,1) logical = false
    options.ReduceFactor (1,1) double {mustBePositive, mustBeLessThanOrEqual(options.ReduceFactor, 1)} = 0.3
    options.BinWidth (1,1) double {mustBePositive} = 0.5
    options.Title (1,1) string = ""
    options.Plot (1,1) logical = true
    options.UsePatch (1,1) logical = false
    options.Tform = []
    options.VoxelSpacing double = []
end

[maskA, tform] = getMask(A, options);
[maskB, tformB] = getMask(B, options);
if ~isequal(size(maskA), size(maskB))
    error("mmSurfaceDistance:size", "The masks must be the same size (%s vs %s). Try mmMatchVolumeGeometry.", ...
        mat2str(size(maskA)), mat2str(size(maskB)))
end
if max(abs(tform.A - tformB.A), [], "all") > 1e-6 * max(abs(tform.A), [], "all")
    error("mmSurfaceDistance:geometry", "The two segmentations have different geometries (tform).")
end
if ~any(maskA, "all") || ~any(maskB, "all")
    error("mmSurfaceDistance:empty", "Both masks must contain at least one voxel.")
end

% crop both masks to the region around them, with a margin, to save time
margin = 2 + 4 * options.Smooth;
[r, c, s] = ind2sub(size(maskA), find(maskA | maskB));
first = max([min(r) min(c) min(s)] - margin, 1);
last = min([max(r) max(c) max(s)] + margin, size(maskA));
cropA = double(maskA(first(1):last(1), first(2):last(2), first(3):last(3)));
cropB = double(maskB(first(1):last(1), first(2):last(2), first(3):last(3)));
if options.Smooth
    cropA = smooth3(cropA, "gaussian", 9, 2);
    cropB = smooth3(cropB, "gaussian", 9, 2);
end
offset = [first(2) first(1) first(3)] - 1; % [x y z] = [col row slice] shift of the crop

% voxel size along x (columns), y (rows), and z (slices)
spacing = vecnorm(tform.A(1:3, 1:3));

% measure the distances
names = options.Names;
pairs = {cropA, cropB, names(1) + " → " + names(2)};
if options.Direction == "both"
    pairs(2, :) = {cropB, cropA, names(2) + " → " + names(1)};
end
S = struct("name", {}, "fv", {}, "distances", {});
for n = 1:height(pairs)
    [fv, distances] = surfaceToSurface(pairs{n, 1}, pairs{n, 2}, spacing, options.ReduceFactor);
    fv.vertices = transformPointsForward(tform, fv.vertices + offset); % mm
    S(n) = struct("name", pairs{n, 3}, "fv", fv, "distances", distances);
end

% summary table
diceAB = dice(maskA, maskB);
rows = cell(numel(S), 1);
for n = 1:numel(S)
    d = S(n).distances;
    rows{n} = table(S(n).name, mean(abs(d)), median(abs(d)), prctile(abs(d), 95), max(abs(d)), ...
        100 * mean(abs(d) <= options.Tolerance), mean(d), diceAB, ...
        VariableNames=["Direction" "Mean_mm" "Median_mm" "HD95_mm" "Hausdorff_mm" ...
        "PercentWithin" + options.Tolerance + "mm" "MeanSigned_mm" "Dice"]);
end
T = vertcat(rows{:});

if options.Plot
    if isempty(options.Limit)
        options.Limit = max(ceil(prctile(abs(vertcat(S.distances)), 95)), 1);
    end
    plotDistances(S, options)
end

end

%% local functions

function [mask, tform] = getMask(X, options)
% Get the mask and the voxel-to-mm transformation from a segmentation input
if isstruct(X)
    mask = logical(X.mask);
    tform = X.tform;
else
    mask = logical(X);
    if ~isempty(options.Tform)
        tform = options.Tform;
    elseif ~isempty(options.VoxelSpacing)
        sp = options.VoxelSpacing;
        tform = affinetform3d(diag([sp(2) sp(1) sp(3) 1])); % [x y z] = [col row slice]
    else
        warning("mmSurfaceDistance:noSpacing", "No Tform or VoxelSpacing given, so the distances are in voxels.")
        tform = affinetform3d(eye(4));
    end
end
if ndims(mask) ~= 3
    error("mmSurfaceDistance:dims", "The masks must be 3D.")
end
end

function [fv, distances] = surfaceToSurface(from, to, spacing, reduceFactor)
% Signed distance (mm) from each vertex of the surface of FROM to the
% surface of TO. Both are (smoothed) masks of the same size. Vertices are
% returned in voxel units, as [x y z]

% resample TO onto cubic voxels, so that bwdist measures true distances
iso = min(spacing);
step = iso ./ spacing; % voxel units per cubic voxel, along x, y, and z
if all(abs(step - 1) < 1e-6)
    toIso = to > 0.5;
else
    [X, Y, Z] = meshgrid(1:step(1):size(to, 2), 1:step(2):size(to, 1), 1:step(3):size(to, 3));
    toIso = interp3(to, X, Y, Z, "linear") > 0.5;
end
signedDistMap = (bwdist(toIso) - bwdist(~toIso)) * iso; % mm: negative inside, positive outside

fv = reducepatch(isosurface(from, 0.5), reduceFactor);
p = (fv.vertices - 1) ./ step + 1; % vertex positions in the cubic grid
distances = interp3(signedDistMap, p(:,1), p(:,2), p(:,3), "linear");
end

function plotDistances(S, options)
% One window: each surface colored by distance, next to its histogram
limit = options.Limit;
blueWhiteRed = interp1([-1 0 1], [0.2 0.4 1; 0.95 0.95 0.95; 1 0.3 0.2], linspace(-1, 1, 256));
toColor = @(d) blueWhiteRed(round(rescale(d, 1, 256, InputMin=-limit, InputMax=limit)), :); % clips beyond +-limit

usePatch = options.UsePatch;
if ~usePatch && isempty(which("surfaceMeshShow"))
    disp("surfaceMeshShow isn't available (it needs the Lidar or Point Cloud Toolbox), so we'll use patch instead")
    usePatch = true;
end

nRows = numel(S);
fig = uifigure(Name=options.Title, Color="w", Position=[100 100 1000 450 * nRows]);
grid = uigridlayout(fig, [nRows 2], ColumnWidth={'3x', '2x'}, BackgroundColor="w");

for n = 1:nRows
    d = S(n).distances;
    vertices = S(n).fv.vertices;
    faces = S(n).fv.faces;
    surfaceTitle = S(n).name;
    if nRows == 1 && strlength(options.Title) > 0
        surfaceTitle = options.Title;
    end

    % surface, colored by distance
    if ~usePatch
        try
            mesh = surfaceMesh(vertices, faces, VertexColors=toColor(d));
            viewer = viewer3d(grid, BackgroundColor="white", BackgroundGradient="off", ...
                LightPositionMode="headlight"); % the light moves with the camera
            viewer.Layout.Row = n;
            viewer.Layout.Column = 1;
            surfaceMeshShow(mesh, Parent=viewer, Title=surfaceTitle)
            center = mean(vertices); % start from the front
            viewer.CameraTarget = center;
            viewer.CameraPosition = center - [0 3*max(range(vertices)) 0];
            viewer.CameraUpVector = [0 0 1];
        catch
            disp("surfaceMeshShow failed, so we'll use patch instead")
            usePatch = true;
        end
    end
    if usePatch
        ax = uiaxes(grid);
        ax.Layout.Row = n;
        ax.Layout.Column = 1;
        p = patch(ax, Faces=faces, Vertices=vertices, FaceVertexCData=toColor(d), ...
            FaceColor="interp", EdgeColor="none");
        axis(ax, "equal", "off")
        view(ax, 0, 0) % from the front
        for direction = [1 1 1; -1 -1 1; -1 1 -1; 1 -1 -1]' % four lights, so every side stays lit
            light(ax, Position=direction', Style="infinite");
        end
        lighting(ax, "gouraud")
        material(p, "dull")
        p.AmbientStrength = 0.3; % dimmer, so that four lights don't wash out the colors
        p.DiffuseStrength = 0.45;
        title(ax, surfaceTitle)
    end

    % histogram, with the bars colored like the surface
    ax = uiaxes(grid);
    ax.Layout.Row = n;
    ax.Layout.Column = 2;
    histRange = max(ceil(prctile(abs(d), 99.5) / options.BinWidth) * options.BinWidth, limit);
    edges = -histRange:options.BinWidth:histRange;
    counts = histcounts(min(max(d, -histRange), histRange), edges); % distances beyond the range go in the end bins
    centers = edges(1:end-1) + options.BinWidth / 2;
    bar(ax, centers, counts, 1, FaceColor="flat", CData=toColor(centers), EdgeColor=[0.5 0.5 0.5]);
    xline(ax, 0, "k", LineWidth=1.5)
    xline(ax, [-1 1] * options.Tolerance, "--", Color=[0.4 0.4 0.4])
    xlabel(ax, "Signed distance (mm)")
    ylabel(ax, "Number of vertices")
    title(ax, "Inside ← → Outside")
    ax.Box = "off";
end
end
