function [allSegT, contentT] = mmGetSlicerMetadataAll(folderPath,options)
%MMGETSLICERMETADATAALL Loads the metadata from Slicer segmentation files
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

si = []; % successful indices
allSegT = table; % segmentation metadata
for n=1:height(contentT)


    filepath = fullfile(contentT.folder(n),contentT.name(n)); % construct file path
    t = mmGetSlicerMetadata(filepath);
    t.Num = repmat(n, height(t),1);
    t.Filename = repmat(string(contentS(n).name),height(t),1);
    t.ID = extractBefore(t.Filename,options.idDelimiter); % extract before an underscore or a space ("_"|" ")       
    t = movevars(t,{'Num' 'ID'},'Before',1);   

    contentT.ID(n) = t.ID(1);
    contentT.VolDim(n) = numel(t.Properties.UserData.ImageSize);
    contentT.VolSize{n} = t.Properties.UserData.ImageSize;
    contentT.PixelSpacing(n,:) = t.Properties.UserData.PixelDimensions;

    try % test if data can be concatenated with previous data

        allSegT = [allSegT; t];
        si = [si; n]; % concatenate successful indices
    catch ME
        fprintf('%d. %s. %s\n',n,t.ID(1), ME.message)
        % disp(t)
        continue
    end
end
allSegT.ID = categorical(allSegT.ID);
allSegT.SegName = categorical(allSegT.SegName);
allSegT.Properties.UserData.contents = contentS; % add contentS to user data 
allSegT.Properties.UserData.si = si; % successfully indices
end