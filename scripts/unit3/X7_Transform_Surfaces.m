%[text] # Transforming Surfaces
%[text] In this module, we will demonstrate how easy it is to Scale, Rotate, and Translate surfaces. These actions are collectively known as transformations.
%[text] ### Learning Objectives
%[text] After this exercise, you should be able to
%[text] 1. Scale a shape by multiplying its vertices
%[text] 2. Translate (move) a shape by adding to or subtracting from its vertices
%[text] 3. Rotate a shape with a rotation matrix, and explain why we center a shape before rotating it
%[text] 4. Convert a surface from voxel units to mm, and place it in patient coordinates with a transformation matrix
%[text] 5. Measure a 3D surface using its range and the distances between its vertices \
%[text:tableOfContents]{"heading":"Table of Contents"}
%%
%[text] %[text:anchor:H_D3E98789] ## First, a review of the 2D realm
%[text] Triangles have three vertices (three X,Y coordinates). We can organize these vertices as a matrix, where every row in the matrix represents one vertex (an x,y pair):
clearvars
V = [0 0; 3 0; 3 4] 
%[text] - Here, the first column is the x-coordinates and the second column is the y-coordinates \
%%
%[text] %[text:anchor:H_B2411B8E] ### Plot Triangle
%[text] We can plot the vertices using **scatter** 
figure;
% plot vertices
scatter(V(:,1),V(:,2),'filled');
xlabel('x'); ylabel('y');
grid minor % display grid on plot
axis equal
%%
%[text] And the triangle face using **patch**. 
% add face
patch(V(:,1),V(:,2),'blue','LineStyle',':','FaceAlpha',0.55)
xlim([-1 4]); ylim([-1 5])
xline(0); yline(0)
%%
%[text] %[text:anchor:H_CE2E914D] ### Scaling
%[text] You can scale the size of a triangle by multiplying (or dividing) the vertices by a factor. 
%[text] Try it now: Triple the vertices
V = V * 3
%%
%[text] Plot the larger triangle:
hold on
scatter(V(:,1),V(:,2),'filled');
patch(V(:,1),V(:,2),'yellow','FaceAlpha',0.1);
xlim([-2 10]); ylim([-2 12])
xline(0); yline(0)
%[text] - The blue triangle is the original triangle
%[text] - The yellow triangle is the scaled triangle
%[text] - The orange vertices are the scaled vertices \
%[text] How does this work?
%[text] - $V\_1 =0,0\\Longrightarrow V\_1 \*3=0,0${"editStyle":"visual"}
%[text] - $V\_2 =3,0\\Longrightarrow V\_2 \*3=9,0${"editStyle":"visual"}
%[text] - $V\_3 =3,4\\Longrightarrow V\_3 \*3=9,12${"editStyle":"visual"} \
%%
%[text] %[text:anchor:H_FEB7576A] ### Centroid
%[text] The center of a triangle is its centroid. To calculate the centroid, you simply calculate the mean of the vertices. 
%[text] Try it now. Calculate the mean of V and assign to ***centroid***:
centroid = mean(V) % centroid of the scaled triangle
%%
%[text] Plot the centroid 
clf;

scatter(V(:,1),V(:,2),'filled');
hold on
scatter(centroid(:,1),centroid(:,2),'kx') % plot the centroid
patch(V(:,1),V(:,2),'yellow','FaceAlpha',0.1);
grid on
axis equal
%[text] - here, the centroid is plotted as a black x \
%%
%[text] %[text:anchor:H_5AA86369] ### Translation
%[text] Moving the triangle is known as translation. We use addition / subtraction to move the location of the triangle. For example, to center our triangle at 0,0, we subtract the current centroid from all vertices. 
%[text] Try it now: Center our triangle at 0,0 and then recalculate the centroid
V = V - centroid
%%
clf;
xline(0,'LineWidth',1,Alpha=0.25); yline(0,'LineWidth',1,Alpha=0.25)

hold on
scatter(0,0,'kx') % plot 0,0

patch(V(:,1),V(:,2),'yellow','FaceAlpha',0.1); % plot the triangle face

axis equal
axis([-7 5 -5 10])
grid minor

