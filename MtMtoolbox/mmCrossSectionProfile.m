function [T, S] = mmCrossSectionProfile(seg, options)
%MMCROSSSECTIONPROFILE Measure the cross-sections of a long structure (a
%   bone or a blood vessel) along its whole length
%
% The function cuts the structure into thin slabs, perpendicular to its long
% axis (or to a curved centerline), and measures each slab:
%   1. Every voxel becomes a point in mm
%   2. The long axis is found with pca ("straight"), or a smooth centerline
%      is traced through the skeleton of the mask ("curved")
%   3. Every voxel gets a position along the axis or centerline, and the
%      positions are cut into slabs, two voxels thick by default
%   4. Number of voxels x voxel volume / slab thickness = the area of each
%      cross-section. The equivalent diameter is the diameter of a circle
%      with the same area
%   5. The largest distance to the wall (bwdist) in each slab is the radius
%      of the largest sphere that fits inside the slab
%   6. The narrowest and widest widths of each cross-section (its minimum
%      and maximum Feret diameters) are measured in the plane of the slab
%
% INPUTS
%
% - seg (required):  a structure from mmGetMedicalVolumeSegment (with fields
%                    mask and tform), or a 3D logical mask (then also give
%                    Tform). The voxels must be cubes
%
% Name-Value options
% - Centerline: "straight" (default): a straight long axis, found with pca.
%               Use this for long bones, like the femur
%               "curved": a smooth centerline, traced along the longest path
%               through the skeleton of the mask. Use this for curved
%               structures, like the aorta
%               or an N-by-3 array of [x y z] points in mm, in order
% - SlabWidth:  thickness of each slab (mm). Default: two voxels. A width
%               that isn't a whole number of voxels makes the profile ripple
% - At:         position (% of the length) of the cross-section returned in
%               S.At and S.CrossSection, and shown in the plot. Default 50
% - Smoothing:  length (mm) of the window used to smooth a "curved"
%               centerline. Default 30
% - Plot:       false skips the figure. Default true
% - Title:      title of the figure. Default ""
% - Tform:      affinetform3d from voxels to mm (for mask inputs)
%
% OUTPUTS
%
% T: table with one row per slab, from the inferior end of the structure
%    - Position_mm: distance of the center of the slab along the axis or
%      centerline
%    - Percent: the same position, as a percent of the length
%    - Area_mm2: cross-sectional area
%    - EquivDiameter_mm: diameter of a circle with the same area
%    - InscribedDiameter_mm: diameter of the largest sphere that fits in the
%      slab
%    - MinWidth_mm, MaxWidth_mm: narrowest and widest width of the
%      cross-section, in any direction (minimum and maximum Feret diameters)
%
% S: structure with
%    - Length_mm: length of the structure along the axis or centerline
%    - Centerline: [x y z] points (mm) of the axis or centerline, from the
%      inferior end, one point per slab
%    - SlabWidth_mm: thickness of the slabs
%    - At: the row of T closest to the At position
%    - CrossSection: the cross-section at the At position, with
%        - Points: [u v] coordinates (mm) of its voxels in the plane of
%          the slab, and the names of the u and v directions (UName, VName)
%        - WidthLR_mm, WidthAP_mm, WidthSI_mm: widths along the patient's
%          left-right, front-back (anterior-posterior), and up-down
%          (superior-inferior) directions. NaN for a direction that runs
%          along the structure. For a femur, WidthLR_mm is the mediolateral
%          (ML) width and WidthAP_mm the anteroposterior (AP) width
%        - MinWidthAngle, MaxWidthAngle: direction (degrees from the u
%          direction) of the narrowest and widest widths
%
% EXAMPLES
%
%   [T, S] = mmCrossSectionProfile(femurSeg);                       % femur
%   [T, S] = mmCrossSectionProfile(aortaSeg, Centerline="curved");  % aorta
%   S.At                                    % the cross-section at midshaft
%
% Needs the Image Processing Toolbox.
%
% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado Modern Human Anatomy
% UPDATED: 11/02/2026

arguments
    seg
    options.Centerline = "straight"
    options.SlabWidth double = []
    options.At (1,1) double {mustBeNonnegative, mustBeLessThanOrEqual(options.At, 100)} = 50
    options.Smoothing (1,1) double {mustBePositive} = 30
    options.Plot (1,1) logical = true
    options.Title (1,1) string = ""
    options.Tform = []
