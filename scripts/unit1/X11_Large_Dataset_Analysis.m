%[text] %[text:anchor:H_D9F37BFE] # Analyzing Large Datasets
%[text] In this exercise, we load a subset of a classic dataset collected in 1886 by Francis Galton. Galton was the originator of using Genetic Methods to test Human behavior. Interested in correlation between Parent's heights and the heights of their children, he collected the heights from 934 adult children and their parents in 205 families. This was one of the first studies to rigorously compare the heights of children to their parents. He was also interested in the question of whether there was a correlation between the husbands and wives (assortative mating).
%[text]  MATLAB Skills Covered
%[text] - Creating File paths
%[text] - Programming loading CSV files as MATLAB table data
%[text] - Tidy Data \
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] 
%%
%[text] %[text:anchor:H_6822A2FD] ## Reset MATLAB
close all
clearvars
clc
%%
%[text] %[text:anchor:H_60485269] ## Load the Table Programmatically
%[text] %[text:anchor:H_91D1D70B] ### Get file path
%[text] First we need the file path to the data file. Remember, a file path is just a character array that MATLAB can read to find files.
%[text] Here, we use a live script Control, called File Browser, to help us create the file path. Click on the yellow icon to bring up a file browser and select the 05-1-Galton-x.csv file on your computer
filename = "/Users/ernesto/MATLAB-Drive/MtMdata/unit1/05-1-galton-x.csv" %[control:filebrowser:40ef]{"position":[12,73]}
%[text] - Remember: WE HAVEN'T OPENED THE FILE
%[text] - We just created the file path so MATLAB can find the file
%[text] - Examine the contents of filename — do they make sense to you? Can you understand how the file location is being stored
%[text] - What class is filename? \
%%
%[text] %[text:anchor:H_C1339E0E] ### Load the data
%[text] The function [getGaltonData](internal:M_8bd5) is a local function that loads the spreadsheet data into a table variable. Its input is a file path. 
T = getGaltonData(filename)
%[text] %[text:anchor:H_CD93CD6C] ### Review Data 
%[text] The [data is tidy ](https://salcedoe.github.io/MtMdocs/dataWrangling/tidyData/)and there are Five Columns (Variables) in the table
%[text] -     Family - Family id (categorical data)
%[text] -     Father - Father's height in inches
%[text] -     Mother - Mother's height in inches
%[text] -     Sex - sex of child (categorical data)
%[text] -     Height - height of child (inches)
%[text] -     Kids - number of kids per family \
%[text] Each row is an observation. Notice how some data is repeated in this type of table.  For example, lines 1-4 are data from one family. There is one row per child, with data pertinent to each child. The rest of the data repeats: family ID, the father's and mother's height and the number of kids  per family. 
%[text] In this table, we have 2 grouping variables:
%[text] - Family
%[text] - Sex \
%[text] The rest are data variables
%%
%[text] %[text:anchor:H_0A945362] ## Data Analysis
%[text] The function **summary** summarizes the data in the table
summary(T)
%%
%[text] - There are a lot of categories for Family: one category per family \
categories(T.Family)
%[text] - 197 different families
%[text] - Hmm. Max number goes to 204 , but we only have 197 —Are we missing data? Something to check on \
%%
%[text] %[text:anchor:H_8A748267] ## Visualize the data
%[text] %[text:anchor:H_A3851106] ### Global Figure settings
mmSetFigPublication(14)
%%
%[text] %[text:anchor:H_880E4490] ### Distribution of Heights 
%[text] Is the height data Normal? One of the first things you should do when you load your data is to visualize its distribution by plotting a histogram. Here we use `histfit` to overlay the normal curve.
figure
nexttile
histfit(T.Height)
%[text] - The distribution looks almost bi-modal (two peaks)
%[text] - The data is not well fit by the normal line \
%[text] 
%%
%[text] %[text:anchor:H_23A42203] ### Overlaying Histograms
%[text] Recall that our data actually has two populations of heights: Males and Females. Also recall that people from different sexes have different height distributions (men tend to be taller than women). So if we plot all the heights together in one plot, the distribution should be bi-modal.
%[text] Instead, lets use the grouping variable Sex to separate the Male and Female Heights. 
figure
hold on % turn on plot overlay

la = T.Sex=="M"; % create logical index for the male rows
x = T.Height(la); % boys heights

histogram(x); % histogram of boys heights

x = T.Height(~la); % girls heights (NOT male)
histogram(x) % histogram of girls heights

xlabel("Height(in)",FontWeight="bold")
ylabel("Frequency",FontWeight="bold")

legend("Males","Females")
%[text] 
%[text] - Now we can clearly see that we have two normal distributions here: one for the girls and one for the boys \
%%
%[text] %[text:anchor:H_F0C549D1] ### Grouping Variables with Swarm and Box Charts
%[text] %[text:anchor:H_C80D781F] Another way to examine the distribution of your data is to plot a box plot swarm chart overlay, using the function **boxchart**  and the function **swarmchart.** Conveniently, you can include a grouping variable in these functions so there is no need to use hold. 
%[text] Here we plot the heights using Sex as a grouping variable
figure

x = T.Sex; % grouping variable
y = T.Height; % data variable

mmBoxSwarm(x,y,'BoxFaceColor','k','Notch','on','MarkerFaceAlpha',0.15)
ylabel('Height (in)')
%[text] - The shapes of these swarm charts also indicate that the data is normal
%[text] - The Medians in the box charts are in the center of the IQR, another indicator of normality \
%%
%[text] ### Testing for Significance
%[text] Are the Heights Significantly Different? You would expect so, since these are Male vs Female heights. But, how do we test this statistically?
%[text] #### Quick and Dirty Box Plot Method
%[text] - Notice that we turned 'Notch' on in the boxcharts \
%[text] ![](text:image:0346)
%[text] - Box charts whose notches do not overlap have different medians at the 5% significance level.
%[text] - So, the heights are statistically different based on the fact that the notches do not overlap
%[text] - But how different are they? \
%%
%[text] %[text:anchor:H_D157F2F1] ### Hypothesis testing
x = T.Height(T.Sex=="M"); % boys heights
y = T.Height(T.Sex=="F"); % female heights
%[text] Since our data are roughly Normal, we can use a t-test:
%[text] - **Null Hypothesis**:  Male and Female heights are the same
%[text] - **Alternate Hypothesis:** Male and Female heights are different \
%[text] %[text:anchor:H_1A9163D3] We perform a t-test using the function `ttest2` 
help ttest2
%%
[h,p,ci,stats] = ttest2(x,y)
%[text] - h=1 means we reject the null hypothesis
%[text] - Since P is less that 0.05, we reject the null hypothesis \
%%
%[text] Use APA style to report the results. 
%[text] - t-tests described [here](https://www.socscistatistics.com/tutorials/ttest/default.aspx). \
s = sprintf('Males were significantly taller than females, ');
s = sprintf('%s%1.2f ± %1.2f" vs %1.2f ± %1.2f" (M±SD), respectively,\n', s, mean(x), std(x),mean(y), std(y));
s = sprintf('%st(%d) = %1.2f, p < .0001.', s,stats.df, stats.tstat);
disp(s)
%%
%[text] %[text:anchor:H_8E2558DF] ### Regression and Correlation
%[text] Scatter plots are two-dimensional plots most often used to compare two variables to see if the variables correlate in any fashion. Here we plot Father's heights vs Son's heights. The Father's height should be on the x-axis, since its the independent variable. 
%[text] 
figure %[text:anchor:T_DBD01520]

la = T.Sex == "M";
x = T.Father(la);
y = T.Height(la);

% hs = scatter(t.Father,t.Height,"filled","MarkerFaceAlpha",0.25);
hs = scatter(x,y,"filled","MarkerFaceAlpha",0.25);


xlabel('Father''s Height (in)') % label the x-axis
ylabel("Son's Height (in)") % label the y-axis

xlim([60 80]) % set the x-limits
ylim([60 80]) % set the y-limits
%[text] - since everything is rounded to the nearest half-inch, there are a lot of dots that overlap
%[text] - Father's height is repeated often, since many fathers have more than one son, giving the scatter plot a columnar appearance \
%%
%[text] %[text:anchor:H_8C347263] #### Equality Line
%[text] Here we use plot to add a diagonal line that represents exact equality between son and father's heights. i.e. 60" father has a son of exactly 60"
hold on % need to hold to not overwrite the scatter plot
plot([60 80],[60 80],':k','DisplayName','Equality');              % 45 on default axis 
%%
%[text] %[text:anchor:H_FADC552B] ### Best Fit Line
%[text] Here we add a best fit line that represents the mean values between the fathers' and sons' heights. 
%[text] - We calculate the line the functions **polyfit** and **polyval**.  \
hold on

% calculate the regression line
p = polyfit(x,y,1); % returns slope and intercept
f = polyval(p,x); % calculate the y's from x using p
plot(x,f,'k-',"LineWidth",1,"DisplayName","Best Fit Line") % plot the regression line
%[text] - The dotted line is the line of equality — a perfect correlation of sons' and fathers' heights
%[text] - The solid line is the regression line — a "best-fit" line that show's the actual correlation between father's and son's heights
%[text] - The best-fit line suggests that Tall fathers have sons that are slightly shorter than them and vice versa \
%%
%[text] ### Calculate the correlation
%[text] The function `corr` calculates the correlation between data
father_son_c = corr(x,y);
title(sprintf('Father Son Height corr = %1.2f',father_son_c))
%[text] - A positive correlation means that the relationship between the two variables moves in the same direction (taller son -\> taller father)
%[text] - 0.39 means the heights are clearly correlated \
%%
%[text] %[text:anchor:H_A58AFB66] ## Tiled Plots
%[text] So how would we plot all permutations of the various parent-child correlations?
%[text] - e.g. Father-Son, Father-daughter, Mother-Son, Mother-daughter?
%[text] - Package the code into a Function, **plot\_height\_corr** \
%[text] 
figure
nexttile
plot_height_corr(T,"Father","M")
%%
%[text] %[text:anchor:H_191F7A04] ### Regression Function
%[text] I have packaged the scatter and regression plotting functions into a function called [plot\_height\_corr](internal:M_C6A13C97). Let's review that function now
%%
%[text] Now that we have a nice function, we can plot all 4 Comparisons. 
clf
nexttile
plot_height_corr(T,"Father","F")
%%
%[text] - Try plotting the other 3 comparisons \

%%
%[text] %[text:anchor:H_7805ACE2] ## Statistics
%[text] %[text:anchor:H_F91ED623] ### Group stats
%[text] Our data is normal, so let's calculate the mean and the standard deviation
S = groupsummary(T,"Sex",["mean" "std"],"Height")
%[text] - here are the heights of the children \
%%
%[text] Calculating the mean parent's height is a little trickier since the data for each parent is repeated multiple times. But, no matter, we can use **groupsummary** to get the mode of the parents' heights as follows
Sp = groupsummary(T,"Family","mode",["Father" "Mother"])
%[text] - now, we have just the one height per Father and Mother \
%%
%[text] We can now call **groupsummary** on Sp (since its a table). Here, though, we don't need a grouping variable. We just want to calculate the mean for all of the data in each column. So, we enter the empty brackets for the grouping variable, as follows: 
S2 = groupsummary(Sp,[],["mean" "std"],["mode_Father" "mode_Mother"])
%%
%[text] %[text:anchor:H_C793FB72] ### Visualize as bar plots
%%
%[text] %[text:anchor:H_2524D39F] #### Plot Children's mean height by Sex
%[text] Pull the data from the first groupsummary function call
figure
nexttile % create new tile
x = S.Sex; % grouping variable
y = S.mean_Height; % data variable
bar(x,y,FaceAlpha=0.5) % bar plot

hold on % overlay
e = S.std_Height; % get error
errorbar(x,y,e,'k',LineStyle="none") % errorbar
ylabel("Children's Heights") % label y axis
%%
%[text] %[text:anchor:H_080E5CB1] ### Plot Parent's height by sex
%[text] - we don't have a grouping variable, we have just have two columns in S2
%[text] - So, we use curly bracket indexing to pull out the values for y
%[text] - Then we use the grouping variable, x, from the previous plot \
nexttile %create second tile

y = S2{1,["mean_mode_Mother" "mean_mode_Father"]}; % curly bracket indexing pulls out mean data as a numeric vector
bar(x,y,FaceAlpha=0.5) % bar plot

hold on % overlay

e = S2{1,["std_mode_Mother" "std_mode_Father"]};  % curly bracket indexing pulls out std data as a numeric vector
errorbar(x,y,e,'k',LineStyle='none')
ylabel("Parents' Heights")
%%
%[text] %[text:anchor:H_87CA59DE] ### Calculating Multiple correlations
%[text] %[text:anchor:H_1724EEE1] ####  Manually
%[text] - One between the mother's height and her daughters' height
%[text] - One between the mother's height and her son's height \
%[text] Manually, we have to use the logical array that you created for the male columns 
la_sons = T.Sex == "M";
x = T.Mother(la_sons);
y = T.Height(la_sons);

mother_son_corr = corr(x,y)
x = T.Mother(~la_sons);
y = T.Height(~la_sons);

mother_daughter_corr = corr(x,y)
%%
%[text] %[text:anchor:H_6561A575] #### Using groupsummary
%[text] In some cases, you have to use the function handle, which is just basically an alias for the function. Function handles start with the ampersand followed by the name of the function. 
%[text] Consider the following function call
%[text] Enter a function handle as the stats function you want. The follow up with a cell array of column headers that you want to input into the function
groupsummary(T,"Sex",@corr,{"Father","Height"})
%%
%[text] Even cooler trick
groupsummary(T,"Sex",@corr,{["Mother","Father"], ["Height","Height"]})
%%
%[text] %[text:anchor:T_BE801CA7] # Local Functions
function plot_height_corr(T,parent,sex) %[text:anchor:M_C6A13C97]
% INPUTS
    % parent: "Father" or "Mother"
    % sex: "M" or "F"


% get property names
props = table(["F";"M"],["Daughter"; "Son"],["magenta"; "blue"], VariableNames=["sex","child","color"]); % property name table
child = props.child(props.sex==sex); % used in ylabel
color = props.color(props.sex==sex); % used to set color of scatter plot 

% get a smaller table with just selected rows
t = T(T.Sex==sex,:); 
x = t.(parent);
y = t.Height;

% scatter plot
scatter(x,y,color,"filled","MarkerFaceAlpha",0.25);

xlabel(sprintf("%s's Height (in)",parent)) % label the x-axis
ylabel(sprintf("%s's Height (in)",child)) % label the y-axis

xlim([50 80]) % set the x-limits
ylim([50 80]) % set the y-limits

% equality line
hold on % need to hold to not overwrite the scatter plot
plot([50 80],[50 80],':k','DisplayName','Equality');  

% regression line
p = polyfit(x,y,1); % returns slope and intercept
f = polyval(p,x); % calculate the y's from x using p
plot(x,f,'k-',"LineWidth",1,"DisplayName","Best Fit Line") % plot the regression line

% calculate the correlation
c = corr(x,y);
title(sprintf('corr = %1.2f',c))

end
%[text] import table
function T = getGaltonData(filename, dataLines) %[text:anchor:M_8bd5]
%GETGALTONDATA Import data from a csv file. Created using the MATLAB
%Import Tool
%  T = IMPORTFILE(FILENAME) reads data from text file FILENAME for the
%  default selection.  Returns the data as a table.
%
%  T = IMPORTFILE(FILE, DATALINES) reads data for the specified row
%  interval(s) of text file FILENAME. Specify DATALINES as a positive
%  scalar integer or a N-by-2 array of positive scalar integers for
%  dis-contiguous row intervals.
%
%  Example:
%  T = importfile("/Users/ernesto/MATLAB-Drive/ANAT6205/UNIT 1/data/05-1-galton-x.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 06-Sep-2023 19:15:23

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 6);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Family", "Father", "Mother", "Sex", "Height", "Kids"];
opts.VariableTypes = ["categorical", "double", "double", "categorical", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Family", "Sex"], "EmptyFieldRule", "auto");

% Import the data
T = readtable(filename, opts);

end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:filebrowser:40ef]
%   data: {"browserType":"File","defaultValue":"\"*.*\"","label":"Select galton file","run":"Section"}
%---
%[text:image:0346]
%   data: {"align":"baseline","height":250,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAh8AAAGsCAYAAAB968WXAACRe0lEQVR4Aey9h19UWbrvff+R9733nhve+znn3pNn5s6cmekwnXO33XayzWLOWUQwRzASzAFzxoQBFVQUMaBIzjnnnH\/v8ywsREQRrCp24W\/PlAVVu9Za+7tWs3\/1pPWfwIMESIAESIAESIAEnEjgPzmxL3ZFAiRAAiRAAiRAAqD44CIgARIgARIgARJwKgGKD6fiZmckQAIkQAIkQAIUH1wDJEACJEACJEACTiVA8eFU3OyMBEiABEiABEiA4oNrgARIgARIgARIwKkEKD6cipudkQAJkAAJkAAJUHxwDZAACZAACZAACTiVAMWHU3GzMxIgARIgARIgAYoPrgESIAESIAESIAGnEqD4cCpudkYCJEACJEACJEDxwTVAAiRAAiRAAiTgVAIUH07Fzc5IgARIgARIgAQoPrgGSIAESIAESIAEnEqA4sOpuNkZCZAACZAACZDAG4mPxsZG1NbWQp87H21tbWhqakJ9fT0aGhrMQ89pbW3tfBp\/JgESIAESIAESeAsJ9El8NDc3Iy8vDxEREbh8+TLCw8NRUFAAfV2PiooKPHz4EFeuXEFISIh51nNLS0uhwoQHCZAACZAACZDA20ug1+JDxUN0dDSWLFmCadOmdTy7u7sjLi4OLS0tuHPnjnnv66+\/xs8\/\/4zBgwdjzpw5ePTokXn\/7cXNKycBEiABEiABEui1+FA3y549e4y4uH37NlJTU43YmDhxIgIDA1FYWIijR49i4cKF5lkFR1RUFBISElBVVUXLB9ccCZAACZAACbzlBHotPqqrq3Hjxg1cunTJxHUoP3WzLFq0CBs2bDBiZPPmzVi1apURHCpWbO6YV7HWeBCNE9HYENtDrSh007yKGt8jARIgARIgAdcj0GvxoUJCBUhNTY25WhUHSUlJGDt2rLF85OfnGyHyww8\/QF0x6m5ZtmwZrl271iFWusOkMSIqWGbNmoWZM2fCy8vLxIvU1dV1dzpfIwESIAESIAEScFECvRYfXa8zOzsbK1euxIwZM0xMhwaVrlixwoiOAwcOYNeuXViwYIERFep+UWtGd4eeN2zYMGzbtg07duzA\/v37TXtdM2m6+yxfIwESIAESIAEScB0CfRYfKiI0jsPHx8dYKq5fv27SbtXNcv\/+ffOeDYNmw0yePNmIipdZMjZu3GgsJrbP8JkESIAESIAESGBgEuiT+FBrhFox1OKhrpVbt26ZWh6KSMWFul40uNR2xMfHY\/HixVi3bp1x2dhe7\/y8adMmE6T6MstI53P5MwmQAAmQAAmQgOsS6LX4sKXaqmtFBYWm3XYuHpabm2uyYUJDQzuoREZGGuvI7t27jXWk441OP1B8dILBH0mABEignwm01lahpTQfrXXV\/TyS57vX+01WVhYSExNNssPz7\/I3VyHQa\/FRVFSEtWvXQmt4bNmyxRQQU5dLWFgYYmNjkZKSgqVLlxoXimbF3L1715w3d+7cV9b5oPhwlSXDcZIACQxUAm1NjWjKSUbNvSuouLgXpUfXo+LSPtQn3EdLdblcdu+LRJaUlJiClMHBwbh48aJJPkiREg2vW++6srIcqSkZqKpsluxHSOJCoynjoK56vefoofelx48fIyMj47kvw+ZN\/mNJAr0WHzYXyqBBg0wBsV9\/\/RX6GD58OPz8\/JCZmYkHDx7A09MT06dPh4qO+fPnm8wVLbX+soPi42Vk+DoJkAAJOJ5AW3MD6uLuomDjVGRM\/RtylgxB7rKhyJr3FXJXDEfltSNoqSwW\/fF6AkTPUhe81oX68aef8Je\/\/hXvyOP999\/HXLknxKWlormtZwkSFXVbMiY3iLhoz7BsFvFx8OBB48Z\/8uSJAaMVtLXw5YkTJ16ZVel4iuzhdQn0WnxoLY7KykpTKl0VbXFxsXnozxrnoTEb+tCfy8rKzEPrgOjnXnVQfLyKDt8jARIgAUcSaENDegzy109C1oJvUXn9qAiNUjSXFRhBUnJorQiRIagMPYbW2orXGkijlGNYu2YNhsoX06NBQciVLTh0G46rV0MwatQIzJ7vjtySCrlfNMt9ohT1EkvYLmtaJTawClXVlahtqMGFCycwfvwsBAVFy7Yehaitq8WhQ4fg7e0Nm\/jQ+426YvQ+pKEBrfKolNf0y3BaWpopftnY2P7lt04+r+epMNJsTf0s60m91pTa9aReiw+79t6pMYqPTjD4IwmQAAk4k0Bri3Gv5IjAKL+wC22N9R29t8l7jbkpKNzhjjzvsWjMjO9476U\/yBfQOrFKTB09Gjuk4nVF\/TOrd0tLnQiJfSJAJuP+g2IRBunwWuyB27GyPYdpsAqHD+\/C9qM7cfXxVfwweBD+3\/\/nv+IPv38H8xe4IzUnB4eOHHlOfKgI2b59uwibq2gVMVNRWoLtUrbh088+MxaX8ePHSwjAQ2O0uXz5vMm+\/O233\/Djjz\/i1KlTZhPUl14L33AIAYoPh2BloyRAAiTgOgQ01qPQb66IiwloSHn0wsBbG+tQdfM0sj1\/QH185Avvv\/CCWDHqpLDkrJEjcUHiAbs6V+7cuYIxY+bg8pViZGUmYNz40Qh58BBPtyaFv98arPLbjJyaEhw8tBvDho6VmlGXEROTgEopctnV8qGxhZoEoUKiuaoSKRJvOEeKVe6SWlOngk5LnanZ8Pe\/JJaXZhE2e\/DZZ59LaMBiiUW5YywgzLJ8YQYd\/gLFh8MRswMSIAESsDaBlopi5K0ei4KA+WgqzHxhsK31tagMO4mM6R+i+u5FqDXklYe4OOquXMbcUaMQ3I34uH07BG5u8xB8UcVHIiZMcsPVh1Ed4mNrwDqs8fNHo3Ry\/8EteCxcLeUdak2Xzc1NL4gPzajUCtlBZ86gUDIut0r9qX\/553\/GJ59\/jkHff49\/\/\/ffibVDNz9NwvHj+zFliocIj4xXXgLfdCwBig\/H8mXrJEACJGB5AppOW7RzkcR8TDAxHl0H3FJZAo37yHb\/BrUxt3sOOpUYv9o7EZg2YgROiSvk+Yi\/Fty8eQ6jR0+X5yLkZIv4mNi9+FDnz93IMLgvWIF79zQ+pD3bpavlwyY+zoj4SEtPx3KxgmhGpu43tnfvXrP1x82bN1BeXiBBqftl+w5fiQWBZMZ0vVL+7iwCFB\/OIs1+SIAESMCqBCTrpCrsBHJXDkPxvmVoypc7c6ejLuGeuFx+RP7GSWjKe\/69Tqc9+1ECPuvyMjBp7BjMlU1HkyUF1nakpcVKBuQMyYacIwGfpcjPi8P3PwzCgeMPUScqJTnpCSZPGgevteug4iPibqiIj5VSqqF9n69XWj4ksLVCdla\/JDusT5wwAVmy3cfzR4tYPgLF5bJZykK0Unw8D8epv1F8OBU3OyMBEiABKxJoQ1ORZItIXY+cJb+gcOtcVIYcRnXEBVQE7xaLyGRkLxyEqvDTr110rLm1HufOn8ToUSNl41E3eHh4SBXrBZg2bRJmz55tgkObJb23tiIPOzwWYcSPs+U9OUeqZn\/11Zcd4iMmJkr2DpsngsQTgfsPIU8yLA9Iqu0ayaTRIpd6aMzH8uXLcfLkSbTV1yNXan7MmDYNE6WfBQsXmniQGzeipRJ3q9QI2Svj2IDkZIqP\/lyJFB\/9SZ99kwAJkICFCDRmJ6HstC\/y1oxGzuKfxBIyXGJBRiF\/w2STftvbaqdtbQ04f\/6MiI05EuPhJq6W0aYIpW7P0VEZu7kFTXHxWLfYy5yjxcN0o9GQmzdNzIduVnrs2DEJGp0JX39\/Iz7uSS2pkJAQaEVtPbS42KVLl0yhMW1X9xi7cuWKqaw9ZswYsbLMkAJnkZAsWzx8GIlz50KlMFnb65YssdAMDZyhUHwMnLnklZAACZDAGxPQ4NO62AhUXNmPsjMBJsBURUlbs4Z\/9v7QGhq2+k\/NIjRUHHRXV6NVglj1PH2\/6zn6u+09HYF+vnMbtt+7vqafaW5uNp+1vffs3N5fCz9hPwIUH\/ZjyZZIgARIYGAQUIEg9TLaJLPEZLbIzZ4HCdiTAMWHPWmyLRIgARIgARIggR4JUHz0iIgnkAAJkAAJkAAJ2JMAxYc9abItEiABEiABEiCBHglQfPSIiCeQAAmQAAmQAAnYkwDFhz1psi0SIAESIAESIIEeCVB89IiIJ5AACZAACZAACdiTAMWHPWmyLRIgARIgARIggR4JUHz0iIgnkAAJkAAJkAAJ2JMAxYc9abItEiABEiABEiCBHglQfPSIiCeQAAmQAAmQAAnYkwDFhz1psi0SIAESIAESIIEeCVB89IiIJ5AACZAACZAACdiTAMWHPWmyLRIgARIgARIggR4JUHz0iIgnkAAJkAAJkAAJ2JMAxYc9abItEiABEiABEiCBHglQfPSIiCeQAAmQAAmQAAnYkwDFhz1psi0SIAESIAESIIEeCVB89IiIJ5AACZAACZAACdiTAMWHPWmyLRIgARIgARIggR4JUHz0iIgnkAAJkAAJkAAJ2JMAxYc9abItEiABEiABEiCBHglQfPSIiCeQAAmQAAmQAAnYkwDFhz1psi0SIAESIAESIIEeCVB89IiIJ5AACZAACZAACdiTAMWHPWmyLRIgARIgARIggR4JUHz0iIgnkAAJkAAJkAAJ2JMAxYc9abItEiABEiABEiCBHglQfPSIiCeQAAmQAAmQAAnYkwDFhz1psi0SIAESIAESIIEeCVB89IiIJ5AACZAACZAACdiTAMWHPWmyLRIgARIgARIggR4JUHz0iIgnkAAJkAAJkAAJ2JMAxYc9abItEiABEiABEiCBHglQfPSIiCeQAAmQAAmQAAnYkwDFhz1psi0SIAESIAESIIEeCVB89IiIJ5AACZAACZAACdiTAMWHPWmyLRIgARIgARIggR4JUHz0iIgnkAAJkAAJkAAJ2JMAxYc9abItEiABEiABEiCBHglQfPSIiCeQAAmQAAmQAAnYkwDFhz1psi0SIAESIAESIIEeCVB89IiIJ5AACZAACZAACdiTAMWHPWmyLRIgARIgARIggR4JUHz0iIgnkAAJkAAJkAAJ2JMAxYc9abItEiABEiABEiCBHglQfPSIiCeQAAmQAAmQAAnYkwDFhz1psi0SIAESIAESIIEeCVB89IiIJ5AACZAACZAACdiTAMWHPWmyLRIgARIgARIggR4JUHz0iIgnvG0EWltb0dLSgtbWtm4vvf29VnT\/brcf6fbFtrY26UPakWceJEACJPA2EaD4eJtmm9faI4H6+krs378PU6dOxenTt1Bd3fkjbcjOicdC9wXwWrIEibk5byRAoqKisGXLFpw\/f96IkM498WcSIAESGMgEKD4G8uzy2npNoKqqELNnz8C\/\/uu\/Yv68lUhMzH3WRkMtnpw5gn\/4X\/8f\/vjnv+BWXBxan73b659SUlIQFBSEu3fv0vrRa3r8AAmQgCsToPhw5dnr5dibmppQW1uLurq6Af9oaGjoJZ3206uri7B0qScmTJiAiRMn4NT5c2h+2lJRWhICxeLxy48\/4utBgxCRmIjGtjqxXARh5cqV8rmlWCHPp4Muo6JSPtTQiIqYJ7h66RJKKirEStKCiIjbePQoXfgDBQUFuH\/\/PlSEQGRMTU0xQkOv49ixY\/Dx8cHGjRvxMOUhrkdew9q1a7Fr924kJyfLuW0oL89DyLWryC8vf2p9qZe2b+FRXLyMtxk5OakIDg4WK85+rFq1Cnv370V8QRyOnDxsxhh05gyKioqeXhmfSIAESMC5BCg+nMu7X3vLzs4WV8Jp+Pn5wdfX1ykP7SsgIAD+\/v5O61ddGXv27EFMTAxUcPXmUMvHsmWL5ebvDbexY7Fywx4UqpBoacTDsCuYNGkivEUY\/DJ0KO4kxKOhrQb79u0UoTIRY+X8yfK616R5OB98H6319ci4ehUzJk\/GuSuX8fjJQ6xetULm4KYIDeDevXsiKtbg1KlT0kEzMjIeYvToERg+bBhGjRyFDz78EOMWjMXsJV4Y9fNojBo8GH4BW9Eo56akRGLqzGmITEltt760lYrI8MS2w4dRjwZcvHgY33\/\/PdzGjMEvv\/yCT778BLPXzMWkGQswctDPGDt8GC5euyZyiAcJkAAJOJ8AxYfzmfdbj4nyTX39+vUYNWoURo4c6fCH9jNMbqR\/\/OMf8fHHH2PEiBEO71OvS\/uZPn06Ll++bCw8vQGu4mP58iUiXo5ip88WrF20FXcj81CenYUz2wOxduV2BB04hOEjR+B2vFoZgFyJ\/bh48aKxMhxavwGLhg3HAo9FqJVg0rLSEmzbvgUzZkzHFIkj8du+A+lZ2WZIKj7WrLGJjxYkJd3B4MGD4L9jJ3Ly8kSs+eLd997DmrU7UZpWhlPbAzBjrgcKqpuQlCziY8bUl4qPY0e3Y9APP+BKWBhSUlOl\/xn46OPPcP7sPdSkZmPZvNnw230YlX0zEPUGKc8lARIggRcIUHy8gGTgvlAjX7dzc3OhFhBnPHJychAdHW2+eavbQN0Lzug3KysL+fn5aGxs7HUsRbv4WIoDB++g9F4KAsVSsXPnLlwMvoD57utwL7wCcWeDMUbFh7g4GurqcWDvXnz\/0094XywVH7\/7Lj78jz9jwSIPVEvGjLpIshLv46MP3sH\/+J\/\/Eyc6WRueFx\/NSE29h8nTpxh3ToNkwJw8eRLjx4\/H2bPnzKIMuXIGC9zXiuulSWJRIjF91nTcE2HRHndShtWrvTosH2eC9mGOhweKW1pRUlqKjRs2GEGWlKRum0Zs3uQNP98g5BcM3PXOKyMBErAuAYoP687Na49Mb7Iax2G1Q1NI09LSMGTIEOzatcuIAauNset4OsTHgQhUlTdiq7+4X9zcsHChOxYuXYbSylqkSCyFER9PYlAnQaezR4\/GVnF3lEk8TWFCAgLXrMWSFStQrSm7jXWIOnsGX3zwFf7l336PwKAzqGmoN912Jz7UlaKCwiY+Jk2aZLJhVMSEhJyFuwigpKQmxMdHYLy4gMJj003MR011Djw85sD\/wEHjdjl7JhDzPD1RIj0Vl5Rgk8SPzJ4962nMiIiPzT4iPs6ISOtKgL+TAAmQgOMJUHw4nrHDetAaEZWVlXj48KHJmND6E1Y6VHykyo3U1cSHxnzs338HEiOK82dO4W\/vvoN3\/voejp0IQpuIvNQLFzBq+HCEP45GnaTLLhRx4ivBoGkZGTh+9CiGiBXEXW78VRInEh8fhbkz5iPA\/4a4UQIxVSwbIdduSR0RIDIyUqwVq42FQ2M+UlMjjeXjrliIVHycOHHCBL6eO6eWjzZcEcvH\/PlrkZjUjKSESIwaMkJExDWZ\/1QcOXIQX375BXx27BDx0Qib5aNESoio+FDLh7pe2gNWG7FJLB++W8TyQfFhpf9kOBYSeGsIUHy46FSr0FAXSkhIiLEqaHxDc3Ozpa7GFcVHdXWxxMX4yI3\/gQg7oDozAxsXLcS4sbMRFy8vSAZLxtUQzJD4jcjEJDSIK8tv0yZ8\/uWXJj7js88\/N2LLf9s25JQUI1Bqhnh6LhZrRTaKizMxbdoEeHsHSaYJJOslSoJ+t+CCiJn2gFMRMp4LEZWeLlk0bcbiMX\/+fBEdIfJ+G27cuIwVK\/yQnNKKxrJSROzajW8\/+gZ\/fed9aXeaiafZJ66aBhEfly4dw1KJJykT8VFaVoYd27fDy8vLWKKAJnElBWD3rksoLLTUkuFgSIAE3hICFB8uONF6U8+Qb9lnz57F1q1b5VvvESSIuV8tIVY6XFF8tLQ0SVxKloiDKmOdEEWHIomRSU7OhCSvSEZsG+rlZp6clIRKsYIo8VwJDr0bEYFrEs8RIc9x4orJE5NCnQiVLPlsRka6ZN1oZKdYLJISxMJRaNqqrq6SlNgclJSUynvSbn21EQfV0pG2WyIWC7UclUl\/epSXl0lbOSZNV8fRJO\/fi7iD66GhiI2NNWugQF5rlf+VlhYhPTPTBMQ2yTXkyRjTRdTUt1+E\/J4rj1JxhZmm+Q8JkAAJOJUAxYdTcb95Z3pD15vRJakdoemyappXU3pf61q8+Yhe3oIrio+XXw3fIQESIAESsBcBig97kXRSO+puefDgAbaJWb+vtSycNFSTaeJqMR\/OYsN+SIAESOBtJkDx4UKzr5aE4uJiE6C4SeIMwqSGQ\/Xzm49Y6mpo+bDUdHAwJEACJGAZAhQflpmKngeiAaVajnuHZDQEBgY+DR7s+XP9dQbFR3+RZ78kQAIkYG0CFB\/Wnp\/nRqdptWdkTw61emhwo\/5u5YPiw8qzw7GRAAmQQP8RoPjoP\/a96lljPTR+Yt++fUZ8aOVQq2W3dL0gio+uRPg7CZAACZCAEqD4cJF1oNksN2\/eNJu0abXQdEmbtPpB8WH1GeL4SIAESKB\/CFB89A\/3Xveq+7Lo7qebN2826bVat8HqB8WH1WeI4yMBEiCB\/iFA8dE\/3HvVq97EC6UUpbpcdFfa8+fPm6yXXjXSDydTfPQDdHZJAiRAAi5AgOLDBSZJs1xiYmJMbQ8VH1pK3Vb10srDp\/iw8uxwbCRAAiTQfwQoPvqP\/Wv3rDvW3rhxw1Q03SAbhIVKOe2qqqrX\/nx\/nUjx0V\/k2S8JkAAJWJsAxYe158eMTuM9dPMxTbHdKFujh4eHQ1+z+kHxYfUZ4vhIgARIoH8IUHz0D\/de9apWDt3DRa0eNvFRW1vbqzb642SKj\/6gzj5JgARIwPoEKD6sP0emmNiBAwdMsKmKD025tXJZdRtSig8bCT6TAAmQAAl0JkDx0ZmGRX8uLy\/H7t274e3tbSwfjPmw6ERxWCRAAiRAAq9FgOLjtTD170mlpaVmP5d169YZ8XH16lWoILH6QcuH1WeI4yMBEiCB\/iFA8dE\/3HvVa35+vkmztYmPixcvoqSkpFdt9MfJFB\/9QZ19kgAJkID1CVB8WHyOdP+WzMxMbN26FSo+NOhUN5fTomNWPyg+rD5DHB8JkAAJ9A8Bio\/+4f7aveqGcrqPS0BAQIf40MwXlld\/bYQ8kQRIgARIwGIEKD4sNiFdh6OWj6ysrA7Lh1Y4PXz4MHJycrqearnfafmw3JRwQCRAAiRgCQIUH5aYhlcPoqCgoCPmQ8VHYGCgccW8+lP9\/y7FR\/\/PAUdAAiRAAlYkQPFhxVnpMibNdtm+fbtxu6j40LRbdcVY\/aD4sPoMcXwkQAIk0D8EKD76h3uvetW02p07d5o6Hz4+PkaIpKam9qqN\/jiZ4qM\/qLNPEiABqxBQt7k+eLxIgOLjRSaWe0XFx969e6HCQx\/+\/v5ISkqy3Di7DojioysR\/k4CJPC2EKioqDA7kAcHB0N\/5vE8AYqP53lY8jdduLby6io+Nm\/ejPj4eEuOtfOgKD460+DPJEACfSfQhoKCNCmyuF529\/ZDltQ+aj\/qcOvWVVy9dQsNfW\/cDp9sxcOHkQgOvik1mNqbKyjIx5YtW0x5BI3b07+Hujv5rl278OjRIzv06dpNUHy4wPxVVlbi6NGjZhFriXWt9RETE2P5kVN8WH6KOEAScBECLUhMvIP33vsL\/v3f\/4CgC9GoN2qjHH6+q7FGBEl1v15JC44c3QsvLz9kZLQPpLCwwFip9cuiTXxERkaav+VxcXH9OlordE7xYYVZ6GEMuoncqVOnTGl1FR8adBoVFWWUdA8f7de3KT76FT87J4EBRKAFKSl38c03X+Cjjz7B9Okb8TghF22oQoD\/WqzzD2gXH42NyBerwjZxTevfSV9ffzx+XAh5WY5GxMY+wpUrVxAUFGTe33\/gpJQyaJK4jHZUbXl5OHvkMHzW+5j3g4MjZCsLfa8VRUXZuHU7HGV1debk5uYaREbeRkJmAh7E3MXkyePw8ceDsHx5AG6IJSY9O\/s58aEf0oKR+rdbxYge+sUyLDTUWEh8fX0REhKCmppq+dveLON+BK1mrdmNWl4hLS3N8n\/zzUW95j8UH68Jqj9Pq6mpwfnz5427xSY+7t27h+bm5v4cVo99U3z0iIgnkAAJvBaBFolzi8Avv\/yMJUs2YND3P2PHwUMoq8nBVv91WCdFGGvFrVH0KAo75i\/Cd18PweBBP+DXL77GogW75EZeLH8vq7Bp0wp8+eVXGOPmhp++\/gojvvxVbvwXUVpZh5bSEoQFbMXYH0fjm29\/ws9ffYUJI+bj5MkYNNS34P69K5g+ZxbiC4vMiOtqc+DpNQ\/7Lx5FUOgZfP31l\/iHf\/hX\/PzzaAQePIhkMYH4S2XqzpaPCxcuYM2aNbhz547omVbEiiVk3vz5GDJsGIb89hsmTpwi7pss1NbWSnzfanz33XcYPHgwPDw85PWHAyp4leLjtRZ+\/56kC\/Hy5ctGHdvER0REBBoa+tfL2RMVio+eCPF9EiCB1yOg4uMOhg0fKWIgFlt9tmPR\/Hm4+eASfLeL+JCbfGNVNa5vDcC40XIDjypEQ009SsV6MG7YSPnbeUysDXly41+EL7\/5Rtw2wWgsKsDNHVulzRGIy8xCZeRdTPptqMTX6cadjWiUmA3\/Zcvh5jYXcXE5uHv3EqbNmvGc+PBYNBeHxTpR39osn9spImETEhIa0CyVqQu6cbvol8hVq1bhjv79Li7G4Q0bMXzECAQeOYLde\/bghx9+lmrW15GdXSxjXY4Rw8eJNeQGmprUOjOwsmYoPl5v5ffrWXVi5gsV05ya5WziQ5UzxUe\/Tgs7JwEScBqBdvExdNgIBF9IRUlUCtynTcHawLVYtMEDPlIHqV4sEnf9\/OG9ejWqRIjoUV9fh6VLl2LZsvUSpB9lXDQaH1JpbuQteHj\/MqaKoEhIz0CNuGNWzpmDBw+jOq7q1KmTmDRplrhqriEiIhgz5s5CQlG75aO+LheenvNw5OIlqA36qMR8LF7sL+6R9o93F\/Oh4mO1jO\/u3btIkKSBMaPH4O\/+7u\/w+9\/\/Hn\/4wx\/wpz\/9Sawzm8UVlCSCaYPEswShsKCtYzwD6QeKDxeYzfr6ety+fdv4D23iwxVMcLR8uMDi4hBJwCUIPBUfQ0V8BKehurwZuwL8MWnieHw36Dus27bNWBJui\/hYvmQZysprzFU1VFfBa5EX\/PxCxZpQJuJjDXzk3PZ3m\/HgwRVME1dKQkYmqkOuYvG06bhz92EHkeOHD2LWLI2xqxJXyUVMnDoVT7JLzfvFRcmYPWcqDokrpUmiT44c2W3Ex6sCTjuLj5TERHguWIAF7u5IkaKRRSJqisUaojEfdXVl4q5ZL9tqXECR9fcQ7eDVmx8oPnpDq5\/OVQvHgwcPOjaX27RpkwROxfbTaF6\/W4qP12fFM0mABF5FQMXHbQwZMkzi39IgBg2UxDzBtBEj8Z\/\/y3\/BItnxu1EsxDf37MaEkZNw6XIsMlMzkSDWjHFDx2Jf4G1xpVSLCFlt4kPa7SIqPtotH\/GyV1aVBILOHDEKAX6nxHWSjRxx2fi4e2D6jHUiXFoQGXEJw38ZhX37o5CQmIn9+\/fgy6++wB5JBlDLx\/Hj+7Fggbd8UcxBuZRHyJN0YD8\/P7FkbOrIdjl37pxxu9wWy3WLnHNG3EXTZ8\/GA6nblCvBrrpbeUNDizwqJcFAazqdo\/h41bKwx3s6QQsXLoTu4srjeQLq73vy5InZ30UtH+p+SRTVbPWD4sPqM8TxkYCrENBsl0iMGzdR4t8yJABUxi3\/bJU6Gn\/+85+xfP0GaA5KVUoyTq5cg08++ALvv\/c+PnvvA6xddVo+WyX3lkqpFL0RW3bv6bB8PHp0HfMXLTSulBaJrYs9egxjf\/gN77z7AT585y+Y5LYY16\/noLEJqMnPwXnvjfjo3S8l4+ZTybiZjt+GDsVJyVCRtxFx57bEh0zEF18MQoC4gZLEBLJLtsLYJpYWtWro38NLly6ZrEVNudUjXjJzZon4+OCTT\/HhRx8acXXzZpq4jWrlc36ylcZlsYaYUwfcP7R8uMCUalZLQkKCKauu4kMXc3JysuVHTvFh+SniAEnARQi0SQZIhdQ3ipWbcZ1JjdVICLUW3JMbubotzNdW+fJaKemsIZcvQa0MFy9dlvgJFR56mc1iwchAhlg52r\/iSqJuZan5IlfTnosLKUWKB+Li1s+ek\/iMR49TxAXyFFFLK2pyc3Et5LK4foIlg+YxoqOjUSh7b2koaFVVlUmj1VTeOInnqBYxo7uP667kjU\/bV7dKuozVVvG0TlzqWjBSU2rVJXPt2nXk51dJgGmLfC7TBJ7ahvZ0FAPmieLDBaZSrUEqNnbs2GECTrVCnuZ8W\/2g+LD6DHF8rkBAsxz0ZqXbLLwND9uN2hXmhmPsOwGKj76zc9onVXykpKQY8aHl1bXgjCpqqx8UH1afIY7PFQhonR\/9pq1u6akS8Kjmfmc8ZsyYgZkzZzqlL72eadOmQfvcvXu3sRa4wtxwjH0nQPHRd3ZO+6TN7aKWD63ap4VqSmwbCDhtFL3viOKj98z4CRLoSkDr\/Fy7ds2kaHp6ekoJby+HP5YtW4ahEs\/wxz\/+0YgCZ\/W7ePFiHDt2DHniTuExsAlQfLjA\/GrAqfoXt0pktO7rojnimn5r9YPiw+ozxPG5AgF1u2g8gbpenPXQst\/q3v3pp5\/MJmjq7nFW3\/r3jsfAJ0Dx4QJzrKm2KjgCpISwPlwh2FSxUny4wOLiEEmgGwIqAHbu3InfpOT3QNtTpJvL5Uv9QIDiox+g97ZLrXB6\/fp1U2TswIEDyJWIa1c4KD5cYZY4RhJ4kYAGfVJ8vMiFr9iPAMWH\/Vg6rCU1uequtlqwRvPE1QTqCgfFhyvMEsdIAi8SsLL4aG1tkRTUbFNosaCg\/Gka7bNrqK2rMqUJEhOTUPuGear6t1aD\/XUXWv17xsN+BCg+7MfSIS3pgteFv3fvXlPnQ3PCrb6brQ0ExYeNBJ9JwLUIWFl81NeXSebPfCku9hfZ+fWAFPBqfAa3rQlRty\/hb++9i0+\/+BKPpObHm2zHduvWLRPce+LECbO527OO+NObEqD4eFOCDv68xnvoPi5aWOzMmTMukeViQ0LxYSPBZxJwLQJWFh91dSVSxnwuvpHdaefMcUfk\/WcbwTUXFyI0wA9\/lk3aPvj4EzyQKqMtsu9KaWmJSd\/NFDGSKUW\/SkqfWkwkmLdZsonKy+R3+Vki1Uxwb01NgylkVioFxLTAo2bftLW1ipWlCZWVFWYPFrW+6Os1DTWoqCo37esXxfZkgDb5ktgoZdbL0SSlEswhn6+qqkTN06pljY31KCsrMyXVs7OyUSibuDS0NKCouAhZ0rb27SpfNPuyut9IfGgUtsJ5WUl0fV0fr2OuclZ59ZaWZqmUV\/t0ofUFme0zbVK1rsEsNEca4zSl9vTp06bGh1bTs\/pOtjY6+kzx0ZkGfyYB1yFgdfHh5eUBd9mQbcyYMdhx8CjqzB\/hNsQ\/jMDSeXMxS+qFfC+ZOg9FbNS3VmC9zyp8+aWWRf8In8pjiac3UtKkdKnsfpslruy1y1cgWW741bVlCAzcI+UM7otQgLh2YrBv3z7cvHlT\/p41ihU6UQo9rpXN5mbhm6+\/xrfffYs9F3Zj\/a6N+PyTzzBm1ChclbRouTsgIz0aa+TcJNltV4\/mplLs2bMVp0OuiiBqwf37odAU5gkTJuDTTz\/FqHGjcP7xeUyfP9O05bloEeJF+AzUo0\/iQ28q1dXVJutCv5XrPiN6Q7eJDH3WtCx1EWiKaL5ssPMygWID21vxoX3YxI2tDX2tubnJCCLbWPQ99RE2N6v6bEFmxhP4bPBBalFxt+a4ngSVrS\/ZWACh1y9g76FDKBcB5ohDmeqGcttlnwCN+VAh0vm6HNGnPdvUsaampsp+BUNM2p7+QeNBAiRgfQJWFx9LlniaGLiZIjKWrghEutZcrK1G+KkTmD9vvuxe649fpU6JWj6aZeeV6OhHpmT66aDTOC9WZN8Zc7ElQPZ4qatHutyjZs2YbvZjOXhov6kiffvOI7lnQHayvYPly5fL39\/T8rdXS6GHi8XlSxEfs02xx4mTJuKjrz\/G3EXrELTzNFZLO14rVso9oVaEQzgmTJqARyJqVBs1NRZgxQp3bD98VO49rTh6dDs+++wzrJVN8TSt+Ycfv8fng7+Cz\/pDOOm3BzPdxuBg0Bmzb4z1V0zvR9gn8ZEhE6o1J+bNmydbCC\/G3Llzzc59aobSIz09HVtkwx99XavyacEa9Z29SoD0VnxoH5r5oVYB202tsjIH69atMlHaKnjajyZRrZfkBn5ITGT1iH1yEyPHjMKjLFt9\/6enPX2Kkp0NtZCX3uxfnW9eh8OHtsFjxQoUOCAvXS1KGuh0SMSNKm8VeK5mgqP4eH5t8TcScBUC1hYfxViyxAv7Ay\/j7uFgbPPyweUrkUh68hibVm7Fyf13cePISYwYNgz301V8APfu3cP8+fPx\/Q8\/YLDc8D\/5v3\/AvIXuKGtoRJ1YsMNunMeg777BBx98iP0iNCpkW3s9IiIisHLlSgSJCFDxkSDiY9iIobh8+w7q5O\/+gf378ePgH+VedErUBRB84iDmua9CWk4N4uLuYPK0yXgs1aht4mPVqkXYefS4ER\/Hju7AeKlYmyDvF4h1ZOmSJfjh+x8R\/SgVreKe8V65DP47TqOs0gxlwP3Ta\/Gh\/iwt7z1u3DhzYwwLCzO\/u7m5GSGgfipN0dKJ1iAd3TBHlaOHh8crq9b1VnyUigDaJ6XGV8jNv8L40NpQ+CQSn7z\/DgYPHmwK45jZKinAYe+VmDXHE\/kltbIgwuE2fiyic7uvoKc+wcuXLxuLw6vEEmQPxaNHdsBr9WoU2ll8qNVIRZBW+gsMDDQ\/u0JRsa7\/dVB8dCXC30nANQhYWXzU1qr4WCxf\/iJRlVqI7WuXSPXXVRKUvwez3FcgNbES8WcuYKQRH+moky+ia7wWY7J8GV69cSM2y\/1o1siRWCqiokxi6jTOI\/\/xXfz+X\/4J\/\/m\/\/lecDg0VG3n70VV8JCXewRQRFE\/y8tEoikLvcVoWXu8Zely6HIRFHhuRlCg75Ma2i4\/o3Hbx0dxUKOP0NOJD3S6nTu4xX16LJTShoLDY7HarZeazsiROpbUWmzdvkLpO51FU0D6WgfZvr8WHpn1q4KPeFLX+hB5aDU8tHGoxuC07Aqo\/TF0F6sLQ47rUqNAJUr\/Zy769q\/hQgfLaR2MNrp04gNlzPJCWXY\/GugbcOHUSv4mf75tvv0XIrZumqdzH0dgmlpcdu3aiSZVrwm0MHzEM\/rKt8jIRLu7uHrJwYsWN1N6zWkzU1KYuIw0wqq6pMCJr0SJPY+lRIRUpsRcqc23io7S1CfkFaSK69iL6cQVqxQEZHf3YVCOdLdsl67U9efLEdJCXl2kW7J49e4xw0kWrTDsf2rea4VTE6eLXvR1c8aD4cMVZ45hJAMaarH9\/rFhkzIgPsbgfPnQXZeXN2LHTH59\/\/jl++flnbArwR21lORJkh1gVHw\/E7VsrVo8FEhtyTL4I65EVG4vl8nd5iX5xbWpAWXE+9m3wxQS3Ffh1iBt8fH2Rnp1lzu1OfEyeOgmPs3PQ0NqG48ePY8qUKfIl+5I5\/9Kl0yI+NiApqVZCDm7glyFDERKei0Yxv0RH34Wb20j47T9gLB8qPtzl3qRfXtXyodWrde+ejAzZobelRu4b69vFR6FpesD902vxoYq4sLDQPPTmooe6W1Rc+Iuf7ezZs8bdogLFdjx69AiLJHims2CxvWd7VjfN999\/b0SLLvqDBw8a64XNpWI779lziwT2nMfYcVMREhIt6Val8JP+V4slYtjQ4dh96BpqJMTgypULWLlqk4iiWPloE+Jib0lwz8cYJgtzkgT6TBIz1wy3JQiLSDJNawzLmjVrjEBora1BwYMITBgzGmPHjpOFMcUEOYXLOTbx4em9HHczH2DjJh\/ZgGkT7kWUoSKjANu2bMYkYTJVlKwGRfn7H5bIZiAy8oZYZn6QssU\/yqZNM4wfUi0dnY9I2SJ6nfgB1a3kytUFKT46zyp\/JgHXIWB1y4eXpycOHoiQmkfA4\/Bw\/CiulHff+ww3bsgXw+oaxMt9aJjEmt0X8VGXkoplc+ZgssSHrBVr+TS5wX8mAZ7LVq1CTmkxLgQHYcLEqQgNzUJY2A2x6o8WK8oF+dL3LObj9Okg43ZJlC+vEyZrHEe7+FDr9KRJk2Tjv3Zhc\/HiKSx095EvuQ3ISY3Dmqmz4DZyGZYu9ZaUXU8jknwD9xvxcfLELswXV4tNfOimoZMnT5awhTQjPjZs8Ja4lnOQJJgBefRafHSloG4WjUlQN4xufqQP3fgoJCSk41T91q9Wjc2bN7\/0W7yvqM0PPvjA7KKolhNbGxp0+bIjVSwQm0TUbN\/qL6aqZCxbvgwnzp2D19LlWLv2GLLj83Fgh6+Y13yRXahCqVUsEGH4RMTHmo2bxJwlaVFxjzB71HAEHDpsTG0qPtauXYsTJ0+K360CeaEX4TZsKLZKkFKeXOuzo04WfwC+H\/49ZqycL26dLXj4oA711RLcdOUyRv7yC2aK62m3sHGTwKExoxdKifQssapcl28TI0TV7pWg3CpZ0O0C7lm7GmEda1JrNb32xo0bL1hGOp9r5Z8pPqw8OxwbCbycgJXFR2NjFU6ePCFfKFMk0UGuQb68XT5yGAFbD0o2ivw9bWhCnritt8lWFGnFxWLxbsMFsYToF+Rf5O+yPnt7e+Py1avIkS\/S5+U9ja1TC35TU7lkFm6VYNAISHauibvTL9IPHjyUv9Vi4c5Pxt7AvcgsLUOztKtfFPX+p5mIekRH3xdrSDBycsVxU9uAAol1nDZ+PH6T4NcN4hnQL9lhYonRgNP7927gqMQsVkkyRIX0rSEK2laxpNq2tjZIQclgXL36SMZlmh5w\/\/RZfOiNRXOaNf5DU4WOHDki1ociE1iqwuGqTKztiImJMZYPdT+8zIWg7y1YsMCkkqprRh82t42tnReey0rw8Mh+eC6ci1vhwZgxazrCJXL5urgyvFeuQtjxE\/AV3+BKUZRVYiJT8REXdwtjxrlJ8ZksEwTU2JAvgT4LsPvkKROY1CE+xJfXKjnXxUUpmC3tuo0diW0H9yNExECOXLdmuwTu88X\/\/t9\/L6JJLDY7wyWlS9abuKI0GFd3g\/zTn\/5k0rs++eQT44p6+PCeCJBQsQwtwb37VaJuX7gi84Lmfqu5Ty0fu3fvlpSs+89lE3X\/Keu9SvFhvTnhiEjgdQhYWXzo+PXe0PmLW5v83vl+oe+Zc55erP6s9xRNItBnjedrlXNs53X+rP7cqvcL\/b+tHXnWo+P3p+12\/N71\/fbT9QMd\/Zo+O43b9tmnTZnxto+j\/cMd47CdMMCe+yQ+FEqWFGrRLd7Hi6rToBuNW9DX9aapVg5VcbZDLR\/qdtHzX2bJUPGhcSPt8G2f7Om5Gfcjr0gq56\/SvgcWuC9AeloqmjJSsG6Ru3FrLPJYLir2nFlommqr4sMEnObkGvHRoOJjqTv2SISzRkV3Fh+atquHLhLNpPHymo\/\/K6LCb98J1De3SkDoTjHXTRJLyzL8NmIk7sTFoVJsdScOHsIk4RL2NMOnfdFpvZMWiboOM+Lj\/oNaWZSm+W7\/0f\/4tbiNKmEVIHHS9quzb7ptpl9fVG5Mte3XKWDnJNAnAlYXH326KH7IUgR6LT70hqLCQ90kM2fONG4WW+CpXpmmhGrErt409Vw9NIBTrRpqDXnZDdQmPl6dYWKa6\/RPm8SFROBbCTB9772\/ScCOn5isStDcWAxPjzn4+3\/4e4lM9kFcgq2+RIu4NG5i9Ngxxmeno1PxsXixuEeeWj60robGjWggkV5XsZjtVATExkaLP\/Cy+PfGYa33GRSXtIi1ZzsWScT0HQkQXS1xIhPEXxcjP+dJG\/PEr+gvlotoEQ0aQJqXVyxqW810YZg920ssHzWvFB96kVpLRcWc7mR7UtxA6uJypYPiw5Vmi2MlgWcEKD6eseBPjiHQa\/GhFg61YGgUtAoM\/Uau6akqSLQIlm7EowGbSySQRt0t+p6eP0OCfdLT0zsESdfL6Zv40GDXLFNr5PPPvxYfWRwa6sXMJe6Snbt24KMPP8Q63+2o7LAwtEhhtEjMXTAPcZIqpeKjsbFIUpzW4KhEK+tpMWKl0Zu9Wm7UjaTX+MUXX+Cvf\/0r\/va39zBixHAJTIowVoyzZw\/BR4Jci8VKESNxGu4isI4cPYoCCcA9cvgQBknK75\/\/8hcTy7Ju3S5x4bSKWLoreeMbxDf4asuH8tGbtwb3alCTMlQLkv5RcJWD4sNVZorjJIHnCVB8PM+Dv9mfQK\/Fh4qNORI5\/N577+HHH380WSNDJZhmlJSV1Zu2Zr5odosWH1PBofU+NN1Ug3peVRq8r+JDLSm6xXx8fIK4Rhrlht1+01aLhVoc8uXmLaEYT482KYdeLbX9M6WwjM2l0ixBRLkoEdGkYkStHRrLoiLK1rZaQ9QCocFFatlpj1tpk+yVEuTJuRq60Sjj0GtXsaA\/6+dVyLR\/7p4IrxwRDhITIlX4cnPy5Vl9lrZxvfxZx6P9ahyJZhK5kvWD4uPl88p3SMDKBCg+rDw7A2NsvRYfGhGsAkRvquGS4qSVS\/Wh9T1sZdZ14Wp1Tr1pawyFZm90rWXRFV9fxUfXdgba73oD182LtO6HWj+Uce9cU\/1HhOKj\/9izZxJ4EwIUH29Cj599HQK9Fh+v02hfzqH4eDk1FW4a1KtxNleuXDFWlZefbZ13KD6sMxccCQn0hgDFR29o8dy+EKD46As1J39GXS8arOvn52eKr6klxBUOig9XmCWOkQReJEDx8SITvmJfAhQf9uXpkNY0VsaW9aKFx9Sl5QoHxYcrzBLHSAIvEqD4eJEJX7EvAYoP+\/J0SGv6h0A3mtOgU3VP6Q6Nrwredcgg+tAoxUcfoPEjJGABAhQfFpiEAT4Eig8XmGCtyKe1RnSzPt28T9OAXSHrheLDBRYXh0gC3RCg+OgGCl+yKwGKD7vidExjmt2ilUI120U3HzoqtUQ0vdjqB8WH1WeI4yOB7glQfHTPha\/ajwDFh\/1YOqwlFR\/JyclGfOiGSFpuPT093WH92athig97kWQ7JOBcAhQfzuX9NvZG8eECs65uFy2Ypm4XFR+uEnRK8eECi4tDJIFuCFB8dAOFL9mVAMWHXXE6pjEVH1qqXkWHig9NudViY1Y\/KD6sPkMcHwl0T4Dio3sufNV+BCg+7MfSYS3pHwKtFKvZLuvWrTMZL1pl1uoHxYfVZ4jjI4HuCVB8dM+Fr9qPAMWH\/Vg6rCVNq9WdgXXvHBUfGzZsMKm3ra3Pdq1xWOdv0DDFxxvA40dJoB8JUHz0I\/y3pGuKDxeY6Pr6eoSFhRl3i7pdNN1Wi45ZvdYHxYcLLC4OkQS6IUDx0Q0UvmRXAhQfdsXpmMZqa2vNni5btmwxMR8UH47hzFZJgATaCVB8cCU4mgDFh6MJ26H9mpoanD9\/Hps3b+4QH1rlVANRrXzQ8mHl2eHYSODlBCg+Xs6G79iHAMWHfTg6tJXq6mqcPn3aBJra3C5abl1v7lY+KD6sPDscGwm8nADFx8vZ8B37EKD4sA9Hh7ZSVVWFY8eOmUBTm\/jQ1FurHxQfVp8hjo8EuidA8dE9F75qPwIUH\/Zj6bCWKisrcfDgQRNoquXV1f2iRcesflB8WH2GOD4S6J4AxUf3XPiq\/QhQfNiPpcNaqqiowL59+8y+Lio+\/P39WWTMYbTZMAmQAMUH14CjCVB8OJqwHdovLy\/Hrl27TLCpig8ts56SkmKHlh3bBC0fjuXL1knAUQQoPhxFlu3aCFB82EhY+LmsrMxsKqcFxjTNVjeWS0tLs\/CI24dG8WH5KeIASaBbAhQf3WLhi3YkQPFhR5iOaqqwsNDs62ITH4GBgcjMzHRUd3Zrl+LDbijZEAk4lQDFh1Nxv5WdUXxYfNr1Bp6dnd2xr4taPg4fPmxes\/jQTSpwamoqhgwZYtxG+geNBwmQgPUJUHxYf45cfYQUHxafwZaWFuNi6byvy\/Hjx5GXl2fxkYPiw\/IzxAGSQPcEKD6658JX7UeA4sN+LB3SkoqPjIyM5zaVCwoKgrpirH7Q7WL1GeL4SKB7AhQf3XPhq\/YjQPFhP5YOaUlv4Pn5+R0xH7qjbXBwMEpKShzSnz0bpfiwJ022RQLOI0Dx4TzWb2tPFB8uMPOlpaUd2S4bN25ESEgINP3W6gfFh9VniOMjge4JUHx0z4Wv2o8AxYf9WDqspc51PlR8XL9+HVr11OoHxYfVZ4jjI4HuCVB8dM+Fr9qPAMWH\/Vg6rCWtcHrgwAFT4VTFx40bN6D7vVj9oPiw+gxxfCTQPQGKj+658FX7EaD4sB9Lh7WkVg7NcNF4DxUf4eHhqKmpcVh\/9mqY4sNeJNkOCTiXAMWHc3m\/jb1RfLjArFdXV+PcuXPYtGlTh\/iora21\/MgpPiw\/RRwgCXRLgOKjWyx80Y4EKD7sCNNRTdXV1SE0NBS+vr5GfISFhdHt4ijYbJcESAAUH1wEjiZA8eFownZov6mpCY8fPzZVTrXC6ZUrV5jtYgeubIIESKB7AhQf3XPhq\/YjQPFhP5YOa0ndF1rRdO\/evWZjufPnz6O4uNhh\/dmrYbpd7EWS7ZCAcwlQfDiX99vYG8WHi8y6xn2cOHHCxH3osxYes\/pB8WH1GeL4SKB7AhQf3XPhq\/YjQPFhP5YObamhocHEffj7+2PPnj2m5LpDO7RD4xQfdoDIJkigHwhQfPQD9LesS4oPF5nw5uZmJCUlGeGxZcsWPHnyxGzcZuXhU3xYeXY4NhJ4OQGKj5ez4Tv2IUDxYR+OTmlFK52eOnXKZLxo9ovVC41RfDhlWbATErA7AYoPuyNlg10IUHx0AWLlXzXrJSIiwmwyd\/DgQaSnp1t5uMYyk5qaiiFDhmDXrl0mfc\/SA+bgSIAEDAGKDy4ERxOg+HA0YTu2r5YEDTQ9duyYCTy9desWtAaIVQ9aPqw6MxwXCbyaAMXHq\/nw3TcnQPHx5gyd2oLGfqj1QwNP9+\/fj8TERLS0tDh1DK\/bGcXH65LieSRgLQIUH9aaj4E4GooPF5tVvaEXFRXh7Nmz0MDTM2fOIDMzE+qSsdpB8WG1GeF4SOD1CFB8vB4nntV3AhQffWfXb59US0dycrJxvwQEBOD06dNIS0uzXPYLxUe\/LRF27CgCIv7R1jrAH21obKjHzh07MPS3IUhNTZFLFuvqW3Ddjlo2bPdFAhQfLzJxiVfU0pEuAada7XSH\/JEICQmxnPuF4sMllhIH+ZoE2lpb0Vycg4b02AH9aJTrq0qMwiGfpZjxy9dIvnER9WkxA\/qazZxmJaC13vq7hb\/mcrX8aRQflp+ilw9Q4z\/UBRMeHo6bN29SfLwcFd8hgTcm0FJViuJ9K5A15wtku3+P7IU\/DNhH5oJBiBr3Hm4O+XekzPpqwF9v9oLvkO3xA+pi7wCtzW+8VthAzwQoPnpmZPkzampqUFFRQbeL5WeKA3RlAs1l+chb7Yacxb+i\/MIeVF47OqAf1aHHURN2ApXXB\/Z1Vl4\/jtJT\/kgf\/0dU37kAtFgvfs6V\/7t52dgpPl5Ghq+\/MQG6Xd4YIRuwEIHmsgLkrR1vrB\/NVSVoa26SRyMfA4BBffIjZM74iOLDif+9UXw4Efbb1hXFx9s24wP7ejvEx\/7VaKmrHtgX+zZdnQTT1ifcR+b0Dyk+nDjvFB9OhP22dUXx8bbN+MC+3ufFR9XAvti36eooPvpltik++gX729EpxcfbMc9vy1VSfAzQmab46JeJpfjoF+xvR6cUH2\/HPDvyKrWmTVZWltnRubKy0pFd9dg2xUePiFzzBIqPfpk3io9+wf6WdCoFmdI6bSzX1Nj4llx495fZ2taIjIw0FJWWQspUtR+SLl1RUIAkKRpX32zNMvm2odr\/uVX2KspDXl6JbDrY3rpmbiUkJEhhq1RTtVcrbR46dAjr1q1DdHS0\/YfQixYpPnoBy5VOpfjol9mi+OgX7JLN1do24B\/NLa1ITknBr0N+w46du1BX34BWESQD\/drlErs5tGpkAZYsccfhCxdQbzujsgI39u3FuEmTkFFVhW4\/ajt3wD03Yu\/eHdi+\/bzUq2m\/OK3Uu2bNGnltu0kfV\/GhOzivXbuW4mPAzb9FLojio18mguLDydj1xlRe24zI9EqEp1QM6Met5HIcDXuCT4ZPx4KNgQiNl4JoA\/yab8v1JRfUGoH1\/NJqQ0N9PubPn4F9QUHo2Iu4ohxXt2\/D0JEjkSZuhSapMVAsd+LCwkJTMj8+PgG5ubmor1e50ibPNWZnY93dOCkpyTxKSkqkwFx7YSQ9LycnBwnx8UhJSUVZWZn5nL5fUlIsVoY8eT3FtNnQ0PD8EEUQN8kYUlOSzYaF2dnZZhx1cl6b\/K+qqgJl5eUdVpvGxnoUS5uNYr1pbWuWNnPM59RykShjKyzUcbV30dTUaAri6bVo\/zr+3Nw0LF\/uBXf3jbh9OwWlMtaaulpj9VBXixbR0zF2FR8qSPTzeo26zUBxcTFa5Qbi6IOWD0cT7qf2KT76BTzFh5OxN7W0ITShDH\/2jsQ76yLx4fp7+GiAPvTa3lsTjv8z7yz+sDgEH\/rcHbDXapvD\/1gdgfknElFc1bVQUbv4WLBgJgJlM8DO4uPaju0YNmo0MqorUFiSCi+vhVi4cCF++uknvPPOXzF16hS5Od+VInLNePDgOiaJlcTd3R2fffYZPvnkI6xatUo2F8yRyozA3Tt3MG36dLz3\/vv49ttv4ecXgNraBhEeuVi9eiUmT56Mb775BkuXLjU37s7Lv6WyHA\/27cc3n36Jv33wIcaPGydiaT5uRkWhUWw1Z4IOImDPXrRHXrQhJfk+Vq5djcSCfNQ2FmPpEg98\/PEn+Nvf\/obPPvoQKxZvFCHRXq46IyMRnp4emDhxgozrG2PdWLZsKf70pz\/iv\/\/3f8DXXw\/GoaNHkSbiRHdrDhKBpi6YFywfIt5jxP0yf8ECc41fffWlWEXWidAp73wpDvmZ4sMhWPu\/UYqPfpkDig8nY28UV8SZR0X4O69bmHosAd5XM7DhWibWD9CHXtum0GxsvJ41YK+xY+6uZ2JQQBSG7X6MvIqu8S09i4\/Mmgpk5kRj8OBvMWPGDFwQ98ytW1fkpj1XhMNO+YbfhCuXj4ogeQfe3j64fv0qLl06hgkTxuHEiUhUJRdj36aNWLx8Oc5evCjCYwumTPFARESFxJqkYty4Mfj1199w5MhRYzHRm\/uzowWJ0TcxZ\/wU2VAsGJcuh0ofa\/Hhhx8i8Ow5Iz727tmMJeu8obYUVToxT25gyoxpeCRWiqa2JsTEROPy5ctm3Jd37sSG6XPgt3Uv1CYTH\/8Qv\/zyM8aMGYtz584b4ZOQEC0iax6mTVsmn4lEjgiP1PQ0+Pj4YKd8XgNMdQ+jDsvHkydoKylF0I6dWODhgTNyjbt27cL06e7SbzbqOhSdGaDd\/6H4sDtSazRI8dEv80Dx4WTsNvHxjyvuYGdELsIzKnA3oxIRfLg8g9CUckw8FI+Re6L7LD6y82IwYaIbjsmNtfGpzyIwcDe8PPeKS6MJ16+dxG8jRuBhSopZubW15SJOvLB16z2cO3YHP333Lf7PP\/4jPv3iC2NV+N3v\/iSWhDPi6ojBvHnzZRPCC6go7+Ju0ZbE6vFw\/26MGzsBKTntVoTMzBiMHTsSB2TzQrV8BO7zxTKf9R3iIzbmJqbNmoHHWdloFJfNjRs3MH78eGOR+fydd\/G33\/\/eCCG1ASUkRInImI1jR2+LSLCF2zbKePzh6xsklgtzOSKS0rFhwwbs3r37BfHxRMRH3MMouA0div\/1939vrlEtQ\/\/2b3\/Apk37UF7u2MJfFB\/tczTg\/qX46JcppfhwMnab+PgnER\/77uYhMrMSD7Oq8IAPl2cQJuJj\/MG4V4iPPMyaNQm+206hwmZ0kJgPm9tFLR85+bGYNWc6QuVGa7tFHz58CMuWHkZMbCPCQoMwcfo0ZNbWmpVbVVUpbpe1Ij6isH3HFQyRLdBVAOjNWx8nTpwQ10cisrPV7bFEdkFOEjdMN4u+qBCPtvhhqrhlMp5GfzY25InbZToOixBqEEeRTXy0S5NWdIiP9AxUZ2Rg4cyZmLtkCbbt2YM9IiDmi9tmzfoNIlwgwikK7guWyAaIhR2ZLW1tdTLuLSIcTkj8R\/uYehIfN2\/dwqjRozB82LCOazwq7hq1urwQw9LNZb7JSxQfb0LPwp+l+OiXyaH4cDL2zuJjr4iPuyI+VHjc58PlGbxafEBujpUSz+EhMRweErsRb1ZeugRNrpw7D9NnzkJZXSWyc6MxfMQQ+O7YgTJxO0iUJ3xXrRQR4CcBqE0ICTmOr8W6cTE0DM0SjFkuAZdTx0+Um3g4HoTEYOmc2dgqN\/+uWTP5+alYtMgLZ8\/GSyxFN4teRNC9XTsx9NcReBRThIbGVokzuSYuoEESo3LWWD4CAtZi8vSlEpcBaaMKe\/cE4JdhQxGVmISq27cx6ZdfcDYszDSecP8ePKZNxSpv7w7xsWD+YoSF5QmH9v47iw+JgzVHT+KjIDER3osWYfX69cad0\/4p5\/xL8eEczk7vheLD6ci1Q4oPJ2On+Bi4Qqsn8aEFs8LDb4j4mCzujLFYvHixuFgmwk0sFRevXpOMjQaxAETjt99+kmDP8eZ9z6lTMcNtAQIDb8oNvwnXxO3ykcRhaCDoYo+F8Bg\/GbOmrMHNWxloLqrGIUlRdZOA1HmenvJ5L4mJOICCAm03TeIrFuHMmbjuxUdTM+LDb2HkCDe4SX8LF3phgQR1fvzxxzhw7pxYPloRceEU5g6fhjGjPUVEydjHT8D3P\/+MKKnJUS0iaL6MdZxYTjy9vCS2Ywy+ENfPOrGAtLtdHmLeXE+Ehj4TH5B3jhw5KLEos0UYrcMtCZZNTk+HjwgLjeWwxXwcOHBAYl5Wt6faSjZM8JEjGDNhAubINXp5eSIgYKcIs4qOzBpH\/SdN8eEosv3croqPxAfc28XJ00Dx4WTgFB9vr\/hoX2otuHLlIuaKtUNv0LNmzcIpyexoNKaKNuRLzMeUqROwUoIuF0jGy+hRo6QWxpWnMRFNuHXzLH4Ta8PGgABMnjJZhMxMXL2a2hFsqamnmzdvFgHhJgLHTbJKNkmF0HpJuS0Rq8c5uYHnd1geui79ysoqnD59WoJUp0hGzUS5qW\/EyJHDcfTS5fa6JMUluCEFv0aPHi3jnyvj2otAEQa5FRUmPiU4ONi8rtel2TgB\/v64GX4bLdJRQUG2tH1OAl0rJIX2Wc\/xYvnx8fHGnNmzESzBqvmSNnz12jXcESFSJxGkKtgiIyNNIKum6eqhKcA7xDJku8Zly1ZLQGvpc+0+68F+PxnxsWYcinYtQUtlsWQ+y6S1iXOMD9dlIDbC1sY61NwPQcaUd7mxnP3+c+mxJYqPHhHZ9wSKj7ddfLxqPbVKjY5oTJ0xCSGS3qo37ecPifkQy4ebCIM0ccfYYkKeP8dev7WhrjbbxKgcPN+pKJq9mnfBdlokJqdo+0LkrR6DmgdX0VJdipaKYj5cmUFVKRqzk1C8ewky536Buifhksjl2P+yXHDpO2TIFB8OwfryRik+KD5evjrapB5HOgK2+eGRuDJe\/BPYjOjH4djk54cCsQp0jet4ebt9e6exoUQqjfrheuQ9E7fRt1YG0KfE0lF9NxjZHt8j32cCah6HoT4tGvWpj\/lwRQY6d8lRKL+0FxkzPkTxvqVQ6xYP5xCg+HAO545eKD4oPjoWQzc\/tIkJv7GxQSqkvig99HStVKpZHbppn6MPrWqqY9FKozzaCbTIN+XiwFVys\/oIxftXoC7xvgiPRxQfLio+qiPOI2\/NaGQv\/MHEfUDiP7oeWjVYq+hWiHtRf3bGf3tdxzAQf6f4cPKsUnxQfDh5ybE7exIQ0Vef+BD5m6YiZ9kQVIYeQ30KxYfLWX\/E6lEXH4HiQ+uQNfcrVF4+iNa67uvE6HYFWjwvTDK5Hj9+LPFLBab4nT2X1dvYFsWHk2ed4oPiw8lLjt3ZmUBLdTkqxFSf7fEdCvxmyU3sLt0vLmf5iEZFyEFkew5Gge9MNBc\/LTTTzVpRS6PuNRQREWECss\/I9giJkvJdKwVzaAXpBthrvkTx8Zqg7HUaxQfFh73WEtvpHwJt4hJrLs1HyYHVyJz1KcqDd7e7X9IY++ESFpD0JyZgOH+TFOub\/42J42lr7rodwvNrS7OuqqurzbYAp06dgqZ\/3717V8rwVD1\/In97bQIUH6+Nyj4nUnxQfNhnJbGV\/iZQG3sHuatGSszAGFTfk3Rkl\/v2\/3aKpYaMWJSe8kf6lPdQtHuxyVZ63bWkGx3GxMRIUb+tJt1b3TDtO06\/bgs8z0aA4sNGwknPFB8UH05aauzGwQTU\/VJ2dhsyZ3+CIg0+jYug+8XqAiztCapunjLxOrkrR6AxM6G9Xksv1kp5eTm0pP\/GjRulSN4R2VE6sxef5qk2AhQfNhJOeqb4oPhw0lJjN44mIMGnDanRyF8\/WbIlBqHy+lHUpURRgFhYgNTG3EKB\/1xkuX+H6vAgidnoPqvsVUtHLR26iaKfpLxv2rTJBKJqNV4evSNA8dE7Xm98NsUHxccbLyI2YBkCbY31qLoVJBkTn6Ng81TURt9AvcQU0AVjQZeOZLhofE7Wgq9RuHUeWqpK+rSONAD13r17xvXiI5WI1QqiAak8ekeA4qN3vN74bIoPio83XkRswFIEWiT4tHjfMmRM\/wBlp\/1RlyS1P1h8zHICrPreJeR5j0XOkl9Q8\/CarKG+1cpRy8fNmzfhL9sHeMvGibtl9+ikpCRLrUlXGAzFh5NnieKD4sPJS47dOZqAmO7rUx5L8OloaBxBdYSUo6f4sJT4qEu8h+K9UkJ95scoPeEr+7nU93lVaIrtpUuXsGXLFiM+AmSfpdjY2D6397Z+kOLDyTNP8UHx4eQlx+6cQKBNClRV3TgptT8GofjAKtTG3BYBQvdL\/7uf2svfazxO1oJvkeczEY0Z8W+0Impqaky9Dw04VbcLxUffcFJ89I1bnz9F8UHx0efFww9al4CU5W7ITkTh9gWyQdln7bU\/ZN+Q\/r\/5WjD2wqkBqdFGCOavn2g2jquW+Jw3PbTex+HDh43wUPFBt0vfiFJ89I1bnz9F8UHx0efFww9amoAGn9ZG35Tg0y8ktmA8qiMvMvjUqUKji9BS15eUvi+\/sAtZ878Wi9Qa2Tgu\/43XkKba7tmzx7hc1q9fj4MHDyI9Pf2N233bGqD4cPKMU3xQfDh5ybE7JxJoqalAyaG1yJzzmcQWbEZd8kNaP\/pLgEjF2ZpH15G7bCjyVo+WOix3e13To+vS0UqnWtdj+\/btWLduHVR8nDx5Erm5Ly\/P3rUN\/t5OgOLDySuB4oPiw8lLjt05kYCWXm\/IjEPeWjfkLP0VFVcPUnz0i\/gQd8uTcEmpnY\/0ye+iKuwU2poa3ngl6A7PycnJJs3WJj6Cg4PNrrdv3Phb1gDFh5MnnOKD4sPJS47dOZlAW3OT3Owk+NTrJ1NPouZRKLNfnClAxN1Sl\/hA4m72ImPa+yjev9LsxWOPZaAbyeXn52Pnzp3G8rFhwwZTcEzjQKx8tIoobutjarGjroviw1FkX9IuxQfFx0uWBl8eQARaKkpQvGexxH+I++X4Rma+OFN8SJG36qhryFs\/QTJcvjS7DkNuvvY6dDM5LSymLhfNeHn06JE03\/v2nbMjbhuKilLh5++LhJxctNgLgh3aofiwA8TeNEHxQfHRm\/XCc12XQF18pIk30KJWVVLKm7U\/ugSEOkKQqNVDuJee3IKMmR+h5Ih3rzaOe53VppvL6Y62urmcChAtOKbpt69\/NCDkylm4L3BH0LlzqJc4Ei14VlaWjcD9+5Ccl4eepExFRRGOHTuOmCdFkOG84mhFRvoDjBozCuEJiWh+xZnOfoviw8nEKT4oPpy85NhdPxHQGIPy87uQveAbFO\/2Ql3CPcZ\/OEJwdGmz8vox5Cz+VeJuxpq9dyBp0PY81GJRUlKCoKAgbN682aTd9m5zuRopULYS\/+2\/\/R3cxs9FYppKgjbkZD\/CmLGjcTM2rkeRkJ+fgpkzZiM4OA11da+6ulZkZjyE2zg33JEqrH2r6fqq9vv+HsVH39n16ZMUHxQffVo4\/JBLEtDg0wLfGcj2\/AHlV\/ajNv6uPCL5cASDxPsmvTl\/8zTZafgzU2nWHkGm3S08dbOkpqaaTJdt27bh1q1bvbB+1GDbVm\/88U9\/xODBY7DZ7zyqmhqRkxONsePdcCsuvt09UlSMkBPHsXz5cnksw4EDZ1FQoBaSIok58cc777yHESNmY\/uOQKTr3jIV5bh1JgjL5PxVq1aJKDqN4qI6ER+PMHrMSGwNDMQWKQm\/ctVqhIREo7qquytz3msUH85jbXqi+KD4cPKSY3f9SKCtoQ6VYSdEfAw2j8Jt7lKIzIMPRzDY4YncNW5In\/YeinYuQmt1uUNnXi0gaWlpOHPmjIkBUQGiv1dUVEBTcl9+1Mi+MGswdKgb5s5dimGjx+B+\/GNkZERh3ISxCI+LQ6PEldwN3I8ZQ8fju+9\/w28\/DILbzxOxa2cYYmLSsWzZYvzjP\/4TPvjgO3gsWoLoxMd4ciUYC0dNwTffDsHw4cOwdq0vsrNrkJ7+CN999xV+\/eVXjBg+HEM\/+wJTR3oi5EZSj+6dl1\/Dm79D8fHmDHvVAsUHxUevFgxPdnkC9QmRyFkxHCkj\/xmZsz6Rb+Wf8uEIBlJbJX3KO5LhIhv8BW2FCj9HHypA8iRGQ4XHsWPHcOjQIVy\/fl1u+tmvCEKtgZ\/fKkybtgIXz0RjhbsHNm3xxoOEUIydNA63Y2KlKmsMFo0fj42bD6FSLRS1NbiwezeGDxuPGzcTRagkYdasObhwIVnfQmt5NlZ7zcOKldtRUiZOHBlX+9Eqgug+Pvv8E8zzWIQsqVHSlhQHz7FjsMpPNkF0NKBXtE\/x8Qo4jniL4oPiwxHrim1ak0BrXZVku2wyKZ+FOxai6m4wqu9d5sMRDO6HiGvrAHJXj0SOpDnXS3l7e8d7dLfKmpqaTJ2PO3fuYO\/evdgtIiEiIgL6evdHu\/iYPEV2Qn5SjZtHT2DcFDfsurgTI8aNxh0RHrUS0OrvvhDBly53NHH7djimT5+D48cvissnFrNnz0XwxVTItkJojXqA9VOnYOvefV2sGe0xHxpLEibtmuiS5mJ4r1uMzXv2Unwo3U2bNmHhwoU9mKs65sFlf6D4oPhw2cXLgfeOgMQF6DbuOV4\/I0\/cATVR1025by35zYcDGEjgaZ3EfZSeDpDdaz8xNVaaix1bebShoUHcGukICwsTUXAcJ06cgIqQwsLCTtaHrsvmqfiYtFTiMYDk2HgsmjcXI0cPx9eDvmsXH\/fuYeOcuTh9Jrjjw7euX5Ug0+UIDS2RPlMwWywfFy+lo6FWLB2PorB20iT4bt\/bJZ32+YBTdQa1tpTIvjRLsUWECi0fAoTiY+DelO9nvR3XFpZSjvEH4zByTzTyKl6Z\/9bxB4U\/DFwCzcU5psJm9qIfUSHfyLnJnHNSbWukxkfhDndkLxqEqpun0FrfmzTY11+PKjxixJqgNT9UdDx+\/NhYQOrr61\/hctH2a+DruxKTJi5BWjrQXFWDW0eP4A\/\/+m\/4J3nciJZ04ZQUrJ4+HSuWBCDqUYZYSKIRuM4HEyd44smTWglOzcCcOfOwd99NpCTnoSY+DitnzcTMWatx736GiT3Jzy8U60uzyXYZI26W8MREI0xUfHh7L6HlQ6dCD4qPt+MGPZCFCMVH+3\/L\/Fe+iUqV04rzO5C9UNJs9y1FXdIDio8uKbEOEWNa50NYV0hmUc4SsTitG4PGrAS7L0kts\/7kyRPJQDlg9nl58OCB1Nt43S8cNZKtsgFz56yV2A0ZmoRnZIgwGDViBN59\/33cio1Fi7SVc\/Uq5g0bg9\/9\/j\/wH3\/4HYb+OAnnz2lqbasEtZaZe+ZHH30pmSxjEREZifMXLuDHH4fg97\/7D8mEeQczZ3ohNaVK4jyeYPrMqYhMTjEumdaWUhE\/a7H90GFaPnRlUHxQfLi6MKH4sPvfeJdtsF5qeuQs\/c0EmlaFn0G9VN10yM3WGTd0F+yjNi4CpRJ0mj7lPZSf2YaWqlK7rSVNs9Ug0yNHjkDLq6vVo3cby7VIymyuuE5yIMYTc6hwSZNMGRU0lbXiR9Gjrh5pkvmiLh19RD9JlHTe9rc0m0bLvEeK6IiKikKZZNhUSYn32NgYKfceZgqfPXkSL+c3Sx+10nYqqqQ9c7Q1y\/hzUCCpvD0VM2v\/gGP+ZcCpY7i+tFXGfAxckUXx8dJl\/1a90dbSJKm0C6XC5scoObZBvonfp\/BwtoARC0jNozDk+UxAzrIhJt5GrVH2ONStomLA19fXiA+tdqouGB69I0Dx0Tteb3w2xQfFxxsvIjZgWQJ6g6uOOI+sOV+gIGAuah6Hsay6s4WH6e+p++XyPmTN\/9LEgDTmpthl3ejeLppS6+PjY\/Z2uX\/\/\/isyW+zS5YBshOLDydNK8UHx4eQlx+6cRUDM8Y3ZSchdORK5K4ah6tZpulv6RXg8C2ytfXJLgn7nImvelxIHcvCNg0\/V5ZKTk4MdO3Z07GobGhoKFSQ8ekeA4qN3vN74bIoPio83XkRswJIEWqXgQtm57ciY\/n67uyWRe7n0e5xLymMjArMXDUbuqpHQWJw3OTTQNDk52Wwqt27dOrOx3Pnz52Xn2KI3afat\/CzFh5OnneKD4sPJS47dOYOAuFvqYm5LTY8fkec91uwxwiDTZxaIfhMhmv0ixcZKjvqIKPwQJftXovUNgk\/V8qHVS7dv324sH7qrrQac6ms8ekeA4qN3vN74bIoPio83XkRswHIEmgoyUeg7W4pbfdxe00MLifWzy4H9PxM\/6n7J3zRN9tf5CdV3zkl6q638eO+XUnl5ualk6u3tbeI+NN1WM1V49I4AxUfveL3x2RQfFB9vvIjYgKUIaBGriquHzTdrLaGuN7p6+cbNm\/+zm3+\/sxAxWHH9qMTjjEDhtvlozEvt8xqqlpRWTbNVq4cGne7cuRMJCfavJdLnAbrIByk+nDxRFB8UH05ecuzOwQQaxKyfs\/RXZHsNNtu4U3hYSHR0sj6pKCySgm9Z879C6dH1fQ4+rZFiG0FBQaY2lVo\/AgICTKVTBy+zAdc8xYeTp5Tig+LDyUuO3TmQgG7bXnZ6q+xS+zlKT22RvUUkyJRWD2tafcT6URVxQQJPRyHb43vUProh7pfel9mqq6vDlStXTJ0PFR9bt26V4l6xDlxlA7Npig8nzyvFB8WHk5ccu3MYgTbUPr5hbmT5m6ZKIatQCo9OloZ+d7V0M5Y6ESClp\/2QOfcLFO3yRGtNZa9XhxYUCw8Ph7+\/v+yR4o19+\/aZDJheN\/SWf4Diw8kLgOKD4sORS06j8fXBw\/EEGjJiJbNlHDKloFjV7bNPv+0z1sOKoqNjTGKVqo2+YeI+sqX4WKVs+Nfa+LTs+GsuGS2FroXF1OKhMR8nT540tT9e8+M87SkBig8nLwWKD4qPNom0V4Ggz90dNgHxsve7+0z7a7U4f\/4ETl28CN0dwtYPxcjLifX1nRZ1t5zYgowZHz0tof6QVo9uLA0dN32LvVcZelzcLyNM+fWG1Gjxvuhm8693qNvlqmz6puXV9REREYFa234sr9cEzxICFB9OXgYUH2+7+GhGcPA52Q57DvbsOYWSks4LsA1lZVlSP2A15s6dh\/vx8WYL7M5nvPrnCvhuWY11EgBXLSdmyJaZ27ZtM3UINEKfh\/0I1EXflCDTISZ7Ql0v\/3975\/1VVZbt+\/\/j\/fBuj\/H6\/nB79Osefce7HavKrq6qriq7rLILyzLnnBAxB0SMmBVBEXNWzIJiDiiKImIABZUkEgQk5\/B9c248FuLhCHI47H3Odzm2wI5rfebee333XHOtZdZKlvmyE\/wq3o\/K5DgUHgkygk8Ldi1CfXlxm24OFfQ6oJh2r123bh1OnjxpTDLX\/g+FNl3OrXei+HCxeSk+PF18VMlkVCvw17\/+FWPHTsWdO8m\/3IF1Mo32jQv4ptun+M1vf4sT166h7petbfitFJs2rsRqERw62HNubq54QiJllkupHGUyLCbnEKgvzEH+rsVG3EDh8WBUPbtH8WEyz8YHRZfMMlwefxG5MvZHxrTuKI+NQkNtzQdvEH2OtMlFe7ioAElJSeG8Lh+kZn8Hig\/7XDptbUvxcTujBHczS7m4AYO2zWpbJYFq6zFy5ChMmDABodu3oepN80tZQS6Oy9fUqEGD8eU\/\/4lT168bng+dS0LHFViwYIExi+Z1XV8vskSabqqePcNOCXzzl22hoesw2Xss1oZtMcSHDoZ0584dIxK\/rq4alZWvcejQfixevBgBAQFYumwpzp6LQbnhFGlEfn6mfMmdwKlTp4zRG5csDURMTIYc12mPg+VO3FhbjeIL+5E51wu5wb4ol\/iBquccUOyDlb0pxYmM\/SG21J4vuUE+0IHipLHS7j2pU9gXiJsyPj5enqFDOH78OJJkunuKeru42rSS4qNNmJy3k018\/N8lN7Hl5ktcTy1GTBoXd2BwLqUQo\/YkYtiOB8gubu0rqkl8aOU\/dZovfGYuRnq+3F8iQLIS4zHNdzJWy+BF\/fr3x8lr0WiU4LaoY0cxafJkjBwzBsOHD8O8efLVnVGNsqJ8RAYFYfjPo2X\/oRg0aBC++uorBG7YgHI55TMRJitWrJDmnR0oKyuRduk8hIQEYdy48Rgj5\/IeOBCLfQNw+eoj2bse9+5dxLfffoPBIn6GDxmMYf\/6HlPHrcTt+y\/AEFZ9BzSi8vFtvFw0SIZR74PSGydEeGiAqYoPLpZj8Cb49NXOAPFidTcGimuofH+CuOLiYjx8+BA6gZwK8wsXLiAzMxM6zwvTxxOg+Ph4dh91pIqPU\/df4f\/4X8dwqaj8Ip7BX5b5XCzPYMbxFHy+5g6GivjIcSA+Qjauw9p1odgbugNLZqzCufNpqCwqxrUDh7F8UQgiDhzBiKFDjGaX7KcpWDhlCsZNmoRDElW\/TLwVXl5DceLwfaTERmPc6FE4dSYBNbWQr7JbIk4GI2DVaiPmQ8WHTn61c+dOY9bNBhE4L1++xPlz53D48GEcES\/LzAEDECgR+\/XyLy7uHP75zddYuT4IRfmvUJ1wByN798K2Y8fBRht53IVfwb5Aqaj+JWN7hKD6RTKqM55wsTKD9CSU3ozEy0CZiXjxIFSnihBv4fzQZ+by5ctG91odybSkpKTVYPGPqhQ89CCKDxcbXsVHxP18\/K+51\/CHxTH4bFUsunFxGwb\/OT\/6A+KjUrwP6xAUdBQv4zJxNmQDlgeukIr\/tgSZLsC5qHRkXL6NiUOH4rjEakReuozvv\/sOv\/vd7\/DNN9\/giy++wM99+iJy\/0E8lTbnqeLBiJWvMk2NjcUICV6O1aGb3xMf5TLld0VBIULEK\/KDl5c063yNb\/\/+d3zdrRtWrV8vsSV1SEi4hHGTJ+GhvGz1\/VtV\/gLTp03C\/jNnKD6UrzS55AZNkeaWaSI4HqOu9DXqSgq5WJmB2LC24CVKrh5G+qTPZYTaKHECvuvR0GBSbXbRxVEvNX0GmdpOgOKj7aycsqet2eW\/FsVg8bk0HIjPRfi9PBziYpeBPTa6rvmi7Fr+3Zxn8236e8v9bescHWM7R\/N93v89F8N3PfpAs4tNfBxDXk4NIk\/uw4CBA7Bo0SJMnjodKRnZyL8dhwlDmsTH1es34COxIcES15H\/+rX0hnmNYvnyqiksQKbMpjlp2HDcuKvNJkBFeQ4Cl83HipCQd8WHDIJUXliI19Il0HvECISfO498iQd5Jn+vmTsX6+TcNvExYcpkPH4zPXhlRZYIosk4cCaK4kP41hW9QvbKccjfvaypd4RUSuoN4WJtBo0iNrQ5LWPylzLp3GkRH+JGZOp0AhQfnY743QvYxMfvJOZjR2w2bqWXIC6jFHe4WJ7B1edFGLc\/6YPiIzh4rcwLcVR6owC3b8XA6\/vv8fvf\/wEbN21F6esiFN6OxTiJuzh29SrKcrIRJMGkActX4OHz58bsmdnZuagrq8aLK1cxYsAQhGw6hYePnst8E8fQr28fLJRmFI0hfRvzIc0u5fn5KJI2a98RI7Ff5qV4npaGHVu3oG\/v3r94PiTmY7yPN5Ly8oybVsXH9One2H+ang8FUvc6F9krxiJ\/TyDq7cQGGND4n\/UIyBgfVU\/ikOHzFcWHC61H8eFC2Hopm\/j4vYiPnSI+Yt\/0domT3h5crM2grb1dtm0LRVhYJHKljq+S2Ipwib34d8++iLmZJZVaHYri72K6eDtO37yJBpl74orMIzF0+HD85ZNP8Nlnn0rA6FQkPy5HYU4BgqTJ5Msvu+PPf\/4bJk6cZIwfsltiQzTgNDU11RgE6cCBA6iQcT7KxKOxdOEifCFBqX\/929\/wbffuRpDqrv37jZiPR4+iMXPeHKSIUNFUVZktPWzm4OjFS6g21nj2fxQfbmp\/io8uMSzFh4uxU3xYW2A4EohtEx8NMkhRHvLyimR8ALn5pLtsmXThe\/YsVXqjiPtaupXUyayZGeKZKCotM2IvdBbN5ORk6fYag5s3YyTyPgnl5doGrd1j86WXSrxsu2GMOfDixQsUSpOKjteoc1DoWB\/aRdAYNVWaCDR4TscpiJG5Ke7fv294RwqkSUZTpXzNZ0gUf9WbKP6Ghhq8eJGJwmIJsDP28Oz\/KD7c1P4UH11iWIoPF2On+PB08eHiG46XcxoBig+noTTXiSg+usQeFB8uxk7xQfHh4luOl3MSAYoPJ4E022koPrrEIhQfLsZO8UHx4eJbjpdzEgGKDyeBNNtpKD66xCIdFh\/a91kn2mk+2pv+rqPC5UnUvG0plHZlnYq4tbReAufmSrc\/PZ87J4oPig93vr\/duWwUH25qXYqPLjFsh8SHigmdO2Lbtm1GUJuWQAdk0dk09+zZY4xdsHTpUmMuiS1bthjR961N703x4b6VsqMgTXfa1raA0y55znlRJxCg+HACRDOeguKjS6zy0eJDh5jVIWfHjx8vwz17IU2i8zWpuIiKisKoUaMwQIZunixzUkycOBGBgYHGRDyOxIefn59xDnf+j54P9xVZFB\/u\/ORynA+3tS7FR5eY9qPEh86WqQJj5syZ6NmzJ3788ce34kObXLZv326IjQcPHhjTDes629C0rZUySCbIGiGjL16VgZV01s7Y2Fi3nLyH4oPio7VngOvNTYCeD3Pb56NzR\/Hx0eg6cuBHiQ8dc0Anq9KmlRAZyrm\/zMCpAxppqpXBC7SpRYXJxYsXjTEFHj9+DI35cJT0PH+TgY90Zk5d1Fty8uRJGfugwtFhlttG8UHxYbmblhk2CFB8uOmNQPHRJYb9KPGhgxdpQGlOTg4OHjxoNK\/YxIeKhTlz5hgeERUQw4YNw8iRI6ExH+oxaS2p58PHx8fwdmRlZSE7O7tpJk5pxnGnRPFB8eFO97MnlYXiw02tTfHRJYb9KPFhy2mpzJR56NChd8SHejjCwsKwY8cO6PTDumhA6hiZffOMzI7ZWo8XDTidN2+e7dRu+5Pig+LDbW9uNy8YxYebGpjio0sM2yHxoUGnLcWHNrto11vdZks6jPOsWbNkMq31Miy0zjrxfmJvF\/etlN2pR4ujsjDg9P3n2p3WUHy4kzWblYXioxkM1\/3qdPGhU34nJCQYc0jYipGUlIT58+djtc62KRNc2UsUHxQfjip2K2yj+LD3ZLvPOpv4yNs8F9UvUlBbmOPWS52Ur+61LG5eztr8LJTFRiF90t85q60LH1eni49MmZhqyZIlRjBqVVWV0cvl3LlzRgDpCZnK21GzCwcZowCxgshoLY8UHy58c3XBpWziI238Z8heOgzZy0e7\/fJy+Si3L2N24Ci8mPsTng\/\/A8pFhKBeZ3xk6mwCHRYfGnDavLeLBpVqzIe3t7fh6QgODjaaXNTroTNu6iBk9hI9HxQerVXqVllP8WHvyXafdXVFeSi5cgQF+1a4\/VJ0cDVuzB+BsN5\/RUrwLOTvW+7eZd67HIVHNqDm5XNjpmn3uWvNW5IOiQ\/t9fLw4UOEh4dDm1s0qbhQkXHkyBGjh4uO+bFv3z5jSvDWBhjT4yg+KD6sIjJayyfFhz7J7psaqitQX1GK+soyt18apIwHd2\/HsIF98TTpAeo8odxVZWh0s96VZn4aOyQ+nFkwig+Kj9Yqdausp\/hw5huB5+pKAto8rr0UBw4cKGM4pclHZVfmhtd2RwIUHy62Krvauq\/Iovhw8cPEy3UagXfFR2qrzeWdlgGe2O0JUHy42MQUHxQfLr7leDkSaDcBio92I+MB7SRA8dFOYB3dneKD4qOj9xCPJ4HOJkDx0dmEeX6KDxffAxQfFB8uvuV4ORJoNwGKj3Yj4wHtJEDx0U5gHd2d4oPio6P3EI8ngc4mQPHR2YR5fooPF98DFB8UHy6+5Xg5Emg3AYqPdiPjAe0kQPHRTmAd3Z3ig+Kjo\/cQjyeBziZA8dHZhHl+ig8X3wMUHxQfLr7leDkSaDcBio92I+MB7SRA8dFOYB3dneKD4qOj9xCPJ4HOJkDx0dmEeX6KDxffAxQfFB8uvuUsfzmdsuHJkye4ceMGsrKyLF8eKxSA4sMKVrJ2Hik+XGw\/ig+KD6AWjx7dw71Hj1Dj4vvPfJerR0pKEuLjn6C0tCl3OjnlxYsXcfnyZZSVlRkrjx07hmXLluHWrVvmK4Ib5ojiww2NarIiUXy42CAUHxQfQAk2bVyJFRs3otjF95\/5LlePAwd2YuXK3Xj5sil3ubm5byelLCgoMFYeP34cy5cvR2xsrPmK4IY5ovhwQ6OarEgUHy42CMUHxYeKj9BNq7By06Z3xYc0L9Tk5eHG1cuIiIzE6dOnZTboHMjk0SguLkZaejry8\/Pljm1EeUUREhIeIPtlJerqZFVVJbJSU5Er24vFW5CQkIBIOceFCxfEs5CC+vo6WWrw\/Pkz3L\/\/AFeuXEFcXNzb2ajfPgYyq2e1VP7RVy4Z19fKPjExEfmFr9Eg\/169ysbT589Ra0w01ojKyhIkpySjuKJCcqUenfs4e\/YsTsu1z0RFIeH+Y1RXNZ29WmaFTU5ONvKmno34+HjJSxzmz5+NYUOnYN\/eC3gi28vkXFrWdFm0EtTUUnxUVFYa+Tpz5gzOnTuHpKRE1NYKKCanEKD4cApGnsQBAYoPB3A6YxPFB8WHXfEhwkMr\/euhYfjpX73w98+\/wFeffYbZ0zeJSCjAwzsJCFu7DocOhYv2qMOzRzcwaOAw7Nh5G0WFtSh6nIj1ixfh1KmTuBkTg8k+Pvj622\/x\/fffY8GCReJVKEZR0SsEBMw3Zirt2fMH+Pn5GRV48\/u8ujgf18O2old3L\/zji68waNAgjBgxAkekgq9CtQia\/VgQGIiCBlUfDcjISMCsubNw++lT1KMcGzaswg8\/9MS33bvjh6\/\/iZkT5uDmrUzUNzZIHp5h2jRfDBgwAD169MDixYuxYkUgvvzyC\/z617\/Bd9\/1wpbt2\/E0M9OYUXXnzp0oLCw0smcTH7dv35bLNuCxiKsZM2ei+7\/+ZZxrxoxZSHmaq5uYnECA4sMJEHkKhwQoPhzicf5Gig+KD7viQ9wDz6POYPzgETh4IBrPnmYiM\/YWZk\/wweIl25B+PQlHpaKev2ghSstL8SAqEmOGj8CywLVIz3iBkxITMd13Nk5u24Nda9Zg6owZiDh\/3qjER4yYjIiIZ3jxIgtTpnhjsFwjKuoCtEmjWt0qttRYj2cPojF5zAQcDr8pXooMhIfvhwqV9SIEVHwcO7YDM\/z9kf9GfKSl3YH3lEm48SRZpAgkIPQFrl+\/Lt6Pc7iwezfWTZyMeQsWo1S8EumZySJkhmPcuMkSu3HbEBaFhTnYuHEdZs9eLU0qWSguKUGWtL8EBwdjk3iGmjw9v3g+VHzUvsrHMdk2ZsJ4HBPv0J69ezBq1ETs3ZuAkhKqD5s5O\/KT4qMj9HhsWwhQfLSFkhP3ofig+LArPiTaMu3gQfhNn4FnzzOb7jjxFgQHrYfv1Lm4c+M6Io\/sxCz\/ADxIy8aubduwdu1a+C8MwN3Hj7Bq\/VqsWn0K+\/ZcxoA+P+PX\/\/lrfNatG\/74xz\/iL3\/9BFu37pGmjGT4+8\/H1m0qPGrfv6vLSvHkwF5MGjMWD59lGNvLy1+Kh2QaQg8cMMTH8eM7MXPBgrfiIz39Lib7eiNGxYd4b85JU8uQoUPxyaefotuf\/oxP\/vsP8J0+HSU1Vch8kYwZM2bj8OE4VFTYRELtm5iPXSKOmrKUnZ2NkJAQhIaGvic+7ty5g8cPH2KseGN+9atf4W9ynT\/\/5c\/4n\/\/5I1atDJZyFb1fLq5pNwGKj3Yj4wHtJEDx0U5gHd2d4oPiwyY+VknlWmK7oUR8ZBw4iMVz54on4434kG2bN4di4cK9SEwqxZXL5+E3bx0OHk5ByOZtuCZND8FbNyMq8SymzJ+CvcfP4czlm5gwfrzRpHL37l0jriIx8ZFU4nlSMWdKs0sADoWrh8B24WY\/Ja4kefsOTB47Folp6caGhoZ8LFkyF2HS3GPzfEyfL56Pet3ciGfPbhuej5tJj1EvzSULfH2xJCgIMRLPEXfhIkJFqPgtCEBJbZP4mDfHX2I00iRWxHbdauzbt12CSXdKE07Tug+JD40V8ZFmJW9vb\/GgxBplfCiCJCcnW+JfNACGqaMEKD46SpDHf4gAxceHCDl5u018\/GZRDFZdzsDJxHycTixApBsvp5MKcTrJvcuo9juYkIcB2x9g6A4JBC121Im2qbfLsg0b8EoCKvVFXytqIEWaTkZJHMe584koL5P16Wnwn+KLgIW7pSkCKH32DCdWBGHo4MlYtCwQjyQgc8eeXVgVshK+M6biWsxNFMkxG6SyX7JqFUokAELHyLCloqKXEv\/hj4OH4iWA1ba22U8N4jx8GAP7DMTZC4+lCaQaly+fRe\/evYxml2rpGHzgwEYMGDgZdxJqkJv7CmFhIejp5YVoCWKtj78Hv5EjsfvoUQlIbUS8dIudPHo0ps+ejeKaSsPzMWe2nzT5PH9PfCxbthVPn9ZIUGw9XqrnQ5pdWno+AiXWRJtdKl5mY+eKFfCVmI9XkufmZWxWGv7aAQIUHx2Ax0PbRIDio02YnLeTio+I+\/n4j3nR+GRlLL7bcBc93Hz5V1CclDPO7cv57fo4\/Jf\/dQwX8ZHjUHyUYs2aRfjk75+jV9++6Ne\/H\/z9FuP+hUc4vGQV+v84BF5efdD3u+8wZcJyXLqciioNzagtx+XDO\/D3bp9h7bp1eCU9Y+6fP4ehfftLj5HdSE0Vd4YImYunTmHYqFHw6tMH\/fr1xZw5C\/Dk8WvxfuSKF0U8H62JDxEMWU8eY\/rU6RLE2Q8\/\/9xfYkSm4N89eyJ0335INY8X8bewcsI0fPVlXwwZMhTjxcvSW8pw87F4Pl6\/xmoJIvXq3Rs\/yzqvXr2MYNCFS5eitK7aEB\/z5vpLPEhz8dGA8+ejMGzYOPTvPwr7pOnpqbhANko35M2bN79tdjlx4oQEp64wxAek507c1SsYLR4ar3790FfK6Os7A3fjXjb1\/HHe4+qxZ6L48FjTu6zgFB8uQ910oaraBsRnlGLthXQsO5OGwDOpbrssj0pDwInH+Mu4Nei9OBxLIlIQGOW+5bWV7VTCK1TUGO0SrdxdtdJUEGt82a+R4NB169aKN+IYXr2sQGnKM+zdvg2rV682Yjqio5+gvNx2mgZkZj6VmInDRi+VOgkWrZIeMpHHT+DOnRdvvQmvpLutdkHVmJC1a9dIs8YhCQQtk+0Vst9t8TDkq0axmzQAVZtrNm8OlXytky6z4VKxT8KW8HBU6BEVlUgVj4aeNywsTITDeVyQbrO54kpRH8uDBw+wc8cOI\/\/bJC4lIiIC9+7fR21DvQwYVmQEmmZmloiH45fL5+TkSC+dU0aAabQEqxaKF+ihDMD2SJaqqqZ+uqmpqUbzio4BoqlIrnf50iUErV9v5GXnzj3Sjfj1O+f95Qr8rb0EKD7aS4z7t5cAxUd7iXVw\/9r6RhRX1qG0qt79l+p6PE3PwoChIxAsMQoFJZUok3XuXvZqEZjuk15Ll9g5RsDpWw3kPoVjSVohQPHRChiudhoBig+noeSJ3iMgbvznMiCVjuugX8G1rX1uv3cgV5iFQGNjhQSIRhoBpK04S8ySVebDiQQoPpwIk6eyS4Diwy4WrnQGAQ0EbC4+9IXGRAIkYH4CFB\/mt5HVc0jxYXULmjj\/FB8mNg6zRgIOCFB8OIDDTU4hQPHhFIw8iT0CFB\/2qHAdCZifAMWH+W1k9RxSfFjdgibOP8WHiY3DrJGAAwIUHw7gcJNTCFB8OAUjT2KPAMWHPSpcRwLmJ0DxYX4bWT2HFB9Wt6CJ80\/xYWLjMGsk4IAAxYcDONzkFAIUH07ByJPYI0DxYY8K15GA+QlQfJjfRlbPIcWH1S1o4vxTfJjYOMwaCTggQPHhAA43OYUAxYdTMPIk9ghQfNijwnUkYH4CFB\/mt5HVc0jxYXULmjj\/FB8mNg6zRgIOCFB8OIDDTU4hQPHhFIw8iT0CFB\/2qHAdCZifAMWH+W1k9RxSfFjdgibOP8WHiY3DrJGAAwIUHw7gcJNTCFB8OAUjT2KPAMWHPSpcRwLmJ0DxYX4bWT2HFB9Wt6CJ80\/xYWLjMGsk4IAAxYcDONzkFAIUH07ByJPYI0DxYY8K15GA+QlQfJjfRlbPIcWH1S1o4vxTfJjYOMwaCTggQPHhAA43OYUAxYdTMPIk9ghQfNijwnUkYH4CFB\/mt5HVc0jxYXULmjj\/FB8mNg6zRgIOCFB8OIDDTU4hQPHhFIw8iT0CFB\/2qHAdCZifAMWH+W1k9RxSfFjdgibOP8WHiY3DrJGAAwIUHw7gcJNTCFB8OAUjT2KPAMWHPSpcRwLmJ0DxYX4bWT2HFB9Wt6CJ80\/xYWLjMGsk4IAAxYcDONzkFAIUH07ByJPYI0DxYY8K15GA+QlQfJjfRlbPIcWH1S1o4vxTfJjYOMwaCTggQPHhAA43OYUAxYdTMPIk9ghQfNijwnUkYH4CFB\/mt5HVc0jxYXULmjj\/FB8mNg6zRgIOCFB8OIDDTU4hQPHhFIw8iT0CFB\/2qHAdCZifAMWH+W1k9RxSfFjdgibOP8WHiY3DrJGAAwIUHw7gcJNTCFB8OAUjT2KPAMWHPSpcRwLmJ0DxYX4bWT2HFB9Wt6CJ80\/xYWLjMGsk4IAAxYcDONzkFAIUH07ByJPYI0DxYY8K15GA+QlQfJjfRlbPIcWH1S1o4vxTfJjYOMwaCTggQPHhAA43OYUAxYdTMPIk9ghQfNijwnUkYH4CFB\/mt5HVc0jxYXULmjj\/FB8mNg6zRgIOCFB8OIDDTU4hQPHhFIw8iT0CFB\/2qHAdCZifAMWH+W1k9RxSfFjdgibOP8WHiY3DrJGAAwIUHw7gcJNTCFB8OAUjT2KPAMWHPSpcRwLmJ0DxYX4bWT2HFB9Wt6CJ80\/xYWLjMGsk4IAAxYcDONzkFAIUH07ByJPYI0DxYY8K15GA+QlQfJjfRlbPIcWH1S1o4vybWXzU19ejuroK+pJtbGwJsRG1tTWoqqpCXV2dsbGhoUH2r5b1tS13tvu3bf+m8793AbvHcCUJmIUAxYdZLOG++aD4cF\/bdnnJzCs+GnDz5jVMnuwNf\/\/lSE+rgWiLt6mu9jWCN6zGkCFDcOT0adTIlidPnmD9+vU4ePCgIUre7tzKL+np6diwYQP27t2DkpKSVvbiahIwJwGKD3PaxZ1yRfHhTtY0WVnMKz7qcOLEIXz55Zf46af+OHUqWjwgbzwaDeIReZyAkb1\/xP\/+j19hZehmlAvX3NxcXLp0CXFxd97zfmg5dWmeCgoKcPnyZcTGxr4nVlru3\/Lv5udx9LvtuObXNtY5OojbSKANBCg+2gCJu3SIAMVHh\/Dx4A8ReP78OQYMGIBt27a9V2l\/6NjO216HyMijGD16tHg\/JmP2vLnIKys1LldTWYqz27dhxvgJ+OfXX2Od5FvFx6tXrxAdHY179xJQX1+LsrJXOHbssOEJWbx4MSZOmoh9+y8hP78p14WFhbh+\/Tru3o0XYaPNO8W4cuUidu3ahYCAAMyeNRuRVyMQ\/fAa5vnNhf+CBeKNuYnammpUVRYiIvIkEtPS0eSQqUF8\/C2cv3IVVahHYeELHD9+DJs3bzbOs2jxItxNv4vDp8Mxffp0hISE4OnTp52Hj2d2ewIUH25v4i4vIMVHl5vAdRnQeIXKykojdkHjFzp70ZiJpKQk9OvXD6GhoSgtLTViLDr7uh+OzahDRMQRzJ49C8uWLUHvfsNxJ6kMDRLeUZmVigVzZmL12jUYPWYM1m7Zggox0aNHj7B8+XJDPNTWViAn55GU6yd4\/egFb29vTBGBNan\/FBw6FgP1oajoWrFiBbZu3SrlLpKmlzQROuPQ5+c+huDx8vJCryFemBIwF5PHzMT4vv0wZ+4cvCzKx+uSVPhOnYST12+gKeKkDHt2h2B+4HKUyNmTkqLxUy8vDB8+HBNEJH3b\/VsMmzYMPnP94TN0Isb074+wHdtFqLzrjXHdncYrWZ0AxYfVLWj+\/FN8mN9GTsvhixcvpLnhBDZu3Gh8HesXcmcv+pX\/6aefGvETQUFBnX49LU9wcDB27txpCAb7AaIqPg5jQUAgIg6dxspp\/ti76xYK8opxJ+I0Vi8MxfljUZgpXpE1b8RHYmIiVq5ciT179ogHpwLZ2Y8wYGAfzJrvjyxpkkF+NtbMmAK\/wECoDyU1NRWrVq3C9u3bxUtShKKi5xgxYhAWr1iJPGmSiTpzBj169ICPz3yUZNfh8eULGD12AuJTXiL\/dRqmz\/BBxI2Yt+Jj395NCJBjS2XNvXsX8O8f\/43wEyeRLx6WdWvX4pO\/fSLepZOozavEvuD1mLdwBXJKKD6c9vB42IkoPjzM4F1QXIqPLoDeVZdMTk7G6tWrMWzYMAwdOtRly+DBgw3x4apr6vW0OSUqKgoVFeq3aJnqcErER8DCYDy\/W4DkE4cxe\/o0RF+Php9fAPaHJ6DofiaW+EzGajvio6amQmJAkuA7bTLOx92VhhBNpdgcuhorRNi1FB9Nno9UQ1CclKYb9WZER1+Dr+9UhIVtkb8akZx8D9OnzUdMTA5yc9IwY5YPImNs4qMcB\/ZvxkIRH+r5ePjwCiZIsGxiTi7KxIO1VwTRGPHSXLsWLedqwNGj+7Fo0SY8e0bxIUCYPoIAxcdHQOMh7SJA8dEuXNbeuby8HFlZWcjIyHDpkpmZCV1ced3s7GyjWal5MOYv1hPxcUrER8AGpD2vxZPEWPQf0BczZszABIndiEl4iIaMTCzy\/rD4uBB\/7xfxsfnD4uOUxIHYxMfUqc3ER4pNfOQiJ\/s5JnqPwcHTTeKjrCxPetosw9wlS9+Ij6uY4OONpNw8lL8RH2PHjjViUig+frEyf\/t4AhQfH8+OR7aNAMVH2zi5xV7Ne0e48+8fNlYdTp4Ml26268U7AGRnvcSU8ePw29\/8FvP9l0qTijSjpGcgYOIkrAwLeyfmY\/fu3RK3op6PRPj4TnrH8xEauhKBIcFvPR8a86GBtjbPx9Rp3rB5Pq5du4opU6ZI0GiYZLcRT5LjMdV3Hm7cyEVeTiZme0\/AnJk7cPZcPI4cCZeg3X7wmT3XEB8PHlzBOO+JSHwjPvZInjR49tq1a3KuBtl\/nwirjRJ0Ss\/Hh+8F7mGPAMWHPSpc50wCFB\/OpMlzWYRAHS5cOI1163YgNa0R9VXVuB8ZgeGDhuHEyXhUVkgfkxeZCPJfgLAD+1EppUpJSTGCZo8ePSYxH5XSq+UpFi0JwPWHj954Psqwb18YQkUIlMn+6unR3ijh4eEoLy8RASLNOEsDcOFOnLH\/7dux0F4y+\/cfkL0bJUYkEUuWrJKuvAWoLqtB9vnzGOnVF\/\/9\/\/4ksSIjMGnSJKzZuEnOXSdjjtyCX4A\/nuYXoEIGSTt+7BjmzJmD27dvy7kacObMCQQF7RFPE8WHAGH6CAIUHx8BjYe0iwDFR7twcWf3INAogqBMuqwWiZCQEskYHfXSCyhXYijKy2ubRjytq0WhdK8tkgHCtLurvoxfv35t9NhpbGyQ7rY1IkDyUSHNHk2pAcXFRXhdXGzsr4Guur8OMKajnTY01Br7l1c29UHRXkd6vG0Astraavm7EJVVEkGimkF6CmWlp0nPlkSjuSpHgloLi4rk3I2Sl0q8yn+Fmrp6NEjetRdRXl6e0ZNJ81Im3YYLC4ubytaUOf5PAu0iQPHRLlzc+SMIUHx8BDQeQgIkQALuTIDiw52ta46yUXyYww7MBQmQAAmYhgDFh2lM4bYZofhwW9OyYCRAAiTwcQQoPj6OG49qOwGKj7az4p4kQAIk4HICGjNUVlbm0kXnJtLB+vr27YsHDx4YcUWuyoNtJmmXg+YFXUqA4sOluHkxEiABEmgfAQ1O1kkKtev2ApkDyBWLn58fevXqhT\/96U8yCq+PS66p5dIRkQ8fPizd3bPbB4l7W44AxYflTMYMkwAJeBIBHRwwIiICOiidjmSrA8q5Yhk\/fjwmTJiAcePGueR6Wja9lnZRT09P9yQTe2RZKT480uwsNAmQgFUI1NfXy9xARUbXbO2e7e6LTkjJ5P4EKD7c38YsIQmQgMUJ2J8mwOKFYvY9mgDFh0ebn4UnARIgARIgAdcToPhwPXNekQRIgARIgAQ8mgDFh0ebn4UnARIgARIgAdcToPhwPXNekQRIgARIgAQ8mgDFh0ebn4UnARIgARIgAdcToPhwPXNekQRIgARIgAQ8mgDFh0ebn4UnARIgARIgAdcToPhwPXNekQRIgARIgAQ8mgDFh0ebn4UnARIgARIgAdcToPhwPXNekQRIgARIgAQ8mgDFh0ebn4UnARIgARIgAdcToPhwPXNekQRIgARIgAQ8mgDFh0ebn4UnARIgARIgAdcToPhwPXNekQRIgARIgAQ8mgDFh0ebn4UnARIgARIgAdcToPhwPXNekQRIgARIgAQ8mgDFh0ebn4UnARIgARIgAdcToPhwPXNekQRIgARIgAQ8mgDFh0ebn4UnARIgARIgAdcToPhwPXNekQRIgARIgAQ8mgDFh0ebn4UnARIgARIgAdcToPhwPXNekQRIgARIgAQ8mgDFh0ebn4UnARIgARIgAdcToPhwPXNekQRIgARIgAQ8mgDFh0ebn4UnARIgARIgAdcToPhwPXNekQRIgARIgAQ8mgDFh0ebn4UnARIgARIgAdcToPhwPXNekQRIgARIgAQ8mgDFh0ebn4UnARIgARIgAdcToPhwPXNekQRIgARIgAQ8mgDFh0ebn4UnARIgARIgAdcToPhwPXOPumJDQwOys7NRWlrqUeX2lMLW1NQgKysL1dXVnlJkjymnPrP67OozzOQ+BBobG5GXl4fCwsIuLVSHxYcWpKysDPX19e8URG9YXV9SUoLa2tp3ttn7Y\/369Zg7d+5757G3L9dZh0BlZSW2b9+O+Ph462SaOW0zgdzcXISGhuLFixdtPoY7WoPA3bt3sWPHDugzzOQ+BLRuPnLkCM6fP9+lheqQ+FDBkZaWhjNnzqC4uPhtQfRmffjwISIiInD8+HHcvHnTUFkqVFpLFB+tkbH2ehWf48aNw8mTJ61dEObeLoGnT59i6NChxvNudweutCwBfWbHjx9vfEBathDM+HsE6urqMH\/+fISEhLy3zZUrPlp8qDcjKSkJixYtwpAhQ5CRkWHkW1VVTEwMZs+ejalTp8LPzw8+Pj7Yt28fKioqWi2bio958+a1up0brEmgvLwco0aNwokTJ6xZAObaIYFnz55h4MCBePTokcP9uNF6BPSZHT16NPQZZnIfAuoEmDNnDrTO7cr0UeKjqqoKt2\/fNppJvvrqK\/Ts2dPwgGhBVGAEBARg6dKlxjptW9q9ezcmTJiA5ORktOb92LBhA6ZPn260RRUUFICLezBIE8\/Y4MGDjXtA2xhpV\/ewq82OsbGx6N27N65du0bbutF7S59VfW\/rs6vPsM3e\/Gn951ebSqdNm4bg4OCu1B74KPHx5MkTbNq0CevWrTNERr9+\/YwbVEuSmJgIb29v7N27923B9AU1c+ZMREZGthqYps0zep7+\/ftjwIABXNyEQd++fdGtWzf06NHD+EKmbd3r3v7pp5\/w6aefwsvLi\/Z1k2dWn1H1Zukzq8+uPsN8bt3nudU6VuvarvZGf5T40PiO58+fIyUlBQcOHDBuTFXHmm7cuGG4dKKiooy\/9T+N\/9Dml82bN7fa9JKfnw8NcNIvKC7uxUDviejoaNrVDe9ttSvt617Pq+39a7Ot7W\/+dB87a12rdW5Xpo8SH7YMa2+WQ4cOvRUf2qSiN6i\/vz8uXrxo281oD1bxoW1MbD98i4W\/kAAJkAAJkIBHEuiQ+NCeDM3FhxK8fv06FixY8J740GDSoKAgig+PvM1YaBIgARIgARL4hYDTxUdcXJwRONq8a+X9+\/cNb4g20WiwKhMJkAAJkAAJkIDnEnCa+EhNTTUo6mBDvr6+Rh9iHf1Q07lz5zBlyhTcuXOHg4gZRPgfCZAACZAACXgugQ6LD\/Vm9OnTxwhAVYw6\/seuXbswa9Ys7N+\/H6dOncLChQuxZMmSLg9w8Vwzs+QkQAIkQAIkYB4CHRIfOpKpBpiuWLEC2ndYkwad6lwPW7duNWI\/dBCy1atX48GDB\/R6mMfuzAkJkAAJkAAJdBmBDokPFRrq6VAR0nzyIV2vsR3as0UX3d5y7pcuKzEvTAIkQAIkQAIk0KUEOiQ+ujTnvDgJkAAJkAAJkIAlCbhUfKh3RCe1ae4laY2aek\/UW9J8actxrZ2P67uWgNqO9utaG3T06vpMtsWGuk\/L51aPZbIWAbWherbbYnNrlcxzcqu2UxuqLT+U7NW5nfncukR8aAG0+UWHZdfREHUSKh0jpLWCKazs7Gxot10dml0XnUsmMzPTAPkhiNxuLgJqTx12X2OBmKxJQF9eaTKKsU4k5yiVlpbi8ePHb5\/bW7duGSMcO3reHZ2P21xPQG396tUrxMfHG+M26ftaB5Rs7X3t+hzyih8ioKKjqKjIqGt17C215evXr1sVkvqOfvny5Tt1rvZO1Xe2buuM5BLxoZMUHT582JjMRnu+6ARy27dvNwSGvULp5EU6qdGgQYOMOQYGy+RGw4cPx8GDBw2g9o7hOnMS0Hify5cvG92vz5w5Y85MMlcOCWhlpMMx64SR27Ztc7ivfihoTzedO0KfW50TRAcY1Bmw2\/L15fDk3NjpBFRgaEWlE4PqfFz6vp4xY4YxQKStU0GnZ4IX6DABnf5EB\/VU22mnD\/2pNm1tcledAFbrZH1mdV4frXtHjBiBI0eOdFqd6xLxod4OHedDu96qmtIC6Sy3Ov6HNsO0TApOb3odKVUnnNP9zp8\/b4Crrq5uuTv\/NiEBfYmp6FT7jRo1Cp988okhHk2YVWbJAQGdpfrKlSuYOnUq\/vGPfyAwMLDVvdXm+oxrpRUWFoazZ89C53iKiYkx7gV+ObeKzjQb9GtZp8HQsZr0o0GFiA6nMH78eOjHg35MMJmbgHb20JHH1WY61IXaUOvQcePGYc+ePcaz2LIEKkr040LrXT1G979w4QKePn3a6mSwLc\/R3r87XXyou04V1aRJkwxXnmZQKyX9GtIXlCqulklHRNWbXwWHHs9kPQLazKY3sapttXXPnj2Nl5j1SuK5OdYPAxUeK1euxPz5840vIu1W31pScaHd6nW26zRpoqHYaI2Ueder1\/nYsWOGaLTlUm2pgjI0NLTTvoJt1+LPjhPQd6\/OraYCxDaiuH5EqLjQ59c2IGjzK9lGJtfjdF9XpE4XHzriqbp\/Fi9e\/HZeFxUUGzZsMCombR9umbSd+Pvvv8fs2bONwcmWLVuGo0ePvhUvLffn3+YjoF9I6uVSr5d+QY0cOdL4KjZfTpmj1ghoM4l+CGibsS4qIpcvX97a7kazyrRp0wyXrT7vuoSEhBhfXhQirWIz1QYdlVo\/DjV2x5a0yW3s2LEIDw9\/+w63beNP8xHQjwb1YOlie+40nkMdAJs2bXo7JlfznOt4XfqB2LzOVRHamTPfdrr4UNUcHBxsCBCbolJltnHjRsydOxcJCQnNGRgBMQpC24zVBaQvO1Xd6rrXuBENXGOyFoF79+4Z7YfqkmeyJgH9WvqQ+NCPijlz5hgVlX5h6ZeWVlr6nGugKmM+rGf79PR0w\/Olzeb6oWirzKxXEs\/NsXqztJVBn8Xo6Oj3Qh00OFU9Hv37939b52qMyOjRo3HixIl3hKgzKXa6+NCbtz3iQ1WbtjNp+6JNdelPDZpRVaaR10zWIaAVjrY5avASxYd17NYypyoePiQ+9GtZX2L6QaFf0PpS05gPm9fL9vHR8tz823wE9LlNSUkxmtC0Irp06VKntf2br\/TukSMVitrysGPHDsProa0HxcXF7xVO61ztiaoxWrY6V3s7acyln5+fESz+3kFOWNHp4kPdPerl0EA128tHPR8qSDQeoGWzi9706t1QCPry0qRBphoooy5ddeMzWYcAxYd1bOUopx8SH\/qi0\/ZlfWnp821LOq2CfjRoEGNzV75tO3+aj4AKRxWQ2tyttlNPtC12wHy5ZY7sEdD3rn7Ea7Oneq00\/q61VgPdV0WJekhsda7aW0WLCs+bN2\/au0SH13W6+NACb5eAUx8fn7fBpVpIW7c9fVmp8lKBoQVXgaLd9TTC2gZL4wcUoj4I2v7IZB0CFB\/WsZWjnNoTH\/q86nOr4wConXVsHu0O3\/wZ1fgtffnpO6C5KHF0LW7rOgJqRxUe+n7Wr14Vj\/p+ZrIWAW0mVcGv4kGbWlr2EtVntnmdqwJDwxpsHwhaD2vguHo7W4ZGOItEp4sP\/SK6evWq4fbRbpfajVbdO9rtR7vz6M2u7j0NTlRRooorMjLScNXqfgpRwWhXv82bN791CzkLAM\/TuQTUvloZDRs2DPv27evci\/HsnUZAxYfGc+jXsC3px4EO\/qfb9EWmXk4dw0fjPbR5VL+89JnVQDe9B1iJ2ciZ92dOTo4hPHR8Fg0w1YBjHSBQPdS6jTY0r+1sOdPnUmM8fvrpJ2zZssV49nScHV20GUY\/5rVrrT6TGlysda7WzWPGjDHqZA2V0O7x6jDQcX1sTTG28zvrZ6eLD82oigpt79egUe1CqwOGbZcvIVs3Ww1qUZWmcFSs6EtMPR064IkC0IpLA0\/1ZabbmaxDQMWHfj3p169GTzNZk0CaBI5r06k2l9qSjji8Zs0a42NBg03V1hrzoc+sBrfpB8bEiRON7XTb26iZ+6c2a2sl1K1bN\/To0cPoAaE9D7UDALvamtt2ttxp\/IZ20vj888\/RvXt3w4Y\/\/PADvLy8jHpUHQBa5+qzbBt0TJ9l7ZU6dOhQo47WOnfVqlWGs6Cz6lyXiA91z2qbkn4hKRj1dGg3IFv7kg77qqraNoCNvsRUkSkY3V9\/qlCh6rbdXtb6qXbVYXrtBTtZqySem1uNA9ARLpt\/Bek6bWrRZ1mfWU1q64yMDOO51a9l\/Ypic4t17ht1u9vsZ\/taVs+HvoPp+bCGHfUZVA+H1p36DKod1Yb6U9\/D+iFgq3NtHwX6\/KqToHmdawuJ6KxSu0R8dFbmeV4SIAESIAESIAHrEaD4sJ7NmGMSIAESIAESsDQBig9Lm4+ZJwESIAESIAHrEaD4sJ7NmGMSIAESIAESsDQBig9Lm4+ZJwESIAESIAHrEaD4sJ7NmGMSIAESIAESsDQBig9Lm4+ZJwESIAESIAHrEaD4sJ7NmGMSIAESIAESsDSB\/w+nkgCF++KC9wAAAABJRU5ErkJggg==","width":317}
%---