%[text] - The translated triangle is now centered at 0,0 \
%[text] 
%%
%[text] %[text:anchor:H_F787E7D5] ## Rotation
%[text] Remember the following results for cosine and sine
cosd(90)
sind(90)
%%
%[text] **WARNING**. The following contains linear algebra. Do not panic. You still don't really need to know linear algebra. 
%[text] Rotation can be accomplished through linear algebra and rotation matrices:
%[text] $R\\left(\\theta \\right)=\\left\\lbrack \\begin{array}{cc}\n\\cos \\;\\theta  & -\\sin \\theta \\\\\n\\sin \\;\\theta  & \\cos \\;\\theta \n\\end{array}\\right\\rbrack${"editStyle":"visual"}
%[text] - This is just a square matrix of 4 values known as a **rotation matrix** (one kind of **transformation matrix**) \
%%
%[text] Here is the linear algebra equation
%[text] $\\left\\lbrack \\begin{array}{c}\nx^{\\prime } \\\\\ny^{\\prime } \n\\end{array}\\right\\rbrack${"editStyle":"visual"}= $\\left\\lbrack \\begin{array}{cc}\n\\cos \\;\\theta  & -\\sin \\theta \\\\\n\\sin \\;\\theta  & \\cos \\;\\theta \n\\end{array}\\right\\rbrack \\left\\lbrack \\begin{array}{c}\nx\\\\\ny\n\\end{array}\\right\\rbrack${"editStyle":"visual"}
%[text] - where x' and y' are the new x and y coordinates
%[text] - So, you basically just multiply the rotation matrix by your (transposed) vertices matrix
%[text] - Notice in the vertices matrix, the x coordinates are in the top row and the y coordinates are in the bottom row (so, transposed from the way we have V) \
%[text] Common rotation matrices are:
%[text] $\\left\\lbrack \\begin{array}{cc}\n0 & -1\\\\\n1 & 0\n\\end{array}\\right\\rbrack ,\\left\\lbrack \\begin{array}{cc}\n-1 & 0\\\\\n0 & -1\n\\end{array}\\right\\rbrack ,\\left\\lbrack \\begin{array}{cc}\n0 & 1\\\\\n-1 & 0\n\\end{array}\\right\\rbrack${"editStyle":"visual"}
%[text] for 90°, 180°, and 270° counterclockwise rotations.
%%
%[text] %[text:anchor:H_6987826B] ### 90º rotation
%[text] We can perform the linear algebra as follows 
Vrot = [ 0 -1; 1 0] * V'; % 90˚ counter-clockwise rotation
Vrot = Vrot' % transpose the vertices back
%[text] - Notice that we are NOT using element-wise multiplication (`.*`) here, because we want matrix multiplication (linear algebra) to happen
%[text] - Also notice that we had to transpose V to make the linear algebra work and then we transposed V back again \
%%
%[text] %[text:anchor:H_145C7D94] ### Plot the result
%[text] Notice that the triangle is rotated around 0,0
figure
patch(V(:,1),V(:,2),'yellow','FaceAlpha',0.1); % original triangle face

patch(Vrot(:,1),Vrot(:,2),'blue','FaceAlpha',0.5); % rotated triangle face
title('90˚ Rotation')

axis equal
% axis([-7 5 -5 10])
grid minor
xline(0,'LineWidth',1); yline(0,'LineWidth',1)
%%
%[text] ### Gamify your triangle
%[text] Video games use rotation matrices, scaling, and translation to move objects in a game. Here we plot the original triangle (in yellow), make a copy of that triangle (in blue), and then update the vertices in the triangle to scale or translate the triangle
%%
figure
patch(V(:,1),V(:,2),'yellow','FaceAlpha',0.1); % original triangle face
%%
%[text] #### Copy Triangle and display
Vrot2 = V; % copy triangle vertices
hp = patch(Vrot2(:,1),Vrot2(:,2),'blue','FaceAlpha',0.5); % plot and get handle to triangle for rotation
grid on
%%
%[text] #### Rotate Triangle
Vrot2 = [-1 0; 0 -1] * Vrot2'; % rotate 180
Vrot2 = Vrot2'; % transpose back
hp.Vertices = Vrot2; % update the vertices in the blue triangle
%[text] - run this section repeatedly \
%%
%[text] Roll your own rotation matrix
angl = 45;
rot_mat = [cosd(angl) -sind(angl);...
           sind(angl) cosd(angl)]

