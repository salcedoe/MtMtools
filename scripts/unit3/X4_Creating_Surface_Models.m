%[text] %[text:anchor:T_101DA890] # Vertices, Triangles, and 3D surfaces
%[text] In this module, we will build 3D surfaces (also known as manifold surfaces) using the power of triangle. 
%[text] %[text:anchor:H_3B24DDD8] ## Faces and vertices matrices
%[text]  Terminology
%[text] - Points in space are called VERTICES (or nodes)
%[text] - The shapes these vertices form are called FACES \
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] 
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
V = V * 2
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
%%
%[text] %[text:anchor:H_10910D06] ## Remember sin and cosine?
%[text] SOHCAHTOA: Sin (theta) = opposite over hypotenuse, Cos (theta) = adjacent over hypotenuse 
%[text] The following plots the sine and cosine of pi/4
clf
plot([0 cos(pi/4)], [0 sin(pi/4)],'-ro',... 
    [cos(pi/4) cos(pi/4)], [0 sin(pi/4)],'--ro',...
    [0 cos(pi/4)], [0 0],'--ro') % plot pi/4
axis off

text(sin(pi/4)+0.05, cos(pi/4)+0.05,'\pi/4','Interpreter','Tex','FontSize',16)
text(0.25, -0.065,'cos(\theta)','Interpreter','Tex','FontSize',16)
text(0.79, 0.3,'sin(\theta)','Interpreter','Tex','FontSize',16)
text(0.1, 0.065,'\theta','Interpreter','Tex','FontSize',16)
%%
%[text] %[text:anchor:H_E028C729] ### Sine and cosine can be used to plot out a circle
hold on
r1 = 1; % radius
r2 = r1;

theta=-pi:0.01:pi;
plot(r1*cos(theta), r2*sin(theta),[0 0],...
    [-1 1],'--', [-1 1], [0 0],'--') % plot the axis
   

ylabel('sine (radians)')
xlabel('cosine (radians)')


title('sine vs cosine')
axis square
grid minor
%%
%[text] Also remember the following results for cosine and sine
cosd(90)
sind(90)
%%
%[text] %[text:anchor:H_F787E7D5] ## Rotation
%[text] **WARNING**. The following contains linear algebra. Do not panic. You still don't really need to know linear algebra. 
%[text] Rotation can be accomplished through linear algebra and rotation matrices:
%[text] $R\\left(\\theta \\right)=\\left\\lbrack \\begin{array}{cc}\n\\cos \\;\\theta  & -\\sin \\theta \\\\\n\\sin \\;\\theta  & \\cos \\;\\theta \n\\end{array}\\right\\rbrack${"editStyle":"visual"}
%[text] - this is just a square matrix of 4 values \
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
%[text] %[text:anchor:T_F581598C] # Triangles in 3D
%[text] %[text:anchor:H_D958E7CE] ## A point in 3D requires three coordinates
%[text] Specifically, an X, a Y, and a Z coordinate. Using the notation (X,Y,Z), this code adds a single point (or vertex) at (0.5,0.5,0)
close all
figure;
clearvars
scatter3(0.5,0.5,1,'m','filled')
xlabel('x'); ylabel('y'); zlabel('z')
%[text] - notice that here we use **scatter3**.  \
%%
%[text] %[text:anchor:H_930388E2] ## A Triangle in 3D requires 3 coordinates at every vertex
%[text] Let's add two more points to create the vertices of a triangle 
%[text] Similar to the 2D triangle, we create a single array that stores the vertices for each point, row by row, as follows:
V = [0.5 0.5 1; ... % X,Y,Z for the magenta point
    0 0 0; ... % ...for the blue point
    1 0 0]     % ...for the cyan point
%[text] - V is known as a **vertex matrix**. In a vertex matrix, each row contains the  coordinates for a single point.
%[text] - The first column in V contains all the X coordinates, the second the Y, and the third the Z. \
%[text] Let's plot these points using **scatter3**
figure;
scatter3(V(:,1),V(:,2),V(:,3),[],[1 0 1; 0 0 1; 0 1 1],'filled')
axis vis3d
%%
%[text] %[text:anchor:H_84C23D76] ## Patches
%[text] Patches are filled polygons (or faces). A simple call to the function *patch* can fill in the triangle with a color. 
%[text] We will use the columns from our Vertices matrix V.
p = patch(V(:,1),V(:,2),V(:,3), 'y'); % color yellow
view([41.873 48.000])
xlabel('x'); ylabel('y'); zlabel('z')
%[text] -  This call specifies the X, Y, and Z coordinates as column vectors
%[text] -  Notice that patch automatically closes the shape.
%[text] - Also notice that we didn't need a "hold on" — patches automatically assume hold is on \
%%
%[text] %[text:anchor:H_BB55B81A] ## Faces Matrix
%[text] In the previous call to **patch,** we inputted vectors for X, Y, and Z. This works fine; however, you must specify each coordinate explicitly, even if you are reusing that coordinate (say, for example, we wanted to add another face to our burgeoning manifold surface)
%[text] %[text:anchor:H_33BBB902] There is another way to input coordinates into patch. This is known as the Vertices / Faces input pair. This is the most common way to organize the data for a surface. 
%[text] A Face matrix is simply a collection of row indices for the vertices matrix. That is to say that every single number found in the face matrix points to a row in the paired vertices matrix.
%[text] Consider the following Face Matrix;
F = [1 2 3]
%[text] - Since there are three columns in this array, this face matrix forms triangles.
%[text] - Since there is only one row, this face matrix would form only one triangle.
%[text] - The numbers in this face matrix indicate the row in V, the vertex matrix, to use as a vertex for the triangle. So, in this example, `F` uses the vertices found in the first, second, and third row in  `V` \
%%
%[text] %[text:anchor:H_96AEE103] ## Patch call with vertex, face input
%[text] We will create a new figure with a yellow face, with one simple call to patch using F and V
figure;
p = patch('Faces',F, 'Vertices', V, 'facecolor', 'y');
xlabel('x'); ylabel('y'); zlabel('z')

view(3)
axis vis3d
grid on
%%
%[text] %[text:anchor:H_52411155] ### Label Faces and Vertices
%[text] %[text:anchor:H_3B54539B] We will use the local function **label\_patches** to label the vertices and faces for clarity (see end of script to review function).
label_patches(F, V)
view([28.925 40.038])
%%
%[text] Review Patch Properties. Notice that p has properties called "Faces" and "Vertices" that have the same values as *V* and *F*
p.Faces
p.Vertices
%[text] -  The faces and vertices properties of p match F and V.  \
%%
%[text] %[text:anchor:H_D0824329] ## View angle
%[text] The function **view** controls the display angle
%[text] ![](text:image:7cb1)
view(10,45)
%[text] - notice that as you manually rotate the triangle, the view settings are updated, and you get a little prompt to update your code \
%%
%[text] You can use these sliders to play around the view settings. Notice that el always rotates around the cardinal axes.
el = 20; %[control:slider:819a]{"position":[6,8]}
az = 130; %[control:slider:3ad3]{"position":[6,9]}
view(az,el)
%[text] - compare az 0 to az 180. Even though they look the same, they are actually in opposing directions. This is an optical illusion \
%%
%[text] %[text:anchor:H_36EA290F] ## Add a second face
%[text] Using Faces and Vertices matrices allows you to reuse some of the Vertices, so you don't have to explicitly redefine them every time. 
%[text] %[text:anchor:H_32849CBF] #### First, add a new vertex
%[text] Let's add a new vertex by adding another row to V
V = [V;...
    0 1 0] ; % new vertex at 0,1,0   
%[text] And let's visualize this new set of coordinates with **scatter3**
scatter3(V(:,1),V(:,2),V(:,3),[],'cyan','filled')
view(3)
axis vis3d
text(0,1,0,'V4')
%[text] 
%%
%[text] %[text:anchor:H_84E0092B] #### Next, add another face
%[text] To add a new face, we have to need to another row to F. Reviewing the vertex array, we can add a second face using vertices in rows 1, 2, and 4:
V
%%
%[text] 
F = [1 2 3; ...
    1 2 4]     % second row indicates second face
%[text] - So, we are reusing Vertices 1 and 3. And our second face will share an edge with the first face \
%[text]  
%%
%[text] %[text:anchor:H_B1E0DE7C] ## Two-Faced Patch  
%[text] %[text:anchor:H_4AC04563] We plot both faces as follows
figure; % create a new figure
p = patch('Faces',F, 'Vertices', V, 'facecolor', 'c');
xlabel('x')
ylabel('y')
zlabel('z')
view(3)
axis vis3d
%[text] Again, we'll **label** the vertices and faces (for clarity)
label_patches(F, V);
%[text] Now we have two faces. Find:
%[text] - the shared vertices
%[text] - The shared edge
%[text] - The corresponding rows of the shared Vertices in *V*
%[text] - The common values in *F* \
%[text] 
%%
%[text] %[text:anchor:H_8867DBF7] ## Add a third face
%[text] %[text:anchor:H_AAD44FFE] Let's continue with our pyramid.  First, we need another vertex. So, where do we need more vertices to complete the pyramid?
V = [V; 1 1 0]; % add new vertices at 1, 1, 0

scatter3(V(:,1),V(:,2),V(:,3),'filled')
view(3)
axis vis3d
text(1,1,0,'V5')
%%
%[text] %[text:anchor:H_2C49D0C7] ### Add another Face
%[text] Which vertices do we need to add a face that shares an edge with F2?
%[text] - Vertices 1, 4, and 5 \
%[text] %[text:anchor:H_CF36FE76]  Add a new row to F that point to vertices 1, 4, and 5
F = [F; 1 4 5];
p.Vertices = V;
p.Faces = F;
xlabel('x'); ylabel('y'); zlabel('z')
%[text] Notice, we do not need to call the function *patch* again. We can simply update the Vertices and Faces property of P.
%[text] And we can label all the vertices and faces again for clarity
label_patches(F,V);
%%
%[text] %[text:anchor:H_22F710F2] ## Final Face(s)
%[text] %[text:anchor:H_16093655] We now have all the vertices we need to complete our pyramid. We just need to add three more faces: one to close up the side and two to close up the bottom.
%[text] What do we need to add to F to complete the pyramid? Add THREE new rows to F

%%
%[text] Update the your pyramid
p.Faces = F;
label_patches(F,V);
%%
%[text] %[text:anchor:H_09CA0337] ## Patch Properties
%[text] There are a lot of color, lighting and transparency options for patches
web(fullfile(docroot, 'matlab/ref/patch-properties.html'))
%%
%[text] %[text:anchor:H_11F5961E] ### Set FaceColor Explicitly
%[text] First, we recreate *V* in case we lost some of you in the previous cell blocks
clearvars
V = [0.5 0.5 1.0;...
    0 0 0;...
    1 0 0;...
    0 1 0;...
    1 1 0];
%%
%[text] Then, we will use the function **boundary** to automagically create the face matrix for us:
F = boundary(V)
%%
%[text] Next, we'll plot the pyramid using the **patch** function
figure; 
p = patch('Faces',F,"Vertices",V,'facecolor', 'c');
view(3)
%[text] We will explicitly set the face color, set the **FaceColor** property to 'flat'
p.FaceColor = 'flat'; % FaceColor is set to 'flat'
%[text] And set the color of each face to an RGB triplet. You need one triplet per face. One simple way to generate RGB triplets is to call a colormap function, like **hsv.** 
cdata = parula(size(F,1)) % number of rows in cdata should equal the number of rows in F
%[text] Once you have come with a matrix of triplets, we set the **FaceVertexCData** property to this matrix:
p.FaceVertexCData = cdata;
axis vis3d
%[text] - Notice here that FaceVertexCData has one row of RGB triplets for each face \
%%
%[text] %[text:anchor:H_CBD486F8] ### Change the face colors to a different color map
%[text] %[text:anchor:H_EDA0B756] Remember, you just need to come up with a new *cdata* matrix and assign that matrix to the **FaceVertexCData** property
cdata = spring(height(F)); % update cdata to parula %[text:anchor:H_2C294192]
p.FaceVertexCData = cdata;
%[text] - re-run this codeblock, changing only the colormap \
%%
%[text] %[text:anchor:H_160D6D18] ### Set FaceColor to the current colormap
%[text] %[text:anchor:H_5E6CF101] If you don't want to explicitly create a *cdata* colormap matrix for your manifold, you can simply set the **FaceVertexCData** property to a series of whole numbers, and then the current colormap of the figure will be assigned to the manifold. Remember, a every figure has a default colormap (probably parula). If you just want that to use that colormap, just input a column vector of integers, with the same number of rows as F into FaceVertexCData as follows:
p.FaceColor = 'flat';
p.FaceVertexCData = (1:size(F,1))' % FaceVertexCData needs to be column vector
axis vis3d
%[text] - now the face colors will update every time you update the figure colormap.  \
%%
colormap(bone)
%%
%[text] %[text:anchor:H_99CB082A] ### Transparency is called alpha
%[text] %[text:anchor:H_C20D6428] The value ranges from 0 to 1
p.FaceAlpha = 0.75;
%%
%[text] %[text:anchor:H_2348AB2D] ###  Change the transparency
%[text] %[text:anchor:H_7AC8B035] Try it now. Set the face alpha to 0.5 and 0.25
p.FaceAlpha = 0.75
colormap("turbo")
%%
%[text] %[text:anchor:H_C5FC7D80] ###  EdgeAlpha
%[text] %[text:anchor:H_BCE32D5B] What do you think the edge alpha sets? Try it now. Set the edge alpha to 0.25
p.EdgeAlpha = .25
%%
%[text] How about the Edge Color?
p.EdgeColor = 'c'
%[text] - What changed? \
%%
%[text] %[text:anchor:H_F820CC54] ## Animation
%[text] The function **rotate** rotates a 3D object.
%[text] %[text:anchor:H_021A17DF]  The following input rotates the pyramid around the z-axis 10 degrees 36 times
% p.Parent.Parent.Visible = 'on' % make figure visible to see animation
for n=1:36
    rotate(p,[0 0 1], 10)
    pause(0.1)
end
axis equal
%%
%[text] %[text:anchor:H_C77FCA4E] ## Challenges
%[text] %[text:anchor:H_B6DFD096] ### Challenge: Create a Diamond
%[text] %[text:anchor:H_596AB2F5] - Add one more row to V to create a diamond surface
%[text] - Use the function **boundary** to automatically generate the faces matrix and overwrite F
%[text] - Plot the Vertices and Faces using **patch**
%[text] - Set FaceColor to the **magenta**.
%[text] - Set the EdgeColor to black
%[text] - Set FaceAlpha to 0.5
%[text] - Set EdgeAlpha to 0.25
%[text] - label the faces and vertices \
figure
V = [0.5 0.5 1.0;...
    0 0 0;...
    1 0 0;...
    0 1 0;...
    1 1 0;...
    ]; % What vertex do we need to add here? 

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
p.Vertices = p.Vertices * 1% update vertices to double size 
%%
%[text] Review your diamond. Notice how the center axes of the diamond runs through 0.5, 0.5 of the xy plane. 
%[text] Shift the center axes to 0,0
p.Vertices = p.Vertices % update vertices to recenter to 0,0,0
%%
%[text] %[text:anchor:H_F74A42F5] ## Set the face colors to the colormap
p.FaceColor = 'flat';
p.FaceVertexCData = (1:height(F))' % FaceVertexCData needs to be column vector
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
%[text] - Try different rotations
%[text] - Add sliders and input boxes \
%%
%[text] %[text:anchor:H_774A6BE9] ## Measure your diamond
%[text] Make sure you rotate the diamond back so that it aligned to the xy plane. Once our diamond is nicely aligned to the cardinal axes, we can easily measure the extent of our diamond using simple math
range(p.Vertices)
%[text] - The range tells the width, depth, and height of our diamond \
%%
%[text] We can also formalize these measurements with a bounding box 
box3d = boundingBox3d(p.Vertices) % part of matGeom
%[text] - This function is part of matGEOM
%[text] - It returns the min and max for the X, Y, and Z extents \
%%
diff(reshape(box3d,2,3))
%[text] - So, subtracting the first two elements returns 1, the next two elements returns a 2, and the next two elements a 1 \
%%
%[text] - Move the vertices up 5 and over 5
%[text] - re-calculate bounding box \
p.Vertices = p.Vertices + [5 5 0]
range(p.Vertices)
%%
%[text] 
box3d = boundingBox3d(p.Vertices) % part of matGeom
hb = drawBox3d(box3d)
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

