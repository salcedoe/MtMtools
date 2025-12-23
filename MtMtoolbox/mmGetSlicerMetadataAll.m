function [allSegT, contentT] = mmGetSlicerMetadataAll(filePath,options)
%MMGETALLSEGTABLES Loads the metadata from Slicer segmentation files found mmGetAllSlicerSegTables
%in the same folder (.SEG.NRRD)
% INPUT
%   - the file path to the folder containing slicer segmentation data. Use a wild card for the file name
%   e.g. '*.seg.nrrd'
% OUTPUTS
% - T: collated slicer Table
% - contentT: folder contents (as a table)


arguments (Input)
    filePath {mustBeTextScalar}
    options.idDelimiter {mustBeTextScalar} = " "; % ID must start file name, pattern to extract before
    options.subFolders logical = false

end

if options.subFolders
    contentS = dir(fullfile(filePath,"**")); % returns a structure of folder contents
    contentT = struct2table(contentS);
    contentT(contentT.isdir,:) = []; % remove any folder references
    contentT = contentT(contains(contentT.name,'seg.nrrd'),:); 
else
    assert(endsWith(filePath,'*.seg.nrrd'),'filePath should end as follows: ...%s*.seg.nrrd.\n Your file path: %s',filesep,filePath)
    contentS = dir(filePath); % returns a structure of folder contents
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
contentT.LastName = strings(height(contentT),1);
contentT.VolDim = zeros(height(contentT),1);
contentT.VolSize = cell(height(contentT),1);
contentT.PixelSpacing = zeros(height(contentT),3);
contentT = movevars(contentT,["LastName" "VolDim" "VolSize" "PixelSpacing"],'Before',1);

si = []; % successful indices
allSegT = table; % segmentation metadata
for n=1:height(contentT)


    filepath = fullfile(contentT.folder(n),contentT.name(n)); % construct file path
    t = mmGetSlicerSegTable(filepath);
    t.ID = repmat(n, height(t),1);
    t.Filename = repmat(string(contentS(n).name),height(t),1);
    t.LastName = extractBefore(t.Filename,options.idDelimiter); % extract before an underscore or a space ("_"|" ")       
    t = movevars(t,{'ID' 'LastName'},'Before',1);   

    contentT.LastName(n) = t.LastName(1);
    contentT.VolDim(n) = numel(t.Properties.UserData.ImageSize);
    contentT.VolSize{n} = t.Properties.UserData.ImageSize;
    contentT.PixelSpacing(n,:) = t.Properties.UserData.PixelDimensions;

    try % test if data can be concatenated with previous data

        allSegT = [allSegT; t];
        si = [si; n]; % concatenate successful indices
    catch ME
        fprintf('%d. %s. %s\n',n,t.LastName(1), ME.message)
        % disp(t)
        continue
    end
end
allSegT.LastName = categorical(allSegT.LastName);
allSegT.SegName = categorical(allSegT.SegName);
allSegT.Properties.UserData.contents = contentS; % add contentS to user data 
allSegT.Properties.UserData.si = si; % successfully indices
end