end

% mask and transformation
if isstruct(seg)
    mask = logical(seg.mask);
    tform = seg.tform;
else
    mask = logical(seg);
    if isempty(options.Tform)
        error("mmCrossSectionProfile:noTform", "For a mask input, also give Tform (the transformation from voxels to mm).")
    end
    tform = options.Tform;
end
if ndims(mask) ~= 3 || ~any(mask, "all")
    error("mmCrossSectionProfile:mask", "The mask must be 3D and contain at least one voxel.")
end
spacing = vecnorm(tform.A(1:3, 1:3)); % voxel size along x, y, and z (mm)
if max(spacing) - min(spacing) > 0.01 * min(spacing)
    error("mmCrossSectionProfile:spacing", "The voxels must be cubes (spacing is %s mm), because bwdist measures distances in voxels.", ...
        mat2str(spacing, 3))
end
voxelSize = spacing(1);
w = options.SlabWidth;
if isempty(w)
    w = 2 * voxelSize;
end

% crop to the bounding box, with one empty voxel on every side
[r, c, s] = ind2sub(size(mask), find(mask));
offset = [min(r) min(c) min(s)] - 2; % [row col slice] shift of the crop
box = padarray(mask(min(r):max(r), min(c):max(c), min(s):max(s)), [1 1 1]);

% 1. every voxel becomes a point in mm
P = transformPointsForward(tform, [c r s]); % [x y z]; x = column, y = row

% 2-3. axis or centerline, and the position of every voxel along it
if isnumeric(options.Centerline)
    centerline = resampleCenterline(options.Centerline, w);
    method = "given";
elseif options.Centerline == "straight"
    method = "straight";
elseif options.Centerline == "curved"
    method = "curved";
    centerline = skeletonCenterline(box, offset, tform, options.Smoothing, w);
else
    error("mmCrossSectionProfile:centerline", 'Centerline must be "straight", "curved", or an N-by-3 array of points.')
end

if method == "straight"
    center = mean(P);
    coeff = pca(P - center);
    longAxis = coeff(:, 1)';
    longAxis = longAxis * sign(longAxis(3) + eps); % point the axis superiorly
    pos = (P - center) * longAxis'; % position along the axis (mm)
