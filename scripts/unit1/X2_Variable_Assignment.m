%[text] %[text:anchor:T_C5E7DB7D] # Variable Assignment
%[text] [Online Documentation](https://salcedoe.github.io/MtMdocs/matlabBasics/ArrayAssignmentOverview/)
%[text] During this course, we will be assigning data to variables. We'll start with the fundamentals classes. Online documentation for these classes can be found here
%[text] - [Numeric Arrays](https://salcedoe.github.io/MtMdocs/matlabBasics/Numeric/)
%[text] - [Character Arrays](https://salcedoe.github.io/MtMdocs/matlabBasics/Character/)
%[text] - [Logical arrays](https://salcedoe.github.io/MtMdocs/matlabBasics/Logical/) \
%[text] These three classes can hold basically all of the data that you need for programming. 
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] 
%%
%[text] %[text:anchor:H_6F58495C] ## Assignment
%[text] Assignment is the process of adding data to a variable.
%[text] %[text:anchor:H_BBC9770E] The special character for variable assignment is the equal sign. 
a = 1 % numeric array %[output:770a8c05]
b = 'a' % character array %[output:56c33d21]
c = true % logical array %[output:1c077576]
%[text] - The variable receiving the data is always on the left side of the equal sign
%[text] - If the variable doesn't exist,  MATLAB creates one (of the appropriate class)
%[text] - The data to be assigned is always on the right side of the equation.
%[text] - notice that the character array is colored pink
%[text] - Review the icons, byte size, and class in the Workspace \
%%
%[text] %[text:anchor:H_C5C1A7C8] ### What to call your variable
%[text] %[text:anchor:H_421FC71A] Variable names have rules and should  be named according to certain conventions, which you can review [here](https://www.mathworks.com/help/matlab/matlab_prog/variable-names.html).
%[text] - Basically, Variable names must start with a letter and cannot contain characters that might be misconstrued as a MATLAB operation (like addition or greater than) \
%[text] ```matlabCodeExample
%[text] 9not+an-acceptable*name!
%[text] ```
%[text] - There's also a size limit (63 characters), but that is usually never an issue. \
%%
%[text] Also, variable names are case sensitive.
%[text] Consider the following:
clearvars% empties the workspace
A = 1 %[output:147866ac]
a = 2 %[output:0533c5cd]
FrUiT = 'apple' %[output:60c28b9a]
fRuIt = false %[output:41757184]
%[text] - notice that these are four different variable names that each contain their own row  in the workspace \
%%
%[text] You shouldn't name variable names any of these keywords 
iskeyword %[output:090b9781]
%[text] - or  *ans* \
%%
%[text] Or the same as a function name
%[text] You can check for function names using a function **exist**
exist('mean') %[output:49014e31]
%[text] - The function **exist** checks if the name **mean** is being  used by MATLAB
%[text] - The return value of 2 means that it is being used as a function and  further investigation would show that it is a function that calculates averages \
%%
%[text] - If the name wasn't being used by MATLAB, the result would be a 0 \
exist('notAfunction') %[output:5ef0d913]
%%
%[text] So what's the big deal? Why can't you name a variable what you want, like the same as a function name?
%[text] Well, If you name a variable the same name as a function, then the function will no longer work properly
my_primes = primes(10) % creates a vector of prime numbers through 10 %[output:13aba8f3]
mean = mean(my_primes) % assign to the variable mean the average of the vector my_primes  %[output:3513a976]
%[text] - Well, actually, it works fine the *first* time.
%[text] - But once ***mean*** is added to the Workspace as a variable, the function **mean** no longer works properly.
%[text] - Test this by re-running this code block
%[text] - The error we get is because  MATLAB is trying to index the variable ***mean*** and not call the function ***mean***.
%[text] - This ambiguity is in fact a criticism of  MATLAB: indexing variables and inputting inputs into functions can look identical and become a source of confusion.
%[text] - So, don't name your variable the same as functions or you will have troubles \
%%
%[text] %[text:anchor:H_CE3B910C] ### Copying data
%[text] %[text:anchor:H_69466774] variables can copy the data from another variable using the following syntax
A = a %[output:929ac017]
FrUiT = A %[output:693bccc8]
%[text] - The variable to be copied is on the Right side of the equation
%[text] - notice that the class of the variable automatically changes to adapt to the data being copied
%[text] - FrUiT is now a class double \
%%
%[text] %[text:anchor:H_0559C212] ### Creating Series
%[text] %[text:anchor:H_ED061042] #### Colon Operator
%[text] %[text:anchor:H_6008F700] The colon operator simplifies the creation of arrays. You just bracket the colon with the two outside valuses that you want in your series
clearvars
a = 1:10 %[output:23ace0dd]
b = 'a':'z' %[output:01bbb0bb]
%[text] - the default interval in the series created is 1 \
%%
%[text] If you want change the interval, you use the following syntax
c = 'b':2:'z' %[output:021abb74]
%%
d = 5:-1:-5 %[output:27869d35]
%%
%[text] %[text:anchor:H_9199F675] #### Try it now. 
%[text] %[text:anchor:H_ED154F4E] Create a new variable ***e*** that contains the series of every third whole number starting from 1 and ending with 33
%[text] ```
%[text] e.g. 1...4...7...
%[text] ```
e = 1:3:33  %[output:668740a9]
%%
%[output:2dffa054]
%%
e(3) %[output:055825f4]
%%
%[text] %[text:anchor:H_931910E2] ### Series functions
%[text] There are many functions can also be used to create a series of arrays. 
%[text] e.g. The function **ones** accepts inputs to indicate how many ones it should create
c = ones(1,10) * 3 %[output:55e11449]
%%
repmat(3,1,10) %[output:24e5bcb0]
%%
%[text] The function **false** creates a series of logical zeros
d = false(10,1) %[output:462dd08e]
%[text] - The first input is the number of rows
%[text] - the second input is the number of columns
%[text] - This is a common theme (row, column) \
%%
%[text] The function **repmat** creates an array that repeats the inputted data, as follows
d = repmat(1:2,1,10) %[output:1dabe0b8]
%[text] - here were take the vector 1 2, and repeat it 10 times along the rows and 1 time along the columns (so, really no times along the columns)
%[text] - Again, notice the convention of first indicating the number of rows (10), then columns (1) \
%%
%[text] What do you the think would happen if we changed the 3rd input in **repmat** to 2?
%[text] Try it now:

%%
%[text] %[text:anchor:H_D488604A] ## Concatenation
%[text] %[text:anchor:H_FE6F2D1B] Concatenation is the process of grouping elements or small arrays into a single larger array. 
%[text] To review, scalar means a lone element. Vector and matrix are as follows
%[text] ![](text:image:4e50)
%[text] %[text:anchor:H_EE0E0907] ### Character arrays
%[text] %[text:anchor:H_D54224FC] Single characters are concatenated into character vectors using the single quotes
clearvars
a = 'hello' %[output:371c4050]
%[text] - characters in single quotes will be colored purple
%[text] - Notice that the variable a in the workspace is listed as a 1X5 vector \
%%
%[text] %[text:anchor:H_D9904BE4] ### Square Brackets
%[text] %[text:anchor:H_782744F8] The square brackets can be used to concatenate numeric and logical arrays
b = [2 3 4] %[output:3b35dabe]
c = [true false true] %[output:7f5b93b8]
%[text] - notice in the workspace ***b*** and ***c*** are vectors \
%%
%[text] You can concatenate various sized vectors together using the square brackets
d = [1:10 11 13] % the vector 1 through 10 concatenated with the scalars 11 and 12 %[output:0f222445]
e = [true(1,3) false(1,4)] % two different size vectors concatenated together %[output:30df09da]
%%
%[text] %[text:anchor:H_32EDCB63] #### Recursive assignment and concatenation
%[text] Recursive assignment means to overwrite a variable with its data and new data. For example, with this syntax, we are adding the scalars 3 and 4 to  ***b***
b = [b 3 4] %[output:528966d1]
%[text] - this syntax adds 3 and 4 to ***b*** and then overwrites the contents of ***b*** \
%%
%[text] order matters for recursive assignment
b = [0 1 b] %[output:674f060c]
%[text] - here we add the scalars 0 and 1 before the contents of ***b*** and overwrite ***b*** \
%%
%[text] Try it Now: add -1 before and 5 after the current series in ***b*** 
%[text] ```
%[text] e.g. -1 0 1 2 3 4 3 4 5
%[text] ```
%[text] Use only 1 line of code:
b=[-1 b 5] %[output:894e631b]
%%
%[text] Same works for character arrays
a = ['hello' ' and '] %[output:76702098]
%%
a = [a 'goodbye'] %[output:036b027f]
%[text] - notice that we had to include the spaces \
%%
%[text] and logical arrays
c = true %[output:8799e5b8]
c = [c false false] %[output:4ba2231d]
%%
%[text] %[text:anchor:H_1E83187D] ### The Semicolon and the new row
%[text] %[text:anchor:H_256F32BA] The Semi-colon indicates that the element or vector should be added vertically. 
clearvars
a = [1; 2; 3; 4] % create a column vector %[output:36118431]
%[text] -  here, with just one element per row, we create a column vector \
b = [true false; false true] % create a matrix %[output:74d66210]
%[text] - Here we have two elements per row, and therefore create a matrix \
%%
%[text] Remember that you need an equal number of elements per row
b = [ 1 2 3 4; 1 2 3; 1 2]
%[text] -  can you see why this fails? \
%%
%[text] Don't forget your brackets
b = [1:5; 6:10] %[output:59efc425]
%[text] - This syntax works, but may not do what you expect it to do
%[text] - Review ***b*** and ***ans***
%[text] - Can you see what happened? b was assigned 1 through and *ans* was assigned 6 through 10 \
%%
%[text] Care must especially be taken with Character arrays
a = ['person'; 'woman'; 'man'; 'camera'; 'TV'] %[output:4b724ecd]
%[text] - This syntax is trying to concatenate five random character vectors of differing length
%[text] - But, remember, for any matrix, you need the same number of columns per row
%[text] - to fix this code, you need to pad each character vector with spaces so that they are all the same length \
%%
%[text] The function **char** simplifies the process of padding character arrays, such as this collection of random words
c = char('person', 'woman' ,'man', 'camera', 'TV') %[output:38ed3182]
%[text] - notice the space characters added at the end of each row \
%%
%[text] Semicolons at the end of a line of code (and outside of the square brackets) suppress output 
a = [4; 5; 6; 7];
%[text] - notice that nothing is displayed in the command window (or right after the code block)
%[text] - but the contents of ***a*** is updated \
%%
%[text] %[text:anchor:H_408E82C1] ## Indexing
%[text] Indexing is the process of accessing elements in an array using their address (also called indices). There are three main ways to index. We'll start with the first two: Linear and Standard. 
%[text] ![](text:image:3ff8)
%[text] Linear indexing uses just one index number to access the element by order (which is column major), while standard indexing uses a pair of indices that represent ROW and COLUMN
%[text] To indicate an index, place parentheses after the variable name:
%[text] ```matlabCodeExample
%[text] variable_name(LINEAR_INDEX)
%[text] variable_name(STD_INDEX_row, STD_INDEX_col)
%[text] ```
%[text] ### Indexing Examples
%[text] Let's create a matrix so we can try our hand at indexing. Here we use the function **magic** to create a magic square.  Here, the parentheses is after the function name (magic), so it indicates an input (4), instead of an index:
clearvars
m = magic(4) %[output:440c8f05]
%[text] - we'll get into the magical properties of ***m***  later \
%%
%[text] %[text:anchor:H_387C2F75] ### Linear Indexing
%[text] %[text:anchor:H_44115B8F] For linear indexing, you use only one index
%[text] Enter the index to return the first element in ***m***
m(1) %[output:86f87672]
%[text] 
%[text] Enter the syntax to return the fifth element in ***m***
m(5) %[output:749ff2f0]
%[text] - Linear indexing is easiest for small vectors
%[text] - It gets somewhat complicated for matrices \
%%
%[text] The keyword **end** indexes the final element.
%[text] Use end as an index on ***m***
m(end) %[output:9bf75b8d]
%%
%[text] You can even use math on the keyword **end**.
%[text] Subtract 1 from end and index ***m***
m(end-1) %[output:3f5b0051]
%[text] - the penultimate element \
%%
%[text] How would you index the 3rd, 4th and 9th elements all at once?
m([3 4 9]) %[output:3888b0dd]
%%
%[text] %[text:anchor:H_64F974C2] ### Standard Indexing 
%[text] %[text:anchor:H_B83B8C2D] Standard indexing using two numbers: row number, column number. This type of indexing is often easier for matrices.
m(2,2) %[output:88dc0708]
%[text] - second row, second column \
%[text] %[text:anchor:H_8A9AE6F3] #### TRY IT NOW
%[text] What would be the equivalent Linear index?
m(6) %[output:82f88370]
%[text] Enter the syntax to index the first row, third column
m(1,3) %[output:844e606b]
%[text] - you should get the value 3 \
%[text] What is the linear equivalent? 
m(9) %[output:267936ed]
%[text] 
%%
%[text] %[text:anchor:H_2698D1D0] ### Assignment vs Indexing
%[text] Remember, indexing un-packages data. And data always goes into to the variable  (or element) to the left of the equal sign
%[text] So, what's the difference between the following two statements?
data = m(5) %[output:9c6df28d]
%[text] - what's going on here \
%%
m(4) =  data + 100 %[output:04dbd28c]
%[text] - how about here \
%%
%[text] What do you think this syntax does?
m([5 7 9]) = 99 %[output:5ac5b55f]
%[text] - Notice the single data point is propagated to all indicated indices \
%%
%[text] Compare with
m(9:11) = 101:103 %[output:5608479b]
%[text] - here we explicitly set the data we want where \
%%
%[text] %[text:anchor:H_590B7685] ### Range Indexing
%[text] %[text:anchor:H_4F170349] The colon can  be used to indicate a range of indices. For example
m(:,3) %[output:2225e596]
%[text] - indicates "all rows, 3rd column" \
%%
m(1:2,:) %[output:5190eb32]
%[text] - Second and Fourth Row, all Columns \
%%
%[text] %[text:anchor:H_66A43774] ## Transpose
%[text] %[text:anchor:H_9A813741] Transpose is the process of swapping the row and column indices. To transpose, you use the single quote.
%[text] Enter the syntax to transpose ***m*** and assign to ***t***
t=m' %[output:1de20d15]
%[text] - notice how the first column in ***t*** matches the first row in ***m***
%[text] - notice that the diagonal (starting from 16 down) does not change \
%%
%[text] Use standard indexing to compare ***t*** to ***m***
t(2,2) %[output:9e7d796d]
m(2,2) %[output:071d4cb5]
%[text] - returns the same value row 2 column 2 has the same value in both arrays
%[text] - This why the diagonals don't change in the transposed matrix: (1,1), (2,2), (3,3), and (4,4) \
%%
%[text] Here, we swap the indices to get the same value returned
t(2,4) %[output:927a3a49]
m(4,2) %[output:5066b098]
%[text] - same value \
%%
%[text] %[text:anchor:H_5D0E2AE9] ## Deleting elements
%[text] %[text:anchor:H_56304ADE] Emptying arrays and deleting elements by using the empty square brackets
%[text] ```
%[text] variable_name(1) = [ ]
%[text] ```
%[text] 
%[text] Assign to ***t*** an empty pair of brackets
t = [] %[output:5e593f8b]
%[text] - notice, ***t*** still exists. It is just empty.
%[text] - Its a 0X0 array \
%%
%[text] You can slice out rows or columns by combining range indexing and the empty brackets
m(:,3) = [] %[output:2819c4da]
%[text] - Here, we slice out the third row in ***m***
%[text] - ***m*** is now a 4X3, instead of a 4X4 \
%%
%[text] - Enter the syntax to delete the last row in ***m*** \
m(end,:)=[] %[output:2c13b9cc]
%%
%[text] ## MATLAB Grader
%[text] [MATLAB grader](https://grader.mathworks.com/) is where many of our MATLAB assignments can be found. 
%[text] Be sure to use Google Chrome or Microsoft Edge. Other browsers may become unresponsive.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[text:image:4e50]
%   data: {"align":"baseline","height":189,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAlQAAAG\/CAYAAACe80n1AABff0lEQVR4Ae2d\/2sU1\/7\/F\/q\/FCrFH\/tDhUL8pf4QECpI4R39oVzzS60I9RZyb6VULfcaubeGd5H4RhT9VPKm8b5DrlQvisRrLEZJQrpoozatsSY0WitWpJYbyutzzu58PTNnNrMz2dnsPBY2u5vdOTPzPI95vZ5zzpkzlYp6vLTjsvBEAxiAARiAARiAARhIx4D2Ud4D8dKJh17oBQMwAAMwAAMwoBnwzJR+AxRAAQMwAAMwAAMwAAPpGcBQ0c1JNy8MwAAMwAAMwEBGBjBUGQXExad38WiGZjAAAzAAA53GAIYKQ8VZCQzAAAzAAAzAQEYGMFQZBew0h83+cNYIAzAAAzAAA+kZwFBhqDgrgQEYgAEYgAEYyMgAhiqjgLj49C4ezdAMBmAABmCg0xjAUGGoOCuBARiAARiAARjIyACGKqOAneaw2R\/OGmEABmAABmAgPQMYKgwVZyUwAAMwAAMwAAMZGcBQZRQQF5\/exaMZmsEADMAADHQaAxgqDBVnJTAAAzAAAzAAAxkZwFBlFLDTHDb7w1kjDMAADMAADKRnAEOFoeKsBAZgAAZgAAZgICMDGKqMAuLi07t4NEMzGIABGICBTmMAQ4Wh4qwEBmAABmAABmAgIwMYqowCdprDZn84a4QBGIABGICB9AxgqDBUnJXAAAzAAAzAAAxkZABDlVFAXHx6F49maAYDMAADMNBpDGCoMFSclcAADMAADMAADGRkAEOVUcBOc9jsD2eNMAADMAADMJCeAQwVhoqzEhiAARiAARiAgYwMYKgyCoiLT+\/i0QzNYAAGYAAGOo0BDBWGirMSGIABGIABGICBjAxgqDIK2GkOm\/3hrBEGYAAGYAAG0jOAocJQcVYCAzAAAzAAAzCQkQEMVUYBcfHpXTyaoRkMwAAMwECnMYChwlBxVgIDMAADMAADMJCRAQxVRgE7zWGzP5w1wgAMwAAMwEB6BjBUGCrOSmAABmAABmAABjIygKHKKCAuPr2LRzM0gwEYgAEY6DQGMFQYKs5KYAAGYAAGYAAGMjKAocooYKc5bPaHs0YYgAEYgAEYSM8AhgpDxVkJDMAADMAADMBARgYwVBkFxMWnd\/FohmYwAAMwAAOdxgCGCkPFWQkMwAAMwAAMwEBGBjBUGQXsNIfN\/nDWCAMwAAMwAAPpGcBQYag4K4EBGIABGIABGMjIAIYqo4C4+PQuHs3QDAZgAAZgoNMYyGiovpLew9Oyu39SeuOeznc9+6\/J+kTjckV2H7spA6duykH1HDg1I12Jvy8ziGiV9iDs2j8puxWLsYzGcev8r7bM\/q\/W8Flbe7OyWelc07gWJ643iBFlPubLuO9XpKdf5ZY0x22No2tr+Hhd5Xp+75qnp9a1549X0Cpnn5HNUO29Ky9kpY\/f5dHiTzLQH1eJ16S6HCzndzmxd5XhylnItEm++d+jVTrtrsnUb0G2Ur5ffiybYWUVAq\/J8TLH\/JrlbBVi9R9vp8gtwWMajmzxcfOZx0GhZPn726twXK8CC2vouMhmqBT0T0JVtLIPE2cmjYq8JhPPg8v+RwYxVIZGLqhoZQsY8f839QpytoL3z39a04aqfY8rs1445uP5dY\/7kr02mVtE4MjG0eahn0IB79ldDJVNq2b\/X4ih0rV66ViwK0WdrYZaETjLsFcoWtm1iUs62VuoetbQGVJYm3ZmBUMVrqs4dkv8v6YNFbnDxhWGavWPp3wN1fKvMnH9gVy6vug8f5Sp75\/Js1B3nmOSl59Ir5eorsjBi\/fl\/OX7Mnr5gXq9Kz3vrf7O28Br7\/+jVbr6uSIDlx\/K1K2fZOLrh\/7z7jMJY\/m7zN8NfK9+W1vm6jdreGxPO7OCoUrHccniYYyhWjSOz9DxXDu2f5Kpr+8H8krJNPPyafx+Y6jidcnzOMzXUD1\/aBlMfk1GfwinL22rJk65rVRXpPdIVfYdc5\/ToXLW75+uDVbXA9YPnqo6Zuu6DF5elOr3T2RWPaem7su+\/YHxWX+clMGLizJ1V3\/\/WK5c\/U769ga+j4Gv99hduaJ+P\/\/wmcwvPpPZuz\/J6LlvLOZObbMaSF\/fJvV6pN6N2dV\/U85\/\/Vhmf3gqcz8429Xv7mdchV6Tg+ceSPWHZ7L48HntOa+Wu3LZtr3JWgXhWL+\/qrbliTz65Td58suv6qlef34uU9e\/k94\/xm2L+t\/eSX+flN71331V30al85zar9nvlS6j1VAdBder33cdrusw7+zTotJ09taPcnpouj0MynvfGN3Vv8lAkolXPJ24\/KPMKi4W1VPXkWZu4Mj12K7Zrv0zMjD0jfNUOtbK1joqZlVdz9265+j3Ve2CDJejfU55m4\/clku3FEeab82h0jt4YUfvMfX91z\/Vvq8qXYeHZkLf1+sjiZW8+NUcXZF9ow9k9qFi7Plv8uhnzdtvsvjDT3L6lNm973K3UkPVTNnuOjTP0zI89ZPMLdaPx+rXD1Sd1Qcu951y60e9HnO2U\/3erzf9fTW2y7frcDX0u4OHGQxtxoBMnyOGqsHxacTzrv6ZUBzz84bPxmZVh+5xV3s9Fo1N+jfDV3\/08kw91zyQwVPR3+r9Xc1c1dUfZO6m1FvOr8nAxQdOnnsi1a8XPb5N\/VdqqNLlQV9Pc31l\/JyvofotabxJVRadxin35cX3d51kpLomQn4rPCh98G7oS5lTrWDz4X+5RcrE0DXpOrVotD64X\/8uE2diEuB7MzLx0FJgbdHfZerctJE4jW3+7bGcvmwfUbb49d1Iwtt87L6R1N3t9F8f3XUTrwuusV4Ja+VCPHD9qV9I7LtlmRg19+mymAMXZ5Wxmw2NbwsUtvxcTkQuMlDm+ftQ\/21gAeetaskcPpJkMt19XcXXSMC2j73oO\/dT4gDZ5Z9\/kt2GGTOZrY7elolfAlIoXmoB0byw47cnygRbBP\/loUru1+TSw98DBflvl3\/+0Qmyrm5JrBjfNcFvjbX938icZXPdLXvx8GFEn5fUfjQc39V02fX97z3z0BIHROaUGX3mbqB+VRcf6ProOvUw+N\/a+\/NHzBOxK3L+5\/DPXjAexYiPLoNNvsYcn2kuVNp9OQrli7tuvlHbtPd2uP51dYby13W5tPifcCVHPv0ml4x8Yh73eeaqaNmLMm8JtU++vx85EWhoqJrKg03Wr2GA3by11l9baKguy2mzlcpNKg2C68AtCzURwFfyj\/+Eryb6482I0bOVUh0NmjEzIdiW8v8fWr7\/u8Qk7S8l8uTrbwLBylxv1AicuNsoEPilz1+tBspWhsoYuOj\/0vLOq8P6gXX6+yRjGizjVxmwtZK14mCLCdhxF0IcvB4NzMG98N6rwevBsVYNmXUHu0e2wyuxqTehpJF4XJkcNV5diF9dR4rhkClJKmL5qewLmU5z\/QbHmcq+LD1nwgNwbZvm0erWx45pmfP+WV\/q0dTN0DHy0ns35VGowN8larpINJmSY+S4MOJ2wxjxlVwyTK+ok8\/Rw3VzHMlFajD76f1unallo746VOP+h2UZDpxUNjzu\/QVX8C68z6nL\/nkx1ItgxvbQoPSm86CrGa+a95Yaqp5RowVHdRHWL0lPDq42kJaX48\/UXVKXfzMio\/PF4nXfREQPLPWj31S3xS9xpkQ1O3smwNxmd63KAP38q7yIW\/UvPzqAX5HhRWPbl3+rNdeeV90TTyLL\/ioHvWRkrjeciOLOsPWWPVNdfY9+iRSsvlkOBJIEQ1XTJG553XXrdHccvh9pEXiy+FguXVVN0otRU\/xoyq+HTMG3YXCNOdhjAnbEUO2\/F2N6f6\/Vb9y4wKDxtTHrUeK0iLwU2Q73F7\/Lcrzc7g8sr88DxiWJFfM7v7jG\/Go91fLBFjd38eX\/qG5rxb\/7OfD64vvvAsbEXH+Q46xlK1MUWO+K3gZaJyJ158WpOkeRY8w4qWg5y83w3+7LxB0XKt7rmG97ivwavjpctf5GDP\/PD2RzfzROzV+d8dncH3eyq7hWXf1PfjPitoIraLgj7Djw5ZGrbGUn8R08CUoyVM3nwZjY2u5sreL2tdRQmRWqD4CDNYOSFFwvSxSk\/8ilofqYh\/WHv4vtNpu96Bwgqttg0UhMXvN8fzRhzl31z0a7VNnmsvOX3W4yc5s11r8GusAm5crPxsGngna9FeO6MTeSOsvxzo4UoO9Fu0fPO2dWyV0l1+RKJMmpbrnDfvdaz9BiJNk9CzSFR+tIGcRbfndlz5kfI6ap6jR7m92Fyz8EE+hl6btqtPY8vB\/pBm1ZMooE7GBCrweJSGvbb0\/loDedx1dyItI191R2OwdrlNl62Fu8q8Y7qTEPly46g90j26HM7w8PHE6uyOm7USMqzx9Ln2OwB6YMTdWZtt81YjIa3EfzuzT8KuMd0zX2KNStPam6TIwDb4XblrXsntHwfDt6zx7d+s4ZC6nGsV01Tuz0DwKGav2RB\/o\/gUdQ02g8emK2YK1iwG7Z8VH0PsQcF4EKsbwN15PWavfFRkMfVFHeiW79uDfjmKiu9mDr88GpX0PrD7b0RI\/7nHKV2pdo2So231WD8GsTdKoLUOKGnPzit1KZsd3b7kx5EEMVPCZbaqi6hsx2VPds2gzuwcAfBenZrWAXmP4+3Jr0wkjk+ywHgAmYPrCCA3+1UL0Xw+c4y4uuCTC3OdBS4wSj9cd+DB14ftBWl\/IbeXD5t1+lqgY568Hteht6jjizxp+5LSfOBAfGm+sNaKWCUHhrRa54A\/998CPGRnXHuEYgookalxOetf5KxLR5hirSXagnc32sBlSrQdn6goD3rtcHgarB2oNn7qqBwMEuVH\/7goCu2vtIwA7oWKu\/aB1NnDLH0kwa3UOq68cxvtHg97tcGYrZ37jt8FpBlSZ\/\/MaoU93FENTK7H4K7kcCK5HuwDT8Ro85MynV6y16YjB\/0XZC4m+3eTynLXvQ7PI2EqbetoNfh5Oif2xqba8b07ioMVfn3MH16mQodOyqbqRQfQTrhvdNH7+R4yIcSuM\/RQ3VSzviuv6CS6tlgiezio2uY\/fURUVqgPfdx+qpLqzwTmbVoHN1ccroD+F84xkTtax53OeVq7SOZtlxx0XkN\/Lc690wY7u73eb\/0+VBGA8y3lJD1XfVSPfeuIWkwB8FyQXB3ZF9xjiXZ7fCE5Z1GYneXd40Wvow090dtavhalfExXRdeM375jb\/JoPBRKgOAJ0MQ+fC3lmwuWzwANfvdbfSM5m4qqaP0OWEnuayfiLqOmUauODUFIFyIk3hfiAyDy4zIMQd2K6hMnU292pZdRvOf\/9QThRppFwtIwHb17Gmd2ScjNqbWrdn\/Qo2zUhcF6qrhRnYvFZRd\/3u6wq2I3wxh7GdEWMU\/N7OSrSlMw2\/X6nW13DtznqGI8CZ2kfT3Pg62LYta9lmuSLBbg\/vWDK7dbxjs779ZmzQJ1K1Zc3lvBgW3m9vPW4982rEsQZ6RY4LNTjhuX\/seTFax+na8z\/y4vkzGfBakAPlR+Kdz67f4xD4vVdX6grsM\/dk4u7T2hCQ2GEcqig3n+g6N4\/74Hf6+2ZzVVzZ1TMxV5ZGWpsSYrtzIYXJulZn5XkwTrfy\/q+lhsqETazmJJgUGkNqtnyZEEdMggNS5EzYP87s77wAagbu8DbXAqoZFAJBe3Oktc62ymW5EppZ3r5ecz\/F21YDcHO7VFeMO37ILMPUMv7Adlterkdar2x79eLhj8XOF5OgQa3u4q4Csu1M4P82QxWnYywjgbqofZ9omHS92nlo\/juHF1Mjj99o611scE9MMLbtzlp23PIun4HjwLpvzm9UYgp3WKrWdLU\/PefCXUiLwbE36vt6nfGaWQezfvRxYZ6wptC777rRIqmP2ZiWS3e7Dza8Sto\/6IPHtpnjgt\/pspvNVXpZs+zZ0EVSDnORuNU4tmfLg7DuMqNfW2ioJiPN6PbuMx+COJBMSBuZANv3g0ZXoX+IJLxboQmsiWwGBS8h1SHcfOQ7mYsdKG6u3786JSlJbjavbLIaKqPlLJDEbVoFoTEPbNdE1H9zTU5PPY2M0zL3SH\/267+Ag9Ksm4AGtf2IBKa4PYj+zzUWpkYms56ejbYj0TBp3WzGJMt3Tn2Y2+bxGzUtU2q6Em+fAonOroNtu7OWvcLlra3HLovm9qm7O6j5q06ErlQOX9ARt\/\/8z9Uz5avJnjo+\/bGBKctSx0hkPGvt0F32rvoL1pMZA4NH+Ytfnsu8MTY2eGzbea9vs1l2cFm9DUnfm2XPX3S7oQN6KN3C\/UB+LrWVnS0PBtYdOO6Depbpfe6GKtpFVRd89+VwNWtI\/URsBi8fAl0ZJkhpIEyCNNL8qgZnr1eTFHb98Svvud67us4EJ3mbaxCZQcFLSOGydL\/8wOh9mbDNKq+0atxVovr3I1fZPZO+OMgjv\/ODle2gCx4UZn349RjcL3W3+CPfyOj1hyoAhccc+AHKX2+w\/Ja8N+vGNFSRCwPUtuqJYwNsdCXcrd3UyGTW28dG25FomLTeSRw2+51Tj+a2efxekVFjwLmtpWbUuJrV18G2bVnL1mNmwheDBK\/CcnW3j2\/0GTaHKDxRM3WH5v1JaOFw18Orr2cqLUz2Mhgqsx79+KPeKabDOcvkUv3mlycyqMa2drm54Fh4LLDP9OrlKq2dGVPck7eQrpGWVT\/G2mJ7tjzYZP3G5aUO+F++hip2pnQ107GaGDHcfK6Rdgek6woxIW6NoTIB011k4YNLnTGoAYr6FgdXpn6UK+r1vDcZZvI21yA3g4KTkLqO1a+0q1\/+q1pqHj4Ind33qFnGzYlG\/YM2Yb3mWbdSOW6MwOnvDYMTCCqmJv56\/QMnemDrLhU9d4uqZeeyZvVGndH7y7z0RzUg\/eJDo+UqXM+hwLDaB5dZN6ahUkyGBx8HTwDc\/dKtcep2NZoN9ZxQs3D3Od0SpkZxOsYyErMdyRNgJvCQeFwlLefsn6mRZ6j0oG7j6kN1YUPEvJvjjRSPvvm2rz9r2ab2+oa5\/hxDet+mI3UbHpTu7H\/C2BsdweKOrZYyvNrHSJHlm+zp46KZLr8VzPcXNtzmca8MibFek6\/gsZ30nWajUXxN+t4sW4zpPHT5JyKx3ZlAOGHd5jrT5UE3FvKq9c\/XUKkk+si71Yi+jcqv8ffxU8EoOBdUUYbqJRXwzXazFz8sereo6T11P\/K9P0jbnhC8oGoGBc9QGYPHlW7mrOWDxmSm\/kGbvN64+URm1f3oNquzK90SNnwrOpYgWBfmweWv1z9gzAO7niSjV9Msq3FSu4PBaP\/d8CB9FSSbb8b3t8fTWwG94vdm3USMjApO5tVi6jeXzji3eNFX+5jBS33vzlNmahSnY21bG25Hcn0nHztJyyZ95+hoblvAUL0UGfyqDmp1Jj\/Qr7v+9G1t7hmTX2oLssKTqIxlrz8SHsav16wN\/qwyvKNXH8qj6NldaNoEn6Eo0\/Wy9N8CTwbScL5Wf2uyp2tQzSv47Pl\/Ep8v1ORt+m4Z9TpUjJvTyPz2XN0+ygQgPKTCPJEKXindGzvtjH8RVKPjvlF8TfreLFtTqO9CMKBaz3r2q1ss3Y3G9mDcsZadKQ+miLlrlcUU252zodJVvIKHaiqvT+jpVkZycDdBCkKiDxwrKI4QSd+nG5AXHDORvM2xydJLSDMyHyeTmhRRX7ESNyniSs7sa+uMS0Zx6\/L+F0xyjbXU6zDrw922uG5dvZpn+iqc52YQU194ergctPA1ErBjEmTKcVTBebdMjUxma3Wl+Wy4HY04S\/q+2e+cejC3zaivOPPuYRXzJmjck41gzF0VYsoL\/itctro1TLhXJvjT+PfGvrn102sMQvcWVhNEmlOsuMvwmsNxbLLnCd\/4jRuPzK4svWT1jJqT7z1znJH6IjA21jRU+qrrR2pSz0fPw13J7pb4J9nR2Gge90m5SHOT9L0ZU9z121\/DU6wkl230WtgLVd8E82AOde3k6U44blpuqJZ\/fhhzdVc08AdbLkyQ8oT0pR2TMmFcAm5jKXw\/v+RtrsFhBoVA0N6s7jO24ofqEvTngmq83t7Rn1ZY9H9k1LinXtJB5wJv1ocbwPT8PZEzwoQtuXTMn3DULbtlr2bdWFocelZaT7+E7+dnamQy6+2n2o5wK6nZateovqPfu1dsxpkW\/7iKLud\/tzJDVes6M1sALPX94of7AYZ1+Y3Wr7rlmi5bla\/uS1YNzRdl2TD334Fj06ubmuE1L+CoL2CbJiK0bAclipbvV+S4cCuq8WstHsWdWAZuxRI3VcCjqfr8hr3nQpPdNF6huv+mN9GutWehfkw1iq9J35sxpdGGzV0OzP7ewKw1nwedWAHrtVbRlhiqZdUMqyd4HB5yJ\/UzK8EMrmpOnMB8IuYkfOE+76irD94CRAeCCKS3\/CbaeqC4IgOXH8e2DNWgff40NNt4fRlzm2PuTWcmbeOqOz0+azEx6P8uc1N3GySisFZu4NOzvM8nlP1C3dDXn\/Xbrw9TK1NLXb55YE+F5kO5rroVwxbBPPCXf1F6qium3G0t5NWsG4nXUW\/bejXbfjXh5tnzkTpSY4yMyWRNZr19VuPewveFMzlqxJn5fXA\/0nxnrlcxYWpk8FvfBz1jfFJ9L0v1sn\/3AW+\/I4ZKbXewe7gWoJst2+VZLX\/9iTHs4HdZVLNL9+w1dLcZKtV9aQ6s13dEcLt2\/f1x18lrLprEjAc144jt85S6c8P5yA3EzSv61O2JjGGAqpnKYzB2Nn21wmdqSEjv3uj9X92TytXMVZG4e+62XImNS\/qmzdErACOx\/VZ4gmzdVZ8+D8J7kPdshqoW9DpJ0K9k97Fv5PTFe+r2IPdl9PJ3aubymDlsct7vnsNVGRz9rrbe0csP5PzlezJ4aqY27ilYWc2871X7M3x1UZX5Xe31kt6nwy0wM2oQ+r6h23L6nFqv0vK8up\/fsAoAfbUxNmuTmS41TmFA1dOw4mP08n05rWaA74mYgLW5b82wFVpGX6l67p5cuv5A1bnzeuZmLgy\/lEPZ652rM71uushdDPzBu6H9Usd6j9Fi4U3ymXMcMNfL54KPJc3dmfrxfnr0G9m9v8AWdcWaaajcq\/w21\/LHXTkxereWN\/zejGb1KyYPdgLvGCqCYrEtReiP\/jkzELl\/2\/KzwA2jdZLR3fzh8TD6SlvPbIW2ZzJyRWC4RbbZpMVynZBAW7kPUUO1+if7rdy\/TlgXhioUPAlynQA1+1Bujrtibtws6oKPOXVftomvf4q9ym92NNxF0nXsgTxTV5VFLqUI3PcSzsrNWavrH0PV\/rxhqDBUtJDAQIcxkO7iCPnlYXT+OeP+n+54Heaeav+k1mqj06r1Yajanz0MFcm0w5Jp+x90rQrApV7Pe9NyZTEy6tj1Rd7rs8X4e0puPvPY+433JsZ4lVpjYmdLY+fg3XB7aey9\/KiTltaJefxjqACwUABNIPmMIcyTgfXqQoITFx\/I1N0nMvt9\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\/UpRjQn6wfkyYpWPS+79e\/Vc\/3BqRUtwY\/WtgIYKntyRBu7NtpUoY9dH61Nng9Vnv\/Is2DKEpkf3V1PlF2DGCqAsCrwZGKgzkllvZxfXLb+zv3ixewJ5\/cVOT238lYtd\/k8XqvDB2VzV48Mz3KqkIeejcpQUVqKbXFYkuGhQdm+pVte29At3fp109uy48BxGbn5uNBtK14bI2HfGZNufcKzZVBuKENTbL21h6G6MXlVPtm7R7o3vSGvrXtVMfSGdG\/bI5+cHJNrBWqk2cnz4bupvEvOcyvXYFnL85dksz6o9BNDtQZrsIWbvDwrvQ4rPadnG6544uDmOlfrD8piw1+vxg+eyGBXne2BqZW1qa3GVpSpTB1HCkvM89OyY50Ty9yYZrz2nZktbvsKTMhxdXLx5Lv143PDQFsYqrhtbN3\/nsrwYUcPg5labqz97x05NfO0EH7ytj2qPP9RpgCV\/74+k9mpCbl0flQG9vV6LQhKXQxV\/mJ3XIlX9nU55rtRt9+89DmBafNgtSAdnsmJza6hooWqFZWg40jrkmCwVWVJ+rf4Zmp7\/4iM3Xks1YUluTg2ItsDRuuzyWKSYjG6BDXy31cnv5SNzvFZwVDJxZN7\/Fy4YY+cGv9Wpucfy7WbVfnswDv+d5UP5WIBxlgfV3k+fDeVd8l5buVaKOvZRAAOPwBpWWmhWgsVWOw2PqsOOvysl9F5e7ef390X\/zs9WH1qYkKuXLminlMy92iFhmf5mczPTjnLXZGp6pw8ietNXNbb9kgGHUO178oj9Tlhe58t1k40atszMSWz848Sfr0sy7XynbpQ2zRXVdt06YrMPbGvo9iaa83adRwpwjhcO3fIi2vbj1Wj27BQlR2ugdj2uUwXlBSL0Ka+ziU5e2FMjg99IX0fBA2CivttYqiKYueWYmO7y8amARmPYSNouHYMfRvlK2aZPOs6b9ujyvMfrQkNHbqW5ScqcUzJlPuszsqlwZ56MNrMGKoOrfUcd2vOG2jec8Le8nTlYHxL1ov5K7Lb6YZTR7SXBPX7zX2nxT4064VMnOgL\/T64fN\/gpcD4v2deV1\/wN\/p9175LYaP0Yk4Gdztdk8b2VCpdMnhpLqKdayo3DygDNXFC1geWOzhR7q5FrXGeiWSlZR3f9WqdjQ2HYhOiLufGBdd0dcvQnN9as9J1ZP1dUdrUtntuzHrslN1Q3bjgjg2tyKfW1ssF6dtQj1evHbjacsY1O3k+VHn+I8+CKUvEa01gDBU4rECB4Ngo3e4TfQRMV2Cs1bPZ4VBQ7+k7KCdODEpfr2O+tDFZ3yfR8esvZLRvvb+sGmR+cPCEnBjc54\/\/08vuHnXM0jMZ7uuRzT2bPbPTtblHetTnzbtP+8br2ZQ3JkxFF+nq2S2DJ07I4ME+6dLlOc\/eE+ErFF1D5X7vvq5f3yWnqytsaYuK1hH\/0VpkNR7pl78n7ztderGtU17rgd8S0XdhqYDtbL2J87RcWFAtVFdl2H2OTcvx\/rfrjKtWmXYYlO5tq1dfrdHLM9rrDiUMPF\/wGNuIoeqIWLVqO+ElCAzVqmncSQW\/mD3tmY3hmG4\/jyd9NaDruJZ9k1Xp2idVoyHn2eyoZ47W77sSkmt+1G+Z2n16KtzCpOzReXfwu0rmgyFD88IbQzVYNfsFX8jpHtc0aSPkbqi76icyus9vuTo96y\/v7199+Z6B8\/LoRbm7+lzVCjFUc1e98UCfjCddyffYG2eVbLxak8iLMhDueqfHne77Nunyc7er1a\/TajzZzl17pO\/Y9QST\/Vg+2VQ\/3mmhco92XmMV8BIEhipWH\/5pKrAo+9bXg0vcgHNv4HqgC3lu2Jmao9IjU5ZGnGdT7visHpnwfjMv+5yWoq6DYaPlb9UjOehsT\/g3wUHpYQe3PO+3lh2sja\/yS\/PfqasEnTFYfuuXiHe8qO3SXYg8fAUKMVTz1+uX\/1feluH5ZDM04rTKFNXK0GqzkLS+G2NOV1ebGKpC2Flha9iNMTc2VWTnGcZQ+Uc87yIKeAkCQxXRhn\/EKzA16E+JEGrbCbRE7R52xx\/5xqY30AUYLfmJHDSmOXjhDYLvkkuhFYWXfqTGMvX09EhfqHvOX685bULVtv3hYuXJxEGnNW6zZwS94yXYAmcsV9aPRSTF6uQX8nLNdDceGzVyuN7NhaFSY8owVAktUr4xvzHxhdcCWqns4Sq\/sga3le63lyAwVCuVrPS\/C7bwDAcGPXksqQHdV9xGoRf+\/FX7zs\/Ko8VFmVfPxeBzflEePVIDxN2r8i7VZ67yDE1Xo2ka4qrEbqimBuqGsGsgPD4qUsqLqfpdBHTLmtPr5+1j10F1HSGPoAJFGCp\/UPE7MtKghep4b71ltQhDldRaVMR37WaoitAgeZ1LcupwYDqFyqvy6URSl7JvwpLLTf87fVzl+VDl+Y88C6asQBcGhgocVqyA6mZzWpM2D\/qm5JI7T1XPafFGHanB397ksU73nTqavXFYce\/XH5yobYlnfJrqWrMZKnUVoGPc+kbnk\/f4yRVvYLs727tnqAJdmsmFlOdbXZd5J5NG5fndMY0N1Uh\/d407DFX7tVA1qudWfj924XOnG9mNU2\/L0YLMlN5vfVzl+VDl+Y88C6YsDBUMNKfA7AlnYtj1++ozoQe6+\/rOB+ZG91p5KtKzb0AGBwdkYCDheXBAzju3ivENlW38VNK2NzZUfrekpZxnrqFaL25LnGeoOAGJiKaidMsN1a35q07yW0GXH2OovPpptxaqQtiJjKG6J59+UDfdenv0c+uBkYSr\/9K3NjVjDPV25PlQ5fmPPAumLAwVDDSpwOJ5v\/VGNfQse+OdNgcGlauyPUMVuOpvhatcvLSv3pLVqMtPTa5Z60JUXYf+BXc2QyXijgHb3KjLT02EW29dixlDhaGK1KKK0l7CbiZxNLWMd5VftzK9SQnuqRzd9UZhLVSFaBMxDL4+GCpfC81ddeaCbHVMlK6r17YdkpGZYrr4zONAb0+eD1We\/8izYMrCUMFAswr498rrOaFmPXfGJVV6h42pDfzfNRqUPrxvt+zu3S2jTguV1xoUHJMVs7mPLrlTK+wW5e2ch91QrXRQ+uJ5t9y4MVRMhOsq7b6qKN16Q7Uw7SXCj8aS5pfyJ2dk2gS6\/IKmpToTuBVPpVv6z7XXPR\/1cZXnw3dTeZec51au0bK8pMUZ9xqtweI2258OwR1rUJH6bV7C2+S2CFUqvRKY0in0I3\/ahIq445XkRdWbfDM8JUJwUd84re8LTmPg\/9+8ym95frTe8qUClX3aBHU\/Qmc6hvWBMVwcL0Htw+8LMVRL\/vxSG\/sTZrG++aVzNaCeEbs9Wh6CSb3V79utharV+++tT91U22uZWvehnE1s5Qy3anllJLQE5vGbvG0Phioct3L9RILIVc5yFfboUmhW8Yq6Gi4yh6ZWRA3u9mYfV1fHzRr3vHsye965mk4Zs+CAdrWob8YqEp3Y84lcGnBunaTMkTvOqV4JQUPlDZGvf6Xa0EZ3uyZwvZyYCIz50r94MS+D3sSfqqsycE8cjhdHwpiXYgzVczl\/zL0\/nZqLypIQj39Q7+4r8tL3PJJrXmW0m6Eqip2zRxqzk5fmzZaDoYoJNu36LxJEu9bMWtgu37Tog3797vNGd5+\/D\/PnnfFQ6nf6tz27d0vP5l7Z3RO49YwyZNHb4S3KgDvBpl52fY\/s3q2W69sdunqwJ3C1YX2t\/tV8la4u6VK3htmt7vnnWSs1nYPbAlXbdrUtB9Vg+YN9zmB7Zzv3nfc7EXW5XkuaatF1Z4bw97Lc77SOzSaNTMupcVTdTn1VNh2S88b0CSPH\/Mvftx6ZLmQbC9PG0nqCodKtTUveDOhb426qbdEuE6tNlKnZyfOhyvMfeRZMWXoM1Yl69weXgYNDEwosBozSQNQNhUp8NDUsvZabI3f1DogzdCq0TP2DuhXMQNjoqIjgdNt1yYCa3yrusXjJnZjT\/a0xn9XyogwftJTb1SvDkVvSqMH3qruwdkNk1ZLmTeget\/IS\/k\/XSauTjbu+8VH35se6rl+Vrbv2S9+B\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\/WJs+TLVWe\/8izYMqiVQAGYAAG8mFARelCEs6tpSXp3+Ibqe39IzJ257FUF5bk4tiIbA8Yrc8mi0uK7dKFV538Uja6xgFDJRdP7vFN+IY9cmr8W5mefyzXblblswPv+N9VPpSLMeZ0tetVH1d5xijfTal3eRZMWfkEUnRERxiAgaIM1bVzh7ykt\/1YNWrqFqqywzUQ2z6X6QKS4mon3eTyl+TshTE5PvSF9H0QNAjKhLaJoUre\/lUcS6XY2O6ysWlAxmPYCBquHUPfRvmKWSbP\/cFQlaypn2RKMoUBGCjKUB3f9arTfXUoNiHq5Hbjgmu6umVobhUT9Con16YS9dyYZzh1HYWeJTdUNy4MeHp8am29XJC+DXXdXjtwFUNFsCfYwwAMwMDqMlCMobon7ztderGtU57B8Vsi+i4sFZIUmzJD3vZnMIELC6qF6qoMu8+xaTne\/3bdSKhWmXYYlF4MOwGjve5QwsDzBY+xjRiq1Q0iBGn0hQEYgIGlWoJuuWmYu+qNB\/pkPOlKvsfeOKtk45XBuCSYn6IMg60+pscH64aqTVqoitJnWo0n27lrj\/Qdu55gsh\/LJ5toocp1IBcBk6QJAzAAA3YGCkmK89frl\/9X3pbh+WQzNOK0yhTRymAzNkX9\/8aY09XVJoaqKB1Wst4bY475VN2lO88whgpjxZguGIABGFhlBoowVNXJL+Tl2rigxmOjRg7Xu7kwVKqrC0OV0CLlG\/MbE194LaCVyh6u8uOM0n5GiTZoAwMwkBcDRRgqf1DxOzLSoIXqeG+926YIQ1WENkmtL+1mqNpNHz0Vx6nDgekUKq\/KpxNJXcq+CUvSvZnvtDZ5HaO6HFWe\/8izYMoimcAADMBAPgyoKL2is\/5mkoptGb87prGhGunvro0bwlC1XwtVEezYmBq78LnTjexeEfm2HC3ITOlt1NrkGaN8N6Xe5VkwZeUTSNERHWEABgpJivNXneS3gi4\/xlB5hrfdWqhs5qa1\/78nn35QN92aZf3cemAk4eq\/1WuVCu633o4846sqz3\/kWTBlkQRgAAZgIB8GVJT2EnYwIazqe+8qv24ZTpxf6qkc3fVGYS1Uq6pBwtWFtvViqMJmqDpzQbY6Jkpz\/Nq2QzIyU0wXn1lnenvyjFG+m1Lv8iyYsvIJpOiIjjAAAzrwm8lg1T8vTHuJ8KOxpPml\/MkZmTaBLr8gl9WZwK14Kt3Sf664ez4Gt8t9j6Fa5atpSF4kLxiAgXZjoBBDteTPL7WxP2EW65tfOlcDVuTTyda3PBSjTbgVxk3Q+rXdWqgK00fdVNtrmVr3oZxNbOW06xnUNu\/3GCoMVa5NlO2WONgezAwMRBkoKimeP+ben07NRWVJiMc\/qHf3FXXpe95JNmt57Waosu5Ps8ufPdKYnWbLzms5DBWGCkMFAzBQMgaKMlS31Diqbnf8y6ZDct6YPmHkmH\/5+9Yj063vlmxijFNeydhWDoZKtzYteTOgb427qXab1BuGqmSBlLP16Nk6mqBJ2RgozFCpxDc+6t78WF+d9aps3bVf+g7sl27nprZ62yrqvnXXCkqSRWoTZ6razVAVo8+33j369Ppfdu4JWWPFNejGa1FTbuQZS9T++Y88C6Yskh4MwAAM5MOAitKFtv6MnTsu3ZakuHXv5zJekJnShqZobUxT5c3fVeabIy9UZYfDS322fXfeKfvrjqHWD1jX7OQZo3w3pd7lWTBl5RNI0REdYQAG2sM0PJVrM1UZuXBVhtVzZLwq14wuQNNc8LmYwdbovjLdMVR0+eXqqEnWJGsYaH8G2sNQrSxJkczRaa0wgKHCUGGoYAAGSsYAhspuUtDGro02Nuhj1wdDVbJASutB+7ceUEfU0WozQFJMToprpUWkiO2EnWR28jx2ldb+I8+CKYskAwMwAAP5MKCidKGD0oswAqzTbgTQJh9t9HGVZ4zy3ZR6l2fBlJVPIEVHdIQBGMBQ5ZNAMSLoGGQAQ0WXX66OmmRNsoaB9mcAQ2U3Amhj10abB\/Sx64OhwlBhqGAABkrGAEkxOSkGWx14H9YKdsJ6BPnAUJUskNJ60P6tB9QRdbTaDJAU7UkxmCB5j05pGMBQYahonYABGCgZAxgqjEIao8BvV8YLhqpkgXS1z3wpn9YVGGh\/BjBU9gSJNnZttLFCH7s+GCoMFa0TMAADJWOApJicFGmRQZ9mGMBQlSyQ0nrQ\/q0H1BF1tNoMYKjshqGZRMoy6KkZwFBhqGidgAEYKBkDGCoMACYwfwYwVCULpKt95kv5tK7AQPszoAN\/0FTx2dfD1QJ9\/Nn0XU3cVpjg5+D\/XJNW1u\/1fucZ\/1R5\/iPPgimr\/YM0dUQdwcDaYEBFaW49o7poXAMQfEWbeF1cjdDHro\/WJs8YqMrzH3kWTFlrI1BTT9QTDLQ\/AypKx5oJN2nyak+aaIM2Ngb0cZVn\/PPdlHqXZ8GU1f5BmjqijmBgbTCAocIU2EwB\/2+eDQwVY6hyddQk1LWRUKmnctcThsqeNNHGro02W+hj1wdDhaHCUMEADJSMAZJiclKklQZ9mmEAQ1WyQErLRLlbJqh\/6l8zgKGyG4ZmEinLoKdmAEOFoaJ1AgZgoGQMYKgwAJjA\/BnAUJUskNJCQQsFDMAAhsqeTNHGro3bCoMZi9cIQ4WhonUCBmCgZAxgGuITIobBrotromDHrhGGqmSBlNYJWidgAAZIivak6BoHXtEoLQMYKgwVrRMwAAMlYwBDhVlIaxb4fWNmMFQlC6S0TtA6AQMwgKGyJ0e0sWujTRX62PXBUGGoaJ2AARgoGQMkxeSkSGsM+jTDAIaqZIGU1omStU58d1PG\/z0h419NyNhXkzKXhvfAsuM3bsq9NMuu1m+dbdL7cnu11lGCcjFUdsPQTCJlGfTUDGCo2jx43r5xQf72513y1psb5PVX1snrr2+Qt3p2yd9OnJObbb7tmLfizdvtfx2oHeT6QNfPv\/x7bsWtUef2bfCXfeVAW\/Dm7886+efd4vVdq4wXbqjmv5Wjh\/fL9m1vy2sb3pDX1qnnhm7Zumu\/HL0wy42bVXIOmbSFWflo17uyddu78tnEUvg787cd\/Hl68kvZoTTYsWuP9bm9QI0wVG1rShbk3N97\/YTmJEQ3MdZft8k\/phdWnCDXavBnu5s3Drcv9TsMrau9vvLemRXyMik7g8y92Z9bi9DF\/9krb76+RY6mMHcuA\/7+bMBQZYhdRRqq6uSIbAyyFfP+tV1fyHRBxqBIbUImKrD\/p\/a+4eWCvgsLhRqqIvW5ceGQp0M9B9ZPFM33O88Vo5HeDjdW5fGqyvMfeRRY1jImTuzywXl9l\/zj3zMy99283KxOyPF92\/zvKh\/IRIbAWlZ9y7LfvgFxA882ufhdY4MWWS43Q3VH\/vJ6fVs+\/ted9MHn\/owc\/Wu\/fPzXYzKxgv0oSz2n3U8VpQtKyrOywzNQr0rfyTEZn1uSG3MLcnF8TPq2verFth1DxbRUFaeN0SrlGKpr58ImosyGaqT\/7RofL+\/6XC7e\/FbGZqLPi5Ozcm0+XkubYc3r\/5qdtMdi0u99N6XeJf2Q7xKS2v0J+YMbdFQim4kxTEHDtfP0TK6VSN0k1E1MXbSzXhFjpLh6\/4vGvPzve\/UWLR0gas\/X82qhmpO\/vekaqpV3P7azxmtx23Sd5pVE0pRz\/tg7nmHqH4\/rulqSftdUbRiQG4FWmjTr6Zjfzl+XbvcYdF6LNlTFaftUjn9Qb6nbemS6EH4b7bs+rvKMB6o8\/5FnwWUq6\/a\/3G6aihy9YevSuyMfO2f6r++7kGsllknrTt9X31Btkfff21RPZm8dSR6c\/t2YvFUL3hvk47\/vlVf0+wRDNffNjIxduiD\/\/L9R+cfZc3Lx35NyM6716L5m+ab8xTFU7\/\/fTfU5yPeC3Kv9xjG09+dkXJX7jy9GZfwb\/3eh36wxg9suvKkoXUhCGjrQ7bQwjFjXPz02UOe09IbqsXzqmMuXe\/fLzi311rvyGqol+WhT\/WTso7E4M15Mq1TQZOnjKs9j3HdT6l2eBZepLG\/gbeJA4Dvyp1fqcL2JocoV4k5izTdUarzdpZPyumOU\/rdqb4Wb+eKDekJTJmrs0mHvvXlV3b1vxuRPbwUGrtfKrjOpA8vOz84Frgyc87r69HfB5+t7ztR+527rm\/uUgTp7uG7knN\/+6azTPfjdBXlT\/6\/nmGMK5+W\/HYNWecXW\/T0n\/\/2Ws85X9sokJqymfzARtOr9kNNlk9TCMD0+WOdDGaprBbRQaTZbpUfSei4O7XGOk7dlZF613G2pM1y0oSpMH9Vat7UWD96QU3eKN09xdae1yTN\/qPL8R54Fl6msuRtnVGvCLvn4f8YSKmfe6zqhhcpuDsrETdy+uialUtmixk7d8Zh567NxC1vKoDjm463P1DQLX1kM1d0LTitWPci\/tUPx+tfD8re\/qgHnjtFXkUD+8D8Tznrm5Oh7W+TNtzZ5Run1N7fIW+rzmzuO1Aa8+9vqmJ9a8KzIK69skP++5HQPKkNVaz1TZs+7yrV6xjGKFXl9z2hkv8Y+88ccflxrFYMXXTdxCaEd\/ud261S2HC9kYHpbaHPzS3nN4f\/90Xuqrh57rTOlNVR3LtQ12XBIxpXRvjEzK2fHrsvIBfUc1+OmnhbOtGYnLg43+z9Vnv9othCWaxzwb7stB6oCVzImBk0ba9qJGvkmZZOcu78kkyecK0dVS03c2LwHnjlZJ\/\/7zZLcc68SNLr8\/vlnt2Vqi7rSdN4IInNy\/D3ne2O5B4v+icBfLoWX87fVMWn7hmTmO7+rr1Y\/rqEyBslPuq1q6nj42G3NUi1R926c9FrD3vzzOWM7y8mE1lFF6cKTj2neqnNqKoUD9UHHevuKGpRublfrPy945unlXSNSrbXSLcknTndX0Yaq9XrUW6NuuF3Bio2XN\/kXL2hW3OfGXcflYkED0rUuejvyzCOqPP+RZ8GU5Qf\/21+drHd71EDaxVV+dOFYD2LfpChDpedtunvOY+e\/\/x02NPoYG3dbc948XOtS85YPGSM1fs9phbJeEOGtx7yqMDgoPXyVn7cuxbXuBow95i2GSo\/F+n\/eQHp3nZPyvtta9vqBeANZUnZUlG4LQ3X+5IeycdPbsnFDOEEmdQkWldBbtd6Rw+7A\/Xfl7ILbtYWhOn\/yXc84aX4rG96WnXsPyfsf7JGN63xTVako3QoyVXq7YuNWk3HGd1PqXZ4FU5Y2VHPyj78HplOorJOjX0WTIlr55rPsWvgmxTFUyngc7akHn2j32E35k3Ohg2uUvOVDhmpJJv7vmPzpz4flYmCweEhrr6VrkzFf1EoM1Tr5f7YxXlZDpet8wps765X3DsvRPzuD8Cub5B+qtS20fU0GuE4pQwf+VhmEpPWM9NcHqevtCT5f7h2Q8wUmxaRtXs3vqhOfezqEB163j6Eqip1hby6uN6T\/wrcGv09l5NiHnnYv7\/rS+N41pqv7qrXJM0ao8vxHngWXvazJfx0LjVnRY2L+H2YqV3g7kTHPEClTUWuhUkbi5tm9TuDZJmOqG9Dd73tfHXP+v0XOOVfpecsbhspdpvZ6X8+PNqNucaOuyDt9Uv6274PAOCp\/vfVlVmCoXrd0R2oTlGioVBef2ofaVYmBBP0nxk15dezWm4rShSScqBl5KjfuLMg1NafQ2QtfSl+vP4FlxRkrE11m9ZNiq9dZX9+s7HRaWl7bO2bUD4bqxuRV+ezY53IqYab4kcNul3ExA9f1ceUeY3m8+m5KvcujQMq4KUf3uGfa9bO4\/1JjS7wBuSU\/04YP3xDFaeEZooChenB\/XP7LMRxBs\/HPfXXOXnlvyAsK3vIRQ7Ug46qVamfCVX46uFSC662xugJDZYyPCu1XA0Olfzv2V\/94ibbCJesVWldtezvz97puijENjc3Q2SN+1064labxsu26TyvZLm829E31QdfhZZ56V\/l9NPa4besuvM0F1NfCtHMlYEWKGGumj6s8Y4gqz3\/kWXAZy7o3PeolPqWqvN5zQC5GBgB3ZsAvY32vxj57hsgwNv9wB5W70w8EJpP9y7\/8CTe95UOGal7+d487KL1u8t\/s6ZX3\/3xA\/vL3I3L8i3NqugW3paiZFqqESUQbGqqb8rE7jYI2dK\/skvFAK9xqaLwWy9TxpPDkZ50SYUH6NtS52th\/tY23Mz\/DMD1x3OuuqvQOytGhL+TTk1\/IZ87z6MkBeVnzrJ5b9x6Xoyc\/l0+HrhdyFWT7cqPro9iWPF0\/ecYDVZ7\/yLPgspV1b\/qMN3hYn+X\/99nJXCuqbHqWdX89Q2QYqrmvjjgBfIP8Qw1Wn\/Mmkw1f5OAtHzBUc+6Vfyp4vFW7Ei\/G1N93JwdtraH6hzduqp58VDSSV3acDMyHFbOtHdwSZeNe69LqxFi9eUG2qi6tl7cdbzgD+rAzAejGA603VEVos9J71Olt85+HGuq4GnVchD63FpbUFAlX1fQI5tgp09RiqDAKZkD\/zu+S0ZMVjumrs8zf8BlNVsCAZ4gqprFRA9C9K\/XGvRYnc5JYb\/mAoRr7+5Z6UFdXApqTfXqcTg85Y5nM9a6gyy+wLq88d18TWqhmzh7wks3HupXthjsmTE0yepoTkqCWRSTF6TFnws7KHrlobZ3SCfKx173V3X+95cavCG2qN6dVq9OIapmKe34px898IdudVrvKtkE5dWZEhmeKmS28CH18w\/l24MpH00ypz3T5YRaCgU6\/9yciVIODMVMYJ9dMNPHqGaKKaWyCnPlnveatjrzlAybnnDPWKml8kt8l2MRVfoF1mceGdVD6N6Nei25wuy7+1TF\/lQ2SNDt8ZD1NaL2WyigiKd4K3Jdu5xl7S8MNz3jpcTDFmIbVaNnJVuZjbx6qT8ZLOIbqzpg30en2Y1WryfYHpXfL0FyM4Uo08tl\/r4+rPOOAKs9\/5Flwecryz+D\/y5tlGtNZnvrPt649QxRjqPQknqEr4tRcTebFDt7yAZPjT6Kppu34d3guqQffzcjxP7smRhs1NUN7aAyTz\/fH\/5oPBZ+4dUXqPbaFSo2bcqZ70C264VvLBL5Lunqwww2UqaOK0taklC3xJyWlp\/JZrzvf1Kvy0ZmqM2mlv8zFc4PeWKHKuv0ytsoJcPX21d+nfNZRbFdWPvuQRRP\/1jua3feHpg12wtMmRK+SzLLulS+rt8081rJ89t2UepeloPIuO+N1xejKecWdmFC915\/jnmY3TXm1y9eMdIKO3n0hlaH6Z6S1M3CPO8VWnIGPNTmqS\/oPARbf7NmiON0kf9gRNFIuq+vU7Wa2yd\/+b8YJNOqefu6g8dc3yOvqtjJ\/+OuZ+iSi7jguZd5MY+fVRYyhcq9OrKh52Y7H3UzcmxOrIm\/uY7Z0raWOI4UkSTWOyr2lSi2WratPzti390Ppdru0amy9IZ9NFtMSU5g2iebRvzFwEVevBVkpTB\/VStUdiDuVdd2yQ03s2bfXmNhzw3656E2IunIzFNzHZt9rbbxYlcNJmirPf+RZcGnKUldb7XRMVKj1IAiS8Z7xIRgp2\/GhL26o3xC5N\/ZqN+9GyMpwxU1+6RkqYyqDe9ULstM1RgaP\/7XnmJqVfEG8KwnV968Ebvsy+YU7D5ZruuotY\/o2MTXm36rf2y92n0xDFTBL\/n0DozxMnHAnxKXrT+uqonQxhkqZhurNq\/L+tsB8UwY\/r207JCN3irsvW5Ha2BO5aqGq3Rz5DTk6U5w2evsK1WeuKp\/scueacuOH\/7p17xe1+\/zZdVxdg6W1iY1bTZorVZ7\/yLNgyoomCTRBk6IZuF2dVFMkjMk59Rz7alJuh7r3luT2NzdlpnpH5oz\/z1Un5Ny\/LsjFf0\/IzN1w11\/R+1SG9asoXZihcpNddX5BxiaqMqJvcKueZ9UNbsfnijUL7rbxurrGI7O+82oM6KTDjndz5OK3WR9XecYP302pd3kWTFmYBxiAARjIh4F2MFSZk2piF1nxyZX9K18dYKiabIojsOcT2NERHWGg9QxgqOzJHm3s2miTiD52fTBUGKpcmyhJjq1PjmiO5mkZICkmJ0Val9CnGQYwVBgqDBUMwEDJGMBQ2Q1DM4mUZdBTM4ChKlkgTXsmy+9p\/YCBzmMAQ4UBwATmzwCGCkNF6wQMwEDJGMBQ2ZMp2ti1cVthMGPxGmGoShZIaW3ovNYG6pQ6TcsApiE+IWIY7Lq4Jgp27BphqDBUtE7AAAyUjAGSoj0pusaBVzRKywCGqmSBNO2ZLL+n9QMGOo8BDBVmIa1Z4PeNmcFQYahonYABGCgZAxgqe3JEG7s22lShj10fDFXJAimtDZ3X2kCdUqdpGSApJidFWmPQpxkGMFQYKlonYAAGSsYAhspuGJpJpCyDnpoBDFXJAmnaM1l+T+sHDHQeAxgqDAAmMH8GMFQYKlonYAAGSsaADvxBU8VnXw9XC\/SpiGu6XE3cVpjg5+D\/4n5fpu+1LnmegKry\/EeeBVNW550lU6fUKQwUw4CK0l6ydJMgr\/UWC7RJbrlBH7s+Wps8Y5oqz3\/kWTBlFRN40R3dYaDzGFBRGkOlxrxgItEgTwb0cZVnvPTdlHqXZ8GU1XlBnTqlTmGgGAYwVBiJPI0EZdV5wlCVbOwECayYBIbu6N5ODGCo7IYKbezaaOOEPnZ9MFQYqlybKNspabAtmBgYiGeApJicFGlxQZ9mGMBQYagwVDAAAyVjAENlNwzNJFKWQU\/NAIaqZIGUM\/b4M3Z0QZcyMYChwgBgAvNnAEOFoaJ1AgZgoGQMYKjsyRRt7Nq4rTCYsXiNMFQlC6RlOgtnX2l1goF4BjAN8QkRw2DXxTVRsGPXCEOFoaJ1AgZgoGQMkBTtSdE1DryiUVoGMFQlC6ScscefsaMLupSJAQwVZiGtWeD3jZnBUGGoaJ2AARgoGQMYKntyRBu7NtpUoY9dHwxVyQJpmc7C2VdanWAgngGSYnJSpDUGfZphAEOFoaJ1AgZgoGQMYKjshqGZRMoy6KkZwFCVLJByxh5\/xo4u6FImBtrBUFVvTkv\/3j2yccMb8vK6V9XzDdm4bY\/0j05LVSWncpmUx3J077uyvfdd2bFrT8Pn9t535P2T1ZJp5DKxIKeOHZKtW7rlNc2N4mfjlndk54HPZWTmcaGaYKgwVLROwAAMlIyBog3VxaH9tbN5vR2xz0375eKCm0Bb+1qMNgvSt86ihUWj1\/aOFWIeitHHYeDOmGy16OFytP3I9UJ0oYWqZEG0TGfg7CstTjBgZ6DIpHhjbNA3URv2yPGxWZleeCrTc9\/K8f53\/e92jRTSUlWUNuPjF+TTY5\/LZye\/iD6PfSFHz4yEzMT7o\/cKMQ5F6XNr6Z70bXBN56vSd\/KqjN9ZkurCY7k2eV0+6e322Ok7V5w2ecYdpbX\/yLNgyrIHR7RBGxiAgTQMqChdSDK+tfSt7HRbYjYNyHhM197I4XecxPiGnLrT2taptu5mnBmR15zWme7DxbXCFKXRjQuHHC5elf7xpRh+n8qn216t\/eblXV\/GfL\/6LOnjKs1x2Oi3vptS7xr9mO9JAjAAAzDQegaKMlTXzvlJ8bOZp\/FJb27MMw4fjcUlztVPjEWZBvt6A0Z0y3GZjjGi9mU7Q6\/pic\/lZW0olRG\/Ydn\/G2MDddO14ZBcs\/xmNXXCUNHtl6ujJjm2PjmiOZqnZaAoQ3Vq7xv1hLft88TuvOk7C\/XunIKS4mom3WbKHul\/22mdeVuG54o1SEWxc81todo0aDWUY0N7HENlN13N6L\/SZTBUGCoMFQzAQMkYKCYp3pP3nTEw248FrlDT46fmH9eeK01cq\/m7YrRJMEk3v6y3zKjWmR1D38a36rXQeBalz\/S4O\/buDTk6Gde6uSAfbaqPsSpywH7ak5uk3yut\/UfSD\/mOs2oYgAEYKIYBFaVbn5jnrspG3WWjnp+MP5Yb4yOyY4vTYuX8v6KmTth5+MtCumtW06Q1X\/ZTOdpbHxdUUS0ztq6u5stPMHItNGkr2\/4F+cQxTJVKt3yipte4MV83VtNzs\/LpLn9Q+kcXFlrPt9JLs51nTPPdlHqXZ8GUVUzgRXd0h4HOY0AH\/pUlsRwT7vxV6a4Zp27p6\/\/Q6cJyr9oyX9+RoZtxrRA5bk\/bGYbovlUnP\/d00ia05XXWdhqpVk7XfFted5wprhUPQ1Wypn6SY+clR+qUOk3LQLGGyjdPW\/u\/lHGnleHW0mM5f2bAG5Be2TBQSEtVIdrEGpdA61QbDUQvUp\/zQ+5FDT5DenuCz9d2fR579WgrzKjejrTHYtLvVXn+I+mHfEcSgAEYgIFiGFBRuvWtHV4LVT0BbrVc+j89ftxLkEW0yhSiTZyhCoydaqerHYvSx5y\/7OiFaq3Lr6rG4N24WZWjwTnM1EUPRVwJqbXJM6ap8vxHngVTVjGBF93RHQY6jwEVpQs2VO\/KeetM6I+lf0vddG3sv9r67YwzNwX8z7uyb93+wlpcWtGqs7J1LPnjpyzzl+lyxkf9GfiLMuN5xkvfTal3eRZMWZ0X1KlT6hQGimGgEEMVGJT+spoFPSmRjhyuTxOw8UBZDdWs7FSmV9fT1uAVkQUYu6R6atl3AXaSjdKSd6VfEezo+sozpqny\/EeeBVNWMYEX3dEdBjqPARWlEw3NqiTK+Wnv1imNkl2RhqoQbQyj5Hd7viHHb0YHq69K\/RjbYFtHIfp43cVvy8h8sh5uy14jxmz7l+X\/Wps846Uqz3\/kWTBldV5Qp06pUxgohgEVpVtvqNSg80+3OQOIE2eyDnT5FdBCVYw2YZMwdMCZAiBRp\/AyWYxAmmUL0cdroXpVPoudg8rVIsBOf+tvz6O1yTOmqfL8R54FU1YxgRfd0R0GOo8BFaULMFR6jIs\/XcInltvK6KkCarcYUdv4\/rli5hNKYzDy\/+2CdxPgIlpZ8t8f1+xkeVXTJTj3gHy59wvrLPtVdXsazbZ+9hUwF5Veb57xUpXnP\/IsmLI6L6hTp9QpDBTDgIrShRiqW0uzssNJeHpyxqMT4Xv1Tc+Med2ClUrSwPUsybnNl\/W6t5QpKKWhjK+fs0fcm2ZXZOPeEblmXNRwTU0UW5\/nTBsqxU6DrsHVMI76uMozpvluSr3Ls2DKKibwoju6w0DnMVCcoXou0+N+C5Tejo3b3pWtG96Q7m3+TNf6\/x+du1eI6StSm1qSn\/nSmYurUfdWvPFYDaMQLLM4fZbkU3fW+Jopf1W27vpQ+g7sl+2bnNnka\/+vSP942KgHt38132tt8oyXqjz\/kWfBlNV5QZ06pU5hoBgGVJQuxKy4yWx68oLsMJKg3qbac9MeOTVZTELU21e4Nqrbqt7lqW6EXEAri1tHttdi9XksQ0c+9LqEPWYcdjb2HpLhAmfY19uTZ0xT5fmPPAumrGICL7qjOwx0HgMqShdqqNxkPX3nWzk7dl1GLlyV4QvX5fxMGcdMFdPS5NbB2nx9LOOTVRnR7Kjn2Ylv1SSfxeuoj6s846XvptS7PAumrM4L6tQpdQoDxTDQLoZqbSbz4hM3urVnHWCouJdfro6aBFlMgkR3dE\/DAIbKnpDRxq6NNnLoY9cHQ4WhwlDBAAyUjAGSYnJSpAUIfZphAENVskCa5iyW39LqAQOdyQCGym4YmkmkLIOemgEMFYaK1gkYgIGSMYChwgBgAvNnAENVskBKi0NntjhQr9RrGgYwVPZkijZ2bdxWGMxYvEYYKgwVrRMwAAMlYwDTEJ8QMQx2XVwTBTt2jTBUJQukac5i+S2tHjDQmQyQFO1J0TUOvKJRWgYwVBgqWidgAAZKxgCGCrOQ1izw+8bMYKhKFkhpcejMFgfqlXpNwwCGyp4c0caujTZV6GPXB0OFoaJ1AgZgoGQMkBSTkyKtMejTDAMYqpIF0jRnsfyWVg8Y6EwGMFR2w9BMImUZ9NQMYKgwVLROwAAMlIwBDBUGABOYPwMYqpIFUlocOrPFgXqlXtMwoAM\/TzSAgfwZSHMcNvqtqh\/\/0ejHfE8SgAEYgAEYgAEYgIEoA76bUu8QKCoQmqAJDMAADMAADMBAIwYwVHQhMh4HBmAABmAABmAgIwMYqowCNnKsfM9ZDQzAAAzAAAx0PgMYKgwVZyUwAAMwAAMwAAMZGcBQZRSQs47OP+ugjqljGIABGICBRgxgqDBUnJXAAAzAAAzAAAxkZABDlVHARo6V7zmrgQEYgAEYgIHOZwBDhaHirAQGYAAGYAAGYCAjAxiqjAJy1tH5Zx3UMXUMAzAAAzDQiAEMFYaKsxIYgAEYgAEYgIGMDGCoMgrYyLHyPWc1MAADMAADMND5DGCoMFSclcAADMAADMAADGRkAEOVUUDOOjr\/rIM6po5hAAZgAAYaMYChwlBxVgIDMAADMAADMJCRAQxVRgEbOVa+56wGBmAABmAABjqfAQwVhoqzEhiAARiAARiAgYwMYKgyCshZR+efdVDH1DEMwAAMwEAjBjBUGCrOSmAABmAABmAABjIygKHKKGAjx8r3nNXAAAzAAAzAQOczgKHCUHFWAgMwAAMwAAMwkJEBDFVGATnr6PyzDuqYOoYBGIABGGjEAIYKQ8VZCQzAAAzAAAzAQEYGMFQZBWzkWPmesxoYgAEYgAEY6HwGMFQYKs5KYAAGYAAGYAAGMjKAocooIGcdnX\/WQR1TxzAAAzAAA40YwFBhqDgrgQEYgAEYgAEYyMiAa6j+P7iu59BiZzehAAAAAElFTkSuQmCC","width":251}
%---
%[text:image:3ff8]
%   data: {"align":"baseline","height":101,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAABVQAAAECCAYAAAARnFzdAABmb0lEQVR4Ae2937MexZnnKW\/sTMzOBh0bMXvlf4GrnY22p5fYP2AG45lLZnD33cq9V90mfNPYEZYbXzQi6DbYI2MbsZqWHWAwYEu0JMKyEW1hkBGNQMLWD0A\/4AgdjhCSAEkIQ66+R85znjdPVr1VlVXvW1X5yYj3VJ36kZX5yeep\/NZTVVnrHAkCEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQqEVhXaSs2ggAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAUdAFSOAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIFCRAAHViqDYDAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAAAVVsAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIBARQIEVCuCYjMIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAgRUsQEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhUJEFCtCIrNIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQgQUMUGIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhUJEBAtSIoNoMABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgQEAVG4AABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgUJEAAdWKoNgMAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAABVWwAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgEBFAgRUK4JiMwhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACBFSxAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACFQkQUK0Iis0gAAEIQAACEIAABCAAAQhAYDqBTz75xH366acrv+l7sAUEIAABCEBgWAQIqA6rvSjtjAns37\/f7d69e\/l34sSJxkdfWFhYyUd5ktIIWJ7bt293V65cScuwpb0\/\/PBDt2nTJrdly5blqS4k+posQ2yyr61EuSAAAQhAAALDIbC0tOTWr1\/v1q1bt+Z3ww03LK+T\/iA5NyTNWNRe0uBe8x49erRos9LlVo+i6UtRFa7016p94ldYWFZAYGQECKiOrEGpTrsEJP6sKNTd9ibp7rvvXslHeZLSCFieap+mIi6tFGv3VtC9DXtZm3P7SyxDbLJ9vuQIAQhAAAIQyIWA9PHNN988oYGsHgrnpTtSHlQYA9chacYi3p\/97GdX2nzDhg1Fm5Uut3oUTV+KKrpSvmf9qy\/XRNHCshACIyRAQHWEjUqV2iNw4403TnRSTQOqemrRd3bKk5RGwPIU176Ict1l9+2saVN7SaNTbW\/LEJusxoytIAABCEAAAhCYJKC3hKz2qTP\/6KOPTGb2x\/\/0ho+CddInCr6O8anWIWnGaCNdW2ivkxQYbZKsHpXtoOnrUZSvWJ\/rC796tWBrCAyXAAHV4bYdJZ8BASsU1Fk1DZDZu688DZjecIivdIbYZDpDcoAABCAAAQjkTiDUytLLX\/3qV5cDYxcvXnQaBkBDCxUNBfDee++tQZhDkIiA6vVmR9OvMf9aC8InVAmo1sLHxhBIJkBANRkhGYyZQCgSmwZUJRYPHjy4\/NOYSaQ0AoivNH7aG5tMZ0gOEIAABCAAgZwJKFBqn47TQwNl49rHnmbVUAFhIqAaEunn\/\/Y6iSdU59dGusbUq\/687j+\/NuDI+RIgoJpv21PzCgSsUEh5QrXCodikBgECqjVgsSkEIAABCEAAAhDogIB920U6WU+kTksff\/zxRBBW+ymAahMBVUujv\/P2OomAan\/biZJBAALdESCg2h1bch4BASsU5hFQ1VOE\/o6jXg1q8oSsngZQHv7uZezVqipNZfPREwnKr4pwLspbgtrXre5TuykBVR1Xr8P4Yzepg3+FTa+x2bI3eX1Lefi2UbnKnuwoYjnL5ak2qfqJk+qtvMKLqFnWhWNBAAIQgAAEINCcgNXJmq+awtf\/Q30bvsYszVYleU0lXSWtKl0l3dc09UkzzkuHi4G4+p9tK9v+8wio9ql9ZGPe\/mSvaPqmXsd+EBgWAQKqw2ovSjtjAlYopARUd+\/evXw3Xq9C3XTTTRO1sMFBzStt2bJlzd17HV8\/vRplxcxEZuYfBavC8vs8NNX4VlVEpkSp\/YqnzcPPS0QVlcnWz4ttu0x51P0yaLi\/RItN4ZMNWjeNh9qoLClPldPXOZzu3bt3WUjZ5UVMdJyyNhZvXQiESXWw+Wte7VOUbr311ontvX1p+1nbZBl\/2aLS9u3bl21N9VfQlQQBCEAAAhCAQH8JWJ2pvrtqkmayekaBKKXwxrTdxs+HN56lZcv0mfZTOYuCsn3XjPPS4eJl29fz19Rfi+iaxi\/vKqDa9\/aR3c5b08v3dI2ptgj1s71m8tcBZeX1bat6FSU0fREZludIgIBqjq1OnSsTCIVEWYCsLFPbmYWC065TYEkdmRcnZdOy4ykwVbavXRcGI22+4RMEdr\/YvH1a0+dj6yfhpTqG+9YVYTZP5RXWIRRf+opseMzY\/xL4sSSxHtt+2rKYvSgv2cC0fbVethCm2EWD6humcFwz5WcD6JZh1zYZXjjF6i4haG2\/bpA9rD\/\/QwACEIAABCDQLYFQJ4d6rOzo0kj6WQ1TJaBqA6OxG80xjeGXxbRFnzXjvHR4WcDNswyndbW8tw2rR5VnaEN9bp8+aHr5kG2LkJ\/l28Z1JpreWy5TCFwnQEAVS4BACYFQKMYCZCW7r6yynVlZ8Mp2iJr3QSZ\/19Gul9iJpZgI0v4SZfZOss3LPxlg84sF5MRD+Us0xfLS+jD5usfq4MtQVJcwL\/+\/z9PvH4qHUHz57fxU5bTBO79cUyvs\/fFiZdeyojx8fqG9hKLHbyeWap\/YcfSUaZjC7bSvTbHjhE+yWoZd2mSR8FIblAWWmwpzy4F5CEAAAhCAAAS6I6C+2msZP5W+iN1gr1IKH1ANdY7y9sus5vPL\/LE1VdBIurIoGBk+wddXzTgvHR47rrhKq0q7WdZ2vqlus3pU+dn2lc30tX1iWttzmqWmD\/mE\/EK+ts3kP7qWiflR7NoMTV\/lLMY2uREgoJpbi1PfWgRC4RAGyKpmZjuzKsErdWy6625T+GRimI+21dietqPUfPgquzre8ClRHS9MYd3DgJy2l2AOO+GQka27LZvKoDqG9QzLEfs\/zDMUD6G48MfVfjbFnmywTz5o29jTrSGLoieCQxbhK\/hiHL66prr48vppeLxYuS2D8DhiHSbLMLQlu86XoYlNxtpBeWu5T6pLaEM6ZlNh7vNlCgEIQAACEIBAtwR0Q97rhHCqvl36QwG6UOtMK1WoH0Jtpv198NUfVwE\/qy\/8MUIdF+qL8Fg+v3lrxnno8BgLaUqrZ6X9YzfEQ66e\/7RpqDmtntW+sTKpjebdPqHWnpemD\/mE\/EK+Yoemn2aVrIdAdQIEVKuzYssMCYRixgqKOjhsZzYteKVOTp1jLIVPRIblCTv3mAD1+YbbhoFNG+QKRYvPQ1MF+7z41DQsk627366sXDbvovkwz1A8hOJCx1XQM5bCi4FQEPoy+2nRR6xCDtrespAA9XloKtsqSmHAVO0eppCB8lSKlSPcV\/\/b\/buyyTDQrGMWJWtvqkvYDkX7sRwCEIAABCAAgfkRCAOWVuuE89Ke0gbTnmANdVyo81Tb8EnKIu2sbW0AMNQX4bFU5nlrRpXZ6qIy\/RTqPqs9lY\/Ve749inS4H1\/fbxe7Ia88lcJrpJDr9a2m\/w3LF7Z1H9unT5o+5BPyC\/k2vc5E00+3ZbbIkwAB1TzbnVpXJBCKhVCkVMxmQsxMC16FHaE9Rtgp2vLo7r8XQJpKtJalcHsJYp\/UOavD9QI0fD3Kb6dpKGhtmbQ+LLP+T01hniGzUFyEzO3xw22tIAzrFnv9xeYVDoNgWUiU2vYpCsz6\/MLtVc4w+fbx+YbH1\/LYcA7KxzIM+dh1yiPka8sRbmvrbC8GlE9Z0jF8PTS17VC2H+sgAAEIQAACEJgvAfXhoSaxfXpsXpqlSAuF2iymQ6TJvFaN3Xi2RKyeD\/VFeKxQE9l8wm1tXm1qRh3H103sZqXD6+i28Oa\/ZWGZTZsPdWTY1iHzPrRPqNGL7NjXPdxedQpT6D9VNX3IJ+Q3ja8tR7gtmt7SYR4CcQLlV7jxfVgKgWwIWAEmQWM7ljoQbAcVCgG7TscoS+okrSi15QlffSoKpNn8beetjrtu0mDs056aDetnP4xU93h++zDPUDyE4iIc9sDn46eWgxWE4XGmlb3sKQFrS5qflsK2jrVneIfc2obmVf6iZOvWhU3KNm15Yh+CCMtmhbxth3A7\/ocABCAAAQhAoH8EFFjSDfpYMMhqAjsv7RSmUMeFOi\/cvuh\/5RMGOkN9ER6rD5qxqD7h8jZ1eMhBQcBpqQ3dZvWo7CJs67BcfWifPmn6kE\/IL+Rb1qbhtYe\/zkTTl1FjXe4EyqM3udOh\/tkTsB2mOnnfsdQFYzuzsuDVtEBbGDS15Qlf01FeCmJJEBX9rKANy+XrqI5arwZJICsfiWQroGweMUa27lrfRgrzDMVDKC7K7uyrPLadrdC2weIiPrY+4d162z4hp7K20bqQcVhHf9zwFRx\/nGnltQzDbe26pjYZtkHsgsnXwU+L2sGvZwoBCEAAAhCAwHAIKMAqfVr0gSivWcIxVkMNUaSBPAl\/HGk4vaFl9YQ\/hp9anaf9w2P1QTP6evnyzUKHhxp2GnOVzerkkKutQ9m81Zxqo\/C4fWwfb0t+Ok9NH\/IJ+Vm+aPoyS2QdBJoRaCe60ezY7AWB3hMIBZkNkNUpvO3MyoJX4brwGGUBVXsM38HXmcY62TrjYvljhYxsuWLHCOtY5X+bp44biodp4iI8hm1nKwjt8iplD4\/rWWjq+TSdhnW0dYjlOW18MsswtLuydfa4mi+yyXBs2rLy+zzbEOY+L6YQgAAEIAABCPSLgLSB7eu9flFAyqZQTxVpCGkdq9V8fmVTq\/N0zKrH8uWzx7N52eUpmtEfR9NZ6vBQzxUxt+XTsAuetWVht5k2bzWn8gqP27f26Zumn8bH8g31ftg2oQ346xg0fUiK\/yGwSoCA6ioL5iCwhoAVR+rkfceyZsMpC8o6s7J1YbZFHZ22s\/l4cVNnqicibaryupaeAgi3CxnZck3ryO3xy+ZtnrMSX1XKHooazyJcXqdd\/LZFHxDQ615+Gzud9kqUZRjWrWxd2C5FNilBbMsTCuQwH\/1vbampMI\/lyzIIQAACEIAABNoloKdK9VSjftPGkAyPHL5dE+qQUDfFNESoP6zm8PPKV3rC\/69pqC+qHMuW314b2Lzs8rA+dn8\/Hx7Xa0a\/3moiW34736YOD3nGmPuy+elQA6op7RO2m22PqvNtavqwPGG7oem9tTKFQDcECKh2w5VcR0LAiiN1kqHYqVrNss6sbF2Yfyh2bHlCwSiBK7Fb9NNd\/XCdP97evXsnxKfqrte1JAC0nz1ueNfSrlN+dernjz9tavNU2ULxME1chPnbdrbiWILLiyNtMy3pgsJvr6lnoaldrqETFAgN+Rf9L+aqUyzZsttjaF77FSXLMBSWZevC\/IpsUse25QnbKMxH\/9u62HaIbcsyCEAAAhCAAATmRyDUnUU6paiEZRqrio6zGkPzejBAT3RKl4Zj3tvgZKgvqhzL1qFIq5TVx+7v54s0o9bPQ4dLp1mm0nfTkgK6fp+Q67R9\/XqrOZVXqBf71j590\/TT+Fi+od73beCnaHpPgikEqhMgoFqdFVtmSMCKJnXyPkBWF0VZZ1a2LjxOUUen7RTs9KJG0ypCKMzf\/x\/WOxQ3fjtNy8qk9XXqp+2rJJtnl+JLgU\/LVKKlLJV9lKqu0C47jl8XPuFhy6r5MuFkGYbbla3zx\/bTovYPBZ4+ClGWwu2bCvOyY7AOAhCAAAQgAIF2CIQB1bpPqVrNIt1pU6gJQh0aag8NI1CWrK4N9cW0Y4X5FuXVpma0xxCnsP62TCGL8FqlqqbTTX3bJnr6dFqy2jbkOm1fv96WL1bXPraPrXdou75edadNNf00PpZvqPfDMhbZUngMNH1Ijv9zJkBANefWp+5TCYSCJhQpUzP44wZlnVnZujD\/oo5O20lsWSFURdjY7dWR+2TrHQ4F4LfxU\/u6j\/ILGdWpn89z2tTm2aX4Co8zTUDYO\/UhCyu+wnWx+obCKtwmfAJUeeqp5PBjVkWC2NYtFFhl68JyFNlkKL6mCc7waYwq9huWhf8hAAEIQAACEJgNgfAmsp4OrZOsXgl1SKghwoBiqD30VGpZkkbyv1BfTDtWmK\/VyDYvq510rBTNaI8xKx0ecph23PAJW8siZFb2f8gtbOuwXOH6MG\/LzpYpPE5K+\/RJ00\/jY+sd+lnILvQrf00XHgNNH5Lj\/5wJEFDNufWp+1QCtlOWOGqayjqzsnXh8Yo6Or+dF4t+6jtCv95Ow4Hu7VfYbb3LOt\/wbraOGx6zTv1s+crmbZ46Ziiuwo4\/XB\/mbetrxVc4nEGZuFQw03P3U8siDJCqDmXJ56Fp7LihmPOB09BGtL\/KFibLMGzjsnVhPuHxbJ3DD08UtYP2sfXVvG2H8Jj8DwEIQAACEIDAfAmEATX13UX9fFjS8Ga8hpWyKdRx4ZiTofaI6Ryfn\/SE1RihvgiPNa0Os9CM9hihRvP10rRtHR7qtrKgY\/gQQcjVlrNs3mrOmA31sX36pOmn8bF8y2xJbRT6FZq+zHJZB4HrBJpHiCAIgQwIWEGjTl5BSAUep\/0kQKwgK+vMytaFiMs6Om0bBknVcdrO0OcXbqe62aT9rPi0dfHbhWXx24fHq1M\/n\/e0qc1Txw3LN01chPnbdg4FoV2nY2kcrjDFgqna1rIIy6T1sQ9HSRyH\/MPtwvqHAdfwtbNwvcpv8wgFVtm6sO6hHdg6h+tUZxu4V14KWqt8Wmd\/YTuEx+V\/CEAAAhCAAATmSyDUG+rHFWyS5okljW0a20d6wSZpCasJwoCrdJ9dH9NmKsOGDRsmttM+ob4I9VmoKW25NG91YZiXXadjxcpVRTOGOjBWppjG0jGtDlN5UzSd8gt1m\/KMtWHIQttVSbZ8Ol5Y1z62T1gmlTvU6qr7LDR9WJaQn+Ub6v2wfUKbsrYUrovZBpo+JMr\/ORCYjKLkUGPqCIEaBEJhpM6jzs93RGWdWdm6sKhhZ+bzt9vFyieRo45egdRQpGn7sPONBVwlZpWHyhvLwx9Xd7clYNXBK9Wpn61H2bzNM1b+aeIizNu2cygIi4Svnq7Qa+oxUekDhGH7hK+1q+wS2+IttrG8VDabYuXRsjD59vDTsF6WYSiwytaFx5lmk+HTDiqPjqcnGzwnX0Y7DcsbHpf\/IQABCEAAAhCYL4FQb9l+XPpGelCaQhqySDuGwVJfo1Aj6H9pIgVli44rPaWArvK0ZQnnpTGkyZTCvEJN7Mvjp7PQjPPU4eGTp2InLSdeKpdvFz\/1bJvqNqs5lVfIv4\/tI1voi6afxsfyDfW+t2k\/RdN7EkwhUJ0AAdXqrNgyQwJWNHnBUGfqA2plnVnZuhD5tI5O20tohiKnrMwSnrFUNQ8JqFj+VeoeO26VZZaZjt2l+FJ5dHc+VsdwWXix4BnYOsVEcpiP\/19tEOYRtosuVmJJTHw+fir78ckyDAVW2Tq\/v59WsclpFzYqX8iuqTD35WIKAQhAAAIQgED3BGJP4XndMW1aFExVqWM3mZWff\/1fb4NNy1\/rpS9ieXmdMS0gFRK01wY+D7tNW5ox1HtFde1Ch9s6Fh03XB5jYbkUzVvNqTzR9GtJlWn6afZr+YZ6PzwSmj4kwv8QmE6AgOp0RmyRMYHY03WhgCj73wfD7FhR4es\/dp2OV5bCMT3ViRal2GtOtqwSajbAFuajvGN3qX0e6pS96IndpfV1twHEsO7hMav+b\/NUecInNENxIW5lybaz8o4lHaNM3PrApt2mqH3E3W7nmdqpz8+WJeSsPMpSaAMSyD5Zuwvbxa5ryyZ1AVQk0L0IVzk8A7\/Ml5cpBCAAAQhAAAL9JaA3bXwfPm0qfRlqt7Bm0lAx3eC1p7afFry0WiK8cet1Vl81o8o1Tx0udkXtKP2pMXRtULtIP4ftGv6Ppr\/+9mNTTT\/NftH0ocXxPwTaJUBAtV2e5AaBXhHQ06oSuBJFEp26S6mg3DQRayshwSSxow5ZP+2vZWHSV+cVNJPQ1fxYk+onjmKqqcSkODdJCqz6NhFj\/cTQB6Ob5Nn3fVQ32Yd+ITcr3GWvJAhAAAIQgAAEhkXAaxs9faqfng7VTxqyicaR5pRu1TTUDZ6MNIPXqdJS0moKNIVJy\/XTjfbY+nD71P\/b0Izz1OF6+lhvsknz6ie20x5SSGU2y\/3baB9fXm\/3uk5C07uJYDya3lsJ0zESIKA6xlalThCAAAR6QEAXPhJR+km0liWJdhtQlTAlQQACEIAABCAAAQhAAALzJYCmny9\/jt5fAgRU+9s2lAwCEIDAoAmEY5aVPQ1SZ9tBQ6HwEIAABCAAAQhAAAIQGBCBOjq9zrYDQkBRIRAlQEA1ioWFEIAABCCQSkCvidmnTjUWWCyoqlejwu1Sj83+EIAABCAAAQhAAAIQgEA6ATR9OkNyGCcBAqrjbFdqBQEIQGDuBDReqg2U+nmNqaaxYzX1y+y0aIy0uVeIAkAAAhCAAAQgAAEIQCAzAmj6zBqc6lYmQEC1Mio2hAAEIACBugQ0FqoNlk6bnzbWat3jsz0EIAABCEAAAhCAAAQgkEYATZ\/Gj73HSYCA6jjblVpBAAIQ6A0BPXG6YcOG0sCqxlvSh6lIEIAABCAAAQhAAAIQgED\/CKDp+9cmlGi+BAiozpc\/R4cABCCQFYGLFy86PYXqf\/qfBAEIQAACEIAABCAAAQgMhwCafjhtRUm7I0BAtTu25AwBCEAAAhCAAAQgAAEIQAACEIAABCAAAQiMjAAB1ZE1KNWBAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEuiNAQLU7tuQMAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIjIwAAdWRNSjVgQAEIAABCEAAAhCAAAQgAAEIQAACEIAABLojQEC1O7bkDAEIQAACEIAABCAAAQhAAAIQgAAEIAABCIyMAAHVkTUo1YEABCAAAQhAAAIQgAAEIAABCEAAAhCAAAS6I0BAtTu25AwBCEAAAhCAAAQgAAEIQAACEIAABCAAAQiMjAAB1ZE1KNWBAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEuiNAQLU7tuQMAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIjIwAAdWRNSjVgQAEIAABCEAAAhCAAAQgAAEIQAACEIAABLojQEC1O7bkDAEIQAACEIAABCAAAQhAAAIQgAAEIAABCIyMAAHVkTUo1YEABCAAAQhAAAIQgAAEIAABCEAAAhCAAAS6I0BAtTu25AwBCEAAAhCAAAQgAAEIQAACEIAABCAAAQiMjAAB1ZE1KNWBAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEuiNAQLU7tuQMAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIjIwAAdWRNSjVgQAEIAABCEAAAhCAAAQgAAEIQAACEIAABLojQEC1O7bkDAEIQAACEIAABCAAAQhAAAIQgAAEIAABCIyMQOWA6nvvvef0I0EAAhCAAAQgAAEItEsAndUuz7HkdvLkybFUhXpAAAIQgAAEIACBXhFI1VmVAqoS+f\/yL\/+y\/Dty5IjjBwNsYK0N\/OIXv3CHDh3CPzhHYAMRG5BvyEc4d6w9d8AEJrIBr7O4ed0rnT3Xwrzxxhvu2Wef5bwZ6VM4b3LelA0cPHjQ7dmzBx\/BR7CBAhv4zW9+41566SX4FPChL6Evkc46evRoY71XKaB69epVp8itfh988AE\/GGADERu466673Ntvvw2bCBvOG5w35RvyEWwBW8AG4jbgdZY0FwkCInDp0iW3f\/9+zpvoCmygwAZef\/1194Mf\/AA+BXzob+P9bU5cnnjiCffyyy\/jI\/gINlBgA9JZH374YWPhWSmgqtx1MawfCQIQiBP4xje+wbAYcTQshcCyb8hHSBCAQJwAOivOJfelerKIBAEIxAm8+eab7r777ouvZCkEIOB++tNHl9+gBAUEIBAnkKqzCKjGubIUArUJvPXWW+7jjz+uvR87QCAHAvIN+QgJAhCIEyCgGueS+9JUoZ87P+o\/bgJXrlxxi4uL464ktYNAAoFz584tv+2QkAW7QmDUBFJ1FgHVUZsHlYMABCAAAQhAYAgECKgOoZVmX8ZUoT\/7EnNECEAAAhCAAAQgMAwCqTqLgOow2plSDoDAJ598MoBSUkQIzI8APjI\/9hy5\/wQIqPa\/jeZRwlShP48yc0wIzJIA2mKWtDnW0Ah8+umnTj8SBCAQJ5CqswioxrmyFAK1CTCGam1k7JARAX25XD5CggAE4gQIqMa55L40Vejnzo\/6j5sAY6iOu32pXToBxlBNZ0gO4yaQqrMIqI7bPqjdDAkQUJ0hbA41OAIEVAfXZBR4xgQIqM4Y+EAOlyr0B1JNigmBRgQIqDbCxk4ZESCgmlFjU9VGBFJ1FgHVRtjZCQJrCTzwwAPu4sWLa1ewBAIQWPYN+QgJAhCIEyCgGueS+9JUoZ87P+o\/bgLvvPPOta+Y\/3TclaR2EEgg8PTTT7vXX389IQd2hcC4CaTqLAKq47YPagcBCEAAAhCAwAAIEFAdQCPNoYipQn8OReaQEIAABCAAAQhAYBAEUnUWAdVBNDOFhAAEIAABCEBgzAQIqI65dZvXLVXoNz8ye0IAAhCAAAQgAIFxE0jVWQRUx20f1G6GBPbu3esuX748wyNyKAgMh4B8Qz5CggAE4gQIqMa55L40Vejnzo\/6j5vAhQsX3IsvvjjuSlI7CCQQOHLkiFtaWkrIgV0hMG4CqTqLgOq47YPazZAAH6WaIWwONTgCfJRqcE1GgWdMgIDqjIEP5HCpQn8g1aSYEGhEgI9SNcLGThkR4KNUGTU2VW1EIFVnEVBthJ2dILCWAAHVtUxYAgFPgICqJ8EUAnECBFTjXHJfmir0c+dH\/cdNgIDquNuX2qUTIKCazpAcxk0gVWcRUB23fVC7GRL43e9+5z766KMZHpFDQWA4BOQb8hESBCAQJ0BANc4l96WpQj93ftR\/3AQuXbrEF8zH3cTULpHAwsKCO3\/+fGIu7A6B8RJI1VkEVMdrG9QMAhCAAAQgAIGBECCgOpCGmnExU4X+jIvL4SAAAQhAAAIQgMBgCKTqLAKqg2lqCgoBCEAAAhCAwFgJEFAda8um1StV6Kcdnb0hAAEIQAACEIDAeAmk6iwCquO1DWo2YwIbN250GieSBAEIrCUg35CPkCAAgTgBAqpxLrkvTRX6ufOj\/uMmoNeZN2\/ePO5KUjsIJBB48skn3eHDhxNyYFcIjJtAqs4ioDpu+6B2MyTAR6lmCJtDDY4AH6UaXJNR4BkTIKA6Y+ADOVyq0B9INSkmBBoR4KNUjbCxU0YE+ChVRo1NVRsRSNVZBFQbYWcnCKwlcM899zDo91osLBkJgU8\/\/TSpJhoQXz5CggAE4gQIqMa55L40Vejnzo\/6j5vA6dOn3ZYtW8ZdyRHXTtrS\/0ZczblWbceOHe7IkSNzLQMHh0CfCaTqLAKqfW5dytYpgb1797p169Yt\/z755JNOj0XmEBgqAfmG95Obb755qNWg3BBoTEAXe+vXr3df\/epXa\/3qXuQTUG3cRKPeMVXojxpOC5XrWgt+9rOfXe5D654PWqgaWUCgFQJt+8ju3bvdjTfeuKItvcbUshMnTrRSZjKBwCwJtOkjV65ccRs2bHA33HDDhI+oL1E\/Qsyi\/ZZN1VkEVNtvE3IcCAHbmXNyGkijUcyZE1AQ1YtddeYkCORGQBd43gfqTCWG6yQCqnVo5bNtqtDPh1SzmnapBTW+pz9n3H333c0KyF4QmDOBtnxENyfDIJH3DzvVDUwSBIZEoC0fqao3Dx48OCQ8vS9rqs4ioNr7JqaAXRDQich23m0EVJWn7iqRIDAWAtu3b5\/wk5SAqnwDATAWy8irHlUFru1TNE9ANS876aq2qUK\/q3KNId8utKDlYi+yCahaMu3Nf\/jhh+7o0aPtZUhOEwTa9JGbbrppQlOqn9RN+9hy\/GWiGZL+OXXqFB9NTiJYvnNbPqLrpFBHqg\/RDYZwuf4n5lDeLnXWpuosAqp1aLPtYAkoYLq0tOQUILIC15+g2gio8lGqwZoHBY8QuHjx4poOPCWgykepIpBZNAgC6h8UVNXTZmU\/+8qX+pa6NxB4QnUQ5jDzQqYK\/ZkXuMcH7FoLqt9UcE\/Dg3h96acEiLoxDD5K1S7XrnzEPq0tn9i0adNEwRUcksb0\/qIpAaMJRI3\/4aNUjdFFd+zKR8J+I9SQocakT4k2T6OFqTqLgGoj7Ow0NAI66dhOOpzXyTE1EVBNJcj+fSIQey2LgGqfWoiy9I2AvVn36KOP1C4eAdXayLLYIVXoZwGpYiW71ILSkaG2tP9z8VuxkWpuRkC1JrApm3flIzZYdOutt0ZL8fHHH0\/4UBhQiu7EwqkECKhORVRrg658xN5QKHrqXmOo+n5FPkVqh0CqziKg2k47kEvPCXR18rPVfu6559zly5ftIuYhMEgCVvjaV01SAqryDfkICQJjJGD7GL2+2CQRUG1Cbfz7pAr98ROqXkPrp\/6i1E5Tbq4TUK3eDm1uqaeCDxw40GaWWefVlY\/YG45646Mo2df\/VRZSOoHXXnvNnT17Nj0jclgm0IWPhP2HxhuOJb1t6\/ususNKxfJj2XUCqTqLgCqWlAUB3fWU6NJYS\/qFr56kiOgsAFLJbAjYsYDUWatT9513SkA1G4BUNDsCVuDKV5r2JwRUszOdShVOFfqVDpLJRl1rQasz9bqynsTz\/SfBoUyMbODV7MpH7NN3ug4rSvZDqPhMESWWz5NAFz7ir7V03VV2U95+24InVNuzglSdRUC1vbYgpwER8CcuL3SbXgAPqMoUFQJTCUgkeJ\/Q1Itev4yA6lSEbJAhATs8hsa4apoIqDYlN+79UoX+uOmk1a5rLahxIn3\/SXAora3Yez4E2vIRjaOv\/rGsjwyf0tu\/f\/98Ks1RIVCDQFs+Mu2Q4c373bt3T9uF9RUJpOosAqoVQbPZuAh0cfL7\/ve\/7y5cuDAuUNQmKwL2lSzdBVWyAjcloCrfkI+QIDAmAvZpgRT\/EBMCqmOyjPbqkir02yvJ+HLqQgtaSgRULY1u5hcXF90jj9Qfs7qb0owv1659xBKzr\/vbm\/p2G+brE\/jlL3\/p9No\/qRsCXfmIbkJo2LUNGzas+aB22VOs3dRy3Lmm6iwCquO2D2pXQKCLkx8fpSqAzeJBELADnduO2vpKSsBIwkA+QoLAWAhY39DFn4aSSUkEVFPojXffVKE\/XjLpNQt9uO23lQioprfRtBz4KNU0Qmnru\/YRlU760D\/J7ac80Z3WbnZvPkplabQ\/35WPaKxh7w\/htOijVe3XLo8cU3UWAdU87IRaBgS6OPkRUA0g8+9gCIRi1l5UWl8hoDqYJqWgMyBgb0Lo6e7UREA1leA4908V+uOk0k6tbP+mC1bb97VxBAKqbVAsz0MB1e9+97vlG7G2MYEufUT+Zj+C6oNGjA3ZuLmiOz722GPu1Vdfja5jYTqBrnxEw655n7BTP8xU2fAZ6bXKK4dUnUVANS97obZ\/JNDVyQ\/AEBgiAdtRx76+6te3ETQaIh\/KDIEYAe8Xmsb8JrZP2TICqmV08l2XKvTzJTe95l1rQQKq09uALfpNoCsfscPl2L6UIFG\/7YHSrSXQlY\/YI+kbFzGfafsmoD1mTvOpOouAak7WQl1XCMzi5LdyMGYg0GMC9ik7idqDBw+ufDhAHwR49NFHVu6Q6q6olknwajsSBHIlIB\/wF4HyizYSAdU2KI4vj1ShPz4i7dWoay1IQLW9tiKn+RBo20cuXry40nf6PlRTPZVKcGg+bcxR0wi07SNlpQn9p42b+WXHy2Vdqs4ioJqLpVDPCQJdnPxOnjzprl69OnEc\/oFA3wnYCz4rbqfN1w0iyTfkIyQIjIGAhr\/wPqKbDm0kAqptUBxfHqlCf3xE2qtRF1rQls72r4wJacm0N3\/58mV3+vTp9jIkpwkCbfpI7BXmm2++2Wk5qTsCZ8+edR988EF3B8g85zZ8RIFRaUn9po2Paj\/epj6GlE4gVWcRUE1vA3IYIIE2Tn5htRlDNSTC\/0MgoIs8HxiqM607niofpRqCNVDGKgTCJwSuXLlSZbep2xBQnYooyw1ShX6W0CpWugstaA9NQNXS6Gaej1J1w9Xn2qaPhBqTN5085W6nfJSqW75t+Ii9FtuwYUNpge24w23d0C89YAYrU3UWAdUMjIQqriXQxskvzJWAakiE\/4dAQOPyKECkJwRiv6WlpZWAq4Ko2kbb1301i4DqEKyBMlYhYIfJaHNcYQKqVejnt02q0M+PWPUad6EF7dEJqFoa3cwTUO2Gq8+1LR9RkMgGVKU9SbMhQEC1W85t+Mju3btX\/GPaAyvWj3jlv522TdVZBFTbaQdyGRiBNk5+YZWfeuopd+nSpXAx\/0Ng0ASsr6QEj+Qb8hESBIZOQH7gBa2Cq20lAqptkRxXPqlCf1w02q2N7d\/k02U3CnUzUf7uX8usUhICqlUopW2jm7V8yCiNYdnebfmI\/zK5\/GzaK81l5WFdfQKvvPKKO3PmTP0d2aMSgTZ8JHzzSR+giiX7JKt8SfuR0gmk6iwCqultQA4DJFDn5DfA6lFkCLRGwPrKtLumrR2UjCDQUwLWHyRmFxYWWispAdXWUI4qo1ShPyoYLVcm9OeygKqeBJLP+1\/Ztr6YBFQ9CaZDJdCGj8hXvN9oquCq9GTZT9u0ecNyqPwpd\/8JtOEjqqUdG1V+sn79eqcbRrqZp+Ex5C\/Wj7Se1A6BVJ1FQLWddiCXgREIO\/cqwnhgVaS4EGiFgBUKBFRbQUomAyagAKoVtPKPthIB1bZIjiufVKE\/Lhrt1qaOFgx9v4puJKDabnuR2+wJtOEjoe\/YPrRsng+5zb69OWJ9Am34iI6q8fjL\/MGuq\/th4Pq1ymuPVJ1FQDUve6G2hoB9\/aSKMDa7Rmcfeugh9\/7770fXsRACQyVgA6opr\/zLN+QjJAgMmYB9Si3FH2IMCKjGqLAsVehDsJxAVS0YBoWq3Eyx4+IpuEpqn4C+YL5jx472MybHFQKpPmLH4rdBoWnz+\/fvXykDM80J\/OY3v3EnT55sngF7TiWQ6iP+AIpH3HzzzaWBVZ7c9rTam6bqLAKq7bUFOWVOgI9SZW4AVL+UAB+lKsXDSgg4AqoYQYxAqtCP5cmyZgT8k0ht30xpVhr2EgE+StUvO8BH+tUeKg0fpepXm1TxEY2NqnFUFTzVVGN3a+zhKjfy+lXbYZQmVWcRUB1GO1PKARAgoDqARqKIcyNAQHVu6DnwQAgQUB1IQ824mKlCf8bFHfXh9PEjPVWnse5I\/SBAQLUf7eBLgY94Ev2ZElDtT1uoJPhIv9pDpUnVWQRU+9emlGigBHQ3SXedSBCAwFoC8g2+RrmWC0sg4AkQUPUkmFoCqULf5sV8cwK6KehfUear8s05tr3nH\/7wB\/fBBx+0nS35NSCAjzSANoNdLl265K5evTqDI3GIaQTwkWmE5rM+VWcRUJ1Pu3FUCEAAAhCAAAQgsEKAgOoKCmYMgVShb7JiNoGAH0NVr1+SIACBtQTwkbVMWAIBSwAfsTT6M5+qswio9qctKcnACeiuE0+oDrwRKX5nBOQb8hESBCAQJ0BANc4l96WpQj93fm3Wn\/Hr2qTZTl568u7ChQvtZEYuyQTwkWSErWegJ7g\/+uij1vMlw2YE8JFm3LrcK1VnEVDtsnXIOysCjKGaVXNT2ZoEFEyVj5AgAIE4AQKqcS65L00V+rnzo\/7jJsAYquNuX2qXToAxVNMZksO4CaTqLAKq47YPajdDAgRUZwibQw2OAAHVwTUZBZ4xAQKqMwY+kMOlCv2BVJNiQqARAQKqjbCxU0YECKhm1NhUtRGBVJ1FQLURdnaCwFoCjz76iHv\/\/ffXrmAJBCCw7BvyERIEIBAnQEA1ziX3palCP3d+1H\/cBN599123a9eucVeS2kEggcC+ffucbjyQIACBOIFUnUVANc6VpRCAAAQgAAEIQGBmBAiozgz1oA6UKvQHVVkKCwEIQAACEIAABGZIIFVnEVCdYWNxKAhAAAIQgAAEIBAjQEA1RoVlqUIfghCAAAQgAAEIQAACcQKpOouAapwrSyFQm8COHTvchx9+WHs\/doBADgTkG\/IREgQgECdAQDXOJfelqUI\/d37Uf9wEND77M888M+5KUjsIJBBQH3L69OmEHNgVAuMmkKqzCKiO2z6o3QwJ8FGqGcLmUIMjwEepBtdkFHjGBAiozhj4QA6XKvQHUk2KCYFGBPgoVSNs7JQRAT5KlVFjU9VGBFJ1FgHVRtjZCQJrCRBQXcuEJRDwBAioehJMIRAnQEA1ziX3palCP3d+1H\/cBAiojrt9qV06AQKq6QzJYdwEUnUWAdVx2we1myGBt956y3388cczPCKHgsBwCMg35CMkCEAgToCAapxL7ktThX7u\/Kj\/uAlcuXLFLS4ujruS1A4CCQTOnTvnLl26lJADu0Jg3ARSdRYB1XHbB7WDAAQgAAEIQGAABAioDqCR5lDEVKE\/hyJzSAhAAAIQgAAEIDAIAqk6i4DqIJqZQg6BwCeffDKEYlJGCMyNAD4yN\/QceAAECKgOoJHmUMRUoT+HInNICMyUANpiprg52MAIfPrpp04\/EgQgECeQqrMqB1T1qubx48fdhQsXnF6v8OmDDz5YXqblPunVTv2v3+XLl\/3i5cfN\/XLf+Wnql9nH0bWfX\/6HP\/xhJQ+\/zH5NXeXxy69evbqy7cWLF5eXv\/\/++yvLtN5vSz0urbCgPa7ba4pdaQxV+Ql2hV35E44\/16TYlc9j6HYl35CPDL0eY2kP6nHdS6U7PIt594PSWAyL4c+eTD2BF198ccVG\/TJ09urrq1wv5H3dc\/ToUfftb3972Ufwj+vXMlxPExfwvqA4zUMPPeT279\/vFy0PT+d1D3Ea4k3eMHKOm73wwgseQ6Np5YCqDnT\/\/fcvXxD\/+te\/dnJQ\/TZt2rS87Jvf\/ObKsmPHji0v+8a1i+edO3euLP\/xj3+8svydd95ZXq4nMrSdfo888sjKttu3b19Z\/sYbbywvV0NrO\/1++MMfrmy7Z8+eleUHDhxYWb5x48bl5ffcc8\/KMp1QtL9+1IP2kA1jV\/iHPydwvuK86\/s2+o\/rfTz9+ex0iTTW3r17G4k5dhovgR07dixrVnQ21wu+f+K6Z\/U69Dvf+Q7+ce1ahutp4gL+WiYW39A6f\/5A181O14l7rD3oz\/vVn\/\/sZz9LEpGVA6o6Ub\/++utOX2rmBwNsYK0N\/OAHP3ALCwv4B+cIbCBiA\/IN+QjnjrXnDpjARDYgjSWtRYKAJaAnVDlHcI7ABuI2oPPmww8\/jI9EdBc2E7eZ3Ljs2rXLHTx4EB\/BR7CBAhuY2ROqBFQ5KefWAdWtr16fqLsP2+NXOdkAPoK952TvdetKQNWGEZn3BAioct6sey7Jbfvz58+jvwsCBbnZAvXlfIkNYAN1bcAOieG1V50pT6jSASFCWrIBgkWcwOuewHPbHh\/BR3Kz+Tr1JaBaR77msy0BVc6bdc4jOW5LQBUfydHuqTN2jw20YwMEVFsKhmGQ7Rhkzhx\/9atfOY0NnDMD6o4fFdmAfEM+UrSe5dhO7jZAQDWfIGmdmhJQ5dyY+7mxrP4aTui5555DW3A9jA0U2IC+L6OPXpb5EevoZ3K2AQKqBSePnI2Cus\/npKiBp0+dOkWHhU9iAxEbkG\/IRzg\/zef8BPf+cyegWifMmM+2BFT777ucX+fXRocPH3b33Xcf2iKiu7DL+dlln9hrjGGNEdmnMlEWbLNPNkBAlQ6EE2RPbICAKp1DnzqHvpWFgCr+0Teb7Ft5CKjmEyStU1MCqpw7+3au6lN5CKjiH32yxz6WhYAqPtJHu+xTmQio9iSY1iejoCzzOXG+9NJLbmlpiQA3PokNRGxAviEf4fw0n\/MT3PvPnYBqnTBjPtsSUO2\/73J+nV8bnTlzxr366qtoi4juwi7nZ5d9Yn\/kyBH31ltv4SP4CDZQYAMEVAvA9OlERlny6ND44E4e7Yw\/N29nfKQ5O+xu\/OwIqOYTJK1TUwKq4\/d9zu9pbcxHqdL4YX\/wwwawgZxtgIAqAVXuNvTEBggW0Rnl3BlVqTs+go9UsZNctyGgWifMmM+2BFQ5b+Z6TqxabwKq+EhVW2E7bAUbwAZCGyCg2pNgWtgw\/J+fs27cuNG9+eabBLjxSWwgYgPyDfkI58b8zo20ebU2J6CaT5C0Tk0JqFbzH84zeXI6evSoe+CBB9AWEd2FT+TpE2G7P\/HEEwy5hX9wjiyxAQKqJXDCEwr\/07F0aQN8lAr76tK+hp43H6XCP4Zuw12Xn4BqnTBjPtsSUOXc2fW5Z8j581Eq\/GPI9juLsvNRKnxkFnY25GMQUCWgyh2HntjA3\/\/93zPod0\/aYsgn9bGWXQPiy0fGWj\/qhWBNtQECqvkESevUlIAq55bUc8uY9z927JjbvHkz2gL9jQ0U2MDPf\/5znlAtYDPmcyN1q64dCKjiIHQgPbEBxoesfuLiJJ8nK3wkz3bH36u1OwHVOmHGfLYloFrNfzjP5MuJMVTzbXv8nrbHBrCBVBsgoNqTYFpqQ7L\/8E8GBIuG34b4YbdtiI90yxf7HTZfAqr5BEnr1JSA6rD9mvNy9+1HQLV7xtgxjLEBbGCsNkBAlYAqT6j2xAbkjEtLS7RHT9pjrCf9odZLviEfGWr5KTdCsmsbIKBaJ8yYz7YEVDn3dH3uGXL+b7\/9tnvllVfQFmhvbKDABjTOMB9Nph8Z8nm+67ITUC04eXQNnvw5MYU2wEepsInQJvh\/1Sb4KNUqC+wCFjEbIKCaT5C0Tk0JqHK+iJ0vWHbdLvgoFf6BL5TbAB+lKueD\/cCHgCoBVe7I9cQGCKhyQqZTLrYBAqrFbLAb2MgGCKjWCTPmsy0BVc4P9BHFNkBAtZgNdgMb2QABVeyAc0G5DRBQ7UkwDUMtN9Qc+Pz6179277zzDgFufBIbiNiAfEM+ksO5gDrSHzSxAQKq+QRJ69SUgCrnkybnk1z2WVhYcPv27UNbRHRXLjZAPcvPkRoS48SJE\/gIPoINFNgAAdUCMJxcy0+uufM5f\/asW1xcvPY7fe13tpUTDB\/cweZy96tp9cdH8JFpNjKk9UvqQ5b7knb6EAKqdcKM+WxLQLW782YXWnBI57CxlJWPUg3TR\/C\/7tptLL49hHpgx8O3YwKqBFRbCQYO4YSVXsZTbu+2ze72L93i1q1bN\/H7wp9\/zf1832tJLAkWDf+Emm5jw2Vw9thed9+dd7qNGzeW\/u688y6349CZRr6CjwzXPnL2jcm6L7hnH\/ue+9LnJ\/uQdf\/mFnfH9x53hxaatzEB1XyCpHVqSkC1uU9N+q7Pp1stOHnMw+7uW66fK\/5q64uN+s3J\/HwdmFouBFTbtocufaTLvNvmQH7Wz5i39tCdHZ89fsD95N473W3\/4fMTsYrPffHL7q6tO93h07YczLdhlwRUCagi0CrYwPkzB9y3\/iy4AA6Cqgqy3vytbW6hQn4x573\/\/vudXj2KrWMZJ\/y+28DpFzZPdNzhTQf7\/6Z9p2rbuXxDPtJ3DpQPXy20gTf2utv\/bXk\/8pn\/+fPufzx7vJGdE1CtE2bMZ1sCqu2dk2ahBe35w\/art97Pa+mWTVvzOm9qjMi28ss9ny59pMu8c2+3svrv3LnTHTx4EB9peH0fsu3Sjt98fmula7EH9hyjPVtqT7UvAdUWYYYOw\/\/tidj5slxwP\/7y5EWwLnq\/fPsd7mvr1z6t2lT08lGqsdhLnvV49eGvVOrEFVj99t76AVU+SpWnXc333N8m8zfcd\/6vyX5k3S1fdnfeeYf7yy8Ey689rfqL4\/WHASCgmk+QtE5NCai25cez0YL+nHfu7DF3\/5dWzw1NtaXPj2ncDvgoVZxLM3vp0ke6zLtNBuPLi49StdmmHdrxG3vcn\/\/r1T5D11uf+9JXrunMr7gv\/qvJ5XorqonObHZeaJNfP\/MioEpAlTsUU2zAPiGgk9NfPfjMxFOoi2887771x1eylp\/CWz5J1Xd4Aqr1mXFi7w+zf9m8\/npA9Zr9\/3z\/YXfs8GGnC5XY7\/hi\/XITUK3PDP\/oD7PXdvztxA2Hb+88MNH3Hnp684Tg\/Y\/3PTuxvkpbElCtE2bMZ1sCqu2cB7rXgmfc8cOH3L69u9yDG+9wf\/Y\/TV4AE1Btpx3Dc6k0yne+853a59swH\/5\/z3XpI13mTduV+9ajjz7iXnjhBXxkSrygih11acfPbPzCis7Ug18P7Dls2mzJvbzz3pX1ilf8J956MHzKfWBa2xJQbcE5pkFmfZqRzpufPUH96dcfd4sxmzm1d+Ku0F176r+yyfiQw7aTedvpfI+\/4H7kn6T5d3e4V85205b4SDdc52s7edTpt5v+24qQ\/dNv7Y6KuJWbEteE7rr\/8qA7FetrSpYRUM0nSFqnpgRU2znHdK0Fzy88O3FTZfkGvc4Ff\/wRUG2nHWP9HWOotsO2Sx\/pMu+YTbCsHZuA4yTH7uz4lLv\/i6v9xX\/fG49DvPyPq28T\/h9373ZnSzQlbTfZdmU8CKhiSNELuzKjyWvdKfegDxRdE7Wb9p0u4HXGPWKGBWhy14dgUfUTV142OAQupiO\/FghqOo7wtHbFR4ZgC5QxZsc2WFp0w23xJTP2FQHVOjFDti0hQEC1jXNS91qQgGob7dQsDwKqzbhN9nVd+kiXebdRd\/KYtAV4xHl0Z8fnF\/atPNj1mT\/5snuh4E3ACZ35f3+v9o37eL1obwKqBFQLAoQ4x\/WTxoJ70Nzx2XmsaFy7Jffk7atf02sSUNVrR2fPFuVPe3AS768NnDuz2pH7p2iWFheXP7KmV\/UXW3hiVb4hH8EO+msHtE1x20w8ofr1bVE7ftY8xbruL35U+8YET6iWRBUzXkVAtdgvq5+zZqEFz1wfKufYMXfs2GF3\/Phr7ok7VnWl71url7mNeo8\/j3feece99tpr0XMyrOu0f5c+0mXedeqY57YnTpxwb7\/9Nj6SHDPqzo7Pn9l\/\/aOnn7v2lOpfbi3Uj4ceu2PlrQc9oco5rh2fJqCa7BztNAQG3V+Opw496\/SFw507n3FvFASGdGfoy\/\/L6qP2f7c7\/qh9WTszhmp\/baCs3Vh3rd2O7V59VfF\/vc1966\/XfqztttvvdXsOLTTuvBlDFf8Ysq+deHpy7Kq\/\/t4utzqW8IJ79uE7V0SuXvH95q76X2AloJpx1LSk6gRU2zl3zkoL2vOcfbKdgGo77Wj5al43au+7777G2iTML+f\/u\/SRLvPOuc2q1J2PUrV37pmnHZ868Pjqtdo1nfk323hIpYr9V9mGgCoBVUREsg0ccw+a1\/01EHTxk6zFJ2UCqsVsqpzM2GZ+\/MJB1v2Yb7Hp32yt\/7EdtS0B1fm1L77VBvszbtfG2yaCpvKPW2770pqPz3zh2ljddcdPVRsRUC2JKma8ioBqG\/5bJY92tKA93xJQrcI9bRsCqmn8rL1On2\/fR1aP2WXes2TUv2MRUJ1lm7Rnx4sHd7o777zL3XvvRveV21bfdli+NvvLB90byfGPWXLp97EIqGJMBFQTbOD0wV9cf8T+2oWxDx41fYrgn\/7pn9yZM2doj4T2WBVW\/T7xjq2c9hUS7we33X6n+9737nVfW7\/2adW\/2Xaotp3LN+QjY2NHffLxVQ2NEX652\/uLnf6PA4uN7JyAasZR05KqE1Dt\/hzTpha0fQIB1e7b7s0333S\/+tWvGp1zbVsxX95WXfmIuHeZN+36nvvtb3\/LsBgzuDZt245PP\/+9ldiE1Zia\/7u9pzjntdimBFRbhMlJt7wzHROf8wuH3SN3rV9zovqvd+9yiw1tig\/u5GM\/Y\/IF1eW3935h1Rf+873uwKnJsYBPHdg2MSSGBkzfe6p+e+Mj9ZmNzdYGW59Teyd8QIJWbzN8af1tE69gedG7aU\/9YWMIqJZEFTNeRUC1u\/NmF1rQnuMIqHbXdpYzH6XqjnOXPtJl3tY+mO\/OPmD7nuvKjs9eG47tz\/\/16gNfXl+u0zir1zToXbt45b8t+yOg2jD41VYDkM\/QTtLXxrp77K41Txnpwvi\/76r\/1J1tf4JFQ7MFyuvt9\/Th\/W7Pnt1u17bd7nDBlyXfPfj4hN9s2ne69t1RfASb8zY3rOmC+9GXVkWt+otv79xvbr4tuSPPPzYhfD\/zv91e+JXWoroTUM04alpSdQKqXZw3u9OC1r8JqHbRdmvzJKC6lom1w2bzXfpIl3l3wYI8m9nQ2LnNyo6X3OlTr7lnHvve5A38a9+82LcwdsazqR8BVQKqtYMauZ4UF3+\/c80TRrrDs37jT9zh0+kO++Mf\/9idPl0\/yJRre1DvdJubLcPJoNL\/s\/XlWuce+YZ8ZLZlHhpjyttH+3j394+vPsGtV62KPlp4bFfSTQcCqiVRxYxXEVBt97zYtRa05zACqu22nWXr5\/UF823btqEtWrwe7tJHuszb2wTTSb\/bs2eP+\/3vf4+PDMRHSu338M6JoOqmfbz6X8qrYpsTUK0Iqg3Y5DF5gh4Sj7PXLnS\/+K9WnzBSIPVzt9\/v9h1rb8xTPko1XPsYki3Ps6z24vA\/3lfv41R8lAr\/mKftphz79PObVwOqN210xwp1xxn3xO2r\/cxfPVLvpgMB1YyjpiVVJ6Da3rlzFlrQnmtsn9l0fH6bH\/NrbYGPUq1lkmInXfpIl3mn1Hns+\/JRqv77yLHnd7mtDz\/sHn54q\/v5s6+VBL\/PuEfMh7T\/64P7SrZtt95j9hMCqoUXNhjRmA2\/Vt2WDrlv\/cnqRe66f3OL+8c97Y87QkAVn6tllz05d51fOOi2XevEH3vs2m\/3y+5sYbkmg0V\/t\/tYrU6cgCr+MUT\/UJlPv2ACqn\/xI7dQ6CPvORtAqSt0CaiWRBUzXkVAtaVz54y0oD3P2fMBAdWW2jE4\/xJQbZFrlz7SZd6BTVgfZP69a0G6h90LL7xQS7PDrcCvOrLj325a\/ZbF\/znlgZVnNq5uW\/fGPe0ab1cCqpxEOUFOsYFnzQd3NK5dk4\/pVDkB6SvmVbZjm\/jJDC7z4WK\/IvmZ\/\/3Owqfvzp\/cM\/GUd90xVM+dO+fwkfm0Mb6Vxn0ioHptzKriPmTBPfjF1Zt3dX2EgGrGUdOSqhNQTfNff\/6blRb0x9OUgGo7bWeZhvPvvvuuW1xcRH9PuRYKucX+79JHusw7VheWrfqe\/OPs2cmPzcJnlU8dFl3Z8dGf37n6JtR\/ub\/kxv3hiYfE6urMOnXNaVsCqi10IDkZTH51Pebu\/rPVC9xv7+1urBE+uNOsc8rPJvvF6fzCsxMf0\/nrh1+MXJiccltv\/\/xKZ6\/A6+Gz9euBj9Rnhn\/Mn1noI3\/69cejYvfIL+5d8RENK\/PQoXo32QiolkQVM15FQLWNc0C6Fjx77Hn3k60\/WX7aa+vD29yxCn0gAdU22m56HnyUajqj6VqiSx9Jz3t6+dtgQB5wLrOBdDsu6kfe\/f22Cf34N08ciFyLLblnNn15ZTt9IPXnh5ci25XVgXUxGyegSkAVRyqxgfML+yaCRev+wxfcbbfc4m4p+31+nfurrbGgUvlJ6K233nJ6Ci\/mqCwrZwefefJZctvvWA2WKhB029cedE\/vO+COHT\/uXn1+m\/vaLas3JbT+mzvrD5kh35CP0NbzbGuO3cz+ltwv7\/rcioiVD6z74h1u294X3bFjx9yh\/Xvc\/3fnbZPrv76tZPiMeDsQUM04alpSdQKqcX+p48ttaEH7NoeGjtpb4evKBFTT225aO+vJOz4Im865Sx9pI+9pdsD6Yht4++233dISgbdUG2nDjov7kcmxUaUz\/9OdP3L7Dh12x48ddvuefnzNtdiffms311QlMaA67U1AtSWQdaCzbfFJu29sTr\/wj5MXuboQrvC7+Xv1PrijejOG6nDsom92Ou\/ynD+z3339hmq+8e+\/tc0tNjjvMoYq\/jFvO086\/rVxs+zbDqX9yL+7w+2vEGwJy0NAtSSqmPEqAqrp5842tOCaoT8q+PhvH1i90cIYquntGJ4z9T9jqLbDtUsfaSPvWNuzrFrbM4ZqNU7T7KkNOy7tR97YM\/kQWFm84toHUl+p8JbEtDqx\/rptEFBtcGGP8bRzYhkCxzMHflIpgBpeHNf94I5YEFDNx66GYPt1y3ju7DH3+L1fKfQXvVrytw\/vrf3UnS8HAVX8w9vCcKen3C83m3GuImL3v33rJ5VeBY4xIKCacdS0pOoEVNPPnW1oQXsh\/Jk\/+bLbd2Z6uey4eHU\/Uhc7R7BsLXMCqmuZNLGTLn2kjbyb1Il9rtsGAdX++4i31fMLB9z9t69+dCqMT+j\/O7fuiQ475fNgWr+9CagSUOVx757YgDosXjuqfxLjxN8vZucXjrsX9+52O3fvcwee33Nt+ozbf+hYo6dSbdvKN+Qjdhnz\/Wp72qNieyyevOYbu93j1+x55549bvvWre7xbXvcoeP1xkwNeRNQLYkqZryKgGpFv5yBFlwZT\/kvNnNBOwPe4Tky9v+JEyfc9u3b0RY9aQ98pD\/nK+8v\/\/zP\/7z8JLf\/n+l826iKj5w6vN899djDbuu1cbsfuzZ9+OHH3e69L7tTi\/Mt+1hth4BqTzqQsRoY9ap+4uKDO9VZYVd5ssJH8mx3\/L1auxNQzThqWlJ1AqrV\/GcW55nXdm68\/hbH\/\/tw8k3GWZQ3l2PwUSp8JBdbp579sfWmbUE\/0r82JKBKQJW7sj2xAYJF\/TtBNu3s2K+btsRHuuGKvY6DKwHVkqhixqsIqPbDvxcPPrwyJM5du46hvXuivdX\/EVDFR9BB\/bAB2qG8HehHyvnMy34IqPaoQ5+XEXDcfjjntm3b3Jkzaa980pb9aEvaof12kG\/IR2DbPluYjoMpAdWMo6YlVSeg2g\/\/9mOo\/u0T++nHenTtpfHZf\/GLX9AmPWgTfKQf56pQEz7\/\/PPu2DFuAoVc5vE\/PtJPHyGg2oMOZB4OyTH755B8lKp\/bYKf9KdN+ChVf9oCv+hnWxBQLYkqZryKgGpf\/HXJLTJ+Xe8Cl3yUqi\/+oXLgI33UV3yUCh\/po132qUwEVAmo9k7c9MlBZlkWAqp96rAoyyxtv8qxCKhik1XsJOdtCKhmHDUtqToBVc6dOZ8Xp9WdgCr+Mc1Gcl9PQBUfyd0HptWfgCoBVQKqPbEBvU7x7rvv0h49aY9pJ0\/Wz1ZgyDd45Wi2zLHxYfEmoFoSVcx4FQHVYfkx593ZttfS0pI7fvw42hvtjQ0U2IAeaGBIutmel+gHhsWbgGrByQNDHpYhj6G9+OAONjcGO+6yDvgIPtKlfQ09bwKqGUdNS6pOQJXz5tDPbV2Xn49S4SNd2xj5Y2PYwHhtgIAqAVXuyPXEBggWjfdESyfaTtviI+1wxB7HyZGAaklUMeNVBFTH6e+cx9trVwKq7bHELsfH8ty5c8QKehIrwL\/66V8EVHEQTpI9sQHGUO3nSZLOqx\/twhiq\/WgH\/KG\/7UBANeOoaUnVCaj212c5n86\/bRhDdf5tgB\/0uw0YQ7Xf7YP\/zL99CKj2JJiGM8zfGebdBgRUsYF522Cfj09AFf\/os332oWwEVEuiihmvIqDKubMP56e+loGAKv7RV9vsS7kIqOIjfbHFvpaDgCoBVZ5Q7YkN\/PCHP3QLCwu0R0\/ao68n7VzLJd+Qj+Raf+qNoJ1mAwRUM46allSdgCrnjmnnjpzX67ypgFHODKg754gyG3jqqafcoUOH8BGuT7GBAhsgoFoApuzEwjo6ni5sgPEhsasu7GpMeeIj+MiY7LntuhBQLYkqZryKgCrnzbbPNWPLjzFU8ZGx2TT1waaxgdnZAAFVAqrcbeiJDRAsmt2Jj05mmKzxkWG2G\/42m3YjoJpx1LSk6gRUZ+N\/nOeGy5mA6nDbDr+j7bABbGDeNkBAtSfBtHkbAsef\/8noV7\/6lXvnnXcIcOOT2EDEBuQb8hHOVfM\/V9EG\/WwDAqolUcWMVxFQ7ae\/ch7tR7toOKHnnnsObRHRXdhoP2x03u1w4MABd\/z4cXwEH8EGCmyAgGoBmHmfvDh+fp0YH6XKr83x8+ptzkepqrPCrvJkRUA146hpSdUJqOZ5PqAfqNbufJSqGifsKV9OfJQq37bH76u1\/cwCqm+99dbygMYnTpxwi4uLKxFuLdcy\/XyjnT17dmXZ22+\/vbJcdxH9tufOnVterqlfZj\/oo\/38cuXn8\/bLdFy\/TOXxy5eWllaW6wJeyzX122q935Z60B7eLrxNpNiVAqqvvvoq\/oGfr5xv2rArn8fQz1fyDfnI0OsxlvagHtdFVp90iT4a8eabb5aE1liVI4F9+\/at6FavWdDZqx8A5Xoh7+uel156yf3DP\/zDso\/gH9evx7meJi7gfUHXtVu3bnXPPPPMyrUJ\/Qf9h78GIG52PY75\/PPPJ8nLdVX3fuGFF9z999+\/fEGsVyuuXr26\/PPLNmzYsLLsjTfeWN5OF8+7du1aWf7QQw+tLJejKw85tbbT76c\/fXRl2yeffHJluS4wtO1HH320smzz5s0r2\/76179eWa6Ldl+2jRs3Li+\/5557Vpa9\/PLLK9tSD9oDu\/qGwz84X\/lzJudd+o9vXOuL6c\/no0ukp\/bu3VtVlrFdJgR27NixrFvxy\/n4pc6JXC9wvcD1AtcLxDeI06g\/0I940\/WY4Fh0yc9+9rMkRVk5oKo7wPqRIAABCEAAAhCAAATaJYDOapfnWHLTE3gkCEAAAhCAAAQgAIH2CaTqLAKq7bcJOUIAAhCAAAQgAIFaBAio1sKVzcapQj8bUFQUAhCAAAQgAAEI1CSQqrMIqNYEzuYQKCKgISY0lAUJAhBYS0C+IR8hQQACcQIEVONccl+aKvRz50f9x01A44VqGDgSBCAQJ6DhvPTxNhIEIBAnkKqzCKjGubIUArUJaEwVAqq1sbFDJgTkG\/IREgQgECdAQDXOJfelqUI\/d37Uf9wE9J2N++67b9yVpHYQSCCgb9Too5ckCEAgTiBVZxFQjXNlKQRqE9DHnc6fP197P3aAQA4E5BvyERIEIBAnQEA1ziX3palCP3d+1H\/cBE6fPu22bNky7kpSOwgkENCHDY8cOZKQA7tCYNwEUnUWAdVx2we1gwAEIAABCEBgAAQIqA6gkeZQxFShP4cic0gIQAACEIAABCAwCAKpOouA6iCamUJCAAIQgAAEIDBmAgRUx9y6zeuWKvSbH5k9IQABCEAAAhCAwLgJpOosAqrjtg9qN0MCBw8edFeuXJnhETkUBIZDQL4hHyFBAAJxAgRU41xyX5oq9HPnR\/3HTeDDDz90R48eHXclqR0EEgicOnWKb3wk8GPX8RNI1VkEVMdvI9RwRgT4KNWMQHOYQRLgo1SDbDYKPUMCBFRnCHtAh0oV+gOqKkWFQG0CfJSqNjJ2yIwAH6XKrMGpbm0CqTqLgGpt5OwAgTgBAqpxLiyFgAgQUMUOIFBOgIBqOZ9c16YK\/Vy5Ue88CBBQzaOdqWVzAgRUm7NjzzwIpOosAqp52Am1nAGB5557zl2+fHkGR+IQEBgeAfmGfIQEAQjECRBQjXPJfWmq0M+dH\/UfN4GLFy+6AwcOjLuS1A4CCQRee+01d\/bs2YQc2BUC4yaQqrMIqI7bPqgdBCAAAQhAAAIDIEBAdQCNNIcipgr9ORSZQ0IAAhCAAAQgAIFBEEjVWQRUB9HMFBICEIAABCAAgTETIKA65tZtXrdUod\/8yOwJAQhAAAIQgAAExk0gVWcRUB23fVC7GRL4\/ve\/7y5cuDDDI3IoCAyHgHxDPkKCAATiBAioxrnkvjRV6OfOj\/qPm8Di4qJ75JFHxl1JageBBAK\/\/OUvnV77J0EAAnECqTqLgGqcK0shUJsAH6WqjYwdMiLAR6kyamyq2ogAAdVG2Ea\/U6rQHz0gKpg1AT5KlXXzU\/kKBPgoVQVIbJI1gVSdRUA1a\/Oh8m0SIKDaJk3yGhsBAqpja1Hq0zYBAqptEx1HfqlCfxwUqAUE4gQUUP3ud78bX8lSCEDAPfbYY+7VV1+FBAQgUEAgVWcRUC0Ay2IIQAACEIAABCAwKwIEVGdFeljHSRX6w6otpYUABCAAAQhAAAKzI5Cqswiozq6tOBIEIAABCEAAAhCIEiCgGsWS\/cJUoZ89QABAAAIQgAAEIACBAgKpOouAagFYFkOgLoGTJ0+6q1ev1t2N7SHQWwKffvqp0++TTz5JLqN8Qz5CgsBYCMg32kwEVNukOZ68UoX+eEhQEwisJXD58mV3+vTptStYMggCXme23Z8OovIzKuTZs2fdBx98MKOjcRgIDI9Aqs4ioDq8NqfEDQlcuXLFbdiwwd1www1u3bp1K7\/PfvazbsuWLclBI8ZQbdgw7NYrAh9\/\/LH76le\/uuIf3lfkN3v37m1cVsZQbYyOHXtGYNOmTWv6kZtuuinJP1RFAqo9a+ieFCdV6PekGr0pRtdaMKyoNKb6UelMUvsE+ChV+0y79pHdu3e7G2+8cY3O1LITJ060X6HMc+SjVO0bQJc+0mXe7ZMYR46pOouA6jjsgFpMIaAO2geGyqYHDx6cklPxagKqxWxYMwwC+\/fvn+onN998c6PKEFBthI2dekTgww8\/nOofCp40fdKGgGqPGrtHRUkV+j2qytyLMgstaCu5sLCwcs64++677SrmWyJAQLUlkH\/MpksfUd8YPtQSuyZbv359u5XKPDcCqu0aQJc+0mXe7VIYV26pOouA6rjsgdpECOhOT9hh6y6oOuxwuf7X9k3SU0895S5dutRkV\/aBwNwJXLx4cY0\/yEd0ERj6yaOPPlK7vPIN+QgJAkMkoAvB0A90YXjrrbeuWd70pgMB1SFaRvdlThX63ZdwGEeYlRa0NOxTeARULZn25nWzNuXtmfZKMvycuvYRvckR9qPqL2PL8Zf27OmVV15xZ86caS\/DjHPq0ke6zDvjJqtU9VSdRUC1EmY2GjKB8PXl8ClUCTHbwdOJD7m1KXtTAqGgVYDVpjBwZNcxD4GxE9Br\/rafCC\/gdZPBrtdTBnUTAdW6xPLYPlXo50Fpei1noQXVbx49ejQ6bA7acnobscV8CXTpI\/ZpbfWV6lNtUjDJD4\/h+1ItI0GgTwS69JEu8+4Twz6WJVVnEVDtY6tSplYJ2A5aQjeWNLaV78B1QiNBICcC4dOpYTBVLMIn9Nr4UFVOjKnrcAmEtq\/x32JJARPfj+gGRd1EQLUusTy2TxX6eVCaXsuutaD6RO\/\/sSkB1eltxBbzJdClj9hgkW7Qx5LG8Le+Ez4AE9uHZRCYJYEufaTLvGfJaIjHStVZBFSH2OqUuTKBUODqwjiWlpaWVjpxvcbZJD300EPu\/fffb7Ir+0BgrgTs03dlY1fpxoM+7BY+WVCl8PIN+QgJAkMjEPYjReUPtyvqb4r2J6BaRCbv5alCP29612tf1TdTtGB4DBsY0jwB1W4sUV8w37FjRzeZZ5RraL9F\/VdTH7HDX5S9wWHflsJn2jHA3\/zmN+7kyZPtZJZxLl36SJd5Z9xklaueqrMIqFZGzYZDJOCfLFKQtOyJoe3bt68EVJs+ocpHqYZoIZRZBKoK3RRafJQqhR77zpOAfVVRvlKUfH\/jAym68KyTCKjWoZXPtqlCPx9SxTX1vtm1FtTbHfp4nX56XdkOlUNwqLh9UtbwUaoUeqv7du0j9uk7+UdR0piqvg\/FZ4oo1VvOR6nq8Srauksf6TLvovqwfJVAqs4ioLrKkrlMCdi7rerEi17nnIaHgOo0QqzvKwEvXjXVXVL5gA2yarlErgJLTRMB1abk2G\/eBJoGVMuewonViYBqjArLUoU+BKsRaEsL2qPZtz8IDlky7c0TUG2P5bScUnzEfzwsHH\/cHjN8Sm\/\/\/v12NfMNCRBQbQiuwW4pPjLtcF3mPe3YY1+fqrMIqI7dQqjfGgLq1PVas15dDoNGZU+xrskoWKAnEyQGSBAYEoFQwNqnCGyg1c+XDQlQVm8dJzY2a9k+rINAHwj4Jwe8D+j\/WArFLgHVGCWW1SWQKvTrHi+X7bvSgpYfAVVLo5v5P\/zhD+6DDz7oJvPMc52Fj1jE9nV\/9bdlT7La\/ZgvJ3Dp0iV39erV8o1Y24hAlz7SZd6NKjvinVJ1FgHVERsHVYsT0EWuvzAOp0UfrYrnxFIIDJ+ADxbpVcjQH\/RUqn7h8qbDYgyfFjXIlYD1Ad2Mi6XwZgQB1RglltUlkCr06x4vl+1noQUJqOZiTeOs5yx8ROQUOLJ9rOZ5onucNjW2WnXpI13mPbZ2SK1Pqs4ioJraAuw\/OAK64xl23PrfB5TKXkcpq6wEAU+olhFiXR8JaJw37w\/eB\/QUqrVlbePX+W3rPm2q\/OQjJAgMkYCGwfC2r6mepNFQAPKDcJ3fTmK4TuKV\/zq08tk2VejnQ6peTbvSgrYUBFQtjW7m9eTdhQsXusk881y79hHpQt2g932mn3LTvl3D0xPcH330UbuZktsygS59pMu8ab5JAqk6i4DqJE\/+y4zAxx9\/7OwHqXxnboNJVZEwhmpVUmzXJwLhkwFFw17IV7x\/aFp3rGEdRz5CgsBQCcSe1rY+4ef9zQcCqkNt6X6VO1Xo96s2\/SxNm1rQ1pCAqqXRzTxjqHbDNcy1bR+JXXupD236UEtYXv5fJcAYqqssupxr20dsWbvM2x4n1\/lUnUVANVfLod4TBPSUkb8Y1rTuhbAyU7CIJ\/AmsPLPAAj4V\/69\/ZcNe2GfJKj7OhYB1QEYA0WcSmDLli0TfYX3G021zo7LXbc\/4AnVqfiz3CBV6GcJrWGl29CC9tAEVC2NbuYJqHbDtSjXVB8J9\/d9qPRlk4dZisrJ8lUCBFRXWcxiLrTxJjGFonJ2mXfRMXNYnqqzCKjmYCUZ11EnsUcffWT5VxYoEiI7GLpEcN2k47z\/\/vt1d2N7CMyVQBhQ1V3QopRycSjfkI+QIDB0ArroO3jw4PKTNPoKsV7998lfHGpaNxFQrUssj+1ThX4elMprOUstaEuS0mfafJgvJvDuu++6Xbt2FW\/AmkoEZuEjsVeY9eaHlpO6I7Bv3z6nGw+kNAJd+kiXeafVOo+9U3VWZcWP0M\/DoMZWSz1F5y9wiz4k4utsn74j8OOpMB07gTCgqi+VFyUuDovIsHzsBHTBpydOy5461U07398UDZ1RxgmdVUYn33WpQj9fcqs1n5cWpM9cbQPm+k1gFj7i+0c\/1Y1JEgSGQqBLH+ky76HwnWc5U3UWAdV5th7H7pyA\/ViIvsBclnwHr6nuFJEgkAsBOzakOvWiZL9izjhXRZRYPjYC4U0H\/R9L1o80PlzdREC1LrE8tk8V+nlQKq\/lvLQgAdXydmFtfwh07SN6qMVeZ5W9DdUfKpQEAqsEuvSRLvNerQFzRQRSdRYB1SKyLB8FgXCskaKLXHtnSB2+9qubduzYwWsrdaGxfS8I6CkBK3TtK8y+gOEHBOqKYT3hJx8hQWCIBOzNBAnfMIU+VBR0Dfez\/xNQtTSY9wRShb7PJ+dpG1pQfZjGSfbDSFXhSUC1CqW0bfTWwDPPPJOWCXsvX\/dYHdjkeqnMR\/zHGnWMaUOw0RztElAfcvr06XYzzTC3LvuRNvLOsElaq3KqziKg2lpTkFFfCdixUdWRr1+\/fvm1TXX8ugi2F8p+fZO68FGqJtTYpy8ErJDWvC4E5SPq5O1wGFpX9hRrUX100SMfIUFgiATCp2t0sambChpPNfxQlf5vkgioNqE2\/n1Shf74CVWrYaoW1JtLtp+s8gEdAqrV2iZlKz5KlUJvct+ufES+Yn1HwVVde5X9tE3TvnSyVvzHR6nas4GufEQlTM27vVrml1OqziKgmp\/NZFfjK1euTHTktlMP59WBN00EVJuSY78+EFDwNPSH2P\/q8JskAqpNqLFPXwiEr\/3HfEPLdIHYNBFQbUpu3PulCv1x06leu1QtqDc3rN8TUK3OvsstCai2R7crHwl9x\/pR2XyTm\/ft0RhPTgRU22vLrnxEJUzNu71a5pdTqs4ioJqfzWRZYwlfO75drANPvRP61ltvLT+xlCVgKj0KAvKTW2+9deKi0fqKnrZpmvQ0n3yEBIGhEpjWj+hJ7pREQDWF3nj3TRX64yVTv2bTfFj9XZEWDINCVYb1sOPipfSf9Wuazx4KQiwuLuZT4Y5r2oWP6GOnVktWnd+\/f3\/Htc0j+3PnzrlLly7lUdkZ1LILH\/HFTsnb58G0PoFUnUVAtT5z9hgwAb2+rFc1JZg11VhYGsunijAecLUpOgRqEdDTqvrolC4G5ScSterkSRCAgFseBkO+4cdSlH\/UHVM4xpGAaowKy1KFPgTXEmiqBdUPKhh04403rs2UJRAYEQF8ZESNSVU6IdCljzTNu5OKZpBpqs4ioJqBkVDF2RAg4DQbzhxluATwkeG2HSXvngAB1e4ZD\/EIqUJ\/iHXua5l1o1EB1aZD3\/S1XkMvF9qiPy2Ij\/SnLXxJ9NAQDw55GvOf4iPzb4OwBKk6i4BqSJT\/IdCQAGOoNgTHblkQYAzVLJqZSiYQIKCaAG\/Eu6YK\/RGjmWnV1If5V5V1QUzqBwHGUO1HO6gU+Eh\/2sKWhDFULY35zuMj8+VfdPRUnUVAtYgsyyFQkwAB1ZrA2DwrAgRUs2puKtuAAAHVBtAy2CVV6GeAaCZV9GOoahgcUn8IEFDtT1vgI\/1pC1sSAqqWxnzn8ZH58i86eqrOIqBaRJblEKhJ4IEHHlgeW6\/mbmwOgSwIaDwg+QgJAhCIEyCgGueS+9JUoZ87vzbrz2uzbdJsJ6933nnH\/fSnP20nM3JJJoCPJCNsPYOnn37avf76663nS4bNCOAjzbh1uVeqziKg2mXrkDcEIAABCEAAAhCoQICAagVIGW6SKvQzREaVIQABCEAAAhCAQCUCqTqLgGolzGwEAQhAAAIQgAAEuiNAQLU7tkPOOVXoD7nulB0CEIAABCAAAQh0SSBVZxFQ7bJ1yDsrAvpIweXLl7OqM5WFQFUC8g0+5FGVFtvlSICAao6tPr3OqUJ\/+hHYAgLDJXDhwgX34osvDrcClBwCHRM4cuSIW1pa6vgoZA+B4RJI1VkEVIfb9pS8ZwT4KFXPGoTi9IoAH6XqVXNQmB4SIKDaw0bpQZFShX4PqkARINAZAT5K1RlaMh4JAT5KNZKGpBqdEUjVWQRUO2saMs6NAAHV3Fqc+tYhQEC1Di22zZEAAdUcW316nVOF\/vQjsAUEhkuAgOpw246Sz4YAAdXZcOYowyWQqrMIqA637Sl5zwj87ne\/cx999FHPSkVxINAPAvIN+QgJAhCIEyCgGueS+9JUoZ87P+o\/bgKXLl3iC+bjbmJql0hgYWHBnT9\/PjEXdofAeAmk6iwCquO1DWoGAQhAAAIQgMBACBBQHUhDzbiYqUJ\/xsXlcBCAAAQgAAEIQGAwBFJ1FgHVwTQ1BYUABCAAAQhAYKwECKiOtWXT6pUq9NOOzt4QgAAEIAABCEBgvARSdRYB1fHaBjWbMYGNGzc6jRNJggAE1hKQb8hHSBCAQJwAAdU4l9yXpgr93PlR\/3ET0OvMmzdvHnclqR0EEgg8+eST7vDhwwk5sCsExk0gVWcRUB23fVC7GRLgo1QzhM2hBkeAj1INrsko8IwJEFCdMfCBHC5V6A+kmhQTAo0I8FGqRtjYKSMCfJQqo8amqo0IpOosAqqNsLMTBNYSuOeeexj0ey0WlkBgmYAGxJePkCAAgTgBAqpxLrkvTRX6ufOj\/uMmcPr0abdly5ZxV5LaQSCBwI4dO9yRI0cScmBXCIybQKrOqhRQff\/9992rr766\/Dt58qTjBwNsABvABrABbAAbwAbaswGvs6S5SBAQAQWLnnvuOXQ31x7YADaADWAD2AA2gA10YAPSWXrboWmqFFC9fPmyO3bs2PLv7Nmzjh8MsAFsABvABrABbAAbaM8GvM6S5iJBQAQ0VMq+ffvQ3Vx7YAPYADaADWAD2AA20IENSGedO3eusfCsFFBV7hL4iPzGnNkRAhCAAAQgAAEIFBJAZxWiyXoFH7vMuvmpPAQgAAEIQAACHRJI1VmVA6od1oGsIQABCEAAAhCAAAQgAAEIQAACEIAABCAAAQgMggAB1UE0E4WEAAQgAAEIQAACEIAABCAAAQhAAAIQgAAE+kCAgGofWoEyQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAoMgQEB1EM1EISEAAQhAAAIQgAAEIAABCEAAAhCAAAQgAIE+ECCg2odWoAwQgAAEIAABCEAAAhCAAAQgAAEIQAACEIDAIAgQUB1EM1FICEAAAhCAAAQgAAEIQAACEIAABCAAAQhAoA8ECKj2oRUoAwQgAAEIQAACEIAABCAAAQhAAAIQgAAEIDAIAgRUB9FMFBICEIAABCAAAQhAAAIQgAAEIAABCEAAAhDoAwECqn1oBcoAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIDIIAAdVBNBOFhAAEIAABCEAAAhCAAAQgAAEIQAACEIAABPpAgIBqH1qBMkAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAKDIEBAdRDNRCEhAAEIQAACEIAABCAAAQhAAAIQgAAEIACBPhAgoNqHVqAMEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAwCAIEFAdRDNRSAhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQKAPBAio9qEVKAMEIAABCEAAAhCAAAQgAAEIQAACEIAABCAwCAIEVAfRTBQSAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQ6AMBAqp9aAXKAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCAyCAAHVQTQThYQABCAAAQhAAAIQgAAEIAABCEAAAhCAAAT6QOD\/B7L+Wkjy7Q+NAAAAAElFTkSuQmCC","width":533}
%---
%[output:770a8c05]
%   data: {"dataType":"textualVariable","outputData":{"name":"a","value":"     1\n"}}
%---
%[output:56c33d21]
%   data: {"dataType":"textualVariable","outputData":{"name":"b","value":"'a'"}}
%---
%[output:1c077576]
%   data: {"dataType":"textualVariable","outputData":{"header":"logical","name":"c","value":"   1\n"}}
%---
%[output:147866ac]
%   data: {"dataType":"textualVariable","outputData":{"name":"A","value":"     1\n"}}
%---
%[output:0533c5cd]
%   data: {"dataType":"textualVariable","outputData":{"name":"a","value":"     2\n"}}
%---
%[output:60c28b9a]
%   data: {"dataType":"textualVariable","outputData":{"name":"FrUiT","value":"'apple'"}}
%---
%[output:41757184]
%   data: {"dataType":"textualVariable","outputData":{"header":"logical","name":"fRuIt","value":"   0\n"}}
%---
%[output:090b9781]
%   data: {"dataType":"matrix","outputData":{"columns":1,"header":"20×1 cell array","name":"ans","rows":20,"type":"cell","value":[["'break'"],["'case'"],["'catch'"],["'classdef'"],["'continue'"],["'else'"],["'elseif'"],["'end'"],["'for'"],["'function'"]]}}
%---
%[output:49014e31]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"     2\n"}}
%---
%[output:5ef0d913]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"     0\n"}}
%---
%[output:13aba8f3]
%   data: {"dataType":"matrix","outputData":{"columns":4,"name":"my_primes","rows":1,"type":"double","value":[["2","3","5","7"]]}}
%---
%[output:3513a976]
%   data: {"dataType":"textualVariable","outputData":{"name":"my_mean","value":"         4.25\n"}}
%---
%[output:929ac017]
%   data: {"dataType":"textualVariable","outputData":{"name":"A","value":"     2\n"}}
%---
%[output:693bccc8]
%   data: {"dataType":"textualVariable","outputData":{"name":"FrUiT","value":"     2\n"}}
%---
%[output:23ace0dd]
%   data: {"dataType":"matrix","outputData":{"columns":10,"name":"a","rows":1,"type":"double","value":[["1","2","3","4","5","6","7","8","9","10"]]}}
%---
%[output:01bbb0bb]
%   data: {"dataType":"textualVariable","outputData":{"name":"b","value":"'abcdefghijklmnopqrstuvwxyz'"}}
%---
%[output:021abb74]
%   data: {"dataType":"textualVariable","outputData":{"name":"c","value":"'bdfhjlnprtvxz'"}}
%---
%[output:27869d35]
%   data: {"dataType":"matrix","outputData":{"columns":11,"name":"d","rows":1,"type":"double","value":[["5","4","3","2","1","0","-1","-2","-3","-4","-5"]]}}
%---
%[output:668740a9]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"e","rows":11,"type":"double","value":[["1"],["4"],["7"],["10"],["13"],["16"],["19"],["22"],["25"],["28"],["31"]]}}
%---
%[output:2dffa054]
%   data: {"dataType":"matrix","outputData":{"columns":5,"name":"ans","rows":1,"type":"double","value":[["1","3","5","4","9"]]}}
%---
%[output:055825f4]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"     7\n"}}
%---
%[output:55e11449]
%   data: {"dataType":"matrix","outputData":{"columns":10,"name":"c","rows":1,"type":"double","value":[["3","3","3","3","3","3","3","3","3","3"]]}}
%---
%[output:24e5bcb0]
%   data: {"dataType":"matrix","outputData":{"columns":10,"name":"ans","rows":1,"type":"double","value":[["3","3","3","3","3","3","3","3","3","3"]]}}
%---
%[output:462dd08e]
%   data: {"dataType":"matrix","outputData":{"columns":1,"header":"10×1 logical array","name":"d","rows":10,"type":"logical","value":[["0"],["0"],["0"],["0"],["0"],["0"],["0"],["0"],["0"],["0"]]}}
%---
%[output:1dabe0b8]
%   data: {"dataType":"matrix","outputData":{"columns":20,"name":"d","rows":1,"type":"double","value":[["1","2","1","2","1","2","1","2","1","2","1","2","1","2","1","2","1","2","1","2"]]}}
%---
%[output:371c4050]
%   data: {"dataType":"textualVariable","outputData":{"name":"a","value":"'hello'"}}
%---
%[output:3b35dabe]
%   data: {"dataType":"matrix","outputData":{"columns":3,"name":"b","rows":1,"type":"double","value":[["2","3","4"]]}}
%---
%[output:7f5b93b8]
%   data: {"dataType":"matrix","outputData":{"columns":3,"header":"1×3 logical array","name":"c","rows":1,"type":"logical","value":[["1","0","1"]]}}
%---
%[output:0f222445]
%   data: {"dataType":"matrix","outputData":{"columns":12,"name":"d","rows":1,"type":"double","value":[["1","2","3","4","5","6","7","8","9","10","11","13"]]}}
%---
%[output:30df09da]
%   data: {"dataType":"matrix","outputData":{"columns":7,"header":"1×7 logical array","name":"e","rows":1,"type":"logical","value":[["1","1","1","0","0","0","0"]]}}
%---
%[output:528966d1]
%   data: {"dataType":"matrix","outputData":{"columns":5,"name":"b","rows":1,"type":"double","value":[["2","3","4","3","4"]]}}
%---
%[output:674f060c]
%   data: {"dataType":"matrix","outputData":{"columns":7,"name":"b","rows":1,"type":"double","value":[["0","1","2","3","4","3","4"]]}}
%---
%[output:894e631b]
%   data: {"dataType":"matrix","outputData":{"columns":9,"name":"b","rows":1,"type":"double","value":[["-1","0","1","2","3","4","3","4","5"]]}}
%---
%[output:76702098]
%   data: {"dataType":"textualVariable","outputData":{"name":"a","value":"'hello and '"}}
%---
%[output:036b027f]
%   data: {"dataType":"textualVariable","outputData":{"name":"a","value":"'hello and goodbye'"}}
%---
%[output:8799e5b8]
%   data: {"dataType":"textualVariable","outputData":{"header":"logical","name":"c","value":"   1\n"}}
%---
%[output:4ba2231d]
%   data: {"dataType":"matrix","outputData":{"columns":3,"header":"1×3 logical array","name":"c","rows":1,"type":"logical","value":[["1","0","0"]]}}
%---
%[output:36118431]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"a","rows":4,"type":"double","value":[["1"],["2"],["3"],["4"]]}}
%---
%[output:74d66210]
%   data: {"dataType":"matrix","outputData":{"columns":2,"header":"2×2 logical array","name":"b","rows":2,"type":"logical","value":[["1","0"],["0","1"]]}}
%---
%[output:59efc425]
%   data: {"dataType":"matrix","outputData":{"columns":5,"name":"b","rows":2,"type":"double","value":[["1","2","3","4","5"],["6","7","8","9","10"]]}}
%---
%[output:4b724ecd]
%   data: {"dataType":"error","outputData":{"errorType":"runtime","text":"Error using <a href=\"matlab:matlab.lang.internal.introspective.errorDocCallback('vertcat')\" style=\"font-weight:bold\">vertcat<\/a>\nDimensions of arrays being concatenated are not consistent."}}
%---
%[output:38ed3182]
%   data: {"dataType":"textualVariable","outputData":{"header":"5×6 char array","name":"c","value":"    'person'\n    'woman '\n    'man   '\n    'camera'\n    'TV    '\n"}}
%---
%[output:440c8f05]
%   data: {"dataType":"matrix","outputData":{"columns":4,"name":"m","rows":4,"type":"double","value":[["16","2","3","13"],["5","11","10","8"],["9","7","6","12"],["4","14","15","1"]]}}
%---
%[output:86f87672]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"    16\n"}}
%---
%[output:749ff2f0]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"     2\n"}}
%---
%[output:9bf75b8d]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"     1\n"}}
%---
%[output:3f5b0051]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"    12\n"}}
%---
%[output:3888b0dd]
%   data: {"dataType":"matrix","outputData":{"columns":3,"name":"ans","rows":1,"type":"double","value":[["9","4","3"]]}}
%---
%[output:88dc0708]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"    11\n"}}
%---
%[output:82f88370]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"    11\n"}}
%---
%[output:844e606b]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"     3\n"}}
%---
%[output:267936ed]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"     3\n"}}
%---
%[output:9c6df28d]
%   data: {"dataType":"textualVariable","outputData":{"name":"data","value":"     2\n"}}
%---
%[output:04dbd28c]
%   data: {"dataType":"matrix","outputData":{"columns":4,"name":"m","rows":4,"type":"double","value":[["16","2","3","13"],["5","11","10","8"],["9","7","6","12"],["102","14","15","1"]]}}
%---
%[output:5ac5b55f]
%   data: {"dataType":"matrix","outputData":{"columns":4,"name":"m","rows":4,"type":"double","value":[["16","99","99","13"],["5","101","10","8"],["9","99","6","12"],["102","102","15","1"]]}}
%---
%[output:5608479b]
%   data: {"dataType":"matrix","outputData":{"columns":4,"name":"m","rows":4,"type":"double","value":[["16","99","101","13"],["5","101","102","8"],["9","102","103","12"],["102","103","15","1"]]}}
%---
%[output:2225e596]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"ans","rows":4,"type":"double","value":[["101"],["102"],["103"],["15"]]}}
%---
%[output:5190eb32]
%   data: {"dataType":"matrix","outputData":{"columns":4,"name":"ans","rows":2,"type":"double","value":[["16","99","101","13"],["5","101","102","8"]]}}
%---
%[output:1de20d15]
%   data: {"dataType":"matrix","outputData":{"columns":4,"name":"t","rows":4,"type":"double","value":[["16","5","9","102"],["99","101","102","103"],["101","102","103","15"],["13","8","12","1"]]}}
%---
%[output:9e7d796d]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"   101\n"}}
%---
%[output:071d4cb5]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"   101\n"}}
%---
%[output:927a3a49]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"   103\n"}}
%---
%[output:5066b098]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"   103\n"}}
%---
%[output:5e593f8b]
%   data: {"dataType":"text","outputData":{"text":"\nt =\n\n     []\n\n","truncated":false}}
%---
%[output:2819c4da]
%   data: {"dataType":"matrix","outputData":{"columns":3,"name":"m","rows":4,"type":"double","value":[["16","99","13"],["5","101","8"],["9","102","12"],["102","103","1"]]}}
%---
%[output:2c13b9cc]
%   data: {"dataType":"matrix","outputData":{"columns":4,"name":"m","rows":3,"type":"double","value":[["16","2","3","13"],["5","11","10","8"],["9","7","6","12"]]}}
%---
