%[text] # Transforming Surfaces
%[text] In this module, we will demonstrate how easy it is to Scale, Rotate, and Translate surfaces. These actions are collectively known as transformations.
%%
%[text] %[text:anchor:H_D3E98789] ## First, a review of the 2D realm
%[text] Triangles have three vertices (three X,Y coordinates). We can organize these vertices as a matrix, where every row in the matrix represents one pair of vertices:
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
V = V * 1
%%
%[text] Plot the larger triangle:
hold on
scatter(V(:,1),V(:,2),'filled');
patch(V(:,1),V(:,2),'yellow','FaceAlpha',0.1);
xlim([-2 10]); ylim([-2 12])
xline(0); yline(0)
%[text] - the green triangle is the original triangle
%[text] - the yellow triangle is the scaled triangle
%[text] - The red vertices are the scaled vertices \
%[text] How does this work?
%[text] - $V\_1 =0,0\\Longrightarrow V\_1 \*3=0,0${"editStyle":"visual"}
%[text] - $V\_2 =3,0\\Longrightarrow V\_2 \*3=9,0${"editStyle":"visual"}
%[text] - $V\_3 =4,3${"editStyle":"visual"}$\\Longrightarrow V\_3 \*3=12,9${"editStyle":"visual"} \
%%
%[text] %[text:anchor:H_FEB7576A] ### Centroid
%[text] The center of a triangle is its centroid. To calculate the centroid, you simply calculate the mean of the vertices. 
%[text] Try it now. Calculate the mean of V and assign to ***centroids***:
centroid = mean(V) % centroid of small triangle
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
%[text] Moving the triangle is known as translation. We use addition / subtraction to move the location of the triangle. For example, to center our triangle to 0,0, we subtract the current centroid from all vertices. 
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
%[text]  remember the following results for cosine and sine
cosd(90)
sind(90)
%%
%[text] **WARNING**. The following contains linear algebra. Do not panic. You still don't really need to know linear algebra. 
%[text] Rotation can be accomplished through linear algebra and rotation matrices:
%[text] $R\\left(\\theta \\right)=\\left\\lbrack \\begin{array}{cc}\n\\cos \\;\\theta  & -\\sin \\theta \\\\\n\\sin \\;\\theta  & \\cos \\;\\theta \n\\end{array}\\right\\rbrack${"editStyle":"visual"}
%[text] - this is just a square matrix of 4 values known as **a transformation matrix** \
%%
%[text] Here is the linear algebra equation
%[text] $\\left\\lbrack \\begin{array}{c}\nx^{\\prime } \\\\\ny^{\\prime } \n\\end{array}\\right\\rbrack${"editStyle":"visual"}= $\\left\\lbrack \\begin{array}{cc}\n\\cos \\;\\theta  & -\\sin \\theta \\\\\n\\sin \\;\\theta  & \\cos \\;\\theta \n\\end{array}\\right\\rbrack \\left\\lbrack \\begin{array}{c}\nx\\\\\ny\n\\end{array}\\right\\rbrack${"editStyle":"visual"}
%[text] - where x' and y' are the new x and y coordinates
%[text] - So, you basically just multiply the rotation matrix by your vertices matrix
%[text] - Notice in the vertices matrix, the x coordinates are in the top row and the y coordinates are in the bottom row (so, transposed from the way we have V) \
%[text] Common rotations matrices are:
%[text] $\\left\\lbrack \\begin{array}{cc}\n0 & -1\\\\\n1 & 0\n\\end{array}\\right\\rbrack ,\\left\\lbrack \\begin{array}{cc}\n-1 & 0\\\\\n0 & -1\n\\end{array}\\right\\rbrack ,\\left\\lbrack \\begin{array}{cc}\n0 & 1\\\\\n-1 & 0\n\\end{array}\\right\\rbrack${"editStyle":"visual"}
%[text] for 90˚, 180˚, and 270˚ counter-clock wise rotations. 
%%
%[text] %[text:anchor:H_6987826B] ### 90º rotation
%[text] We can perform the linear algebra as follows 
Vrot = [ 0 -1; 1 0] * V'; % 90˚ counter-clockwise rotation
Vrot = Vrot' % transpose the vertices back
%[text] - Notice that we are NOT using dot multiplication here, because we want linear algebra to happen
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
%[text] Video games use rotation matrices, scaling, and translation to move objects in a game. Here we plot original triangle (in yellow), make a copy of that triangle (in blue), and then update the vertices in the triangle to scale or translate the triangle
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
%%
%[text] Roll your own rotation matrix
angl = 45;
rot_mat = [cosd(angl) -sind(angl);...
           sind(angl) cosd(angl)]

Vrot2 = rot_mat* Vrot2'; % rotate 180
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
Vrot2 = Vrot2 * 1 % scale triangle
hp.Vertices = Vrot2; % update the vertices in the blue triangle
%[text] 
%%
%[text] #### Translate triangle
%[text] The following code moves the triangle so the minimum vertex will be at 0,0
Vrot2 = Vrot2 - min(Vrot2); % move minimum vertex to 0,0
hp.Vertices = Vrot2; % update the vertices in the blue triangle
%[text] 
%%
%[text] Drive your triangle (change the translation values)
Vrot2 = Vrot2 + [4 4];
hp.Vertices = Vrot2; % update the vertices in the blue triangle
%%
%[text] #### Recenter Blue Triangle to 0,0
Vrot2 = Vrot2 - mean(Vrot2);
hp.Vertices = Vrot2; % update the vertices in the blue triangle
%%
%[text] ## Transform the Diamond
%[text] ### Create the Diamond
figure
V = [0.5 0.5 1.0;...
    0 0 0;...
    1 0 0;...
    0 1 0;...
    1 1 0;...
    0.5 0.5 -1]; % What vertex do we need to add here? 

