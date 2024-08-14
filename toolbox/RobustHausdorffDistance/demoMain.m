%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author : Baraka Maiseli
% Contact: barakamaiseli@yahoo.com
% Date   : 15th March, 2017
% Version: 1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Determine where your m-file's folder is.
folder = fileparts(which(mfilename)); 
% % Add that folder plus all subfolders to the path.
addpath(genpath(folder));

h = waitbar(0,'Please wait shortly...');

method = 'euclidean';
%%%%%%%%%%%%%%%%%%%%%%%% Original Fish datasets %%%%%%%%%%%%%%%%%%%%%%%%%%%
load('A_Fish_original.mat');
load('B_Fish_original.mat');

K11 = 3.00;
[ hdFish1 ] = computeHD( A, B, method); % Original Hausdorff distance
[ rhdFish1 ] = robustHD( A, B, K11, method); % Robust Hausdorff distance
% [ mhdFish1 ] = ModHausdorffDist( A, B ); % Modified Hausdorff distance by Dubuisson and Jain
                                           % Uncomment to test MHD, but the computational time becomes high 

figure(1);
subplot(221);
scatter(A(:,1),A(:,2),'b'); hold on;
scatter(B(:,1),B(:,2),'r'); hold off;
box on;
legend('Point set A','Point set B','Location','NorthWest');
ylabel('Y-Axis');
xlabel('X-Axis');
title('Fig 2(a): Fish');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% Fish datasets with outliers %%%%%%%%%%%%%%%%%%%%%%%%
K12 = 3.00; % Gives rhdFish = 2.0279. (Best option for outliers)
load('A_Fish_outlier.mat');
load('B_Fish_outlier.mat');
[ hdFish2 ] = computeHD( A, B, method); % Original Hausdorff distance
[ rhdFish2 ] = robustHD( A, B, K12, method); % Modified Hausdorff distance
% [ mhdFish2 ] = ModHausdorffDist( A, B ); % Modified Hausdorff distance (MHD) by Dubuisson and Jain
                                           % Uncomment to test MHD, but the computational time becomes high 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%% Original Chinese characters datasets %%%%%%%%%%%%%%%%%%%
load('A_Chinese_original.mat');
load('B_Chinese_original.mat');

K21 = 55; % K2 = 3 gives rhdChinese = 1.9699
[ hdChinese1 ] = computeHD( A, B, method); % Original Hausdorff distance
[ rhdChinese1 ] = robustHD( A, B, K21, method);% Modified Hausdorff distance
% [ mhdChinese1 ] = ModHausdorffDist( A, B ); % Modified Hausdorff distance (MHD) by Dubuisson and Jain
                                              % Uncomment to test MHD, but the computational time becomes high 

subplot(222);
scatter(A(:,1),A(:,2),'b'); hold on;
scatter(B(:,1),B(:,2),'r'); hold off;
box on;
legend('Point set A','Point set B','Location','NorthWest');
ylabel('Y-Axis');
xlabel('X-Axis');
title('Fig 2(b): Chinese characters');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%% Chinese characters with outliers %%%%%%%%%%%%%%%%%%%%%%%
% K22 = 3; % Gives rhdChinese = 2.4039.
K22 = 2.5; % Gives rhdChinese = 2.0024. (Best option for outliers)
load('A_Chinese_outlier.mat');
load('B_Chinese_outlier.mat');

[ hdChinese2 ] = computeHD( A, B, method); % Original Hausdorff distance
[ rhdChinese2 ] = robustHD( A, B, K22, method);% Robust Hausdorff distance
% [ mhdChinese2 ] = ModHausdorffDist( A, B ); % Modified Hausdorff distance (MHD) by Dubuisson and Jain
                                              % Uncomment to test MHD, but the computational time becomes high 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% Original Elephant %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% K3 = 3 gives rhdElephant = 6.4851.
K31 = 37; % gives rhdElephant = 6.4974.
load('A_Elephant_original.mat');
load('B_Elephant_original.mat');

[ hdElephant1 ] = computeHD( A, B, method); % Original Hausdorff distance
[ rhdElephant1 ] = robustHD( A, B, K31, method);% Robust Hausdorff distance
% [ mhdElephant1 ] = ModHausdorffDist( A, B ); % Modified Hausdorff distance (MHD) by Dubuisson and Jain
                                               % Uncomment to test MHD, but the computational time becomes high 

