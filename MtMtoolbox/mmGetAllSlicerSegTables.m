function [T, contentT] = mmGetAllSlicerSegTables(filePath)
%MMGETALLSEGTABLES Loads the metadata from Slicer segmentation files found
%in the same folder
%   Input the file path to the folder. Use a wild card for the file name
%   e.g. '*.seg.nrrd' or '*.nrrd'

arguments (Input)
    filePath {mustBeTextScalar}
end

contents = dir(filePath);

if isempty(contents)
    error('Incorrect path or no Slicer files found')
end

contentT = struct2table(contents);
contentT = convertvars(contentT,["name" "folder"],"string");
contentT.LastName = strings(height(contentT),1);
contentT.VolDim = zeros(height(contentT),1);
contentT.PixelSpacing = zeros(height(contentT),3);
contentT = movevars(contentT,["LastName" "VolDim" "PixelSpacing"],'Before',1);

si = []; % successful indices
T = table; % segmentation metadata
for n=1:numel(contents)
    filepath = fullfile(contents(n).folder,contents(n).name); % construct file path
    t = mmGetSlicerSegTable(filepath);
    t.ID = repmat(n, height(t),1);
    t.Filename = repmat(string(contents(n).name),height(t),1);
    t.LastName = extractBefore(t.Filename,("_"|" ")); % extract before an underscore or a space       
    t = movevars(t,{'ID' 'LastName'},'Before',1);   

    contentT.LastName(n) = t.LastName(1);
    contentT.VolDim(n) = numel(t.Properties.UserData.ImageSize);
    contentT.PixelSpacing(n,:) = t.Properties.UserData.PixelDimensions;

    try % test if data can be concatenated with previous data
        T = [T; t];
        si = [si; n]; % concatenate successful indices
    catch ME
        fprintf('%d. %s. %s\n',n,t.LastName(1), ME.message)
        disp(t)
        continue
    end
end
T.LastName = categorical(T.LastName);
T.SegName = categorical(T.SegName);
T.Properties.UserData.contents = contents; % add contents to table
T.Properties.UserData.si = si; % successfully indices
end