Vrot2 = rot_mat* Vrot2'; % rotate by angl degrees
Vrot2 = Vrot2'; % transpose back
hp.Vertices = Vrot2; % update the vertices in the blue triangle
%[text] - What would happen if you ran this code block again? \
%%
%[text] #### Scale triangle
%[text] Here we reduce the size of our triangle by half.
Vrot2 = Vrot2 * 0.5 % scale triangle by 1/2
hp.Vertices = Vrot2; % update the vertices in the blue triangle
%[text] - what happens if you run this code block again? \
%%
%[text] #### Increase the triangle size.
%[text]  Change the following code to increase the size of your triangle
Vrot2 = Vrot2 * 10 % scale triangle
hp.Vertices = Vrot2; % update the vertices in the blue triangle
%[text] 
%%
%[text] #### Translate triangle
%[text] The following code moves the triangle so the bottom-left corner of its bounding box will be at 0,0 (the smallest x and the smallest y)
Vrot2 = Vrot2 - min(Vrot2); % move the minimum x and minimum y to 0,0
hp.Vertices = Vrot2; % update the vertices in the blue triangle
%[text] 
%%
%[text] Drive your triangle (change the translation values)
Vrot2 = Vrot2 + [0 5];
hp.Vertices = Vrot2; % update the vertices in the blue triangle
%%
%[text] #### Recenter Blue Triangle to 0,0
Vrot2 = Vrot2 - mean(Vrot2);
hp.Vertices = Vrot2; % update the vertices in the blue triangle
%%
%[text] ### Challenge 1: rotate by 180°
%[text] Starting with the vertices of the yellow triangle in V:
%[text] 1. Rotate the vertices V by 180°, counterclockwise
%[text] 2. Shrink the triangle by 1/2
%[text] 3. Translate the triangle so that the bottom-left corner of its bounding box is at 0,0
%[text] 4. Plot the new triangle with **patch** \
% YOUR CODE HERE

%%
%[text] ## Transform the Vertebra
%[text] At the end of X6, we made a surface model of a vertebral body from a CT scan, and it came out squished. Now we have the tools to fix it: scaling, translation, and rotation.
%[text] ### Recreate the squished vertebra
%[text] This is where X6 left off. We load the label map of the vertebra, wrap a surface around it with **isosurface**, and reduce the number of triangles with **reducepatch**:
clearvars
close all
mmSetUnitDataFolder(3)
medVolLabel = medicalVolume("LungCT01_vertebra.nii.gz"); % label map of one vertebral body

% create surface
fv = isosurface(medVolLabel.Voxels, 0.5); % surface in voxel units (intrinsic volume)
fv = reducepatch(fv, 0.15); % keep 15% of the triangles
Vvox = fv.vertices; % vertices in voxel units: (column, row, slice)
F = fv.faces; % faces
%[text] We plot the surface twice, side by side, so we can compare it before and after we fix it:
figure
tiledlayout(1, 2)
nexttile
patch(Faces=F, Vertices=Vvox, FaceColor="cyan", EdgeColor="none"); % plot surface
mmSetSurfacePlotProps % course function: lighting, view angle, and axis equal
title("Voxel units")
range(Vvox) % extent in x, y, and z
%[text] - The vertebra is about 53 units wide, but only about 11 units tall. Squished! \
%%
%[text] ### Why is it squished?
%[text] Remember, the volume is stored as rows, columns, slice numbers. This is the intrinsic volume. Storing volumes like this implies that all dimensions are equal. When you create a surface from this intrinsic volume, the **voxel units** dimensions carry over into the vertices: column, row, and slice numbers. But in this CT scan, the voxels aren't cubes:
medVolLabel.VoxelSpacing % mm
%[text] - Within each slice, the voxels are 0.73 mm × 0.73 mm. But the slices are 2.5 mm apart.
%[text] - So one unit in z (one slice) is 2.5 mm, while one unit in x or y is only 0.73 mm. When we plot the vertices with **axis equal**, MATLAB draws every unit the same length, so the vertebra is squished to 0.73 / 2.5 ≈ 30% of its real height
%[text] - Voxels that have different sizes in different directions are called **anisotropic** \
%%
%[text] ### Scale: convert voxel units to mm
%[text] To fix the vertebra, we **scale** it, just like we scaled the triangle. But this time, we scale each axis by a different factor: x and y by 0.73, and z by 2.5. Multiplying the vertices element-wise (**.\***) by a row vector multiplies each column by its own number.
%[text] Careful: the vertices are in (column, row, slice) order, but VoxelSpacing is in (row, column, slice) order. So we reorder the spacing to match:
spacing = medVolLabel.VoxelSpacing([2 1 3]) % (column, row, slice) order, to match the vertices
Vmm = Vvox .* spacing; % scale each column of the vertices by its voxel spacing