%%
%[text] %[text:anchor:T_F69B48DE] # Local Functions
%[text] %[text:anchor:H_95B0506D] ## label patches
%[text] %[text:anchor:H_D05456FE] To position the face label on the center of the patch, we need to find the centroid of the vertices(which is basically just their averages): [http://www.mathopenref.com/coordcentroid.html](http://www.mathopenref.com/coordcentroid.html) 
function label_patches(F, V)
hold on
% labels the faces and vertices of the inputted patches
offset = 0.025; % offset the label
% vertex label
for n=1:size(V,1)
    c = V(n,:) + offset; % grab row from Vertices array
    text(c(1), c(2),c(3), sprintf('V%d',n))
end

% faces label
for n =1:size(F,1) 
    c = mean(V(F(n,:),:)); % calculate the centroid of the triangle
    text(c(1), c(2), c(3), sprintf('F%d',n),'Color','b','FontWeight','bold');
end
end
%[text] %[text:anchor:H_FC3E9027] ## 
%[text] 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[text:image:7cb1]
%   data: {"align":"baseline","height":184,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAABGAAAANICAYAAACIVpl8AAAgAElEQVR4AezB0XGbZ6Jt27n+CEyGAIVAZWBwR2Aog4Y6ApMdQYPOQHAGRAhEZyCGQPgNfiP8iM8PXKfq3FIVzy1p21ILtiXPMaZKkj67p6enPj099enpqZIkSZI0IUmSJEmSpJOakCRJkiRJ0klNSJI+uyQkIQmSJEmSNCFJkiRJkqSTmpAkSZIkSdJJTUiSJEmSJOmkJiRJkiRJknRSE5IkSZIkSTqpCUmSJEmSJJ3UhCRJkiRJkk5qQpL0QW1pS1vepy1taUtb2tIWSZIkSXpuQpIkSZIkSSc1IUmSJEmSpJOakCR9UBKSkIT3SUISkpCEJCRBkiRJkp6bkCRJkiRJ0klNSJIkSZIk6aQmJEmSJEmSdFITkiRJkiRJOqkJSdL\/lYQkJCEJSUhCEpIwTRPTNDFNE0lIwna7Zbvdst1ukSRJkqQPmZAkSZIkSdJJTUiSJEmSJOmkJiRJ\/9fV1RVXV1e0pS1taUtb2vL999\/z\/fff8\/3333N1dcXV1RXz+Zz5fM58PkeSJEmSPmRCkiRJkiRJJzUhSZIkSZKkk5qQpK9MW9rysVarFavViuc2mw2bzYbNZsP9\/T339\/fc39+zWq1YrVZIkiRJ0u8xIUmSJEmSpJOakCRJkiRJ0klNSNJXJglJ+FS73Y7dbsdut+Pq6oqrqyuurq548+YNb9684c2bN\/yWtrSlLZIkSZI0IUmSJEmSpJOakCRJkiRJ0klNSNIXqi1tacvn9OrVK169esWrV6+4ubnh5uaGm5sbZrMZs9mM2WzGO7vdjt1ux26347kkJCEJkiRJkjQhSZIkSZKkk5qQpC9UEpKQhM9huVyyXC759ttv+fbbb\/n2229ZLBYsFgsWiwXvs16vWa\/XrNdrJEmSJOlDJiRJkiRJknRSE5IkSZIkSTqpCUn6G7u9veX29pbb21t+\/PFHfvzxR3744Qd++OEHfvjhB5KQhCQkIQlJSEIS7u\/vub+\/5\/7+HkmSJEn6kAlJkiRJkiSd1IQkSZIkSZJOakKS\/sZevXrFq1evePXqFW1pS1va0pa2tKUtbWlLW9rSlru7O+7u7ri7u0OSJEmSPmRCkiRJkiRJJzUhSZIkSZKkk5qQpK9AW9rSllNpS1vaIkmSJEkfY0KSJEmSJEknNSFJX4EkJCEJp5KEJCRBkiRJkj7GhCRJkiRJkk5qQpIkSZIkSSc1IUmSJEmSpJOakCRJkiRJ0klNSJIkSZIk6aQmJEmSJEmSdFITkiRJkiRJOqkJSZIkSZIkndSEJEmSJEmSTmpCkiRJkiRJJzUhSZIkSZKkk5qQJEmSJEnSSU1IkiRJkiTppCYkSZIkSZJ0UhOSJEmSJEk6qQlJkiRJkiSd1IQk6f+RhCQkIQlJSIIkSZIkfaoJSZIkSZIkndSEJEmSJEmSTmpCkiRJkiRJJzUhSZIkSZKkk5qQJEmSJEnSSU1IkiRJkiTppCYkSZIkSZJ0UhOSJEmSJEk6qQlJ0gclIQlJSEISkiBJkiRJH2NCkiRJkiRJJzUhSfq\/kpCE59rSlrZIkiRJ0qeakCRJkiRJ0klNSJIkSZIk6aQmJOkL0pa2tOXP1Ja2SJIkSdLvMSFJkiRJkqSTmpAkSZIkSdJJTUjSFyQJSUjCn2maJqZp4rm2tKUtkiRJkvTchCRJkiRJkk5qQpIkSZIkSSc1IUn6LJKQhCRIkiRJ0nMTkiRJkiRJOqkJSZIkSZIkndSEJEmSJEmSTmpCkiRJkiRJJzUhSX9jSUhCEj5FEpKQBEmSJEn6kAlJkiRJkiSd1IQkSZIkSZJOakKS9P9IQhKSIEmSJEmfw4QkSZIkSZJOakKSJEmSJEknNSFJf2NtaUtb2tKWtrSlLW1pS1va0pa2tKUtbWlLWyRJkiTpQyYkSZIkSZJ0UhOSJEmSJEk6qQlJkiRJkiSd1IQkSZIkSZJOakKSJEmSJEknNSFJkiRJkqSTmpAkSZIkSdJJTUjSF6QtbWnLX1lb2tIWSZIkSZqQJEmSJEnSSU1IkiRJkiTppCYk6QuShCQk4a8sCUlIgiRJkiRNSJIkSZIk6aQmJEmSJEmSdFITkiRJkiRJOqkJSZIkSZIkndSEJEmSJEmSTmpCkiRJkiRJJzUhSZIkSZKkk5qQJEmSpGfW6zXr9Zr1es3l5SWXl5dcXl6iL8t6vWa9XrNer7m8vOTy8pLLy0v+W21pS1sk\/X4TkiRJkiRJOqkJSZIkSZIkndSEJEmSpE\/Wlra05XNIQhKSkIQknJ+fc35+zvn5Oefn55yfn3N+fs5vOT8\/5\/z8nPPzc87Pzzk\/P+f8\/JwkJOFDdrsdu92O3W7H27dvefv2LW\/fvkVflt1ux263Y7fbcX9\/z\/39Pff397zTlra05WMkIQlJ+C1taUtbpL+7CUmSJEmSJJ3UhCRJkiRJkk5qQpIkSdInS0ISkvA5vH37lrdv3\/LcfD5nPp8zn895fHzk8fGRx8dHfsvj4yOPj488Pj6yXC5ZLpcsl0tub2+5vb3lQ1arFavVitVqxePjI4+Pjzw+PqIvy2q1YrVasVqteHx85PHxkcfHR95JQhKScCpJSEISntvtdux2O3a7HdLfxYQkSZIkSZJOakKSJEmSJEknNSFJkiTpL+Pi4oKLiwsWiwWLxYLFYsFms2Gz2bDZbPjpp5\/46aef+Omnn\/gY2+2W7XbLdrtlsViwWCz4PZKQhCT8EdrSFn193rx5w5s3b3jz5g2z2YzZbMZsNkP6u5iQJEmSJEnSSU1IkiRJ+lO1pS1teWe5XLJcLlkulzy3Wq1YrVasVivepy1tact6vWa9XrNer1ksFiwWCxaLBb9lt9ux2+3Y7Xb88MMP\/PDDD\/zwww98Tm1pS1v+atrSlrYkIQmfqi1tacsfbbfbsdvt2O123NzccHNzw83NDe9zOBw4HA4cDgfW6zXr9Zr1es1\/a71es16vWa\/X\/POf\/+Sf\/\/wn\/\/znP5H+jiYkSZIkSZJ0UhOSJEmSJEk6qQlJkiRJf6okJCEJ78znc+bzOfP5nPl8znw+Zz6fs9ls2Gw2bDYbDocDh8OB55KQhCRsNhs2mw2bzYblcslyuWS5XPI+2+2W7XbLdrtlvV6zXq9Zr9dcXV1xdXXF1dUV79OWtrRls9mw2WzYbDZcXFxwcXFBEpKQhPPzc87Pzzk\/P+df\/\/oX\/\/rXv\/jXv\/7Fc\/\/zP\/\/D\/\/zP\/\/DixQtevHjBixcvSEISkvA+L1++5OXLl7x8+ZLz83POz885Pz\/n8vKSy8tLLi8veZ+XL1\/y8uVLXr58ycuXL3n58iUvX75kmiamaWKaJt5JQhKSkIQkJCEJSUhCEpKQhCQkIQlJSMKHHA4HDocDh8OB169f8\/r1a5KQhCQkIQlJePHiBS9evODFixdcX19zfX3N4XDgcDhwOBzYbrdst1u22y3r9Zr1es16veb6+prr62uur695n81mw2azYbPZ8Pr1a16\/fs3r16+5urri6uqKly9f8vLlS16+fEkSkpCEJCQhCa9fv+b169e8fv2adzabDZvNhs1mw3NJSEISkpCE7XbLdrtlu90ifY0mJEmSJEmSdFITkiRJkiRJOqkJSZIkSX9py+WS5XLJcrnkcDhwOBw4HA7c3Nxwc3PDc7vdjt1ux263YzabMZvNmM1mnJ2dcXZ2xtnZGe8zn8+Zz+fM53NWqxWr1YrVasVv+fHHH\/nxxx\/58ccf2Ww2bDYbNpsN9\/f33N\/f05a2tOX29pbb21tub2+5ubnh5uaGm5sb1us16\/Wa9XrN3d0dd3d3LJdLlssly+WSs7Mzzs7OODs7432urq64urri6uqKw+HA4XDgcDjw5s0b3rx5w5s3b3jup59+4qeffmI+nzOfz5nP57x9+5a3b9\/y9u1b2tKWtrzz9PTE09MTT09PtKUtbWlLW9ryPklIQhI+5Pr6muvra66vr5nP58znc9rSlrYcDgcOhwOHw4HFYsFisWCxWHBzc8PNzQ3X19dcX19zfX3NfD5nPp8zn89ZrVasVitWqxW\/ZblcslwuWS6XPHd9fc319TVv377l7du3vH37lra0pS0PDw88PDzw8PDAer1mvV6zXq955+7ujru7O+7u7niuLW1pS1vaMp\/Pmc\/nzOdzpK\/RhCRJkiRJkk5qQpIkSZIkSSc1IUmSJOkvbbFYsFgsWCwWzGYzZrMZs9mMzWbDZrPhufV6zXq9Zr1es1gsWCwWLBYLTuXm5oabmxtubm7YbDZsNhs2mw1JSEISkpCEy8tLLi8vuby85Lntdst2u2W73fLOcrlkuVyyXC45HA4cDgcOhwObzYbNZsNms+Gdt2\/f8vbtW96+fcvZ2RlnZ2ecnZ2xXq9Zr9es12uee\/PmDW\/evGG5XLJcLlkul3xIEpKQhCQk4UPa0pa2fIz1es16vWa9XrNYLFgsFrSlLW355ptv+Oabb\/jmm29YrVasVitWqxWr1YrVasV6vWa9XrNer2lLW9ryOZydnXF2dkZb2tKW52azGbPZjNlsxsdoS1va8jHa0pa2SF+aCUmSJEmSJJ3UhCRJkiRJkk5qQpIkSdIX4+rqiqurK66urtjtdux2O3788Ud+\/PFHfvzxR7bbLdvtlu12y3w+Zz6fM5\/PaUtb2vI57XY7drsdu92Ox8dHHh8feXx85OnpiaenJ9rSlra0pS1taUtb2nJ7e8vt7S23t7e8c3Z2xtnZGWdnZyyXS5bLJcvlks1mw2azYbPZ8M5PP\/3ETz\/9xE8\/\/cTNzQ03Nzfc3Nyw2WzYbDZsNhue2+127HY7ZrMZs9mM2WzGh7SlLR\/Slra05bm2tOVjHQ4HDocDSUhCEj5kuVyyXC55LglJSMLnlIQkJOG5trSlLR8jCUlIwjttaUtbnmtLW9qShCQkQfrSTEiSJEmSJOmkJiRJkiR9MZbLJcvlkuVyyWw2YzabsVwuWS6XLJdLFosFi8WCxWLBc0lIQhI+VVva8txsNmM2mzGbzbi5ueHm5oabmxuSkIS2tKUtH7LZbNhsNmw2G95nsViwWCxYLBZsNhs2mw2bzYbr62uur69ZLpcsl0uWyyXfffcd3333Hd999x2Hw4HD4cDhcODVq1e8evWKV69esVgsWCwWtKUtbflUSUhCEtrSlrZ8jIuLCy4uLri4uOD29pbb21s+xmKxYLFYsFgs+KMlIQlJ+G8lIQlJeC4JSUiC9CWbkCRJkiRJ0klNSJIkSZIk6aQmJEmS\/iRtaUtbJH28xWLBYrHg7OyMs7Mzzs7OWC6XLJdLlsslv6UtbWnL7\/HLL7\/wyy+\/8NxqtWK1WrFarbi5ueHm5oabmxuur6+5vr7ml19+4ZdffuGXX37huZubG25ubri5ueG3zOdz5vM58\/mc2WzGbDZjNptxf3\/P\/f098\/mc+XzOfD7n7OyMs7Mzzs7OWCwWLBYLFosF9\/f33N\/fc39\/z2KxYLFYkIQkJOG3JCEJSfiQJCQhCUlIQlva0pYPWS6XLJdLlssl19fXXF9fs91u2W63bLdbntvtdux2O3a7HTc3N9zc3HB1dcXV1RVXV1f8HofDgcPhwO9xOBw4HA58rMPhwOFw4EO22y3b7Zbtdss7u92O3W7HbrdD+hpNSJIkSZIk6aQmJEmSJEmSdFITkiRJf5IkJCEJkj7e999\/z\/fff89yuWS5XLJcLjk7O+Ps7IyzszN+SxKSkITLy0suLy+5vLzkxYsXvHjxghcvXvDc+fk55+fnbLdbttst2+2WxWLBYrFgsVhwe3vL7e0tt7e3bDYbNpsN5+fnnJ+fc35+zosXL3jx4gUvXrxgNpsxm82YzWZ89913fPfdd3z33Xf8luVyyXK5ZLlcslgsWCwWfMhyuWS5XLJcLlksFiwWCxaLBf+tJCQhCUlIQhKSkIQktKUtz7WlLW15brlcslwuWS6XvH79mtevX\/Pq1StevXrFq1evSEISknB9fc319TXX19csFgsWiwUXFxdcXFxwcXHB5eUll5eXXF5e8uLFC168eMGLFy947vz8nPPzc7bbLdvtlu12y+XlJZeXl1xeXvLc+fk55+fnXF5ecnl5yeXlJdvtlu12y3a7JQlJSMJz5+fnnJ+fs91u2W63bLdbFosFi8WCxWLB5eUll5eXXF5ecnl5yeXlJdLXbkKSJEmSJEknNSFJkiRJkqSTmpAkSZL0RTo\/P+f8\/JzVasVqtWK1WvGp7u7uuLu74+7ujoeHBx4eHnh4eKAtbWlLW9oyn8+Zz+fM53OeWywWLBYLFosFDw8PPDw80Ja2tOXh4YGHhwceHh5YLBYsFgsWiwUf4+rqiqurK66urlgulyyXSz7k4uKCi4sLLi4uWK1WrFYrVqsVn6ItbWlLW9rSlra0pS1taUtb3icJSUjCh6xWK1arFY+Pjzw+PvL4+Ehb2tKW29tbbm9vub295eLigouLC567u7vj7u6Ou7s7Hh4eeHh44OHhgaenJ56ennh6eqItbfn222\/59ttv+fbbb7m7u+Pu7o67uzva0pa2tKUtd3d33N3dcXd3x3w+Zz6fM5\/PaUtb2tKWtrSlLW2Zz+fM53Pm8zm3t7fc3t5ye3tLW9rSlru7O+7u7pjNZsxmM2azGdLXaEKSJEmSJEknNSFJkvSVaUtb2iLpry8JSUjC16ItbfmrSEISkvBOEpKQhC9FW9rSFulLMyFJkiRJkqSTmpAkSZIkSdJJTUiSJP1J2tKWtvyWy8tLLi8vuby8JAlJSEISkpCEJCThP\/\/5D\/\/5z3\/4z3\/+w3NJSEISkpCEJCQhCZI+n7a05a+oLW05pSQk4Y\/Qlra05bm2tKUtf7S2tOVzS0ISkiB9aSYkSZIkSZJ0UhOSJEmSJEk6qQlJkqQ\/SRKSkITfcnd3x93dHXd3d7x69YpXr17x6tUrnnt4eODh4YH5fM58Pmc+n\/Pc4+Mjj4+PPD4+slgsWCwWPD4+8vj4yOPjI5I+nyQk4ZTa0paPlYQkfEgSkpCEd5KQhCQkIQlJ+CtIQhKS8FwSkpCET9WWtvwebWlLW5KQhOfa0pa2SH9HE5IkSZIkSTqpCUmSJEmSJJ3UhCRJ0hfm3\/\/+N\/\/+97\/597\/\/zXPr9Zr1ek1b2tKW566vr7m+vub6+prlcslyueTs7IyzszPOzs6Q9L9rS1uea0tb2vJHS0ISPre2tKUtbWlLW9rSlra0pS1fuyQk4fdIQhKS8D5JSEISpL+jCUmSJEmSJJ3UhCRJkiRJkk5qQpIk6Qszm82YzWbMZjOWyyXL5ZLlcsl6vWa9XpOEJCThcDhwOBw4HA7c399zf3\/P\/f098\/mc+XyOpN8vCUl4LglJSIIk6cMmJEmSJEmSdFITkiRJX7DFYsFisWCxWHA4HDgcDqzXa9brNev1ms1mw2azYbPZsFgsWCwWLBYLJEmS\/kgTkiRJkiRJOqkJSZIkSZIkndSEJEnSF6YtbWnLfD5nPp8zn8+5uLjg4uKC9XrNer1mvV6z2WzYbDZsNhtev37N69evef36NZIkSX+kCUmSJEmSJJ3UhCRJkiRJkk5qQpIk6QuThCQk4bnlcslyueT+\/p77+3vu7++ZzWbMZjNmsxnffPMN33zzDd988w3vtKUtbZEkSTqVCUmSJEmSJJ3UhCRJkiRJkk5qQpIk6SuxXC5ZLpfMZjNmsxmz2YzlcslyuWS5XCJJkvRnmZAkSZIkSdJJTUiSJH0ldrsdu92O2WzGbDZjNptxcXHBxcUFFxcXvE8SkpAESZKkU5mQJEmSJEnSSU1IkiRJkiTppCYkSZK+ANfX11xfX3N9fc319TXX19dcX1\/zyy+\/8Msvv\/DLL79wc3PDzc0Nb9684c2bN7x58wZJn18SkpCEJCQhCZKkD5uQJEmSJEnSSU1IkiRJkiTppCYkSZK+ANvtlu12y3a7Zb1es16vWa\/XXFxccHFxwcXFBf\/4xz\/4xz\/+wWw2YzabMZvNkPTHSUISkpCEJCQhCUlIQhKSkIQkJOG\/1Za2tOW5trSlLZL0Z5uQJEmSJEnSSU1IkiRJkiTppCYkSZK+AG\/fvuXt27e8ffuWx8dHHh8feXx85OHhgYeHBx4eHnj58iUvX75E0mm1pS1taUtb2tKWtrSlLW35PZKQhCQkIQlJSEISkpCEJCQhCUlIQhKSkIQkPJeEJCThVNrSlrZI0v9mQpIkSZIkSSc1IUmSJEmSpJOakCRJkqQTaUtb2tKWtrTl6emJp6cnnp6eaEtb2vIpkpCEJCQhCUlIQhKScCpJSEISJOl\/MyFJkiRJkqSTmpAkSfoLaEtb2iLp65eEJCThuba0pS1tacuHtKUtv0cSkpCEJCQhCUlIQhKSkARJOoUJSZIkSZIkndSEJEmSJEmSTmpCkiTpLyAJSUiCJCUhCUl4ri1tacs7bWlLW9rSlra0pS1taUtb2vJbkpCEJCQhCUlIQhKSkIQkJCEJSZCk\/82EJEmSJEmSTmpCkiRJkiRJJzUhSZIkSX8RSUjCc21pS1s+h7a0pS1taUtb2tKWtrSlLW1py++RhCQkIQlJSEISkpCEJCRB0t\/PhCRJkiRJkk5qQpIkSZIkSSc1IUmSJEn6X7WlLW1pS1va0pa2tKUtbWnL+yQhCUlIQhKSkIQkJCEJSUhCEpIg6eswIUmSJEmSpJOakCRJkqTfoS1tea4tbWnL59SWtrTlc2tLW06pLW1pS1va8vT0xNPTE09PT7SlLW1pS1va8j5taUtbJH25JiRJkiRJknRSE5IkSZIkSTqpCUmSpL+JtrSlLW1py9eoLW1pi\/Q5JSEJzyUhCUn4VElIQhL+CElIwl9FEpKQhHfa0pa2JCEJSZD05ZqQJEmSJEnSSU1IkiRJkiTppCYkSZL+JpKQhCQkIQl\/tLa0pS2nkoQkJEHSX1MSkpCE59rSFklfnwlJkiRJkiSd1IQkSZIkSZJOakKSJOk3JCEJSUhCEsYYjDEYYzDGYIzBGIMxBmMMxhiMMRhjMMZgjMEYg+PxyPF45Hg8MsZgjMEYgzEGYwzGGIwxGGMwxmCMwRiDMQZjDMYYHI9Hjscjx+MRSV+XtrTla5SEJCThQ9rSFklfnwlJkiRJkiSd1IQkSZIkSZJOakKSJOk9kpCEJHwObWlLEpKQhE+VhCQkYYzBGIMxBmMMxhiMMRhjMMbg119\/5ddff+XXX3\/leDxyPB45Ho\/8WZKQhCR8SFva8qna0pa2SPqwtrSlLX+mtrSlLUlIgqSvz4QkSZIkSZJOakKSJP2tJSEJSUhCEpLwIcfjkePxyMdKQhL+aG1pS1uSkIQkjDEYYzDGYIzBGIMxBmMMxhiMMRhjMMZgjMEYgzEGf4QkJOFTJSEJSZD0YUlIQhJOJQlJSMJzbWlLWyT9PUxIkiRJkiTppCYkSZIkSZJ0UhOSJOlvIwlJSEISkvCx2tKWzyEJSUjCX1lb2tKWMQZjDMYYjDEYYzDGYIzBGIMxBmMMxhhI+vtKQhKea0tb2iLp72dCkiRJkiRJJzUhSZIkSZKkk5qQJElfjba05bkkJCEJn+p4PHI8Hjkej0zTxDRNfKokJCEJbWlLW\/7KkpCEJHyM4\/HI8XhkjMEYgzEGx+OR4\/HI8XhE0oclIQlJSEISkiBJX6oJSZIkSZIkndSEJEmSJEmSTmpCkiR9NaZpYpomkpCEJPyWJCQhCb9HW9ryqZ6ennh6euLp6YkPSUIS\/kxtaUtb3qctbWlLW9rSlueSkITnkpCEJIwxGGMwxmCMwRiDMQbH45Hj8Yj0d5SEJHxIEpKQhCQk4a8iCUlIwjttaUtbJP29TUiSJEmSJOmkJiRJkiRJknRSE5Ik6YvTlra05b\/Vlra05bnj8cjxeOR4PPI5JSEJSfiQtrTlz5SEJCThfZKQhCQkIQlJ+BySkITj8cjxeOR4PDLGYIzBGIMxBmMMxhg815a2SH+ktrSlLW1pS1u+Nm1pS1ueS0ISkvBcW9oiSe9MSJIkSZIk6aQmJEnSFycJSUjCc21pi748SUhCEt5JQhKS8CFjDMYYjDH49ddf+fXXXxljMMZgjIF0aklIQhL+aG1pyx8hCUlIwjRNTNPENE0815a2tEWS\/v8mJEmSJEmSdFITkiRJkiRJOqkJSZL01WlLW9qiL0Nb2tKWz2mMwRiDMQZjDMYYjDGQTiEJSUjCx3h6euLp6Ymnpyfepy1tactzSUjCH60tbWmLJP1eE5IkSZIkSTqpCUmSJEmSJJ3UhCRJ+iK0pS1t+S1JSEISPsbxeOR4PHI8HtGfJwlJ+Nza0pa2jDEYYzDGYIzBGIMxBmMMxhhIp5aEJCQhCUlIwqdIQhKScCpJSEISnmtLW9oiSf+bCUmSJEmSJJ3UhCRJkiRJkk5qQpIkfRGSkIQkfKrj8cjxeOR4PKK\/rra05UOSkIQkJCEJSfgtSUhCEn7LGIMxBmMMxhiMMRhj8N9qS1vaoj9fW9rSllNJQhKSkIQkJOFD2tKW55KQhCS8T1va0pbPLQlJeK4tbWmLJP1eE5IkSZIkSTqpCUmS9JfTlrZ8rCQk4bnj8cjxeOR4PPLc8XjkeDxyPB45Ho8cj0f0ZWhLW9rSlra05Y8wxmCMwRiDMQZjDD5GEpKQBP35kpCEJHyqJCQhCUlIQhKSkARJ0v9nQpIkSZIkSSc1IUmSJEmSpJOakCRJf6i2tKUtH5KEJPweSUhCEt45Ho8cj0eOxyNtaUtbfksSkpCEJCQhCfp7SEISkvAxxhiMMRhjMMZgjMEYgzEGYwz09UhCEpKQhCR8yH6\/Z7\/fs9\/v2e\/37Pd79vs9+\/2e\/X7Pb2lLW9ryR0tCEpLwTlva0hZJ+hQTkiRJkiRJOqkJSZIkSZIkndSEJEn6QyUhCUn4VElIQhKeOx6PHI9HnktCEpLwW9rSlra0pS1t0d9DW9rSlra0pS3\/rTEGYwzGGOivKwlJSEISkpCEJCQhCe+z3+\/Z7\/fs93v2+z37\/Z79fs87bWlLWz5VW9rSlvdJQhKS8Hu0pS3PJdtNTWAAACAASURBVCEJSXiuLW2RpP\/WhCRJkiRJkk5qQpIkSZIkSSc1IUmS\/hLa0pa2vE8SkpCE547HI8fjkePxiPS5JCEJSfhUbWnLc2MMxhiMMRhjMMZgjIH+WElIQhKSkIQP2e\/37Pd79vs9P\/\/8Mz\/\/\/DP7\/Z79fs9+v+e3JCEJSfgc2tKWtrxPEpKQhA9JQhKSkIQkPNeWtrRFkj6XCUmSJEmSJJ3UhCRJkiRJkk5qQpIk\/SUkIQlJeCcJSUjCc8fjkePxyPF4RPoajDEYYzDGYIzBGIOvXVva0pZTSUISkpCEJCThfX7++Wd+\/vlnfv75Z\/b7Pfv9nv1+z3NtactfRVva0pa2tOW5JCQhCUlIQhKSkARJ+iNNSJIkSZIk6aQmJEnSX04SkvDc8XjkeDxyPB6RvgRJSMKnGmMwxmCMwRiDMQZjDL4WSUhCEj5VEpKQhCQkIQlJSMKH7Pd79vs9+\/2e\/X7Pfr+nLW1pSxKSkIQvTVva0pa2tKUtkvRnm5AkSZIkSdJJTUiSJEmSJOmkJiRJ0nu1pS1t+SMkIQlJkPRhYwzGGIwxOB6PHI9Hjscjf6S2tKUtf4QkJCEJSUhCEt7n559\/5ueff+bnn39mv9+z3+\/Z7\/fs93v2+z37\/Z73aUtb2tKWtrRFkvR5TEiSJEmSJOmkJiRJkiRJknRSE5Ik6b2SkIQknEoSkpCE9zkejxyPR47HI9LXpi1taUtb2tKWj5GEJCRhjMEYg0\/Vlra05bckIQlJ+NySkIQkJCEJH7Lf79nv9+z3e\/b7Pfv9nra0pS0fIwlJSMLHSEISkvBXk4QkJOF92tKWtrSlLW2RpFOYkCRJkiRJ0klNSJIkSZIk6aQmJEnSHyoJSUjChxyPR47HI88lIQlJeK4tbWmL9CVJQhKSkIQkJCEJSfhUYwzGGIwxGGMwxmCMwW9JQhKS0Ja2tOVzSkISkpCEJCQhCUlIwjv7\/Z79fs9+v\/8\/7ME\/bJz3nfbrzz0Nf6xsqnyAzcJkl2IbKUAUQNuEBFRE5dgO4DbkIltHHNi1DE7qqNDUNOBw3EmFE06KjQLEAaQiKeKKMlYAv+xEu\/Izje6Dg4XPO+8BufpjjSzL93VxcnLCyckJJycnVBVVRVXxKrCNbWzzfWEb20REvEwDIiIiIiIiIiJiqQZERETEK+Hrr7\/m66+\/5uuvv+YstrGNbRZJQhKSiHgd2MY2L9p8Pmc+nzOfz3kSSUhCEs9LEpKQhCQkcZ6qoqqoKqqKqmKRbWxjm1eBJCQhiVeNJCQhiUW2sY1tIiK+CwMiIiIiIiIiImKpBkRERERERERExFINiIiIiJdCEpJY1Pc9fd\/T9z2SkIQkIuL52cY2tjnPfD5nPp\/zvCQhCUlIQhKSkIQkJHGWqqKqqCqqiqqiqnhekpDEy2Yb29jmZbCNbWxzFklIQhKLbGMb29jGNraJiPguDIiIiIiIiIiIiKUaEBERERERERERSzUgIiIilkYSkpDEN\/q+p+97+r4nIl48SUhCEk8yn8+Zz+fM53Pm8znz+Zz5fM4iSUhCEpKQxHmqiqqiqqgqqorj42OOj485Pj7mRbONbV53kpCEJJ6XJCQhiYiI78KAiIiIiIiIiIhYqgEREREREREREbFUAyIiIuKFkoQkJLGo73v6vicivnuSkMSi1hqtNVprSEISkjhLVVFVVBVVRVVRVZxFEpKQRCyHbWxjG9vYxjYREa+SARERERERERERsVQDIiIiIiIiIiJiqQZERETEtyYJSUhiUd\/39H1P3\/dE\/FBJQhKSeNkkIQlJtNZordFaY2VlhZWVFVprtNZorSEJSUhiUVVRVVQVVUVVERER8awGRERERERERETEUg2IiIiIM9nGNrY5iyQkIYlFfd\/T9z193xMRYBvb2EYSkpDEIklIQhJPYhvb2GaRJCTRWqO1RmuNlZUVVlZWWFlZ4SxVRVVRVRwfH3N8fMzx8TFVRVVRVSyShCQW2cY2tjmLJCQhiYiI+OEaEBERERERERERSzUgIiIiIiIiIiKWakBEREScSRKSkMQiSUgiIp6dbWxjm0W2sY1tnmR1dZXV1VVWV1dprdFao7XGysoKKysrnKeqqCqqiqqiqrCNbWzzNGxjm0WSkIQkzmIb29gmIiJ+uAZERERERERERMRSDYiIiIiIiIiIiKUaEBEREU8kCUlI4ix939P3PX3fExHns41tbLPINraxzTdaa7TWaK3RWqO1RmuN81QVVUVVUVVUFVVFVVFVnEUSkpBERETEMg2IiIiIiIiIiIilGhAREREREREREUs1ICIiIs4kCUlI4ix939P3PX3fExFPRxKSkMSi1dVVVldXWV1dpbVGa43zVBVVRVVRVVQVVcWzsI1tFtnGNraJiIh40QZERERERERERMRSDYiIiIhn0vc9fd8TEU+ntUZrjdYarTVaa7TWaK3RWqO1xlmOj485Pj7m+PiYqqKqqCqWRRKSkERERMSLNiAiIiIiIiIiIpZqQERERERERERELNWAiIiI+P9IQhKSWNT3PX3f0\/c9Ea8rSUhCEk8iCUlIYtHq6iqrq6usrq7SWqO1xnmqiqqiqqgqqoqqoqqoKiQhCUm8aJKQRERExMsyICIiIiIiIiIilmpAREREREREREQs1YCIiIhAEpJY1Pc9fd\/T9z0R3wXb2MY23yVJSEISrTVaa6ysrLCyssLKygqtNVprtNawjW1s842qoqqoKqqKqqKqiIiI+CEZEBERERERERERSzUgIiIiIiIiIiKWakBERMQPlCQkIYlv9H1P3\/f0fU\/Ed00SkpDEy9Zao7VGa42VlRVWVlZYWVnhLFVFVVFVVBVVRVVRVVQVERERAQMiIiIiIiIiImKpBkRERERERERExFINiIiI+AGRhCQksajve\/q+Z5EkJCGJs0hCEpJYJAlJSCLiedjGNs\/LNraxzZO01mit0VqjtUZrjdYa56kqqoqqoqqoKiIiIuLJBkRERERERERExFINiIiIeM1JQhKSWNT3PX3f0\/c9Z7GNbWyzyDa2sY1tbLPINraxzSLb2CbiSSQhifPYxja2OYskJCGJ1hqtNVprtNZordFao7VGa41FtrGNbaqKqqKqqCqqiqoiIiIins+AiIiIiIiIiIhYqgEREREREREREbFUAyIiIl5DkpCEJBbN53Pm8znz+ZznJQlJPCtJSCJiWVprtNZordFao7XGeaqKqqKqqCqqiqqiqqgqIiIi4sUaEBERERERERERSzUgIiIiIiIiIiKWakBERMRrRBKSOI9tbGObRZKQRMR3RRKSkIQkJHGe1dVVVldXWV1dpbVGa43WGmepKqqKqqKqqCqqim9IQhKSWGQb29gmIiIivr0BERERERERERGxVAMiIiIiIiIiImKpBkRERHzPSUISkjhL3\/f0fU\/f93yXbGObiLPYxja2WVlZYWVlhdYarTVaa7TWaK3RWmNRVVFVVBVVRVVxfHzM8fExx8fHSEISkrCNbWzzjcePH\/P48WMeP37MIklIQhIRERHx7Q2IiIiIiIiIiIilGhAREREREREREUs1ICIi4jtkG9vY5kXq+56+7+n7nqdhG9sskyQkEf+HJCQhiR+i1hqtNVprtNZordFa4yxVRVVRVVQVVUVVYRvb2OYbkpCEJGxjG9tIQhKS+IYkJCGJiIiIWJ4BERERERERERGxVAMiIiK+Q5KQhCSehSQkIYlFfd\/T9z3x\/WAb29jmddRao7VGa43WGq01Wmu01mitcZ6qoqqoKqqKquI8kpCEJCIiIuLVNSAiIiIiIiIiIpZqQERERERERERELNWAiIiI7wlJSEISi\/q+p+97+r4nXl+2sY1tXgbb2MY2T9Jao7VGa43WGq01WmucpaqoKqqKqqKqqCqqiqqiqoiIiIjXz4CIiIiIiIiIiFiqARERERERERERsVQDIiIiXmGSkIQkFvV9T9\/39H1P\/DBIQhKSeBaSkIQknoUkJCGJRa01Wmu01mit0VrjPCcnJ5ycnHB8fMzx8THHx8dERETED9OAiIiIiIiIiIhYqgEREREREREREbFUAyIiIl5BkpDEor7v6fuevu+JeFq2sY1tnqS1RmuN1hqtNVprtNZordFao7XGWaqKqqKqqCqqiqrCNraRhCQkscg2trHNi2Ab20RERMSrZ0BERERERERERCzVgIiIiFfEYDBgMBgwGAz4Rt\/39H1P3\/ecRxKSkMS3JQlJSCJeb601Wmu01mit0VrjPFVFVVFVVBVVRVVRVVQVz0sSkpDEiyAJSURERMSrZ0BERERERERERCzVgIiIiIiIiIiIWKoBERER3yFJSEIStrGNbfq+p+97noZtbGObb8s2trFNfH+11mit0VqjtUZrjdYarTVaa7TWOEtVUVVUFVVFVVFVRERERHxbAyIiIiIiIiIiYqkGRERERERERETEUg2IiIh4ySQhCUm8CJKQhCS+LdvYxjbx6pKEJCTRWqO1RmuN1hqtNSQhCUksqiqqiqqiqqgqqoqqoqpYJAlJSOJZ2MY2tjmLJCQhiSeRhCQkEREREd9vAyIiIiIiIiIiYqkGRERERERERETEUg2IiIh4SSQhifP0fU\/f9\/R9z7OwjW1s821JQhKSeN1JQhLfF601Wmu01lhZWWFlZYWVlRXOcnx8zPHxMcfHx1QVVUVV8SxsYxvbPAtJSEISZ7GNbWzzJLaxjW0iIiLi+21AREREREREREQs1YCIiIiIiIiIiFiqAREREd+h+XzOfD5nPp8TL5dtbCMJSUjiu9Rao7VGa43WGq01VldXWV1dZXV1lfNUFVVFVXFycsLJyQkRERERr5oBERERERERERGxVAMiIiKWSBKSkMQ35vM58\/mc+XyObWxjG9vYxjbx8tjGNrZZJklIorVGa43WGq01Wmu01jjL8fExx8fHHB8fU1VUFVVFVVFVVBWLbGObiIiIiFfNgIiIiIiIiIiIWKoBERERERERERGxVAMiIiKek21sY5tFkpCEJBb1fU\/f99jGNraxjW1sIwlJSCK+v1prtNZordFao7VGa42VlRVWVlY4T1VRVVQVJycnnJycEBEREfG6GBAREREREREREUs1ICIiIiIiIiIilmpARETEc5KEJCQhCUlIYtF8Pmc+nzOfzzmLJCQhiUWSkER8dyQhCUmcpbVGa43WGq01Wmu01jjPyckJJycnVBVVRVVRVVQVVYUkJCEJ29gmIiIi4nUxICIiIiIiIiIilmpAREREREREREQs1YCIiIjnJAlJSGJR3\/f0fU\/f99jGNrZ5FraxTTwb29jmRbCNbWzTWqO1RmuN1hqtNc5zcnLCyckJJycnVBVVRVVhG9sskoQkJGEb29gmIiIi4nUzICIiIiIiIiIilmpARETEAtvYxjbnkYQkFvV9T9\/39H1PfHcGgwGDwYBn0VqjtUZrjdYarTVaa7TWaK3RWuMsVUVVUVVUFVVFVWEb29jmSWxjG9u8CJKQRERERMSrZkBERERERERERCzVgIiIiIiIiIiIWKoBERERCyQhCUkskoQkJPGNvu\/p+56+73nZbGMb28T\/YRvbnKe1RmuN1hqtNVprnKeqqCqqiqqiqqgqqoqq4lVkG9tEREREvGoGRERERERERETEUg2IiIiIiIiIiIilGhDxAtnGNraJeB62sY1tnsXp6Smnp6ecnp6ytbXF1tYWkpCEJLa2ttja2mJra4sfCtvYxjbPSxKSkMSrRhKSkMQPnW1sY5tvtNZordFao7VGa43WGmepKqqKqqKqqCqqikW2sY1tIiIiIuLZDYiIiIiIiIiIiKUaEBERERERERERSzUg4gWShCQk8cknn\/DJJ5\/wySefsLW1xdbWFltbW0hCEpKQhCQ2NjbY2NhgY2OD0WjEaDRiNBqxs7PDzs4OOzs7zGYzZrMZL5ptbGObb8s2trFNPB9JSEIStrGNbZ5kPB4zHo8Zj8fs7e2xt7fH4eEhh4eHHB4eMpvNmM1mzGYzDg8POTw85PDwkNeZJCQhiWchCUlI4jx939P3PU\/DNraxTXw7kpCEJFprtNZorbG6usrq6iqrq6u01mitsaiqqCqqiqqiqqgqqoqq4mlIQhKSiIiIiIhnNyAiIiIiIiIiIpZqQERERERERERELNWAiBdoNBoxGo0YjUYMh0OGwyHD4ZCLFy9y8eJFLl68yKNHj3j06BGPHz\/m8ePHPH78mMPDQw4PDzk8PGTRZDJhMpkwmUxYFklIQhLfliQkIYknOTo64ujoiKOjI+JskpCEJJ7k4OCAg4MDDg4OuHjxIhcvXmRzc5PNzU02Nze5d+8e9+7d4969e\/zkJz\/hJz\/5CT\/5yU+I\/0MSkjhP3\/f0fU\/f9zwLSUhCEvHsWmu01mitsbKywsrKCisrK5ynqqgqqoqqoqp4Fl3X0XUdXdfRdR1d19F1HYskIYmIiP+NbWwTERH\/Y0BERERERERERCzVgIgXYDabMZvNGI\/HjMdjxuMxv\/rVr\/jVr37Fr371K\/b29tjb22Nvb4+1tTXW1taQhCQksb6+zvr6Ouvr6+zt7bG3t8fe3h67u7vs7u6yu7vLF198wRdffMH33WQyYTKZsLGxwcbGBhsbGyyLbWxjm9fdF198wRdffMEXX3yBbWyz6OLFi1y8eJGLFy\/y5ptv8uabb\/Lmm28S\/7u+7+n7nr7vieVordFao7VGa43WGq01VldXWV1d5TxVRVVRVZycnHBycsLJyQnPwja2eRpd19F1HV3XYRvbSEISkoiI+P+ThCQiIuJ\/DIiIiIiIiIiIiKUaEBERERERERERSzUg4gWYTCZMJhMWvf3227z99tu8\/fbbLLKNbZ7G7u4uu7u77O7u8tZbb\/HWW2+xTKenp5yenjKZTJhMJkwmE16EyWTCZDJhMpmws7PDzs4OL4MkJCGJRffv3+f+\/fvcv3+f0WjEaDRiNBrxupCEJOLJJCEJSXyj73v6vqfve55EEpKQxA+JbWzzNCQhCUm01mit0VqjtUZrjfMcHx9zfHxMVVFVVBVVRVVRVbwIkpDEeSQhCUks6rqOruuwjW1sExERERH\/uwEREREREREREbFUAyIiIiIiIiIiYqkGRLwAs9mM2WzGos3NTTY3N9nc3GSRJCTxNNbW1lhbW2NtbY3NzU02NzdZNJ1OmU6nTKdTLl26xKVLl7h06RKSkMSFCxe4cOECFy5cYDQaMRqNGI1GnGc6nTKdTtnZ2WFnZ4ednR1GoxGj0YjRaMSlS5e4dOkSly5dQhKSkIQkJLGzs8POzg47Ozssmk6nTKdTptMp35CEJCQhCUlIYjabMZvNmM1mLJpOp0ynUy5dusSlS5e4dOkSkpCEJNbW1lhbW2NtbY3RaMRoNGLR22+\/zdtvv83bb7\/NpUuXuHTpEpcuXWI8HjMejxmPx4xGI0ajEZKQhCTG4zHj8ZjxeMzzOj095fT0lNPTU3Z2dtjZ2UESkpCEJCQhiY2NDTY2NtjY2GA0GjEajRiNRpyennJ6esrW1hZbW1tsbW0hCUlIYpEkJCEJSUhiNpsxm82YzWa87mxjm\/NIQhKSWNT3PX3f8yxsYxvbnMc2trHN940kJCGJRZKQxCJJSEISrTVaa7TWaK3RWqO1xlmqiqqiqqgqqoqq4lnYxja2+baqiqqiqrCNbWwTEfE0bGMb20RExP9tQERERERERERELNWAiIiIiIiIiIhYqgERL8Dp6Smnp6e8DJPJhMlkwmQyYTqdMp1OmU6n3Lt3j3v37nHv3j1sY5uDgwMODg44ODhgPB4zHo8Zj8dMJhMmkwmTyYRF29vbbG9vs2h3d5fd3V12d3e5d+8e9+7d4969e9jGNrY5Ojri6OiIyWTCZDJhMpmw6PDwkMPDQw4PD\/mGbWxjG9vYxjabm5tsbm6yubnJZDJhMpkwmUyYTqdMp1Pu3bvHvXv3uHfvHraxjW0++eQTPvnkEz755BPG4zHj8ZjJZMJkMmEymXBwcMDBwQEHBwccHR1xdHTE0dERi0ajEaPRCNvYxja7u7vs7u6yu7vL8xqNRoxGI0ajEZubm2xubmIb29jm0aNHPHr0iEePHjEcDhkOhwyHQ8bjMePxmPF4zGg0YjQacXh4yOHhIYeHh9jGNrZZZBvb2MY2ttnc3GRzc5PNzU1ed5KQxCJJSEISi\/q+p+97+r7nRbKNbWwjCUlI4vvGNraxzaLWGq01Wmu01mitsbKywsrKCisrKyyyjW1sU1VUFVVFVVFVSEISkjiLJCQhiRfBNraxzbfVdR1d19F1HRER\/y9JSEISERHxfxsQERERERERERFLNSDiBVhbW2NtbY2XYTweMx6PGY\/HTKdTptMp0+kUSUhCEpKQxNbWFltbW2xtbbHoT3\/6E3\/605\/405\/+xJOsra2xtrbG2toa51lfX2d9fZ0X7be\/\/S2\/\/e1v+e1vf8t0OmU6nSIJSUhCEpKQxObmJpubm2xubvKN2WzGbDZjNpuxaH19nfX1ddbX11n05ptv8uabb\/KiTSYTJpMJk8mE4XDIcDhk0draGmtra6ytrbG3t8fe3h57e3vs7e2xt7fH3t4ek8mEyWRCPD1JSEISi\/q+p+97+r7nSWxjG9s8iW1sYxtJSEIS32etNVprtNZordFao7XGWaqKqqKqqCqqiqqiqqgqqoqz2MY2tjmLbWxjmxdBEpKQRETEMklCEk9jPp8zn8+Zz+dERLyuBkRERERERERExFINiIiIiIiIiIiIpRoQ8QL8\/Oc\/5+c\/\/zmLZrMZs9mM2WzGi\/TgwQMePHjAgwcPePToEY8ePeLRo0fYxja2sY1tbGMb29jGNrb5\/e9\/z+9\/\/3t+\/\/vfYxvb2OZV8+DBAx48eMCDBw84PT3l9PQU29jGNraxjW1sYxvb2MY2BwcHHBwccHBwwKvi9PSU09NTnsb29jbb29tsb2\/zOrONbWzzIkhCEovm8znz+Zz5fM6zkIQkJPEkkpCEJL4vWmu01mit0VqjtUZrjdYarTXOU1VUFVVFVVFV\/NB1XUfXdXRdx6vGNraxzaJ\/\/OMf\/OMf\/+CHxDa2sc2zsI1tbPMNSUhCEoskIQlJ7O\/vs7+\/z7vvvsu7777Lu+++y8tmG9vYJl4u29gmIiL+x4CIiIiIiIiIiFiqARERERERERERsVQDIl6A\/\/iP\/+A\/\/uM\/WDSZTJhMJkwmE16E09NTTk9PWV9fZ319nfX1dcbjMePxmPF4zLOYTqdMp1Om0ymSkIQkXjVvvfUWb731Fm+99RZ7e3vs7e3xLKbTKdPplOl0ynfp4sWLXLx4kYsXLzKdTplOpzyr4XDIcDjkdSQJSUjieUlCEpI4i21sY5tnIQlJSOJFkIQkXrbWGq01Wmu01mit0VrjLFVFVVFVVBVVRVVRVVQVVcVZbGMb2\/zQdV1H13V0XcdZPvzwQz788EM+\/PBDrl69ytWrV7l69Spd19F1HV3X0XUdXdfRdR1d19F1HV3X0XUdXdfRdR1d19F1HV3X0XUdXdfRdR1d17HoL3\/5C3\/5y1\/4y1\/+ws7ODjs7O+zs7HD16lWuXr3KyyAJSUjiuyQJSUjiWUhCEpL4hm1sY5tFtrGNbR4+fMjDhw\/5+9\/\/zt\/\/\/nf+\/ve\/87xsYxvbPIvBYMBgMGAwGLDINraJV898Pmc+nxMR8boZEBERERERERERSzUgIiIiIiIiIiKWakDEC\/Dzn\/+cn\/\/852xvb7O9vc329jbT6ZTpdMp0OmU0GjEajRiNRnzxxRd88cUXnGc2mzGbzZjNZuzu7rK7u8vu7i7379\/n\/v377O3tsbe3x97eHuPxmPF4zHg8ZjQaMRqNGI1GnJ6ecnp6yqLxeMx4PGY8HvMsTk9POT095fT0lGdxenrK6ekpp6ennGU2mzGbzZjNZix68OABDx484MGDB+zt7bG3t8fe3h7j8ZjxeMxoNGI0GjEajfjyyy\/58ssv+fLLL1m0t7fH3t4eL5ttbGMb29jGNtvb22xvb7O9vc1oNGI0GnF4eMjh4SGHh4csevDgAQ8ePODBgweMx2PG4zHj8Zjd3V12d3d5Gqenp5yenvJ9Zxvb2OYskpCEJM7S9z1939P3Pc\/CNraxjW1sY5sXwTa2WabWGq01Wmu01mitcZ6qoqqoKqqKquJ5SUISkoj\/3QcffMAHH3zABx98wKeffsqnn37Kp59+ylmqiqqiqqgqqoqqoqqoKqqKf\/7zn\/zzn\/\/kn\/\/8J\/\/2b\/\/Gv\/3bv7HoypUrXLlyhStXrnDr1i1u3brFrVu3eJEkIQlJnMU2trHNi2Ab29jmLLaxjW1etP\/+7\/\/mv\/\/7v3kaH3zwAR988AGff\/45n3\/+OZ9\/\/jm2sY1tnoUkJCGJZ2Eb29hmkSQkES+WJCQhiedlG9tERLxuBkRERERERERExFINiIiIiIiIiIiIpRoQ8QLdunWLW7ducevWLQ4ODjg4OODg4ID79+9z\/\/597t+\/z\/r6Ouvr60hCEpLY2NhgY2ODjY0NZrMZs9mM2WzGzs4OOzs77OzssLm5yebmJsPhkOFwyHA45ODggIODAw4ODphOp0ynU6bTKRcuXODChQtsbGywsbHBxsYG6+vrrK+vs76+znA4ZDgcMhwOWbS1tcXW1haLLly4wIULF7hw4QJbW1tsbW2xtbXFbDZjNpsxm82QhCQWXbhwgQsXLnDhwgVmsxmz2YzZbMZwOGQ4HLK1tcXW1hZbW1tsbW2xtbXF1tYWi4bDIcPhkOFwyMHBAQcHB0ynU6bTKdPplLW1NdbW1lhbW2NjY4ONjQ02NjbY2NhgY2OD4XDIcDhkOBwiCUlIQhKSkMQiSUjieUlCEpKQhCQksb29zfb2Ntvb22xvb7O9vc0777zDO++8wzvvvIMkJCGJ0WjEaDRiNBoxHA4ZDocMh0MuXrzIxYsX2draYmtri62tLTY2NtjY2GBjY4NFFy5c4MKFC2xtbbG1tcXW1hbfR5KQhCS+IQlJYvbxDgAAIABJREFUSGKRJCQhib7v6fue5yUJSUjiVdNao7VGa43WGq01Wmu01mit0VpDEpJYVFVUFVVFVVFVVBVnkYQkJPF9ZBvbPA3b2OZFqCqqiqqiqqgqqoqz2MY2tnkSSUhCEud54403eOONN3jjjTeYTCZMJhNeNtvYxjZnkYQkJPEiSEISkrCNbWzzDUlIQhLPyza2sc3+\/j77+\/vs7+\/zr\/\/6r\/zrv\/4rT8M2tlkkCUlI4vtIEpKIs9nGNrb5tubzOfP5nPl8TkTE62BAREREREREREQs1YCIJRkOhwyHQ4bDIYeHhxweHnJ4eIhtbGMb29jm6OiIo6Mjjo6O2NvbY29vj729PdbX11lfX2d9fZ2zDIdDhsMhw+GQo6Mjjo6OODo6wja2OTo64ujoiKOjI4bDIcPhkOFwyHkODw85PDzENraxjW1sY5s\/\/vGP\/PGPf+SPf\/wjm5ubbG5usrm5iW1sYxvb2MY2trHN5uYmm5ubbG5ucnBwwMHBAbaxjW0ODw85PDzk8PCQ9fV11tfXWV9fZ9FwOGQ4HHJ0dMTR0RFHR0c8fvyYx48f8\/jxY46Ojjg6OuLo6IjhcMhwOGSRbWxjG9vYxja2sY1tbGObZdrb22Nvb49Hjx7x6NEjHj16hG1sY5uDgwMODg44ODjg4sWLXLx4kYsXL\/KNw8NDDg8POTw85OjoiKOjI46OjrCNbWxjG9scHh5yeHjI4eEhr7uvv\/6ar7\/+mq+\/\/prXRWuN1hqtNVprtNY4T1VRVVQVx8fHHB8fU1VUFVXFs7CNbWzzfSQJSTwNSUjiaVQVVUVVUVVUFS+DbWxjm\/P88pe\/5Je\/\/CW\/\/OUv+Zd\/+Rf+5V\/+hRfBNraxzbdlG9vY5kWThCQk8W1JQhKS+Oijj\/joo4\/46KOPuH79OtevX+f69es8i4cPH\/Lw4UNu3rzJzZs3uXnzJsskCUks+uqrr\/jqq6\/46quv+Oijj\/joo4\/46KOPeF62sU08mSQkIQlJSOJpSEISERGvmwEREREREREREbFUAyIiIiIiIiIiYqkGRLwmbGMb2yyLJCQhiWdhG9vY5tuyjW1sIwlJSCKenm1sY5vvC0lIYlHf9\/R9T9\/3PIkkJCGJ80hCEi9Da43WGq01Wmu01mit0VqjtUZrjbNUFVVFVVFVVBVVxbOQhCQkEf+7qqKqqCqepOs6uq6j6zpehjt37nDnzh3u3LnDn\/\/8Z\/785z\/z5z\/\/GUlI4kWQhCQkcefOHe7cucOdO3e4evUqV69epes6uq6j6zp+\/OMf8+Mf\/5gf\/\/jH3Lhxgxs3bnDjxg2+8e677\/Luu+\/y7rvv8rOf\/Yyf\/exn\/OxnP+OnP\/0pP\/3pT\/npT3\/Kk1y+fJnLly9z+fJlLl++zOXLl7l8+TKLbGObGzducOPGDW7cuMHOzg47Ozvs7OzQdR1d19F1HV3X0XUd169f5\/r161y\/fh3b2MY2d+7c4c6dO9y5c4dFXdfRdR1d19F1HV3XcffuXe7evcvdu3e5e\/cud+\/e5e7du+zv77O\/v8+NGze4ceMGN27c4DxfffUVX331FV999RXXr1\/n+vXrdF1H13V0XUfXdXRdR9d1XL58mcuXL3P58mU+\/PBDPvzwQz788EO+\/PJLvvzySxbdvn2b27dvc\/v2bX7zm9\/wm9\/8ht\/85jd8+OGHfPjhh1y9epWrV69y9epVuq6j6zq6rqPrOrquo+s6rl+\/zvXr17l+\/Trx9GxjG9vYxjbnkYQkJHGW+XzOfD5nPp8TEfF9NSAiIiIiIiIiIpZqQERERERERERELNWAiNeEJCQhiVeNJCQhiW9LEpKQRJzNNrY5jyQkIYlXmSQkIYlv9H1P3\/f0fc95bGObRbaxjW3OYxvbPC\/b2MY2i1prtNZordFao7XGeaqKqqKqqCqqiqqiqqgqnoZtbHMe29jGNi+DJCQhiXh2XdfRdR1d19F1HV3X0XUd29vbbG9vs729zbOQhCQk8ST7+\/vs7++zv7\/P7du3uX37Nrdv3+bTTz\/l008\/paqoKqqKW7ducevWLW7dusXNmze5efMmN2\/eZH9\/n\/39fT7++GM+\/vhjPv74Y37961\/z61\/\/ml\/\/+tc8fPiQhw8f8vDhQx4+fMjDhw95+PAh33j48CEPHz7k4cOHXLt2jWvXrnHt2jX++te\/8te\/\/pW\/\/vWvLJKEJO7evcvdu3e5e\/cut27d4tatW9y6dYuqoqqoKv72t7\/xt7\/9jf39ffb399nf32fRxx9\/zMcff8zHH3\/Moqqiqqgqqoqq4sqVK1y5coUrV65w5coVrly5wpUrV3j\/\/fd5\/\/33eRo3btzgxo0b3Lhxg3\/\/93\/n3\/\/936kqqoqq4vPPP+fzzz\/n888\/59q1a1y7do1r167xu9\/9jt\/97nf87ne\/48aNG9y4cYNF7733Hu+99x7vvfcei\/7zP\/+T\/\/zP\/+TTTz\/l008\/5dNPP6WqqCqqis8++4zPPvuMzz77jP39ffb399nf3yeenSQkIYnz2MY2tjmLbWxjm4iI76sBERERERERERGxVAMiIiIiIiIiImKpBkREvKJsYxvbPAtJSOL7SBKSkMSivu\/p+56nIQlJLJKEJCSxLKurq6yurrK6ukprjdYarTXOUlVUFVVFVVFVVBVPIglJSOI8kpCEbWxjm0WSkIQkXgbb2MY2kpDEy2Yb29hmkSQksUgSkpDEq6CqqCqqiqqiqqgqPvvsMz777DM+++wznoVtbGObb0hCEpJYdPPmTW7evMnNmze5ffs2t2\/f5vbt23RdR9d1dF1H13V0Xcc777zDO++8wzvvvMOiu3fvcvfuXRZdu3aNa9euce3aNd58803efPNN3nzzTfb399nf32d\/fx9JSGJ\/f5\/9\/X329\/d57733eO+993jvvfeQhCQkcZY\/\/OEP\/OEPf+APf\/gDi+7cucOdO3e4c+cO\/\/Vf\/8V\/\/dd\/8arY399nf3+f\/f19fvGLX\/CLX\/yCRW+88QZvvPEGb7zxBu+\/\/z7vv\/8+77\/\/Ph988AEffPABH3zwAfv7++zv7\/M03njjDd544w3O86Mf\/Ygf\/ehH\/OhHP+IstrGNbeJ\/Zxvb2OZ5SUISkpjP58znc+bzORER3ycDIiIiIiIiIiJiqQZERERERERERMRSDYj4nrl\/\/z7379\/n\/v37xKvFNraxzYsgCUlI4nUmCUlIYlHf9\/R9T9\/3PA9JSEIStrGNbSQhCUk8i9YarTVaa7TWaK3RWqO1RmuN81QVVUVVUVVUFc\/LNraxzZNIQhKSWGQb29jmZbONbV42SUhCEotsY5tFtrGNbZ6k6v9hD45hpD4Ptl\/\/7mn4uwleun0igQwVkUKR3cbFuppVXMBbeTCSN2VmU6TOjp06zqzb2MUMLVIwuCOFpZkqRPJbQOMCpTESlvy424HKzzTcpzgHfaPv7AZDWBub+7oqtVZqrXwftrHNi3D69GlOnz7N6dOn+fTTT\/n000\/59NNPeR62sY1tVj148IAHDx7w4MED\/v3vf\/Pvf\/+bf\/\/739RaqbVSa6XWSq2VWiu1Vmqt1FqptVJrZTKZMJlMkIQkJHHy5ElOnjzJyZMnee+993jvvfd47733uHXrFrdu3eLWrVvYxjYPHz7k4cOHPHz4kNOnT3P69GlOnz6NbWxjm8PcunWLW7ducevWLa5du8a1a9e4du0aW1tbbG1tsbW1xc7ODjs7O7yMHj16xKNHj7CNbWxzlJ2dHXZ2dtjZ2eEJ29jGNqskIQlJHMY2trHN00hCEpKIiIj4PnpERERERERERMSx6hHxnPb29tjb22Nvb49z585x7tw5JCEJSUhCEpKQhCQkIQlJbG5usrm5yebmJuPxmPF4zHg8ZtV8Pmc+nzOfz7l8+TKXL19mc3OTzc1NNjc3ednYxja2eV6j0YjRaMRoNGJzc5PNzU02NzeRhCQkIQlJnDp1ilOnTnHq1CkkIQlJnDp1ilOnTrG9vc329jbb29tcvXqVq1evcvXqVY6LJCQhiaexjW1s8yqShCQksaq1RmuN1hrHxTa2sY0kJCGJJ7quo+s6uq6j6zq6rqPrOg5Ta6XWSq2VWiu1Vmqt1FqptVJrxTa2sU28GkoplFIopbBKEpKQhCQk8SJsbW2xtbXF1tYWT1y7do1r165x7do1nteZM2c4c+YMZ86c4eOPP+bjjz\/m448\/5glJSEISR\/nHP\/7BP\/7xD2xjG9us+t3vfsfvfvc7fve73\/HgwQMePHjAgwcP+NOf\/sSf\/vQnLly4wIULF7hw4QLfx4MHD3jw4AHXrl3j2rVrXLt2jZ2dHXZ2dtjZ2eHkyZOcPHmSkydP8jSSkIQkjoskJCGJCxcucOHCBS5cuMCtW7e4desWkpCEJFZJQhKSWHXp0iUuXbqEJCQhiVW2sY1tDiMJSUgiXi62sY1tVi2XS5bLJRERPwU9IiIiIiIiIiLiWPWIiIiIiIiIiIhj1SPiOe3v77O\/v8\/+\/j5fffUVX331FZKQhCRW2cY2trlz5w537tzhjTfe4I033uCNN97g\/fff5\/333+f9999nNBoxGo0YjUb0+336\/T79fp8bN25w48YNXkb379\/n\/v37SEISknhe4\/GY8XjMeDzmzp073Llzhzt37nCYg4MDDg4OODg4wDa2sc2NGze4ceMGa2trrK2tsba2xnA4ZDgcMhwOGY1GjEYjRqMRPxZJSEISrxJJSGLVcrlkuVyyXC5ZJQlJSOJ52MY2tjnKiRMnOHHiBCdOnOC1117jtdde4yi1Vmqt1FqptVJr5fuQhCQkET8vkpCEJJ6FbWxjm2chCUlIYtWjR4949OgRjx494q9\/\/St\/\/etf+fLLL\/nyyy\/58ssveZpHjx7x6NEjHj16xKo\/\/\/nP\/PnPf+bPf\/4zH3\/8MR9\/\/DEff\/wxH374IR9++CEPHz7k4cOHPHz4kFWffPIJn3zyCZ988gm2sc1RTp8+zenTpzl9+jSXLl3i0qVLXLp0iX\/84x\/84x\/\/YGdnh52dHXZ2dvg+bt++ze3bt3nw4AEPHjzgwYMHfPnll3z55Zd8+eWXrLp9+za3b9\/mKLaxjW1W3b59m9u3b7Pq66+\/5uuvv+brr7\/maR49esSjR4949OgRjx8\/5vHjxzx+\/JidnR12dnbY2dnhww8\/5MMPP+Sf\/\/wn\/\/znP\/nnP\/\/JqgcPHvDgwQMePHjAJ598wieffMInn3zCH\/\/4R\/74xz+yShKSkMSqR48e8ejRI57Vo0ePePToEfHDkoQkJBER8VPVIyIiIiIiIiIijlWPiIiIiIiIiIg4Vj0iXgDb2MY2trHNUTY2NtjY2GA6nTKdTplOp6yaTqdMp1Om0ylPYxvb2Oa42MY2tlk1nU6ZTqdMp1POnj3L2bNnedFsYxvbPIt+v0+\/32cymTCZTJhMJkhCEpLY399nf3+f\/f19XgTb2ObHZBvb2Oa\/JQlJSOJFkIQkJHEY29jGNqtsYxvbPI+u6+i6jq7r6LqOruvouo6u6+i6jq7rWPXNN9\/wzTffUGul1kqtlW+++YZvvvmGb775hni12cY2tpGEJGxjG9uskoQkJCEJSUjiiQ8\/\/JAPP\/yQDz\/8kLfffpu3336bt99+m8OUUiilUErht7\/9Lb\/97W\/57W9\/SymFUgqlFM6fP8\/58+c5f\/48f\/vb3\/jb3\/7GW2+9xVtvvcVbb73FlStXuHLlCleuXOFXv\/oVv\/rVr\/jVr37FE+fPn+f8+fOcP3+e27dvc\/v2bW7fvs3Fixe5ePEiFy9eZDqdMp1OmU6n3Lp1i1u3bnH+\/HnOnz\/P+fPnefPNN3nzzTd58803OXPmDGfOnOHMmTNcunSJS5cu8X289957vPfee7z33nu89957vPfee3wftrGNbf7nf\/6H\/\/mf\/+HMmTOcOXOGM2fO8Pbbb\/P222\/z9ttvs7u7y+7uLru7u5w8eZKTJ0\/y+uuv8\/rrr\/P666\/z5ptv8uabb\/Lmm2\/y9ddf8\/XXX\/P1119z6dIlLl26xKVLl3j33Xd59913uXLlCleuXOHKlSusunLlCleuXOHKlSu8+eabvPnmm6w6f\/4858+f5\/z58\/zrX\/\/iX\/\/6F\/\/617\/Y2dlhZ2eHnZ0ddnZ22NnZ4Q9\/+AN\/+MMf+MMf\/kAphVIKpRT+8pe\/8Je\/\/IW\/\/OUvXLx4kYsXL3Lx4kV+\/etf8+tf\/5pV7777Lu+++y7vvvsuq86fP8\/58+e5cuUKV65c4cqVK9y+fZvbt29z+\/ZtSimUUiilsOr8+fOcP3+e27dvc\/v2bW7fvk38+JbLJcvlkuVySUTEy6pHREREREREREQcqx4REREREREREXGsesQrwza2sc2LJglJPIu1tTXW1tZYW1tj1WKxYLFYsFgseBpJSEISx0USkpDEdDplOp0ynU7Z3d1ld3eX3d1djoskJCGJ5\/Hw4UMePnzIw4cPsY1tbLOxscHGxgYbGxu8CJKQxI9JEpKQxH\/LNraxzfOShCQkcZjWGq01Wmu8CF3X0XUdXdfRdR1d13GUWiu1Vmqt1FqptVJrxTa2WSUJSUjiednGNraJny5JSEIStrHNqlortVZqrdjGNraxjW1s88QHH3zABx98wAcffMDnn3\/O559\/zueff06tlVortVZqrdRaqbVSa6XWyueff87nn3\/O559\/Tq2VWiu1Vmqt1FqptVJrpdbKxYsXuXjxIhcvXuT69etcv36d69evc+\/ePe7du8e9e\/eotVJrpdZKrZVaK1tbW2xtbbG1tcWqixcvcvHiRS5evMgXX3zBF198Qa2VWiu1Vr744gu++OILvvjiCy5dusSlS5e4dOkSh7GNbWyz6q233uKtt97irbfe4o9\/\/CN\/\/OMf+T4kIQlJ\/OIXv+AXv\/gF169f5\/r161y\/fp1aK7VWaq1MJhMmkwmTyYQLFy5w4cIF7t27x71797h37x5ffPEFX3zxBV988QWnT5\/m9OnTnD59mslkwmQyYTKZUGul1sr169e5fv06169f5\/Tp05w+fZrTp09z\/fp1rl+\/zvXr1\/nf\/\/1f\/vd\/\/5daK7VWaq3UWqm1Umtla2uLra0ttra2WPXBBx\/wwQcfcO\/ePe7du8e9e\/eotVJrpdbKZDJhMpkwmUy4cOECFy5c4MKFCxzm73\/\/O3\/\/+9\/5+9\/\/Tq2VWiu1Vr799lu+\/fZbrl+\/zvXr17l+\/TpbW1tsbW2xtbVFrZVaK7VWaq3UWqm1Umul1srW1hZbW1tsbW0RPw22sY1tIiJ+DD0iIiIiIiIiIuJY9YhXhiQkIYkXzTa2eRbT6ZTpdMp0OmXV3t4ee3t77O3t8d9aLBYsFgsWiwW7u7vs7u6yu7uLJCQhCUlIQhJnz57l7Nmz7O3tsbe3x97eHovFgsViwWKx4ObNm9y8eZObN2+yShKSkIQkJDGfz5nP58znc35oN2\/e5ObNmwwGAwaDAYPBgH6\/T7\/fp9\/vM5vNmM1mzGYzDrNYLFgsFiwWC3Z3d9nd3WV3dxdJSEISkpCEJM6dO8e5c+cYjUaMRiNGoxGLxYLFYsFiseAw29vbbG9vs729jSQkIYlz585x7tw5zp07x3Q6ZTqdMp1OOXfuHOfOnePcuXOcO3eOc+fOMZ\/Pmc\/nzOdzfipaa7TWOIokJCGJVV3X0XUdXdfRdR1d19F1HV3X0XUdh6m1Umul1kqtlVortVaOIglJvGiSkIQkIr4vSUjip8g2trHNYSQhCUkc5eTJk5w8eZKfOtvYZpVtbGMbSUhCEsdFEpKQxCrb2CZeHZKQhCQiIn4MPSIiIiIiIiIi4lj1iIiIiIiIiIiIY9Uj4hnYxja2WSUJSRxlNBoxGo0YjUa8\/\/77vP\/++9y8eZObN29y8+ZNJpMJk8mEyWTCeDxmPB4zHo\/5b+3t7bG3t8fe3h79fp9+v0+\/38c2trHNwcEBBwcHHBwccPnyZS5fvsxHH33ERx99xEcffcRoNGI0GjEajZjNZsxmM2azGatsYxvb2MY2\/X6ffr9Pv9\/nuEhCEpKQhCQkcfnyZS5fvsyq4XDIcDhkOByytrbG2toaa2trHGY0GjEajRiNRvT7ffr9Pv1+H9vYxjYHBwccHBxwcHDAYDBgMBiwv7\/P\/v4++\/v7jEYjRqMRo9GIw8xmM2azGbPZjMFgwGAwYDAYsLa2xtraGmtra9y\/f5\/79+9z\/\/59bty4wY0bN\/jqq6\/46quv+Oqrr+j3+\/T7ffr9Pi8DSUhCEqtaa7TWaK1xGElIQhInTpzgxIkTnDhxgq7r6LqOrus4TK2VWiu1Vmqt1FqptVJrpdZKxHGThCQkcZRSCqUUSik8C9vY5nnZxja2edEkIYlVkpCEJOL7s41tbBPxoiyXS5bLJcvlkoiIl0mPiIiIiIiIiIg4Vj0iIiIiIiIiIuJY9Yh4BpKQhCSexXg8ZjweMx6P+etf\/8pf\/\/pXZrMZs9mM2WzGcDhkOBwyHA55ka5evcrVq1e5evUqg8GAwWDAYDBg1draGmtra6ytrTEejxmPx4zHY8bjMePxmOl0ynQ6ZTqd8rKxjW1sYxvb2GY2mzGbzTh79ixnz57l7NmzXL58mcuXL3P58mUmkwmTyYTJZMJhptMp0+mU6XTKYDBgMBgwGAxYtba2xtraGmtra4zHY8bjMePxmPF4zHg8ZjqdMp1OmU6nPM10OmU6nTKdTrl\/\/z7379\/n\/v37LBYLFosFi8WCjY0NNjY2eFnYxjaSkIQkVrXWaK3RWuMwXdfRdR1d13HixAlOnDjBiRMnOEqtlVortVZqrdRakYQkJBHxY7CNbWzzspGEJCTxotnGNs9CEpKQxCpJSEISLwNJSEISq2xjG9vYxjbPSxKSkETEiyIJSUgiIuJl1SMiIiIiIiIiIo5Vj4iIiIiIiIiIOFY9Il4Ri8WCxWLBYrHgaYbDIcPhkOFwyMtCEpI4im1sY5t+v0+\/3+fGjRvcuHGDGzdusLGxwcbGBhsbG3z00Ud89NFHfPTRRzzNYrFgsViwWCx4muFwyHA4ZDgc8ixef\/11Xn\/9dV5\/\/XU2NjbY2NhgY2OD6XTKdDplOp1y9+5d7t69y8ui1+vR6\/VY1VqjtUZrja7r6LqOruvouo6u6+i6jq7r6LqOo9RaqbVSa6XWSq2VWiuHsY1tbBMRPy7b2MY2h7GNbWyzyja2sc3LwDa2sc0qSUhCEpKQRMT3JQlJSOIokpCEJJ6HbWxjm+\/DNraJ+CFJQhKSeJnZxja2eUISkpCEJCQhCUlIQhKSkIQknpCEJCQhCUlI4tSpU5w6dYpTp07xKukRERERERERERHHqkdERERERERERByrHhE\/YxsbG2xsbLCxscFnn33GZ599xmeffcazGAwGDAYDBoMBPybb2OYokpCEJA6ztrbG2toaa2trPM1vfvMbfvOb3\/Cb3\/yGzz77jM8++4zPPvuMZ\/HOO+\/wzjvv8M477\/A0o9GI0WjEaDRiPB4zHo8Zj8f0+336\/T79fp\/RaMRoNOLHJAlJSOIwXdfRdR1d13GUWiu1Vmqt1FqptfLtt9\/y7bff8u233xIREfFzYxvb2OZZSEISklhlG9vY5mlaa7TWaK2xShKSiPixSEISkpCEJCQhCUm8CLaxjW2ehSQkIYknbGMb2wyHQ4bDIcPhkFWTyYTJZMJkMuGJg4MDDg4OODg4YG1tjbW1NdbW1rhz5w537tzhzp072MY2r4IeERERERERERFxrHpE\/IQtFgsWiwWLxYLDDIdDhsMhw+GQvb099vb22NvbYz6fM5\/Pmc\/nrLp\/\/z73799nf3+f\/f199vf32dvbY29vj729PY4yn8+Zz+esun\/\/Pvfv3+f+\/fv8WPb399nf32d\/f5\/5fM58Pmc+nzMYDBgMBgwGAw6zu7vL7u4uu7u77O3tsbe3x97eHvP5nPl8znw+Z9X9+\/e5f\/8++\/v77O\/vs7+\/z2g0YjQaMRqNOMx8Pmc+nzOfz1m1sbHBxsYGGxsbTCYTJpMJk8mEu3fvcvfuXUajEaPRiNFoxGKxYLFYsFgsOC6SkIQknkWtlVortVZqrdRaqbVyGNvYxjYRERGvItvYxjZP2MY2tlklCUlI4mkkIQlJRPyUSEISkpCEJCQhCUlI4mkkIQlJvEiTyYTJZMJkMqHf79Pv9+n3+4xGI0ajEaPRiLt373L37l22t7fZ3t5me3ub2WzGbDZjNpvxxhtv8MYbb\/DGG29wGNvYxjY\/Jz0iIiIiIiIiIuJY9YiIiIiIiIiIiGPVI+I59ft9+v0+\/X4fSUjiKNvb22xvb7O9vc2z2N7eZnt7m+3tbU6dOsWpU6dYderUKU6dOsWpU6eYz+fM53Pm8zlPDIdDhsMhw+GQ3\/\/+9\/z+97\/n97\/\/PZcvX+by5ctcvnwZSUhCEqPRiNFoxDvvvMM777zDO++8w8bGBhsbG2xsbLBqMBgwGAwYDAZsb2+zvb3N9vY229vbbG9v87xGoxGj0YjRaMTm5iabm5tsbm5yGElIQhKSkIQkJCGJ+XzOfD5nPp8zmUyYTCZMJhPG4zHj8ZjxeMxhhsMhw+GQ4XDIcDhkOBwyHA65fPkyly9f5vLly0hCEpIYjUaMRiMGgwGDwYDBYMDGxgYbGxtsbGywant7m+3tbba3t9ne3mZ7exvb2MY2q86ePcvZs2c5e\/Ysi8WCxWLB\/v4++\/v77O\/vc+rUKU6dOsWpU6d4kSQhCUkcpdZKrZVaK7VWaq3UWqm1UmvlWdjGNraJiIiI\/0wSkpBExKtMEpKQhCQkcRTb2OZFu3nzJjdv3uTmzZusra2xtrbG2toam5ubbG5uMhgMGAwGDAYDNjY22NjYYGNjA0lIQhKSkMSroEdERERERERERByrHhERERERERERcax6RDyn2WzGbDZjNpthG9vYxja2sY1tbDObzZjNZsxmM57FbDZjNpsxm804ODjg4OCAx48f8\/jxYx4\/foxtbGObfr9Pv9+n3+9zmP39ffb399nf3+fg4ICDgwMODg6wjW1sc+PcvfuLAAAgAElEQVTGDW7cuMHm5iabm5tsbm5ylE8\/\/ZRPP\/2UTz\/9FNvYZjabMZvNmM1mnD17lrNnz3L27FmexXg8ZjweMx6PuXPnDnfu3OHOnTvYxjaPHz\/m8ePHPH78GNvYxja2sY1tbGOb2WzGbDZjNpsxHA4ZDocMh0OexXg8ZjweMx6POTg44ODggIODA2xjG9vcuHGDGzdusLGxwcbGBhsbGxxlNpsxm82wjW1ss7+\/z\/7+Pvv7+xzFNraxjW1sYxvb2OZFkIQkbGMb2zwL29jGNk8jCUlIQhKSkERERMSrqOs6uq6j6zq6rqPrOrquo+s6uq6j6zq6rqPrOk6cOMGJEyc4ceIEXdfRdR2vvfYar732Gq+99hpd19F1HV3X0XUdXdfRdR2SkIQkJCEJSUhCEpKQhCQkIQlJSEISkpCEJCQhCUlIQhKSkIQkJCEJSUhCEpKQhCQkIQlJSEISkpCEJCQhCUlIQhKSkIQkJCEJSUhCEpKQhCQkIQlJSEISkpCEJCQhCUlIQhKSkIQkJCEJSUhCEpKQhCQkIQlJSEISkpCEJCQhCUlIQhKSkIQkJCEJSUhCEpKQhCQkIQlJSEISkpCEJCQhCUlIQhKSkIQkJCEJSUhCEpKQhCQkIQlJSEISkpCEJCQhCUlIQhKSkIQkJCEJSUhCEpKQhCQkIQlJSEISkvghSEISkvghnDx5kpMnT3Ly5EkGgwGDwYDBYMATd+\/e5e7du9y9e5dnIQlJSOLnpEdERERERERERByrHhERERERERERcax6RDwnSUhCEj8kSUhCEj8mSUhCEv8t29jGNk8jCUlIIv57kpCEJJ5FKYVSCqUUSimUUpCEJCTxNLaxjW2ehW1sY5uIiIifi9YarTVaa7TWaK3RWqO1RmuN1hqtNVprtNZordFao7VGa43vvvuO7777ju+++47WGq01Wmu01mit0VqjtUZrjdYatrGNbWxjG9vYxja2sY1tbGMb29jGNraxjW1sYxvb2MY2trGNbWxjG9vYxja2sY1tbGMb29jGNraxjW1sYxvb2MY2trGNbWxjG9vYxja2sY1tbGMb29jGNraxjW1sYxvb2MY2trGNbWxjG9vYxja2sY1tbGMb29jGNraxjW1sYxvb2MY2trGNbWxjG9vYxja2sY1tbGMb29jGNraxjW1sYxvb2MY2trGNbWxjG9vYxja2sY1tbGMb29jGNraxjW1sYxvb2MY2trGNbWxjG9vYxja2sY1tbGMb27wItrGNbWxjG9vYxja2sY1tVklCEi\/a1atXuXr1KlevXmWxWLBYLFgsFkwmEyaTCTdv3uTmzZvcvHmT\/f199vf32d\/fZ5VtbPMq6BEREREREREREceqR0T86CQhCUk8L9vYxjZPYxvb2OZVJAlJSOIwrTVaa7TWaK3RWqO1RmuN1hqtNQ5TSqGUQimFUgqlFEoplFIopVBKISIi4lVmG9vYJuJVYxvb2MY2trGNbWxjG9vYxja2sY1tbGMb29jGNj+Wu3fvcvfuXe7evcvNmze5efMmN2\/eZDKZMJlMmEwmDIdDhsMhg8GAwWDAYDBgNBoxGo0YjUZMp1Om0ynT6RRJSOJV0CMiIiIiIiIiIo5Vj4iIiIiIiIiIOFY9Ip6BbWxjm\/+WbWxjm+dlG9vY5jC2sY1tfu4kIQlJPI0kJCGJ+D9aa7TWkIQkJHGU1hqtNVprtNZordFao7VGa42jlFIopVBKoZRCKYVnIQlJSCIiIuKnRhKSkMSPablcslwuifipkYQkJPEi2cY2tjnM9vY229vbbG9vs7m5yebmJpubm8znc+bzOfP5nNFoxGg0YjQaMZ\/Pmc\/nzOdz5vM58\/mcVbu7u+zu7rK7u8v29jbb29u8CnpERERERERERMSx6hEREREREREREceqR8QzkIQkJPHfkoQkJPG8JCEJSRxGEpKQRPz02MY2tvlvSUISkljVWqO1RmuNJ2xjG9s8r9YarTVaayyXS5bLJcvlksOUUiilUEqhlEIphVIKz0ISkpDE87KNbSIiIuL\/zza2sU3Ez40kJCGJw8xmM2azGbPZDNvYxja2sY1txuMx4\/GY8XhMv9+n3+9zcHDAwcEBBwcH2MY2trGNbWwzm82YzWa8CnpERERERERERMSx6hEREREREREREceqR0TES0oSkpDE85CEJCQhCUlIorVGa43WGj8E29jGNq01Wmu01mit0VrjKKUUSimUUiilUErhKLaxjW2elyQk8SJIQhKSiIiI+DmQhCQkERHxPHpERERERERERMSx6hEREREREREREceqR0TEz4wkJLHqu+++47vvvuO7777jZdNao7VGa43lcslyuWS5XHKYUgqlFEoplFIopVBKQRKSkMTLwDa2sU1ERERERECPiIiIiIiIiIg4Vj0iIl4itrGNbZ6FJCQhiSdaa7TWaK3xspGEJCSxyja2sU1rjdYarTVaa7TWaK3RWqO1xqr19XXW19dZX1+nlEIphVIKpRRKKfyYJCEJSURERLxMlssly+WS5XJJRMRx6xEREREREREREceqR0REREREREREHKseEREvEUlIQhJPIwlJSGJVa43WGi8jSUjCNraxzSrb2MY2T7NcLlkulyyXS1prtNZorXGYUgqlFEoplFIopVBK4VnYxja2eRa2sY1t4tVmG9tEREREvIp6RERERERERETEseoRERERERERERHHqkdExI\/ANraxzbOQhCQk8VNkG9scRRKSkIRtbGObw9jGNraRhCQk0VqjtUZrjdYarTWOUkqhlEIphVIKpRSOIglJSEISkohXhyQkIYnnJQlJRERERLyKekRERERERERExLHqERERERERERERx6pHRMQxsI1tbHMYSUhCEt+HJCRxlNYarTVaa\/xcSEISkrCNbSQhCUmsso1tbHOY1hqtNVprtNZordFa4zClFEoplFIopVBKoZSCJCQhCdvYJl4dtrGNbSIiXkW2sY1tIiKeR4+IiIiIiIiIiDhWPSIijoEkJCGJ5yUJSUjiMK01Wmu01vi5k4QkbGMb27wIrTVaa7TWWC6XLJdLjrK+vs76+jrr6+uUUiilsEoSkpBEvBokIQlJHOXbb7\/l22+\/5dtvv0USkoiIeBm11mit0VrjMJKQhCQiIp5Hj4iIiIiIiIiIOFY9IiIiIiIiIiLiWPWIiPgJaa3RWqO1RrxYtrFNa43WGq01Wmu01mit0VqjtUZrDUlIopRCKYVSCuvr66yvr7O+vk4phVIKpRTi58s2trGNJCQhiVW2sY1tbGObiIiXhSQkIQlJSEIST2Mb29jGNraxTUTEf9IjIiIiIiIiIiKOVY+IiIiIiIiIiDhWPSIijpltbGObp5GEJCSxqrVGa414OXz33Xd89913tNZordFa4yilFEoplFIopVBK4fuQhCSOYhvb2CZ+fOvr66yvr7O+vs5RbGObiIiXhW1sY5tnIQlJSEISkpBERMR\/0iMiIiIiIiIiIo5Vj4iIiIiIiIiIOFY9IiKOmSQkIYnDSEISkljVWqO1RmuNePm11mit0VqjtUZrjdYahymlUEqhlEIphVIKpRRW2cY2R5GEJCQRLxdJSEISqyQhiYiIiIhXUY+IiIiIiIiIiDhWPSIiIiIiIiIi4lj1iIhXmm1sY5sfkiQkIYlVrTVaa7TWkIQkJBE\/Xa01Wmu01mit0VrjKKUUSimUUiilUEohfnpsYxvbRERERMT\/q0dERERERERERByrHhHxSpOEJCTxQ5CEJFa11mit0VpjlW1sY5t4uUhCEs+rtUZrjdYarTVaa7TWOEwphVIKpRRKKZRSKKXwLCQhCUmskoQkJBERERERcZx6RERERERERETEseoRERERERERERHHqkdExDGThCQk8URrjdYarTXip8c2tnkRbGMb27TWaK3RWqO1RmuN5XLJcrlkuVyyqpRCKYVSCqUUSimUUiilUErh+7CNbWwTL06tlVortVYiIn4qJCEJSUREHIceERERERERERFxrHpERERERERERMSx6hERcQwkIQlJxKvBNraxzbOQhCQkcRjb2MY2rTVaa7TWaK3RWqO1xmFKKZRSKKWwvr7O+vo66+vrSEISkojvzza2sU1ExM+RbWxjm9YarTVaazyNbWxjm4iI\/6RHREREREREREQcqx4REREREREREXGsekREvCCSkIQkjtJao7VG\/PxIQhKS+KG11mit0VqjtUZrjaOsr6+zvr7O+vo6pRRKKZRSeMI2trFN\/B+SkIQkniilUEqhlEJExM+JJCQhiaeRhCQkERHxn\/SIiIiIiIiIiIhj1SMiIiIiIiIiIo5Vj4iI\/5IkJHGU1hqtNVprRPxQWmu01mit0VqjtUZrjaOUUiil8Mtf\/pJf\/vKX\/PKXv+S42MY2tvkpkoQkIiIiIuL76xEREREREREREceqR0TEMWit0VqjtUbE\/00SkpDEi2Yb23wfy+WS5XLJcrnkMKUUSimUUiilUEqhlMITkpCEJJ6FJCQhiZ8i29hmVa2VWiu1VlbZxja2eUISkpBERERExKuiR0REREREREREHKseERERERERERFxrHpERDwHSUhCEk+01mit0Voj4jC2sY1tbGObF00SkljVdR1d19F1HatsYxvbLJdLlsslrTVaa7TWaK3RWqO1xqpSCqUU1tfXWV9fZ319nVIKpRRKKfwc2cY2timlUErh+5CEJCTxhG1sY5uIiIiIV0WPiIiIiIiIiIg4Vj0iIiIiIiIiIuJY9YiI+J4kIQlJrGqt0VpjlSQkIYnDSEISklglCUlIIn5+JCGJH0LXdXRdR9d1HMU2trGNbWxzlNYarTVaayyXS5bLJUcppVBKoZRCKYVSCqUUDmMb29jmZdbr9ej1evR6PSIiIiLi2fWIiIiIiIiIiIhj1SMiIiIiIiIiIo5Vj4iI\/0ASkpDEquVyyXK5ZLlc8oQkJCEJ29jGNqtsYxvb2MY2q2xjG9usso1tIp6m6zq6ruMorTVaa7TWkIQkJPEsbGOb1hqtNVprtNZordFa4yilFEoplFIopVBKQRKSkMQqSUjiZWEb29jmiVortVZqrURERETEf9YjIiIiIiIiIiKOVY+IiP+LJCQhiVWtNVprtNawjW1s84RtbGObo0hCEs9KEpKIOEzXdXRdR9d1vAxaa7TWaK3RWqO1RmuNw5RSKKVQSqGUQimFUgq2sc3LopRCKYVSChERERHx7HpERERERERERMSx6hEREREREREREceqR0TE\/0cSkpCEJCSxXC5ZLpcsl0sifgy2sY1tVnVdR9d1dF3HT0VrjdYarTVaa7TWOEophVIKpRRKKZRSiIiIiIifrh4REREREREREXGsekRERERERERExLHqERGvNElIQhJPtNZordFawza2sc3T2MY2tnnRbGObePW89tprvPbaa7z22mt0XUfXdXRdx7NordFao7XGy6a1RmuN1hrL5ZLlcslyuaS1RmuNVaUUSimUUiilUEqhlEIphVIKpRR+CLVWaq1ERERExPfXIyIiIiIiIiIijlWPiIiIiIiIiIg4Vj0i4pVgG9vYRvp\/2IND6LrPA+vXv\/0HOa9RHSa9InVYVlEKWxSHVUUxNAxMiuqiilVFY6EWWmUzzGYyi8o8zEFdKbJYvYqiQdqHeN9117d8v3OnUh07Po7j7OcRkpDEZZKQhCS8jGVZWJaFZVl43SQhido+SUhCEm+aJCQhiTEGYwxetyQkIQlvmyQkIQnP2cY2tlmv16zXa9brNVeZczLnZM7JnJM5Jy8iCUlIIglJSMLe3h57e3vs7e1RVVVVVd\/NQlVVVVVVVVVVbdVCVVVVVVVVVVVt1UJV\/Sgsy8KyLCzLwlVsY5tXlYQkJKF+uJKQhCS8aUlIQhK2RRKSkMQPTRKSkATb2MY2trGNbS4z52TOyZyTOSdzTuacPJeEJCRBEpKQRBKSkIQXSUISklBVVVVV\/2qhqqqqqqqqqqq2aqGqftRsYxvbSEISVd9WEpKQhFeVhCQkYZNtbGMb29jmZdjGNrb5MbGNbWxjG9tcZc7JnJM5J3NO5pxc5R\/\/+Af\/+Mc\/+Mc\/\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\/M\/\/\/A\/\/8z\/\/w\/n5Oefn55yfn7MtkpCEJF7GX\/7yF\/7yl7\/wl7\/8hf39ffb399nf36f+ryQk4WWcnZ1xdnbG2dkZV0lCEpLwIklIQhK2RRKSkMTFxQUXFxdcXFxgG9tcZc7JnJM5J3t7e+zt7bEpCUlIwrZIQhKSqKq3kyQkIYmXIQlJSKKq6n9bqKqqqqqqqqqqrVqoqqqqqqqqqqqtWqiq74UkJCGJTbaxjW1ehiQkIYmXkYQkJOG7SkISknCVJCThTbCNbWxjG9vYxja2sY1tbGMb29jGNraxjW1sYxvb2MY2trGNbWxjG9vYxja2sY1tbGMb29jGNraxjW1sYxvbvAlJSEISNv3Hf\/wH\/\/Ef\/8HR0RFHR0ccHR2xSRKSkMSbJAlJSOLJkyc8efKEJ0+e8PjxYx4\/fszjx4+pV3N0dMTR0REffvghH374IR9++CFvM0lIQhIvYhvb2MY2trHNpiQkYc7JnJM5J3t7e+zt7bG3t8eckzknc06qqqqqvquFqqqqqqqqqqraqoWqqqqqqqqqqtqqhap6oyQhiU22sY1trpKEJLxukpCEJJ6ThCQk8TIkIQlJXEUSkqjvjyQkIYlNx8fHHB8fc\/\/+fe7fv8\/9+\/eRhCQkkYQkJOG5JCQhCd+GJCTxMpKQhCQcHh5yeHjI4eEhT58+5enTpzx9+pT6V0+ePOHJkyc8efKEq\/z2t7\/lt7\/9LZKQhCTeNElIQhIvkoQkJCEJSUjCpiQk4Sq2sY1tbGMb29jGNleZczLnZM7JnJM5J1VVVVUvY6GqqqqqqqqqqrZqoaqqqqqqqqqqtmqhqrZOEpKQxHO2sY1tkpCEJFxFEpK4ShKSkITvKglJSMKmJCQhCW+zJCRBEpKQxNtMEpKQRBKSkIQ34fj4mOPjY46Pj\/noo4\/46KOPePLkCU+ePOHJkyfcu3ePe\/fuce\/ePTZJQhKSkIQkNiUhCUnYlIQkJCEJSXgRSUhCEvVix8fHHB8f88EHH\/DBBx\/wwQcfkIQkJOEySUhCEt60JCQhCS+ShCQk4SqSkMSrso1tbGMb29jmMnNO5pzMOZlzMudkzsllkpCEJFTV22+1WrFarVitVrxIEpKQhKqqf2ehqqqqqqqqqqq2aqGqtkISkpDEpvV6zXq9ZpMkJCGJVyUJSUhiWyQhCUm8zSQhiSQkIQlvsyQkIQmSkIQkXiQJSUjCq7p\/\/z7379\/n\/v37PHz4kIcPH3Ljxg1u3LjBjRs3ePDgAQ8ePODBgwdsSkISkpCEJGyShCQkcRlJSEISL5KEJCTh7OyMs7Mzzs7OODo64ujoiKOjIyQhCUlc5vj4mOPjY46Pj9mUhCQk4VVIQhKS+D4dHx9zfHzM8fExn3\/+OZ9\/\/jnvIklIQhJvmm1sYxvb2OYqc07mnMw5mXMy50QSkpDE90kSkpBEVb0ekpCEJKqq\/p2FqqqqqqqqqqraqoWqqqqqqqqqqtqqhap6bSQhCUlsso1tbJOEJFR9V5KQhCQ2SUISVzk9PeX09JTT01N+\/vOf8\/Of\/5yf\/\/znPHfr1i1u3brFrVu3+PLLL\/nyyy\/58ssv+eqrr\/jqq6\/46quveE4SkpDEVcYYjDEYYzDGYIzBGIMxBmMMxhiMMRhjMMZgjMEYg9PTU05PTzk9PeX09JTT01OOj485Pj7m+PiY3\/\/+9\/z+97\/n97\/\/PUlIQhKeOzg44ODggIODAz7\/\/HM+\/\/xzPv\/8cw4ODjg4OODg4IBf\/vKX\/PKXv+SXv\/wlYwzGGIwxGGMwxmB\/f5\/9\/X329\/c5Pj7m+PiY4+NjPvzwQz788ENWqxWr1YrVasXt27e5ffs2t2\/f5ioHBwccHBwwxmCMwRiDq9y+fZvbt2\/zm9\/8ht\/85jf85je\/YYzBGIMxBklIQhIePHjAgwcPePDgAc+NMRhjMMbg2rVrXLt2jWvXrnF6esrp6Smnp6c8JwlJSOLg4ICDgwMODg74xS9+wS9+8Qt+8YtfMMZgjMEYgzEGYwy++OILvvjiC7744gu+DUlI4l1hG9vYxja2sc1l5pzMOZlzMudkzsmck21JQhKSsCkJSUhCEpJQVVVVb8ZCVVVVVVVVVVVt1UJVVVVVVVVVVW3VQlV9Z5KQRNXbIAlJuMqDBw948OABDx484LPPPuOzzz7js88+47k7d+5w584d7ty5w6bj42OOj485Pj7mZdy5c4c7d+5w584dbGMb29jGNnfu3OHOnTvcuXOH3\/3ud\/zud7\/jd7\/7HTdv3uTmzZt88sknfPLJJ3zyySccHh5yeHjI4eEhL3J4eMjh4SGHh4ds+uMf\/8gf\/\/hH\/vjHP\/Lo0SMePXrEo0ePsI1t\/v73v\/P3v\/+dv\/\/973z55Zd8+eWXfPnll9y6dYtbt25x69Ytvv76a77++mv++c9\/8s9\/\/pN\/\/vOf3L9\/n\/v373P\/\/n2ucnh4yOHhId\/Gf\/7nf\/Kf\/\/mf\/OlPf+JPf\/oTf\/rTn9i0LAvLsrAsCycnJ5ycnHBycsJztrGNbWxjG9vcvHmTmzdvcor3mDoAACAASURBVPPmTZ5LQhKScOfOHe7cucOdO3d49OgRjx494tGjR9jGNrb57\/\/+b\/77v\/+b4+Njjo+POT4+ZpMkJCGJTUlIwrvONraxjW1sYxvb2GbTnJM5J3NO5pzMOZlzMudkzokkJCGJlyEJSUhCEpKQhCQkIQlJSGJTEpKQhKqqqnq9FqqqqqqqqqqqaqsWqqqqqqqqqqpqqxaq6pVIQhKSuIxtbGObJCQhCVXfh7OzM87Ozjg7O+Px48c8fvyYx48fc3Z2xtnZGWdnZ5yennJ6esrjx495\/Pgxjx8\/5pNPPuGTTz7hk08+4d69e9y7d4979+5xdnbG2dkZ38bh4SGHh4ccHh7y3IMHD3jw4AEPHjzgq6++4quvvuKrr77iD3\/4A3\/4wx\/4wx\/+wHNJSEISXodnz57x7Nkznj17xmV++tOf8tOf\/pSf\/vSnbLp+\/TrXr1\/n+vXrPPeTn\/yEn\/zkJ\/zkJz\/hTUtCEpJwGUlIQhIv4\/r161y\/fp3r16+zSRKSkMRHH33ERx99RBKSkIRNSUhCEn7sJCGJTbaxjW1sYxvbXGZ3d5fd3V12d3eZczLnZM7Jy0hCEpKQhCQk4TKSkIQkqqqq6vVaqKqqqqqqqqqqrVqoqm9NEpKQxGVsYxvbbJKEJCRR9X04Pj7m+PiY4+NjNh0dHXF0dMTR0RFHR0ccHR1xdHTE0dERR0dHfPPNN3zzzTd88803bDo+Pub4+JhvQxKSkMTZ2RlnZ2ccHBxwcHDAwcEBf\/7zn\/nzn\/\/Mn\/\/8Z94ESUhCEm8DSUhCEq9TEpKQhNchCUlIQv0fkpCEJJKQhCRsSkISJCEJSVzFNraxjW1sc5U5J3NO5pzMOZlzMudEEpJ43SQhCUlUFSQhCUmoqvq2FqqqqqqqqqqqaqsWqqqqqqqqqqpqqxaq6juzjW02SUISkqj6vp2ennJ6esrp6SkPHz7k4cOHPHz4kIcPH\/Lw4UMePnzIyckJJycnnJyccHJywsnJCY8ePeLRo0c8evSIDz74gA8++IAPPviA4+Njjo+P+TaSkIQk3L59m9u3b3N4eMjh4SGHh4fcuHGDGzducOPGDTadnZ1xdnbGuy4JSUjC2ywJSUjCq5KEJN4VSUhCEiQhCUlcJglJSIIkJCGJF7GNbWxjG9vY5iq7u7vs7u4y52TOyZyT1yEJSUhC1btqtVqxWq1YrVa8iCQkIYlNSUhCEqqq\/reFqqqqqqqqqqraqoWqqqqqqqqqqtqqhar6tyQhCUlsso1tbHOZJCQhCVXfh4ODAw4ODjg4OODWrVvcunWLW7ducf36da5fv87169dJQhKS8CKHh4ccHh5yeHjIN998wzfffMPBwQEHBwccHBxwlS+++IIvvviCL774go8\/\/piPP\/6YTz\/9lE8\/\/ZRPP\/2UqxwfH3N8fEwSkpCEq5yfn3N+fs75+Tkvcn5+zvn5Oefn57yM8\/Nzzs\/POT8\/50XOz885Pz\/n\/Pycy7z\/\/vu8\/\/77vP\/++xwdHXF0dMTR0RGbzs\/POT8\/5+joiKOjI46OjngZp6ennJ6ecnp6yqazszPOzs44OzvjMufn55yfn3N+fs4mSUhCEpc5Pz\/n\/Pyc8\/NzrvLs2TOePXvGj10SkpCEV2Ub29jGNraxzWXmnMw5mXMy52TOyZyTy0hCEpKo+rFJQhKS8KokIQlJVFX9bwtVVVVVVVVVVbVVC1VVVVVVVVVVtVULVfUvJCEJSWyyjW1s811JQhKSuIokJCGJqn9HEpKQxBiDMQZ3797l7t273L17l4ODAw4ODjg4OOBVff7553z++ed8\/vnnvP\/++7z\/\/vvcvXuXu3fvcvfuXcYYjDEYY\/DgwQMePHjAgwcPuHfvHvfu3ePevXscHR1xdHTEGIMxBmMMxhiMMRhjMMZgjMEYg6+++oqvvvqKX\/\/61\/z617\/m17\/+NT\/72c\/42c9+xs9+9jM27ezssLOzw87ODqenp5yenjLGYIzBGINNOzs77OzssLOzw\/7+Pvv7++zv73NwcMDBwQFjDMYYjDHYtLOzw87ODjs7O5yennJ6esoYgzEGYww27ezssLOzw87ODvv7++zv77O\/v89zh4eHHB4ecnh4yN27d7l79y53795ljMEYgzEGt2\/f5vbt23z00Ud89NFHfPTRR7z\/\/vu8\/\/77vP\/++xwcHHBwcMDBwQGbPv30Uz799FN+9atf8atf\/Ypf\/epX7O\/vs7+\/z\/7+Ppv29\/fZ399n087ODjs7O+zs7LC\/v8\/+\/j77+\/v89a9\/5a9\/\/St\/\/etfGWMwxmDTzs4OOzs77OzscHp6yunpKaenp2yShCTeRUlIQhI2SUISb4ptbGMb29jGNraxzaY5J3NO5pzMOZlzsru7y+7uLru7u1T92EhCEpKoqtqGhaqqqqqqqqqq2qqFqqqqqqqqqqraqoWq+v9IQhKbbGMb27xOSUhCEq6ShCQkoerfSUISkmAb29jGNra5uLjg4uKCi4sLXtXTp095+vQpT58+5enTpzx9+hTb2MY2trGNbT799FM+\/fRTPv30U2xjG9vYxja2sY1tbGMb29jGNrY5OTnh5OSEk5MTTk5OODk54W9\/+xt\/+9vf+Nvf\/oZtbGMb29jGNjdv3uTmzZvYxja2sY1tbGMb29jm5OSEk5MTTk5OODw85PDwENvYxja2sY1tbGMb29y8eZObN29iG9vYxja2sY1tbGObk5MTTk5OODk54bnPPvuMzz77jM8++4ynT5\/y9OlTnj59im1sY5uHDx\/y8OFDPv74Yz7++GM+\/vhjvv76a77++mu+\/vprDg8POTw85PDwkE3\/9V\/\/xX\/9139hG9vY5uTkhJOTE05OTrhx4wY3btzgxo0bnJyccHJygm1sYxvb2MY2JycnnJyccHJywscff8zHH3\/Mxx9\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\/Xee+\/x3nvv8d5771FV9S5YqKqqqqqqqqqqrVqod1ISkpCEVyEJSUjiKraxjW2eS0ISklBVVVX1Y5CEJCThXWcb29jGNraxjW1ss2nOyZyTOSdzTuac7O3tsbe3x97eHleRhCQkIQlJVFW9CxaqqqqqqqqqqmqrFqqqqqqqqqqqaqsW6p0kCUlI4nWyjW1sU1VVVVW1yTa2sY1tbLMpCUlIwlXee+893nvvPaqq3jULVVVVVVVVVVW1VQtVVVVVVVVVVbVVC1UbJCGJTbaxjW2qqqqqql6GbWxjG9vYxja2sY1tqqp+DBaqqqqqqqqqqmqrFqqqqqqqqqqqaqsW6p2RhCQk4WVIQhKSeM42trFNVVVVVdU2rVYrVqsVq9WKqqp31UJVVVVVVVVVVW3VQr0zJCEJSbyIJCQhiU22sU1VVVVV1TatVitWqxWr1Yqqqh+Dhaqqqqqqqqqq2qqFqqqqqqqqqqraqoX6wUlCEpLwMiQhCUlsso1tbFNVVVVVVVVVr99CVVVVVVVVVVVt1UJVVVVVVVVVVW3VQr11kpCEJFxGEpKQxLchCUlsso1tbFNVVVVV9SasVitWqxWr1Yqqqh+bhaqqqqqqqqqq2qqFqqqqqqqqqqraqoV660hCEpJ4VZKQhCReJAlJSEJVVVVV1auShCQk8dxqtWK1WrFarXgZSUhCEqqq3gULVVVVVVVVVVW1VQtVVVVVVVVVVbVVC\/XOkP6f9uDm6KoDUbJo5hncfYaSC58LwgTKBPAAZEJJFihkArggEyrkQWECMgGmV6Ps6IEieP2g+REXEOy1mrZpm9e5Xq+5Xq+5Xq95Vdu0TdtIkiRJH2pbtmVbgAD5UG3TNm0jSV+DI5IkSZIkSbqpI\/pHa5u2aZs3uV6vuV6vkSRJkm5pW7ZlW95mW7ZlWyTpW3BEkiRJkiRJN3VEkiRJkiRJN3VEX6U\/\/\/wzf\/75Z\/78889IkiRJr7Mt27ItH8N5njnPM+d55m3apm3aRpK+BUckSZIkSZJ0U0ckSZIkSZJ0U0f0wbZlW7blUzqOI8dx5DiOvOp6veZ6veZ6vWZbtmVbJEmSpNdpm7Zpmw8FBAgQSdKbHZEkSZIkSdJNHZEkSZIkSdJNHdEHa5u2aZtPoW3aZlu2ZVuu12uu12uu12skSZKkTwEIECCSpHdzRJIkSZIkSTd1RF+0tmmbtvnL9XrN9XrN9XqNJEmSJEn68h2RJEmSJEnSTR2RJEmSJEnSTR3RF6dt2qZtXnW9XnO9XvO+2qZtJEmSpL8DCBBJ0vs7IkmSJEmSpJs6IkmSJEmSpJs6oi9C27RN27zqer3mer3mer3mQ23LtkiSJEn\/V9u0zbsAAgTIx7Qt27Itr7Mt27ItkvQ1OCJJkiRJkqSbOiJJkiRJkqSbOqIPti3bsi0fom3apm1edb1ec71ec71eI0mSpG9T27RN23xqQIAAuZW2aZu2eZ22aZu2kaSvwRFJkiRJkiTd1BFJkiRJkiTd1BF9sLZpm7Z5H23TNm+yLduyLR9qW7ZlWyRJkvTPsy3bsi3vo23apm3eZFu2ZVu2ZVuAAAEiSfr4jkiSJEmSJOmmjnwDtmVbvmTX6zXX6zXX6zVt0zZt86Hapm3aRpIkSV+PbdmWbXmdbdmWbXmb8zxznmfO84wk6baOSJIkSZIk6aaOSJIkSZIk6aaOfAPapm0+tm3Zlm15H9uyLduyLdsCBAgQSZIk6U3apm3a5n1sy7ZsCxAgkqRP54gkSZIkSZJu6ogkSZIkSZJu6og+WNu0Tdt8TECAAHmbbdmWbZEkSZLe5DzPnOeZ8zzzPrZlW7ZFkvThjkiSJEmSJOmmjkiSJEmSJOmmjuiDbcu2bMutAAECBAiQV7VN27SNJEmSvk5t0zZt8z6AAAHyodqmbdpGkvThjkiSJEmSJOmmjnwDtmVb3sW\/\/vWv\/Otf\/0rbtE3btE3btE3btE3b\/P777\/n999\/z+++\/5y9t0zZt0zZt0zZt0zZt83cBAQLkVW3TNm0jSZKkr8e2bMu2vA0QIEBuZVu2ZVskSe\/miCRJkiRJkm7qiCRJkiRJkm7qyDegbdrmXfznP\/\/Jf\/7znzx8+DAPHz7Mw4cP86rnz5\/n+fPnef78ee7fv5\/79+\/n\/v37+cuLFy\/y4sWLvHjxIg8ePMiDBw\/y4MGDvHjxIi9evMiLFy\/yPrZlW7ZlW7blVUCAANmWbdkWSZIkfTuAAAHyKbRN27TNtmzLtkiS3uyIJEmSJEmSbuqIJEmSJEmSbuqIXuuXX37JL7\/8kl9++SWvevr0aZ4+fZqnT59mW7ZlW\/7y008\/5aeffspPP\/2Ux48f5\/Hjx3n8+HG+\/\/77fP\/99\/n+++\/zPtqmbdqmbdrmTYAAAQIECJCPaVu2ZVskSZL0aWzLtmzLq4AA+Zzapm3aRpL0ZkckSZIkSZJ0U0ckSZIkSZJ0U0f0P2zLttzd3eXu7i53d3d59OhRHj16lEePHuXp06d5+vRpnj59mrZpm7Z5+fJlXr58mWfPnuXZs2d59uxZ7t+\/n\/v37+f+\/fv5nIAA+Rjapm3aRpIkSZ\/GeZ45zzPneQYIECB\/2ZZt2RZJ0pfpiCRJkiRJkm7qiCRJkiRJkm7qyFeqbdqmbdqmbdqmbdqmbdqmbV7VNm3zqocPH+bhw4d5+PBhXr58mZcvX+bly5d5+vRpnj59mqdPn+a3337Lb7\/9lgcPHuTBgwd58OBBvjRAgAABAgSIJEmSvjxAgAB5m7Zpm7aRJH2ZjkiSJEmSJOmmjnyltmVbtmVbtmVbtmVbtmVbtuVt7t+\/n\/v37+f+\/fv54Ycf8sMPP+SHH37I06dP8\/Tp0zx9+jS\/\/fZbfvvtt\/z444\/58ccf8+OPP+afAggQIH9X27RN23yotmmbtpEkSfoWtE3btA0QIJKkr8sRSZIkSZIk3dQRSZIkSZIk3dQRvZfHjx\/n8ePHefz4cZ49e5Znz57l2bNnubu7y93dXb777rt89913+e677\/KqbdmWbfmSAQHyqrZpm7Z5Vdu0Tdv8ZVu2ZVvepG3a5k22ZVu2RZIk6WsFBAiQy+WSy+WSy+USSdLX6YgkSZIkSZJu6ogkSZIkSZJu6ojey+PHj\/P48eM8fvw4d3d3ubu7y93dXR4\/fpzHjx\/nawEECJDL5ZLL5ZLL5ZJXbcu2bMv72JZtkSRJ+tYAAQJEkvRtOSJJkiRJkqSbOiJJkiRJkqSbOvKF2JZt2ZZb2ZZt2ZYP9ccff+SPP\/7IH3\/8kbu7u9zd3eXu7i4\/\/PBDfvjhh7xJ27RN2\/yTAQECBAgQIJIkSXo9IECASJK+XUckSZIkSZJ0U0ckSZIkSZJ0U0e+EG3TNm1zK23TNm3zJv\/+97\/z73\/\/Oz\/\/\/HN+\/vnn\/Pzzz3n58mVevnyZly9f5tdff82vv\/6aX3\/9NU+ePMmTJ0\/y5MmTfIu2ZVu2BQgQIECASJIkfcuAAJEk6f86IkmSJEmSpJs6ov\/h999\/z++\/\/54nT57kyZMnefLkSe7du5d79+7l3r17efToUR49epRHjx7l7u4ud3d3ubu7y7eobdqmbV4HCBAg27It2\/I+2qZt2kaSJH0btmVbPoZt2ZZteZtt2ZZteVXbtE3bvA4QIECAAAEiSdKrjkiSJEmSJOmmjkiSJEmSJOmmjuh\/+O9\/\/5v\/\/ve\/efHiRV68eJEXL17k+fPnef78eZ4\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\/HtmzLtujjapu2aZu2aRtJkqR\/siOSJEmSJEm6qSOSJEmSJEm6qSOSpM+qbdqmbd5H27RN2+jzaJu2aZsvzbZsy7ZIkiTp8zsiSZIkSZKkmzoiSZIkSZKkmzoiSdInti3bsi3bsi3bsi3bsi2SJEnS1+SIJEmSJEmSbuqIJEmfWNu0Tdu0Tdu0Tdu0Tdvo72mbtmkbSZIkfX5HJEmSJEmSdFNHJEmSJEmSdFNHJEmSJEmSdFNHJEmSJEmSdFNHJEmSJEmSdFNHJEmSJEmSdFNHJEmSJEmSdFNHJEmSJEmSdFNHJEmSJEmSdFNHJEmSJEmSdFNHJEmSJEmSdFNHJEmSJEmSdFNHJEmSJEmSdFNHJEmSJEmSdFNHJEmSJEmSdFNHJEmSJEmSdFP\/B5gP8s8DYLEaAAAAAElFTkSuQmCC","width":246}
%---
%[control:slider:819a]
%   data: {"defaultValue":-10,"label":"Slider","max":90,"min":-90,"run":"Section","runOn":"ValueChanging","step":10}
%---
%[control:slider:3ad3]
%   data: {"defaultValue":50,"label":"az","max":180,"min":0,"run":"Section","runOn":"ValueChanging","step":10}
%---