subplot(223);
scatter(A(:,1),A(:,2),'b'); hold on;
scatter(B(:,1),B(:,2),'r'); hold off;
box on;
legend('Point set A','Point set B','Location','NorthEast');
ylabel('Y-Axis');
xlabel('X-Axis');
title('Fig 2(c): Elephants');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% Elephant with outliers %%%%%%%%%%%%%%%%%%%%%%%%%%
load('A_Elephant_outlier.mat');
load('B_Elephant_outlier.mat');

K32 = 8.20; % K3 = 3 gives rhdElephant = 6.4851.
[ hdElephant2 ] = computeHD( A, B, method); % Original Hausdorff distance
[ rhdElephant2 ] = robustHD( A, B, K32, method);% Modified Hausdorff distance
% [ mhdElephant2 ] = ModHausdorffDist( A, B ); % Modified Hausdorff distance (MHD) by Dubuisson and Jain
                                               % Uncomment to test MHD, but the computational time becomes high 
                                               
subplot(224);
scatter(A(:,1),A(:,2),'b'); hold on;
scatter(B(:,1),B(:,2),'r'); hold off;
box on;
legend('Point set A','Point set B','Location','NorthEast');
ylabel('Y-Axis');
xlabel('X-Axis');
title('Fig 2(d): Elephants');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
waitbar(1/ 3);
%%%%%%%%%%%%%%%%%%%%%%%%%%% Original Butterfly %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% K5 = 3; % Gives rhdButterfly = 32.0786
K51 = 59; % Gives rhdButterfly = 32.1056
load('A_Butterfly_original.mat');
load('B_Butterfly_original.mat');

[ hdButterfly1 ] = computeHD( A, B, method); % Original Hausdorff distance
[ rhdButterfly1 ] = robustHD( A, B, K51, method);% Robust Hausdorff distance
% [ mhdButterfly1 ] = ModHausdorffDist( A, B ); % Modified Hausdorff distance (MHD) by Dubuisson and Jain
                                                % Uncomment to test MHD, but the computational time becomes high 
                                               
figure(2);
subplot(221);
scatter(A(:,1),A(:,2),'b'); hold on;
scatter(B(:,1),B(:,2),'r'); hold off;
box on;
legend('Point set A','Point set B','Location','NorthWest');
ylabel('Y-Axis');
xlabel('X-Axis');
title('Fig 3(a): Butterflies');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Bird with outliers %%%%%%%%%%%%%%%%%%%%%%%%%%%
load('A_Butterfly_outlier.mat');
load('B_Butterfly_outlier.mat');

K52 = 46.00; % K5 = 3 gives rhdButterfly = 31.2055.
[ hdButterfly2 ] = computeHD( A, B, method); % Original Hausdorff distance
[ rhdButterfly2 ] = robustHD( A, B, K52, method);% Modified Hausdorff distance
% [ mhdButterfly2 ] = ModHausdorffDist( A, B ); % Modified Hausdorff distance (MHD) by Dubuisson and Jain
                                                % Uncomment to test MHD, but the computational time becomes high 

subplot(222);
scatter(A(:,1),A(:,2),'b'); hold on;
scatter(B(:,1),B(:,2),'r'); hold off;
box on;
legend('Point set A','Point set B','Location','NorthWest');
ylabel('Y-Axis');
xlabel('X-Axis');
title('Fig 3(b): Butterflies');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Original Bird %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('A_Bird_original.mat');
load('B_Bird_original.mat');

K41 = 46; % Gives rhdBird = 35.1459
% K4 = 3;  % Gives rhdBird = 35.1034
[ hdBird1 ] = computeHD( A, B, method); % Original Hausdorff distance
[ rhdBird1 ] = robustHD( A, B, K41, method);% Modified Hausdorff distance
% [ mhdBird1 ] = ModHausdorffDist( A, B ); % Modified Hausdorff distance (MHD) by Dubuisson and Jain
                                           % Uncomment to test MHD, but the computational time becomes high 
                                           
subplot(223);
scatter(A(:,1),A(:,2),'b'); hold on;
scatter(B(:,1),B(:,2),'r'); hold off;
box on;
legend('Point set A','Point set B','Location','NorthWest');
ylabel('Y-Axis');
xlabel('X-Axis');
title('Fig 3(c): Birds');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Bird with outliers %%%%%%%%%%%%%%%%%%%%%%%%%%%
load('A_Bird_outlier.mat');
load('B_Bird_outlier.mat');

