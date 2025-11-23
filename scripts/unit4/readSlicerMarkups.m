%[text] # Collating Slicer Markups 
%[text] Each markup measurement made in Slicer, like length or angle, is saved as a JSON file (extension .JSON), which is a structured data format used by the internet. If you review your slicer folder, each folder will have a series of .MRK.JSON files that have the same name as the measurement that you made  in slicer. 
%[text] Storing every measurement in a separate file makes our data incredibly [UNTIDY](https://salcedoe.github.io/MtMdocs/dataProcessing/tidyData/). We need to collate our data in a single table to simplify its analysis. This live script helps you do that.
%[text] ## Set Project Folder
%[text] To start, organize your slicer folders in a single project folder. Then, select the project folder using the code below:
project_folder = "/Users/ernesto/MATLAB-Drive/Mighty Mandibles" %[control:filebrowser:16c6]{"position":[18,64]} %[output:016814d3]
folders = dir(project_folder); % find contents in the project folder
foldersT = struct2table(folders); % convert to table
foldersT(~foldersT.isdir,:) = []; % remove reference to any content that is not a folder
foldersT.date = datetime(foldersT.datenum,ConvertFrom="datenum"); % reformat the date information
foldersT = removevars(foldersT,"datenum"); % remove datanum column
foldersT = foldersT(~matches(foldersT.name,[".",".."]),:) % remove relative folder references %[output:7c82f921]
%[text] - foldersT should contain directory information about your Slicer Folders (e.g. their names, the folder that they in which they are contained, and the date they were modified) \
%%
%[text] ## Collating the Markups
%[text] Next, we import each markup into MATLAB and extract the measurements (e.g. the lengths and angles). We organize the data in a table. The we load the next dataset set, building our table row by row. In the end, our table will have one row per Slicer folder. 
%[text] **Important**: for this to work properly, you need to use the exact same name for the same measurement across all slicer folders. No typos or variations in spacing. 
%%
%[text] ### Set Measurement Names and Column Headers
%[text] Manually enter the names of your measurements (the exact name you entered in Slicer). You should also be able to see these names as files with the extension .MRK.JSON in your slicer folder.
measurementNames = ["Bicondylar Breadth" "Bigonal Breadth" "Foramen Magnum Width" "Ramus Length Left" "Ramus Length Right"]; % the names of the saved measurements
%[text] Next enter the column names you would like to use in the final table. Its usually easier to have one word column names
varNames = ["Bicondylar" "Bigonal" "ForamenMagnum" "RamusLeft" "RamusRight"]; % column headers names for table
%[text] - IMPORTANT: **`varNames`** must have the same number of elements as **`measurementNames`** \
%%
%[text] ### Collate the data
%[text] Run this loop to collate the data
rowCount = height(foldersT);

% preallocate table
T = [table(strings(rowCount,1),VariableNames = "ID") array2table(zeros(rowCount,numel(measurementNames)),VariableNames=varNames)];

for n=1:rowCount %[output:group:08df1cd9]
t = getMeasurements(fullfile(foldersT.folder{n},foldersT.name{n}),measurementNames,varNames); %[output:6aa22742]
T(n,:) = t;
end %[output:group:08df1cd9]
T %[output:3164913f]
%[text] - Any data that was unable to be loaded with have a value of NaN (not a number) \
%%
%[text] # Local Function
%[text] This function loads the measurements from a given folder and returns a one-row table
function t = getMeasurements(slicerFolder, measureNames, varNames)

num = numel(measureNames); % number of measurements to load
assert(numel(varNames)==num,'varNames must have the same number of elements as measurementNames')

values = zeros(1,num); % preallocate values array
[~,ID] = fileparts(slicerFolder); % get folder name
ID = string(ID); % use folder name as measurement ID

% Loop through each JSON file in the directory and read its contents
for n = 1:num
    try
        filePath = fullfile(slicerFolder, measureNames(n)+ ".mrk.json");
        jD = readstruct(filePath); % import JSON file
        values(n) = jD.markups.measurements.value; % load value (e.g. length or angle)
    catch ME
        % fprintf('%s. %s. %s. %s\n',ID, measureNames(n), ME.identifier, ME.message)
        fprintf('%s. %s. %s\n',ID, measureNames(n), ME.message)

        values(n) = nan; % not a number
    end

end

t = array2table(values,"VariableNames",varNames); % create a table from the values array
t = [table(ID) t]; % add folder name and names of the measurements

end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[control:filebrowser:16c6]
%   data: {"browserType":"Folder","defaultValue":"\"\"","label":"Select Project Folder","run":"Section"}
%---
%[output:016814d3]
%   data: {"dataType":"textualVariable","outputData":{"name":"project_folder","value":"\"\/Users\/ernesto\/MATLAB-Drive\/Mighty Mandibles\""}}
%---
%[output:7c82f921]
%   data: {"dataType":"tabular","outputData":{"columnNames":["name","folder","date","bytes","isdir"],"columns":5,"dataTypes":["cellstr","cellstr","datetime","double","logical"],"header":"2×5 table","name":"foldersT","rows":2,"type":"table","value":[["'ID189'","'\/Users\/ernesto\/MATLAB-Drive\/Mighty Mandibles'","20-Nov-2025 12:39:31","0","true"],["'ID192'","'\/Users\/ernesto\/MATLAB-Drive\/Mighty Mandibles'","20-Nov-2025 13:20:41","0","true"]]}}
%---
%[output:6aa22742]
%   data: {"dataType":"text","outputData":{"text":"ID189. Bigonal Breadth. Unable to find or open '\/Users\/ernesto\/MATLAB-Drive\/Mighty Mandibles\/ID189\/Bigonal Breadth.mrk.json'. Check the path and filename or file permissions.\nID189. Ramus Length Left. Unable to find or open '\/Users\/ernesto\/MATLAB-Drive\/Mighty Mandibles\/ID189\/Ramus Length Left.mrk.json'. Check the path and filename or file permissions.\nID192. Ramus Length Left. Unable to find or open '\/Users\/ernesto\/MATLAB-Drive\/Mighty Mandibles\/ID192\/Ramus Length Left.mrk.json'. Check the path and filename or file permissions.\nID192. Ramus Length Right. Unable to find or open '\/Users\/ernesto\/MATLAB-Drive\/Mighty Mandibles\/ID192\/Ramus Length Right.mrk.json'. Check the path and filename or file permissions.\n","truncated":false}}
%---
%[output:3164913f]
%   data: {"dataType":"tabular","outputData":{"columnNames":["ID","Bicondylar","Bigonal","ForamenMagnum","RamusLeft","RamusRight"],"columns":6,"dataTypes":["string","double","double","double","double","double"],"header":"2×6 table","name":"T","rows":2,"type":"table","value":[["\"ID189\"","125.34","NaN","38.515","NaN","66.373"],["\"ID192\"","125.86","101.33","38.65","NaN","NaN"]]}}
%---