else
    if centerline(1, 3) > centerline(end, 3)
        centerline = flipud(centerline); % start at the inferior end
    end
    tangent = gradient(centerline')';
    tangent = tangent ./ vecnorm(tangent, 2, 2);
    arc = (0:height(centerline) - 1)' * w; % resampled every w mm
    nearest = nearestPoint(P, centerline); % closest centerline point of each voxel
    pos = arc(nearest) + sum((P - centerline(nearest, :)) .* tangent(nearest, :), 2);
end

% cut the positions into slabs
edges = min(pos):w:max(pos) + w;
slab = discretize(pos, edges);
nSlabs = numel(edges) - 1;
position = (edges(1:end-1)' + w/2) - min(pos);
lengthMM = max(pos) - min(pos) + voxelSize; % voxel centers, plus half a voxel at each end

if method == "straight"
    centerline = center + (edges(1:end-1)' + w/2) * longAxis;
    slabTangent = repmat(longAxis, nSlabs, 1);
else
    % tangent at the center of each slab (from the closest centerline point)
    slabTangent = tangent(min(max(round((edges(1:end-1)' + w/2) / w) + 1, 1), height(tangent)), :);
end

% 4. area and equivalent diameter
counts = accumarray(slab, 1, [nSlabs 1]);
area = counts * prod(spacing) / w;
equivDiameter = 2 * sqrt(area / pi);

% 5. largest inscribed sphere in each slab
edt = bwdist(~box); % distance to the nearest voxel outside the mask (voxels)
wallDistance = double(edt(box)) * voxelSize; % same order as P (both are in linear index order)
inscribed = 2 * accumarray(slab, wallDistance, [nSlabs 1], @max, NaN);

% 6. narrowest and widest width of each cross-section
minWidth = nan(nSlabs, 1);
maxWidth = nan(nSlabs, 1);
groups = accumarray(slab, (1:numel(slab))', [nSlabs 1], @(i) {i});
for k = 1:nSlabs
    if numel(groups{k}) >= 3
        [u, v] = planeAxes(slabTangent(k, :));
        uv = P(groups{k}, :) * [u' v'];
        [minWidth(k), maxWidth(k)] = feretWidths(uv, voxelSize);
    end
end

T = table(position, 100 * position / lengthMM, area, equivDiameter, inscribed, minWidth, maxWidth, ...
    VariableNames=["Position_mm" "Percent" "Area_mm2" "EquivDiameter_mm" "InscribedDiameter_mm" "MinWidth_mm" "MaxWidth_mm"]);

% the cross-section at the At position
[~, kAt] = min(abs(T.Percent - options.At));
[u, v, uName, vName] = planeAxes(slabTangent(kAt, :));
uv = P(groups{kAt}, :) * [u' v'];
uv = uv - mean(uv);
[~, ~, minAngle, maxAngle] = feretWidths(uv, voxelSize);
cs.Points = uv;
cs.UName = uName;
cs.VName = vName;
patientAxes = eye(3);
widths = nan(1, 3);
for a = 1:3
    inPlane = patientAxes(a, :) - (patientAxes(a, :) * slabTangent(kAt, :)') * slabTangent(kAt, :);
    if norm(inPlane) > 0.5 % skip a direction that runs along the structure
        widths(a) = range(P(groups{kAt}, :) * (inPlane / norm(inPlane))') + voxelSize;
    end
end
cs.WidthLR_mm = widths(1);
cs.WidthAP_mm = widths(2);
cs.WidthSI_mm = widths(3);
cs.MinWidthAngle = minAngle;
cs.MaxWidthAngle = maxAngle;

S.Length_mm = lengthMM;
S.Centerline = centerline;
S.SlabWidth_mm = w;
S.At = T(kAt, :);
S.CrossSection = cs;

if options.Plot
    plotProfile(P, slab, T, S, kAt, options)
end
end

% -------------------------------------------------------------------------
function centerline = skeletonCenterline(box, offset, tform, smoothing, w)
% Longest path through the skeleton of the mask, smoothed, in mm
skel = bwskel(box, MinBranchLength=20);
CC = bwconncomp(skel, 26); % keep the largest piece: a path can't cross between pieces
if CC.NumObjects > 1
    [~, big] = max(cellfun(@numel, CC.PixelIdxList));
    skel(:) = false;
    skel(CC.PixelIdxList{big}) = true;
end
if nnz(skel) < 2
    error("mmCrossSectionProfile:skeleton", "The skeleton of the mask is too small to trace a centerline.")
end
ends = find(bwmorph3(skel, "endpoints"));
if isempty(ends)
    ends = find(skel, 1); % a skeleton that is a closed loop has no end points
end
% the longest path: from the voxel farthest from any end, to the voxel farthest from it
d0 = bwdistgeodesic(skel, ends(1), "quasi-euclidean");
[~, a] = max(d0(:));
dA = bwdistgeodesic(skel, a, "quasi-euclidean");
[pathLength, b] = max(dA(:));
dB = bwdistgeodesic(skel, b, "quasi-euclidean");
onPath = find(abs(dA + dB - pathLength) < 1); % voxels on the shortest route from a to b
[~, order] = sort(dA(onPath));
[r, c, s] = ind2sub(size(skel), onPath(order));
points = transformPointsForward(tform, [c r s] + offset([2 1 3]));
voxelSize = vecnorm(tform.A(1:3, 1));
points = smoothdata(points, 1, "gaussian", max(round(smoothing / voxelSize), 3));
centerline = resampleCenterline(points, w);
end

function centerline = resampleCenterline(points, w)
% Resample a centerline at steps of w mm along its length
arc = [0; cumsum(vecnorm(diff(points), 2, 2))];
[arc, keep] = unique(arc);
points = points(keep, :);
if numel(arc) < 2
    error("mmCrossSectionProfile:centerline", "The centerline needs at least two different points.")
end
centerline = interp1(arc, points, (0:w:arc(end))');
end

function nearest = nearestPoint(P, centerline)
% Index of the closest centerline point to each voxel (in chunks, to save memory)
nearest = zeros(height(P), 1);
chunk = 20000;
for first = 1:chunk:height(P)
    rows = first:min(first + chunk - 1, height(P));
    d2 = sum(P(rows, :).^2, 2) + sum(centerline.^2, 2)' - 2 * P(rows, :) * centerline';
    [~, nearest(rows)] = min(d2, [], 2);
end
end

function [u, v, uName, vName] = planeAxes(tangent)
% Two perpendicular directions in the plane of a cross-section. u follows
% the patient's left-right axis (or front-back, if the structure runs
% left-right), made perpendicular to the tangent
names = ["left-right" "front-back" "up-down"];
patientAxes = eye(3);
[~, order] = sort(abs(patientAxes * tangent')); % the axes most perpendicular to the tangent first
order = sort(order(1:2)); % keep the usual order (x before y before z)
u = patientAxes(order(1), :) - (patientAxes(order(1), :) * tangent') * tangent;
u = u / norm(u);
v = cross(tangent, u);
uName = names(order(1));
vName = names(order(2));
end

function [minWidth, maxWidth, minAngle, maxAngle] = feretWidths(uv, voxelSize)
% Narrowest and widest widths (mm) of 2D points, over all directions
try
    hull = convhull(uv);
catch
    hull = 1:height(uv); % points on a line
end
angles = 0:179;
directions = [cosd(angles); sind(angles)];
widths = range(uv(hull, :) * directions, 1) + voxelSize; % points are voxel centers
[minWidth, iMin] = min(widths);
[maxWidth, iMax] = max(widths);
minAngle = angles(iMin);
maxAngle = angles(iMax);
end

function plotProfile(P, slab, T, S, kAt, options)
% 3D view colored by equivalent diameter, the cross-section at the At
% position, and the diameter profile
figure(Color="w")
tl = tiledlayout(2, 2, TileSpacing="compact");
if options.Title ~= ""
    title(tl, options.Title, FontWeight="bold")
end

% 3D view of the voxels, colored by the equivalent diameter of their slab
nexttile
show = 1:max(1, floor(height(P) / 30000)):height(P);
scatter3(P(show, 1), P(show, 2), P(show, 3), 4, T.EquivDiameter_mm(slab(show)), "filled", MarkerFaceAlpha=0.15) % see-through, so the centerline shows
hold on
plot3(S.Centerline(:, 1), S.Centerline(:, 2), S.Centerline(:, 3), "k", LineWidth=1.5)
c = S.Centerline(kAt, :);
plot3(c(1), c(2), c(3), "ko", MarkerFaceColor="w", MarkerSize=8)
hold off
axis equal
grid on
view(-60, 15)
colormap(gca, "parula")
cb = colorbar;
cb.Label.String = "equivalent diameter (mm)";
xlabel("x (mm)"); ylabel("y (mm)"); zlabel("z (mm)")
title("Colored by equivalent diameter")

% cross-section at the At position
nexttile
cs = S.CrossSection;
plot(cs.Points(:, 1), cs.Points(:, 2), "s", MarkerSize=5, MarkerFaceColor=[0.6 0.6 0.6], MarkerEdgeColor="none")
hold on
widths = [S.At.MinWidth_mm S.At.MaxWidth_mm];
angles = [cs.MinWidthAngle cs.MaxWidthAngle];
colors = [0.93 0.69 0.13; 0.49 0.18 0.56]; % same colors as the width lines of the profile
for i = 1:2 % draw each width as a line through the center, in its direction
    d = [cosd(angles(i)) sind(angles(i))] * widths(i) / 2;
    plot([-d(1) d(1)], [-d(2) d(2)], LineWidth=2.5, Color=colors(i, :))
end
hold off
legend("voxels", sprintf("narrowest %.1f mm", widths(1)), sprintf("widest %.1f mm", widths(2)), Location="southoutside")
axis equal padded
grid on
xlabel(cs.UName + " (mm)")
ylabel(cs.VName + " (mm)")
title(sprintf("Cross-section at %.0f%%", T.Percent(kAt)))

% diameter profiles
nexttile([1 2])
plot(T.Percent, T.EquivDiameter_mm, LineWidth=1.5)
hold on
plot(T.Percent, T.InscribedDiameter_mm, LineWidth=1.5)
plot(T.Percent, T.MinWidth_mm, ":", LineWidth=1)
plot(T.Percent, T.MaxWidth_mm, ":", LineWidth=1)
xline(T.Percent(kAt), "--")
hold off
xlim([0 100])
grid on
xlabel(sprintf("Position (%% of the length, %.0f mm; 0 = inferior end)", S.Length_mm))
ylabel("Diameter (mm)")
legend("equivalent diameter", "largest inscribed sphere", "narrowest width", "widest width", "", Location="best")
end