K42 = 53.00;
[ hdBird2 ] = computeHD( A, B, method); % Original Hausdorff distance
[ rhdBird2 ] = robustHD( A, B, K42, method);% Modified Hausdorff distance
% [ mhdBird2 ] = ModHausdorffDist( A, B ); % Modified Hausdorff distance (MHD) by Dubuisson and Jain
                                           % Uncomment to test MHD, but the computational time becomes high 
subplot(224);
scatter(A(:,1),A(:,2),'b'); hold on;
scatter(B(:,1),B(:,2),'r'); hold off;
box on;
legend('Point set A','Point set B','Location','NorthWest');
ylabel('Y-Axis');
xlabel('X-Axis');
title('Fig 3(d): Birds');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
waitbar(2/ 3);
%%%%%%%%%%%%%%%%%%%% Butterfly with outliers and noise %%%%%%%%%%%%%%%%%%%%
load('A_Butterfly_outlier_noise.mat');
load('B_Butterfly_outlier_noise.mat');

K6 = 2.90; % K5 = 3 gives rhdButterfly = 31.2055.
[ hdButterfly3 ] = computeHD( A, B, method); % Original Hausdorff distance
[ rhdButterfly3 ] = robustHD( A, B, K6, method);% Modified Hausdorff distance
%[ mhdButterfly3 ] = ModHausdorffDist( A, B ); % Modified Hausdorff distance (MHD) by Dubuisson and Jain
                                               % Uncomment to test MHD, but the computational time becomes high 
                                               
figure(3);
scatter(A(:,1),A(:,2),'b'); hold on;
scatter(B(:,1),B(:,2),'r'); hold off;
box on;
legend('Point set A','Point set B','Location','NorthWest');
ylabel('Y-Axis');
xlabel('X-Axis');
title('Fig 4: Buttetrflies with noise + outliers');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
waitbar(3/ 3);
close(h)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Summary %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Scenes without outliers %%%%%%%%%%%%%%%%%%%%%%%%%%%
rows = 6; cols = 7;
resultsTable3 = cell(rows,cols);
resultsTable3{1,2} = 'No Outliers';
resultsTable3{2,1} = 'Scene';
resultsTable3{2,2} = 'HD';
resultsTable3{2,3} = 'RHD';

resultsTable3{3,1} = 'Fish';
resultsTable3{3,2} = hdFish1;
resultsTable3{3,3} = rhdFish1;

resultsTable3{4,1} = 'Chinese character';
resultsTable3{4,2} = hdChinese1;
resultsTable3{4,3} = rhdChinese1;

resultsTable3{5,1} = 'Elephant';
resultsTable3{5,2} = hdElephant1;
resultsTable3{5,3} = rhdElephant1;

resultsTable3{6,1} = 'Butterfly';
resultsTable3{6,2} = hdButterfly1;
resultsTable3{6,3} = rhdButterfly1;

resultsTable3{7,1} = 'Bird';
resultsTable3{7,2} = hdBird1;
resultsTable3{7,3} = rhdBird1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% Scenes with outliers %%%%%%%%%%%%%%%%%%%%%%%%%%%%
resultsTable3{1,4} = 'Outliers';
resultsTable3{2,4} = 'HD';
resultsTable3{2,5} = 'RHD';

resultsTable3{3,4} = hdFish2;
resultsTable3{3,5} = rhdFish2;

resultsTable3{4,4} = hdChinese2;
resultsTable3{4,5} = rhdChinese2;

resultsTable3{5,4} = hdElephant2;
resultsTable3{5,5} = rhdElephant2;

resultsTable3{6,4} = hdButterfly2;
resultsTable3{6,5} = rhdButterfly2;

resultsTable3{7,4} = hdBird2;
resultsTable3{7,5} = rhdBird2;

resultsTable3{1,6} = 'Outliers & Noise';
resultsTable3{2,6} = 'HD';
resultsTable3{2,7} = 'RHD';

resultsTable3{6,6} = hdButterfly3;
resultsTable3{6,7} = rhdButterfly3;

save('resultsTable3.mat','resultsTable3');
disp('Results of HD and RHD are stored in a variable resultsTable3.mat');