F = boundary(V);

figure % Turn Visible on 
p = patch('Faces', F, "Vertices",V, ...
    'FaceColor','red', ...
    'EdgeColor','k',...
    'FaceAlpha',1,...
    'EdgeAlpha',1); % update


view(35,30)
axis vis3d equal
colormap("turbo")
xlabel('x'); ylabel('y'); zlabel('z')
%%
%[text] %[text:anchor:H_B5449802] ### Scale and Translate that Diamond
%[text] %[text:anchor:H_1CF53D45] - Double the size of the diamond
%[text] - shift the diamond so that its centroid is centered at 0,0,0 \
p.Vertices = p.Vertices * 1;% update vertices to double size 
%%
%[text] Review your diamond. Notice how the center axes of the diamond runs through 0.5, 0.5 of the xy plane. 
%[text] Shift the center axes to 0,0
p.Vertices = p.Vertices; % update vertices to recenter to 0,0,0
%%
%[text] %[text:anchor:H_F74A42F5] ## Set the face colors to the colormap
p.FaceColor = 'flat';
p.FaceVertexCData = (1:height(F))'; % FaceVertexCData needs to be column vector
colormap("sky") % update to preferred colormap
%%
%[text] %[text:anchor:H_A27230A3] ## matGeom
%[text] A powerful geometric computing toolbox for 2D/3D. [matGeom Manual](https://mattools.github.io/matGeom/api/index.html).
%[text] 1. Add the matGeom folder to the search path: /Matlab Drive/Mastering-MATLAB/matGeom-master/matGeom
%[text] 2. If you can't find matGeom, install using the following [Instructions for matGeom installation](https://salcedoe.github.io/MtMdocs/setup/githubRepoInstallation/#add-matgeom-using-matlab).- This was part of the MATLAB setup at start of semester.
%[text] 3. Try the following code \
setupMatGeom
%[text] - if you see a bunch of output, then congratulations, you've properly installed matGeom \
%%
%[text] The following code uses matGeom to rotate our model around the x-axis
theta = deg2rad(45); %converts degrees into radians
rotx = createRotationOx(theta) % create our 3D rotation matrix
p.Vertices = transformPoint3d(p.Vertices,rotx); % linear algebra happening in here somewhere
%[text] 
%%
%[text] %[text:anchor:H_02C43AE5] ### Course function
%[text] The function **mmRotateSurfaceVertices** packages the above code and allows you to select the axis of rotation. Remember, you need to **setupMatGeom** to use this function (once per  MATLAB session)
%[text] For example, the following code
p.Vertices = mmRotateSurfaceVertices(p.Vertices,'z',45);
%[text] - Try different rotations \
%[text] 
%%
%[text] %[text:anchor:H_774A6BE9] ## Measure your diamond
%[text] Make sure you rotate the diamond back so that it aligned to the xy plane. Once our diamond is nicely aligned to the cardinal axes, we can easily measure the extent of our diamond using simple math
range(p.Vertices)
%[text] - The range tells the width, depth, and height of our diamond \
%%
%[text] We can also formalize these measurements with a bounding box 
box3d = boundingBox3d(p.Vertices) % part of matGeom
hb = drawBox3d(box3d)
%[text] - This function is part of matGEOM
%[text] - It returns the min and max for the X, Y, and Z extents \
%%
diff(reshape(box3d,2,3))
%[text] - So, subtracting the first two elements returns 1, the next two elements returns a 2, and the next two elements a 1 \
%%
delete(hb)
%%
%[text] ### Align to cardinal Axes
%[text] Actually easier to measure the extent of the diamond if its aligned to the cardinal axes
p.Vertices = mmAlignSurface2Axes(p.Vertices)
range(p.Vertices)
%%
%[text] 
box3d = boundingBox3d(p.Vertices) % part of matGeom
hb = drawBox3d(box3d)
diff(reshape(box3d,2,3))
%%
%[text] %[text:anchor:H_FC689FF7] ### Pythagorean for measuring
%[text] %[text:anchor:H_936E9349] We can calculate the distance between vertices using Euclidean Distances (just as we did for the triangles). We just need to include a third term in our calculations
%[text] $\\textrm{Distance}=\\sqrt{{\\left(x\_2 -x\_1 \\right)}^2 +{\\left(y\_2 -y\_1 \\right)}^2 +{\\left(z\_2 -z\_1 \\right)}^2 }${"editStyle":"visual"}
%[text] %[text:anchor:H_A69B020A] What is the distance between
%[text] - V1 and V2, V3, V4, and V5? \
%[text] %[text:anchor:H_00AE96B7] How far is V1 from V2? V3-5?
d = V(2:5,:) - V(1,:) % subtract the first row from the rest of the matrix (x and y distances from V1 to the rest)
sqrt(sum(d.^2,2)) % pythogorean for all distances
sqrt(sum(V(1,:).^2)) % pythogorean for distance from 0,0,0
%%
%[text] %[text:anchor:H_9AB8C59A] ### Challenge: vertex separation 
%[text] %[text:anchor:H_44CD7C04] What is the distance between V1 and V6?
d = V(1,:) - V(6,:)
sqrt(sum(d.^2,2))
%[text] - does our result make sense? \
%%
%[text] %[text:anchor:T_8EB44798] # **Challenges**
%[text] %[text:anchor:H_59F975D7] ### **Challenge 1: rotate by 180˚**
%[text] 1. Rotate the vertices V  by 180˚, counter clockwise
%[text] 2. Shrink the triangle by 1/2
%[text] 3. Translate the triangle so that its lowest vertices are 0,0 \


%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
