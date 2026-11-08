function [allSegT, contentT] = mmGetSlicerSegmentInfoAll(folderPath,options)
%MMGETSLICERSEGMENTINFOALL Loads the metadata from Slicer segmentation files
%found (formerly mmGetAllSlicerSegTables)
%in the same folder (.SEG.NRRD)
% INPUT
%   - the folder path to the folder containing slicer segmentation data (.seg.nrrd files)
% OUTPUTS
% - T: collated slicer Table
% - contentT: folder contents (as a table)


arguments (Input)
    folderPath {mustBeTextScalar}
    options.idDelimiter {mustBeTextScalar} = " "; % ID must start file name, pattern to extract before
    options.subFolders logical = false

end

if options.subFolders
    contentS = dir(fullfile(folderPath,"**")); % returns a structure of folder contents
    contentT = struct2table(contentS);
    contentT(contentT.isdir,:) = []; % remove any folder references
    contentT = contentT(contains(contentT.name,'seg.nrrd'),:); 
else
    fullPath = fullfile(folderPath,'*.seg.nrrd');
    % assert(endsWith(folderPath,'*.seg.nrrd'),'filePath should end as follows: ...%s*.seg.nrrd.\n Your file path: %s',filesep,folderPath)
    contentS = dir(fullPath); % returns a structure of folder contents
    contentT = struct2table(contentS);
end

if isempty(contentT)
    error('Incorrect path or no Slicer files found')
end

% convert to table and update fields
contentT = convertvars(contentT,["name" "folder"],"string");
contentT.date = datetime(contentT.datenum,ConvertFrom="datenum");
contentT = removevars(contentT,"datenum");

% preallocate added fields
contentT.ID = strings(height(contentT),1); % e.g. student last name / folder name
contentT.VolDim = zeros(height(contentT),1);
contentT.VolSize = cell(height(contentT),1);
contentT.PixelSpacing = zeros(height(contentT),3);
contentT = movevars(contentT,["ID" "VolDim" "VolSize" "PixelSpacing"],'Before',1);

nFiles = height(contentT);
segC = cell(nFiles,1); % preallocate: one cell per file, each will hold that file's segment table
ok = false(nFiles,1);  % which files were read successfully
for n = 1:nFiles
    filepath = fullfile(contentT.folder(n),contentT.name(n)); % construct file path
    try
        t = mmGetSlicerSegmentInfo(filepath);
    catch ME
        fprintf('%d. %s. %s\n',n,contentT.name(n),ME.message)
        continue % leave this cell empty
    end
    t.Num = repmat(n,height(t),1);
    t.Filename = repmat(contentT.name(n),height(t),1);
    t.ID = extractBefore(t.Filename,options.idDelimiter); % extract before an underscore or a space ("_"|" ")
    t = movevars(t,{'Num' 'ID'},'Before',1);

    contentT.ID(n) = t.ID(1);
    contentT.VolDim(n) = numel(t.Properties.UserData.ImageSize);
    contentT.VolSize{n} = t.Properties.UserData.ImageSize;
    contentT.PixelSpacing(n,:) = t.Properties.UserData.PixelDimensions;

    segC{n} = t; % store the table; no copying of the growing result
    ok(n) = true;
end
si = find(ok); % successful indices
allSegT = vertcat(segC{:}); % stack all the tables at once (empty cells are skipped)
if isempty(allSegT)
    error('None of the Slicer files could be read')
end
allSegT.ID = categorical(allSegT.ID);
allSegT.SegName = categorical(allSegT.SegName);
allSegT.Properties.UserData.contents = contentS; % add contentS to user data 
allSegT.Properties.UserData.si = si; % successfully indices
end