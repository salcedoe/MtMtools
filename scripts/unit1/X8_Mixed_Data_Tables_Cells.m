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
%[text] The grab-bag variable type can be used to package anything into its elements
%[text] - Useful for organizing disparate information: numbers, characters, and/or boolean
%[text] - Can contain all the fundamental data classes
%[text] - Can even contain another cell array inside of it, or any data type, really
%[text] - No need to worry about dimensions of each variable \
%%
%[text] %[text:anchor:H_D67D6267] ### Creating Cell arrays
%[text] To create a cell array, you use the Curly Brackets: { }.
%[text] Here, for example, we cobble together a couple of numeric arrays, character arrays, and logical arrays, and even another cell array.
clearvars
c = {[1 2 3 4; 5 6 7 8], 'hello', [true false], 'goodbye', 10000, {'a', 2}}
%[text] Note:
%[text] - The elements in a cell are referred to as "cells". So, the above syntax returns a `1x6` cell array with six *cells*
%[text] - The cell array icon contains a pair of curly bracket in the workspace
%[text] - Each cell in the cell array contains a different fundamental data type, and each one is of a different size  \
%[text] 
%%
%[text] %[text:anchor:H_31471F15] ### Indexing Cell Arrays
%[text] Just like any other variable, you use the parentheses to return a smaller cell array.
%[text] Try it now. Index the first element in `c` using the parentheses
c(1)
%%
%[text] Since Cell arrays can package anything into their elements, the contents of these cells remain effectively hidden until you access them. To access the contents of a cell, you use the curly brackets {}.
%[text] Try it now. Access the content from the first cell in `c` using the curly brackets. [MATLAB Documentation on Cell Access](https://www.mathworks.com/help/matlab/matlab_prog/access-data-in-a-cell-array.html)
c{1}
%[text] - notice that the output here is not a cell, but a numeric array \
%[text] 
%%
%[text] Index elements 2 through 4
c(2:4)
%[text] So, fairly standard procedures. You use the parentheses to get a subset of the cells from the larger array.
%%
%[text] Here we return the contents from elements 2 through 4
c{2:4}
%[text] - Notice the output is just spit out, one after the other, overwriting `ans` each time. \
%%
%[text] Accessing contents of the last element in `c`
c{end}
%[text] - cell arrays inside cell arrays
%[text] - can get tricky! \
%%
%[text] %[text:anchor:H_BA4AC070] #### Applying functions to cell contents
%[text] It is often important to access the contents before you try doing anything with the data. 
sum(c(1))
%[text] - this doesn't work \
%%
%[text] But, if you access the contents in element 1, then it works:
sum(c{1})
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
celly = {'apple'; 'banana'; 'orange'; 'peach'; 'grape';'tomato'}
%[text] - Cell arrays are really nice for organizing character arrays, because you don't have to worry about padding the arrays with spaces to concatenate them together \
%%
%[text] Indexing is pretty straight forward when you have the same content
celly{3}
%%
%[text] Indexing gets a little more complicated for multiple elements
celly{4:6}
%[text] - notice here we getting one output spit out after the other, not concatenated or anything
%[text] - This is known as a comma-separated lists (even though there are no commas)
%[text] - This can be a huge pain, because you have to concatenate the output and often don't get what you want \
%%
%[text] But you can always typecast to a string if you need to:
stringy = string(celly)
%[text] - and then you have the power of string arrays.  \
%%
%[text] And you can go back to a cell array just as easily using the `cellstr` function
cellstr(stringy)
%%
%[text] %[text:anchor:H_0627A8F4] ## MATLAB Tables
%[text] In MATLAB, tables are a type of variable class designed to organize multiple variable types. 
%[text] Consider the following variables:
clearvars
student = (1:10)';
score = [17 15 20 5 7 19 22 15 9 17]';
site = [false false true false false true true true false true]';
%[text] - Here we have two numeric arrays and one logical array
%[text] - For the `site` variable, true indicates "on-site"
%[text] - notice that all of these variables are COLUMN vectors (there is a little transpose character at the end of each line)
%[text] - All variables are column vectors that have the same number of rows: 10x1
%[text] - double-click on each variable name in the workspace to see their values. \
%[text] We could just use all of these variables to analyze our data, but that would be kind of a pain. We would end up having to input multiple variables into our analysis functions. And overtime this would become cumbersome and error-prone.
%[text] Instead, it's better to organize this data into a table. 
%%
%[text] %[text:anchor:H_24AB335A] ### Generating a table from the variables
%[text] Since the data are in the correct orientation (column vectors) and have the same number of rows, we can easily organize them into a table by just inputting the variables into the `table` function:
T = table(student,score, site)
%[text] - Inspect `T` in the workspace.
%[text] - What class is it? What size does it have?
%[text] - Double-click on `T`. Notice its spreadsheet-like appearance in the Variable Editor \
%%
%[text] %[text:anchor:H_4B6544B0] ### Tables have nice formatting
%[text] - Try displaying the table in the command window by entering `T` and return \
T
%%
%[text] %[text:anchor:H_8F9A37A7] ### Table Properties
%[text] All tables have a `Properties` structure that defines the properties of the table. You can bring up these property using dot notation, as follows:
T.Properties
%[text] - Notice that the syntax returns a structure array, which has a hierarchical data structure
%[text] - Data in a structure can be accessed using dot notation, very similar to a table
%[text] - The names of the columns are stored under the `VariableNames` field as a cell array \
%%
%[text] We can list all of the column names as follows
T.Properties.VariableNames
%[text] - notice these variable names are saved in a cell array \
%%
%[text] %[text:anchor:H_102C463A] #### Modifying column names
%[text] To change the name of a column, you modify the `VariableNames` property.
%[text] Let's try it now. Let's capitalize the "`student`" variable name. Be sure to use proper indexing to modify just the `student` column
T.Properties.VariableNames(1) = {'Student'}
%%
%[text] We can use `regexprep` to capitalize the first letter in each column header. The function `regexprep` is designed to find patterns and replace them. I found the required regular expression using the following prompt: "Use `regexprep` to capitalize the first letter in a cell array of words"
T.Properties.VariableNames = regexprep(T.Properties.VariableNames, '(^\w)', '${upper($1)}') % capitalize the first letter
%[text] - `regexprep` returns cell arrays by default, so this works really well \
%%
%[text] ### Accessing data from a table
%[text] #### Dot notation
%[text] There are several ways to access the data in a table. The simplest way is to use dot notation, which means to enter the variable name, add a period, and then add the column name.
T.Site
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
T.Score(1)
%[text] - you index the column of data
%[text] - Here we get the first element out of the `Score` column \
%%
%[text] %[text:anchor:H_7C498C8D] #### Indexing the Table 
%[text] Just as with the other variables, if you use parentheses after the variable name of the table, you get a smaller table. 
%[text] Try it now. Index out the third column of `T` using the parentheses
T2 = T(:,3)
%[text] - Now we have a new table, `T2`, that has just one column
%[text] - notice that the output is a `table`, not a logical array \
%%
%[text] - You can also index using the Column Name \
T2 = T(:,"Score")
%%
%[text] Here we index out the first 7 rows from the table
T2 = T(1:7,:)
%%
%[text] %[text:anchor:H_02917F36] #### Using columns of the table to index
%[text] The `Site` column contains a logical array. We can use this column as a logical index for the rows in the table.
T2 = T(T.Site,:)
%[text] - now we just have the rows from the table where `Site` was true. \
%%
%[text] %[text:anchor:H_C5B7F797] #### Curly Brackets of a table
%[text] You can use the Curly Brackets to access data from a table. This is especially useful when you want more than one numeric variable
T{:,[1 2]}
%[text] - here we get a matrix of the data from the first and second variables in the table \
%%
%[text] %[text:anchor:H_5D2D9C08] ### Now you try
%[text] Create a new table, `t`, that contains following :
Student = (11:20)';
Score = [16 17 22 9 10 16 21 14 8 18]';
Site = [false false true false false true true true false true]';
%%
t = table(Student, Score, Site)
%[text] - `t` should have the same number of columns as `T` \
%%
%[text] %[text:anchor:H_88D53AF4] ### Concatenation
%[text] We can easily merge two tables using the square brackets. As long as the number and names of the columns are the same, you can use the square brackets to concatenate as you would any other variable. Remember, in this case, we want to add new *rows* to `T`.
%[text] Try it now. Concatenate `T` and `t`. Assign to `T`. Don't forget your semicolon
%[text] 
T = [T ; t]
%[text] - The final result should be a table, `T`, that has 20 rows and 3 columns \
%%
%[text] ### Sort rows
%[text] You can sort the rows of a table using the `sortrows` function. Here we sort based on the `Score`.
T = sortrows(T,"Score")
%%
%[text] %[text:anchor:H_6E9990CF] ## Basic Analysis
%[text] We can perform stats on the data in our table by simply indexing out the data from a column. Here we calculate the overall mean Score
s = mean(T.Score)
%%
%[text] ### Try it now. 
%[text] 1. Calculate the median score
%[text] 2. Calculate the standard deviation of the score \


%%
%[text] ### Specify rows for analysis
%[text] What's the mean of the on-site scores? the off-site scores? Hint: using the `Site` Variable for Indexing.


%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