nexttile
patch(Faces=F, Vertices=Vmm, FaceColor="cyan", EdgeColor="none");
mmSetSurfacePlotProps
title("mm")
range(Vmm) % extent in mm
%[text] - Now the vertebra is about 38 mm wide and 27.5 mm tall: a short, thick cylinder, just like a real vertebral body
%[text] - Notice the stair steps on the sides of the vertebra. Each step is one 2.5 mm slice. Thin slices give smoother surfaces
%[text] - Here we use element-wise multiplication (**.\***), not matrix multiplication (**\***), because we want to multiply each column by its own number \
%%
%[text] ### Translate: center the vertebra
%[text] Where is the vertebra? Let's calculate its centroid, the mean of its vertices:
centroid = mean(Vmm) % mm
%[text] - The vertebra is more than 200 mm away from the origin (0,0,0) \
%[text] **Predict:** remember that rotations happen around the origin. What will happen if we rotate the vertebra by 90° around the x-axis without centering it first?
%[text] Let's try it. The course function **mmCreateRotationMat** returns a transformation matrix that rotates points around the origin, and the function **transformPointsForward** applies it to the vertices:
tform90 = mmCreateRotationMat(90, 'x'); % rotate 90 degrees around the x-axis
Vswing = transformPointsForward(tform90, Vmm);

figure
patch(Faces=F, Vertices=Vmm, FaceColor="cyan", EdgeColor="none"); % before rotating
patch(Faces=F, Vertices=Vswing, FaceColor="magenta", EdgeColor="none"); % after rotating
mmSetSurfacePlotProps
hold on
scatter3(0, 0, 0, 100, "k", "filled") % the origin
hold off
legend(["Before" "After" "Origin"])
title("Rotating without centering")
%[text] - The vertebra didn't just turn. It swung in a big arc around the origin, and ended up far from where it started
%[text] - To rotate an object in place, we first move its center to the origin \
%%
%[text] Now let's center the vertebra, by subtracting its centroid from every vertex:
Vcentered = Vmm - centroid;
mean(Vcentered) % the new centroid
%[text] - The new centroid is (0,0,0), apart from tiny rounding errors (numbers like 1e-15 are zero, for all practical purposes) \
%%
%[text] ### Rotate the centered vertebra
%[text] Now the same rotation turns the vertebra in place. We plot the centered vertebra, and keep a handle to the surface (hp), so we can update its vertices:
figure
hp = patch(Faces=F, Vertices=Vcentered, FaceColor="cyan", EdgeColor="none");
mmSetSurfacePlotProps
title("Centered vertebra")
%%
hp.Vertices = transformPointsForward(tform90, hp.Vertices); % rotate 90 degrees around the x-axis
%[text] - Now the vertebra turned in place. Run this section again to keep turning it \
%%
%[text] The course function **mmRotateSurfaceVertices** combines these steps into one function call. You choose the axis of rotation (x, y, or z) and the angle, and it rotates the surface around its own center, so it works even if the surface isn't centered at (0,0,0):
hp.Vertices = mmRotateSurfaceVertices(hp.Vertices, 'z', 45); % z, 45
%[text] - Try different axes and angles \
%%
%[text] ### One matrix does it all
%[text] So far, we scaled and translated the vertebra by hand. But a medicalVolume already knows how to place every voxel in the real world: its **VolumeGeometry** holds this information, and the function **intrinsicToWorldMapping** turns it into a single **affine transformation matrix**:
tform = intrinsicToWorldMapping(medVolLabel.VolumeGeometry);
tform.A % the 4 x 4 transformation matrix
%[text] This one matrix combines all of our transformations:
%[text] - The **0.73** and **2.5** values **scale** each axis by the voxel spacing
%[text] - The **minus signs** flip some axes, and the swapped first two columns swap x and y, so the axes match the patient's directions
%[text] - The **last column translates** the vertebra to its position in the patient, in mm \
%[text] We apply it to the original voxel vertices `Vvox` with **transformPointsForward**:
Vpatient = transformPointsForward(tform, Vvox); % from voxel units to patient coordinates in mm

