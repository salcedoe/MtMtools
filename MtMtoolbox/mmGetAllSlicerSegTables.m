function T = mmGetAllSlicerSegTables(filePath)
%MMGETALLSEGTABLES Loads the metadata from Slicer segmentation files found
%in the same folder
%   Input the file path to the folder. Use a wild card for the file name
%   e.g. '*.seg.nrrd' or '*.nrrd'

arguments (Input)
    filePath {mustBeTextScalar}
end

contents = dir(filePath);

T = table; % segmentation metadata
for n=1:numel(contents)
    filepath = fullfile(contents(n).folder,contents(n).name); % construct file path
    t = mmGetSlicerSegTable(filepath,addVolInfo=true);
    t.ID = repmat(n, height(t),1);
    t.Filename = repmat(string(contents(n).name),height(t),1);
    t.LastName = extractBefore(t.Filename,("_"|" ")); % extract before an underscore or a space    
   
    t = movevars(t,{'ID' 'LastName'},'Before',1);   

    try % test if data can be concatenated with previous data
        T = [T; t];
    catch ME
        fprintf('%d. %s. %s',n,t.LastName(1), ME.message)
        continue
    end
end
T.Properties.UserData.Content = contents; % add contents to table

end