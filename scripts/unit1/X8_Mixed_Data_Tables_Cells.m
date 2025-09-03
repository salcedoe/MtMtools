%[text] %[text:anchor:T_D8E3C10E] # Mixed Data Variables
%[text] Online Documentation
%[text] - [Cell Arrays](https://salcedoe.github.io/MtMdocs/matlabBasics/Cell/)
%[text] - [Tables](https://salcedoe.github.io/MtMdocs/matlabBasics/Tables/) \
%[text] Up to this point, we have been focused on storing a single type of data in a variable. Either a Character, Numeric, or logical type. 
%[text] But many variables in MATLAB can handle mixed data types. In this Live script, we cover two types of such variables: Cells and Tables. 
%[text] ## Learning Objectives
%[text] - Create and Index Cell Arrays
%[text] - Create and Index Table Arrays
%[text] - Understand which variable type is best for which Data Type \
%[text:tableOfContents]{"heading":"Table of Contents"}
%%
%[text] %[text:anchor:H_318D79F1] ## Cell arrays 
%[text] The grab-bag variable type can be used package anything in its elements
%[text] - Useful for organizing disparate information: numbers, characters, and/or boolean
%[text] - Can contain all the fundamental data class
%[text] - Can even contain another cell array inside of it, or any data type, really
%[text] - No need to worry about dimensions of each variable \
%%
%[text] %[text:anchor:H_D67D6267] ### Creating Cell arrays
%[text] To create a cell array, you use the Curly Brackets: { }.
%[text] Here, for example, we cobble together a couple of numeric arrays,  character arrays, and logical arrays, and even another cell array. 
clearvars
c = {[1 2 3 4; 5 6 7 8], 'hello', [true false], 'goodbye', 10000, {'a', 2}} %[output:25d4eeec]
%[text] Note:
%[text] - The elements in a cell are referred to as "cells". So, the above syntax returns a `1X6` cell array with six *cells*
%[text] - The cell array icon contains a pair of curly bracket in the workspace
%[text] - Each cell in the cell array contains one of the three fundamental data type and each one is of a different size  \
%[text] 
%%
%[text] %[text:anchor:H_31471F15] ### Indexing Cell Arrays
%[text] Just like any other variable, you use the parentheses to return a smaller cell array.
%[text] Try it now. Index the first element in *c* using the parentheses
c(1) %[output:5ab8b819]
%%
%[text] Since Cell arrays can package anything into their elements, the contents of these cells remain effectively hidden access them. To access the contents of a cell, you use the curly brackets {}. 
%[text] Try it now. Access the content from the first cell in *c* using the curly brackets. [MATLAB Documentation on Cell Access](https://www.mathworks.com/help/matlab/matlab_prog/access-data-in-a-cell-array.html)
c{1} %[output:2bd45d06]
%[text] - notice that the output here is not a cell, but a numeric array \
%[text] 
%%
%[text] Index elements 2 through 4
c(2:4) %[output:2ae46b75]
%[text] So, fairly standard procedures. You use the parentheses to get a subset of the cells from the larger array.
%%
%[text] Here we return the contents from elements 2 through 3
c{2:4} %[output:48e1cd8b] %[output:998fc513] %[output:86c8dbdf]
%[text] - Notice the output is just spit out, one after the other, overwriting `ans` each time. \
%%
%[text] Accessing contents of the  the last element in ***c***
c{end} %[output:2cbc6d19]
%[text] - cell arrays inside cell arrays
%[text] - can get tricky! \
%%
%[text] %[text:anchor:H_BA4AC070] #### Applying functions to cell contents
%[text] It is often important to access the contents before you try doing anything with the data. 
sum(c(1))
%[text] - this doesn't work \
%%
%[text] But, if you access the contents in element 1, then it works:
sum(c{1}) %[output:688e8cd4]
%%
%[text] So, in summary:
%[text] - You use the ( ) to return a subset of cells  from a cell array
%[text] - Use the { } to access the contents of the cell  \
%[text] This extra level of unpacking cells makes indexing cell arrays REALLY tricky.
%%
%[text] %[text:anchor:H_63A15ACD] ### Practical Cell Array Usage
%[text] Avoid creating cell arrays with mixed datasets whenever possible. As you can see from the examples above, the indexing can get too complicated.
%[text] Cell arrays are often best used to organize different size words or numeric matrices. At least, that's what we are going to use them for.
%[text] Here is a cell array containing just character arrays
celly = {'apple'; 'banana'; 'orange'; 'peach'; 'grape';'tomato'} %[output:0392dbd2]
%[text] - Cell arrays are really nice for organizing character arrays, because you don't have to worry about padding the arrays with spaces to concatenate them together \
%%
%[text] Indexing is pretty straight forward when you have the same content
celly{3} %[output:0bdfbb34]
%%
%[text] Indexing gets a little more complicated for multiple elements
celly{4:6} %[output:869dde6f] %[output:00b1ae7c] %[output:0e8c24e8]
%[text] - notice here we getting one output spit out after the other, not concatenated or anything
%[text] - This is known as a comma-separated lists (even though there are no commas)
%[text] - This is also know as a pain in the ass, because you have to concatenate the output and often don't get what you want \
%%
%[text] But you can always typecast to a string if you need to:
stringy = string(celly) %[output:4fd537c5]
%[text] - and then you have the power of string arrays.  \
%%
%[text] And you can  go back to a cell array just as easily using the **cellstr** function
cellstr(stringy) %[output:9f487ac9]
%%
%[text] %[text:anchor:H_0627A8F4] ## MATLAB Tables
%[text] In MATLAB, tables are a type of variable class designed to organize multiple variable types. 
%[text] Consider the following variables:
clearvars
student = (1:10)';
score = [17 15 20 5 7 19 22 15 9 17]';
site = [false false true false false true true true false true]';
%[text] - Here we have two numeric arrays, one string array, and one logical array
%[text] - For the 'site' variable, true indicates "on-site"
%[text] - notice that all of these variables are COLUMN vectors (there is a little transpose character at the end of each line)
%[text] - All variables are column vectors that have the same number of rows: 10X1
%[text] - double-click on each variable name in the workspace to see their values. \
%[text] We could just use all of these variables to analyze our data, but that would be kind of a pain. We would end up having to input multiple variables into our analysis functions. And overtime this would become cumbersome and error-prone.
%[text] Instead, it's better to organize this data into a table. 
%%
%[text] %[text:anchor:H_24AB335A] ### Generating a table from the variables
%[text] Since the data are in the correct orientation (column vectors) and have the same number of rows, we can easily organize them into a table by just inputting the variables into the **table** function:
T = table(student,score, site) %[output:12020604]
%[text] - Inspect ***T*** in the workspace.
%[text] - What class is it? What size does it have?
%[text] - Double-click on ***T***. Notice its spreadsheet-like appearance in the Variable Editor \
%%
%[text] %[text:anchor:H_4B6544B0] ### Tables have nice formatting
%[text] - Try displaying the table in the command window by entering ***T*** and return \
T %[output:809d24c3]
%%
%[text] %[text:anchor:H_8F9A37A7] ### Table Properties
%[text] All tables have Properties structure that defines the properties of the table. You can bring up these property using dot notation, as follows:
T.Properties %[output:995a9af4]
%[text] - Notice that the syntax returns a structure array, which has a hierarchical data structure
%[text] - Data in a structure can be accessed using dot notation, very similar to a table
%[text] - The names of the columns are stored under the "VariableNames" field as a cell array \
%%
%[text] We can list all of the column names as follows
T.Properties.VariableNames %[output:16154c48]
%[text] - notice these variable names are saved in a cell array \
%%
%[text] %[text:anchor:H_102C463A] #### Modifying column names
%[text] To change the number of your column, you modify the VariableNames property. 
%[text] Let's try it now. Let's capitalize the "`student`" variable name. Be sure  to use proper indexing to modify just the `student` column
T.Properties.VariableNames(1) = {'Student'} %[output:61b13cfd]
%%
%[text] We can use **`regexprep`** to capitalize the first letter in each column header. 
T.Properties.VariableNames = regexprep(T.Properties.VariableNames, '(^\w)', '${upper($1)}') % capitalize the first letter %[output:916d18fd]
%[text] - **`regexprep`** returns cell arrays by default, so this works really well
%[text] - I found the required regular expressing using the following ChatGPT Prompt: "Use **`regexprep`** to capitalize the first letter in a cell array of words" \
%%
%[text] ### Accessing data from a table
%[text] #### Dot notation
%[text] There are several ways to access the data in a table. The simplest way is to use dot notation, which means to enter the variable name, add a period, and then add the column name.
T.Site %[output:80479a55]
%%
%[text] **Try it now**. 
%[text] In the code block below, type
%[text] ```matlabCodeExample
%[text] T.
%[text] ```
%[text] - Notice that you get a pop-up window of the column names
%[text] - Select one column name using the UP/DOWN arrow keys
%[text] - Execute the code block \
T.
%[text] 
%%
%[text] #### Indexing a column
%[text] If you index after the name of the column, as follows
T.Score(1) %[output:54e14511]
%[text] - you index the column of data
%[text] - Here we get the first element out of the score column \
%%
%[text] %[text:anchor:H_7C498C8D] #### Indexing the Table 
%[text] Just as with the other variables, if you use parentheses after the variable name of the table, you get a smaller table. 
%[text] Try it now. Index out the third column of ***T*** using the parentheses
T2 = T(:,3) %[output:0937f736]
%[text] - Now we have a new table, `T2`, that has just one column
%[text] - notice that the output is a **table**, not a logical array \
%%
%[text] - You can also index using the Column Name \
T2 = T(:,"Score") %[output:8cbbf6ce]
%%
%[text] Here we index out the first 7 rows from the table
T2 = T(1:7,:) %[output:1fce8bf4]
%%
%[text] %[text:anchor:H_02917F36] #### Using columns of the table to index
%[text] The Site column contains a logical array. We can use this column as a logical index for the rows in the table. 
T2 = T(T.Site,:) %[output:961be14a]
%[text] - now we just have the rows from the table where "Site" was true. \
%%
%[text] %[text:anchor:H_C5B7F797] #### Curly Brackets of a table
%[text] You can use the Curly Brackets to access data from a table. This is especially useful when you want more than one numeric variable
T{:,[1 2]} %[output:62e11ec1]
%[text] - here we get a matrix of the data from the first and fourth variables in the table \
%%
%[text] %[text:anchor:H_5D2D9C08] ### Now you try
%[text] Create a new table, t\*,\* that contains following :
Student = (11:20)';
Score = [16 17 22 9 10 16 21 14 8 18]';
Site = [false false true false false true true true false true]';
%%
t = table(Student, Score, Site) %[output:5f27a27f]
%[text] - ***t*** should have the same number of columns as *`T`* \
%%
%[text] %[text:anchor:H_88D53AF4] ### Concatenation
%[text] We can easily merge two tables using the square brackets. As long as the number and names of the columns are the same, you can use the square brackets to concatenate as you would any other variable. Remember, in this case, we want to add new *rows* to `T`.
%[text] Try it now. Concatenate *`T`* and *`t`*. Assign to *`T`*. Don't forget your semicolon
%[text] 
T = [T ; t] %[output:68f1f0a3]
%[text] - The final result should be a table, *`T`*, that has 35 rows and 4 columns \
%%
%[text] ### Sort rows
%[text] You can sort the rows of a table using the **sortrows function**. Here we sort based on whether or not the score was from a on-site exam.
T = sortrows(T,"Score") %[output:2e8a52c4]
%%
%[text] %[text:anchor:H_6E9990CF] ## Basic Analysis
%[text] We can perform stats on the data in our table by simply indexing out the data from a column. Here we calculate the overall mean Score
s = mean(T.Score) %[output:0be5cf35]
%%
%[text] Try it now. 
%[text] 1. Calculate the median score
%[text] 2. Calculate the standard deviation of the score \
m = median(T.Score) %[output:83019b9f]
s2 = std(T.Score) %[output:6d64d5b9]
%%
%[text] ### Specify rows for analysis
%[text] What's the mean of the on-site scores? the off-site scores? Hint: using the Site Variable for Indexing.
mean(T.Score(T.Site)) %[output:0fc7433b]

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[output:25d4eeec]
%   data: {"dataType":"tabular","outputData":{"columns":6,"header":"1×6 cell array","name":"c","rows":1,"type":"cell","value":[["[1,2,3,4;5,6,7,8]","'hello'","1×2 logical","'goodbye'","10000","1×2 cell"]]}}
%---
%[output:5ab8b819]
%   data: {"dataType":"textualVariable","outputData":{"header":"1×1 cell array","name":"ans","value":"    {2×4 double}\n"}}
%---
%[output:2bd45d06]
%   data: {"dataType":"matrix","outputData":{"columns":4,"name":"ans","rows":2,"type":"double","value":[["1","2","3","4"],["5","6","7","8"]]}}
%---
%[output:2ae46b75]
%   data: {"dataType":"tabular","outputData":{"columns":3,"header":"1×3 cell array","name":"ans","rows":1,"type":"cell","value":[["'hello'","1×2 logical","'goodbye'"]]}}
%---
%[output:48e1cd8b]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'hello'"}}
%---
%[output:998fc513]
%   data: {"dataType":"matrix","outputData":{"columns":2,"header":"1×2 logical array","name":"ans","rows":1,"type":"logical","value":[["1","0"]]}}
%---
%[output:86c8dbdf]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'goodbye'"}}
%---
%[output:2cbc6d19]
%   data: {"dataType":"tabular","outputData":{"columns":2,"header":"1×2 cell array","name":"ans","rows":1,"type":"cell","value":[["'a'","2"]]}}
%---
%[output:688e8cd4]
%   data: {"dataType":"matrix","outputData":{"columns":4,"name":"ans","rows":1,"type":"double","value":[["6","8","10","12"]]}}
%---
%[output:0392dbd2]
%   data: {"dataType":"matrix","outputData":{"columns":1,"header":"6×1 cell array","name":"celly","rows":6,"type":"cell","value":[["'apple'"],["'banana'"],["'orange'"],["'peach'"],["'grape'"],["'tomato'"]]}}
%---
%[output:0bdfbb34]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'orange'"}}
%---
%[output:869dde6f]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'peach'"}}
%---
%[output:00b1ae7c]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'grape'"}}
%---
%[output:0e8c24e8]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'tomato'"}}
%---
%[output:4fd537c5]
%   data: {"dataType":"matrix","outputData":{"columns":1,"header":"6×1 string array","name":"stringy","rows":6,"type":"string","value":[["apple"],["banana"],["orange"],["peach"],["grape"],["tomato"]]}}
%---
%[output:9f487ac9]
%   data: {"dataType":"matrix","outputData":{"columns":1,"header":"6×1 cell array","name":"ans","rows":6,"type":"cell","value":[["'apple'"],["'banana'"],["'orange'"],["'peach'"],["'grape'"],["'tomato'"]]}}
%---
%[output:12020604]
%   data: {"dataType":"tabular","outputData":{"columnNames":["student","score","virtual"],"columns":3,"dataTypes":["double","double","logical"],"header":"10×3 table","name":"T","rows":10,"type":"table","value":[["1","17","false"],["2","15","false"],["3","20","true"],["4","5","false"],["5","7","false"],["6","19","true"],["7","22","true"],["8","15","true"],["9","9","false"],["10","17","true"]]}}
%---
%[output:809d24c3]
%   data: {"dataType":"tabular","outputData":{"columnNames":["student","score","virtual"],"columns":3,"dataTypes":["double","double","logical"],"header":"10×3 table","name":"T","rows":10,"type":"table","value":[["1","17","false"],["2","15","false"],["3","20","true"],["4","5","false"],["5","7","false"],["6","19","true"],["7","22","true"],["8","15","true"],["9","9","false"],["10","17","true"]]}}
%---
%[output:995a9af4]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"  <a href=\"matlab:helpPopup('matlab.tabular.TableProperties')\" style=\"font-weight:bold\">TableProperties<\/a> with properties:\n\n             Description: ''\n                UserData: []\n          DimensionNames: {'Row'  'Variables'}\n           VariableNames: {'student'  'score'  'virtual'}\n           VariableTypes: [\"double\"    \"double\"    \"logical\"]\n    VariableDescriptions: {}\n           VariableUnits: {}\n      VariableContinuity: []\n                RowNames: {}\n        CustomProperties: No custom properties are set.\n      Use <a href=\"matlab:helpPopup table\/addprop\">addprop<\/a> and <a href=\"matlab:helpPopup table\/rmprop\">rmprop<\/a> to modify CustomProperties.\n"}}
%---
%[output:16154c48]
%   data: {"dataType":"matrix","outputData":{"columns":3,"header":"1×3 cell array","name":"ans","rows":1,"type":"cell","value":[["'student'","'score'","'virtual'"]]}}
%---
%[output:61b13cfd]
%   data: {"dataType":"tabular","outputData":{"columnNames":["Student","score","virtual"],"columns":3,"dataTypes":["double","double","logical"],"header":"10×3 table","name":"T","rows":10,"type":"table","value":[["1","17","false"],["2","15","false"],["3","20","true"],["4","5","false"],["5","7","false"],["6","19","true"],["7","22","true"],["8","15","true"],["9","9","false"],["10","17","true"]]}}
%---
%[output:916d18fd]
%   data: {"dataType":"tabular","outputData":{"columnNames":["Student","Score","Virtual"],"columns":3,"dataTypes":["double","double","logical"],"header":"10×3 table","name":"T","rows":10,"type":"table","value":[["1","17","false"],["2","15","false"],["3","20","true"],["4","5","false"],["5","7","false"],["6","19","true"],["7","22","true"],["8","15","true"],["9","9","false"],["10","17","true"]]}}
%---
%[output:80479a55]
%   data: {"dataType":"matrix","outputData":{"columns":1,"header":"10×1 logical array","name":"ans","rows":10,"type":"logical","value":[["0"],["0"],["1"],["0"],["0"],["1"],["1"],["1"],["0"],["1"]]}}
%---
%[output:54e14511]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"    17\n"}}
%---
%[output:0937f736]
%   data: {"dataType":"tabular","outputData":{"columnNames":["Virtual"],"columns":1,"dataTypes":["logical"],"header":"10×1 table","name":"T2","rows":10,"type":"table","value":[["false"],["false"],["true"],["false"],["false"],["true"],["true"],["true"],["false"],["true"]]}}
%---
%[output:8cbbf6ce]
%   data: {"dataType":"tabular","outputData":{"columnNames":["Score"],"columns":1,"dataTypes":["double"],"header":"10×1 table","name":"T2","rows":10,"type":"table","value":[["17"],["15"],["20"],["5"],["7"],["19"],["22"],["15"],["9"],["17"]]}}
%---
%[output:1fce8bf4]
%   data: {"dataType":"tabular","outputData":{"columnNames":["Student","Score","Virtual"],"columns":3,"dataTypes":["double","double","logical"],"header":"7×3 table","name":"T2","rows":7,"type":"table","value":[["1","17","false"],["2","15","false"],["3","20","true"],["4","5","false"],["5","7","false"],["6","19","true"],["7","22","true"]]}}
%---
%[output:961be14a]
%   data: {"dataType":"tabular","outputData":{"columnNames":["Student","Score","Virtual"],"columns":3,"dataTypes":["double","double","logical"],"header":"5×3 table","name":"T2","rows":5,"type":"table","value":[["3","20","true"],["6","19","true"],["7","22","true"],["8","15","true"],["10","17","true"]]}}
%---
%[output:62e11ec1]
%   data: {"dataType":"matrix","outputData":{"columns":2,"name":"ans","rows":10,"type":"double","value":[["1","17"],["2","15"],["3","20"],["4","5"],["5","7"],["6","19"],["7","22"],["8","15"],["9","9"],["10","17"]]}}
%---
%[output:5f27a27f]
%   data: {"dataType":"tabular","outputData":{"columnNames":["Student","Score","Virtual"],"columns":3,"dataTypes":["double","double","logical"],"header":"10×3 table","name":"t","rows":10,"type":"table","value":[["11","16","false"],["12","17","false"],["13","22","true"],["14","9","false"],["15","10","false"],["16","16","true"],["17","21","true"],["18","14","true"],["19","8","false"],["20","18","true"]]}}
%---
%[output:68f1f0a3]
%   data: {"dataType":"tabular","outputData":{"columnNames":["Student","Score","Virtual"],"columns":3,"dataTypes":["double","double","logical"],"header":"20×3 table","name":"T","rows":20,"type":"table","value":[["1","17","false"],["2","15","false"],["3","20","true"],["4","5","false"],["5","7","false"],["6","19","true"],["7","22","true"],["8","15","true"],["9","9","false"],["10","17","true"],["11","16","false"],["12","17","false"],["13","22","true"],["14","9","false"]]}}
%---
%[output:2e8a52c4]
%   data: {"dataType":"tabular","outputData":{"columnNames":["Student","Score","Virtual"],"columns":3,"dataTypes":["double","double","logical"],"header":"20×3 table","name":"T","rows":20,"type":"table","value":[["4","5","false"],["5","7","false"],["19","8","false"],["9","9","false"],["14","9","false"],["15","10","false"],["18","14","true"],["2","15","false"],["8","15","true"],["11","16","false"],["16","16","true"],["1","17","false"],["12","17","false"],["10","17","true"]]}}
%---
%[output:0be5cf35]
%   data: {"dataType":"textualVariable","outputData":{"name":"s","value":"        14.85\n"}}
%---
%[output:83019b9f]
%   data: {"dataType":"textualVariable","outputData":{"name":"m","value":"    16\n"}}
%---
%[output:6d64d5b9]
%   data: {"dataType":"textualVariable","outputData":{"name":"s2","value":"       5.1736\n"}}
%---
%[output:0fc7433b]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"         18.4\n"}}
%---