figure
patch(Faces=F, Vertices=Vpatient, FaceColor="cyan", EdgeColor="none");
mmSetSurfacePlotProps
xlabel("x (mm): left \rightarrow right")
ylabel("y (mm): posterior \rightarrow anterior")
zlabel("z (mm): inferior \rightarrow superior")
title("Vertebra in patient coordinates")
%[text] - This file uses the **RAS+** patient coordinate system: x increases toward the patient's **R**ight, y toward the **A**nterior (front), and z toward the **S**uperior (head)
%[text] - The vertebra has the same shape as Vmm, the vertebra we scaled by hand. But now it's also in the right place and orientation, so it would line up with other structures segmented from the same scan \
%%
%[text] ## Measure the vertebra
%[text] ### Size
%[text] In patient coordinates, the axes point along the patient's anatomical directions. So the range of the vertices tells us the size of the vertebral body in each direction:
vertebraSize = range(Vpatient);
sizeTable = table(vertebraSize(1), vertebraSize(2), vertebraSize(3), ...
    VariableNames=["LeftRight_mm" "FrontBack_mm" "Height_mm"])
%[text] - A typical thoracic vertebral body is about 3–4 cm wide and 2–3 cm tall. Our measurements fit
%[text] - Because the slices are 2.5 mm apart, the height is only accurate to within a few mm \
%%
%[text] ### Align to the cardinal axes
%[text] Measuring with range works well when the object lines up with the x, y, and z axes (the **cardinal axes**). But what if the object is tilted, like our rotated vertebra in hp? The course function **mmAlignSurface2Axes** rotates a surface so that its longest direction lines up with the x-axis, its second-longest with the y-axis, and its shortest with the z-axis.
%[text] mmAlignSurface2Axes rotates around the origin, so we center the surface first:
Valigned = mmAlignSurface2Axes(hp.Vertices - mean(hp.Vertices));
hp.Vertices = Valigned; % update the rotated vertebra
title("Aligned vertebra")
range(Valigned)
%[text] - No matter how we rotated the vertebra, we get the same aligned ranges. (Try it: rotate hp again, and rerun this section)
%[text] - But the ranges are larger than the ones we measured in patient coordinates. Why? The vertebral body is almost round, so it has no clear "longest direction". mmAlignSurface2Axes picks directions that run diagonally across the vertebra, and the vertebra is wider along its diagonals
%[text] - Also notice: x is now just the longest direction of the vertebra, not left-right. Alignment works best for long, narrow objects, like a femur. Whatever method you use, always check that the results make sense \
%%
%[text] ### Distances: Pythagoras in 3D
%[text] We can calculate the distance between any two vertices with the Pythagorean theorem. In 3D, we just add a third term:
%[text] $\\textrm{Distance}=\\sqrt{{\\left(x\_2 -x\_1 \\right)}^2 +{\\left(y\_2 -y\_1 \\right)}^2 +{\\left(z\_2 -z\_1 \\right)}^2 }${"editStyle":"visual"}
%[text] For example, how far apart are the most posterior (back) and the most anterior (front) vertex of the vertebra?
[~, back] = min(Vpatient(:,2)); % row of the most posterior vertex
[~, front] = max(Vpatient(:,2)); % row of the most anterior vertex

d = Vpatient(front,:) - Vpatient(back,:) % differences in x, y, and z
backToFront_mm = sqrt(sum(d.^2)) % Pythagorean theorem
%[text] - The distance is larger than the front-to-back size of the vertebra (in sizeTable), because the two vertices aren't directly in front of each other: they are also a few mm apart in x and z
%[text] - **sum(d.^2)** squares each difference and adds them up. To calculate many distances at once, you can sum along the rows of a matrix with **sum(D.^2, 2)** \
%%
%[text] ### Challenge 2: Squished height
%[text] Using only the voxel vertices (**Vvox**) and the voxel spacing (**medVolLabel.VoxelSpacing**), calculate the height of the vertebra in mm.
%[text] - Hint: the height is the range of the z (third) column
%[text] - Why isn't the height in voxel units the same as the height in mm? \
% YOUR CODE HERE

%%
%[text] ### Challenge 3: Farthest from the center
%[text] What is the largest distance between the centroid of the vertebra and any of its vertices? (This is the radius of the smallest sphere, centered on the centroid, that holds the whole vertebra.)
%[text] - Hint: calculate the centroid of **Vpatient**, subtract it from every vertex, then calculate all the distances at once with **sum(D.^2, 2)** \
% YOUR CODE HERE

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
