function msT = mmGetMultiSegTable(folderPath)
%MMGETMULTISEGTABLE Returns segmentation tables from multiple *.seg.nrrd
%files
% ---
% Ernesto Salcedo, PhD
% Created: 12-06-2023
% Updated: 12-06-2023
% University of Colorado Modern Human Anatomy

contents = dir(fullfile(folderPath,'*.seg.nrrd')); % returns info on *.seg.nrrd files

if isempty(contents) % check folder for seg.nrrd files
    beep
    disp("No *.seg.nrrd files found")
    return
end

rows = numel(contents);

% msT = table(strings(rows,1),zeros(rows,1),zeros(rows,1), zeros(rows,3),...
%     strings(rows,1),'VariableNames',{'Name','Layer','LabelValue','Color','filename'});

msT = table;
for n = 1:rows

    fullpath= fullfile(folderPath,contents(n).name); % get full path to file
    
    st = mmGetSlicerSegTable(fullpath); % get the segmentation table
    st.filename = repmat(string(contents(n).name),height(st),1); % add the file name

    msT = [msT; st]; % append to table

end

msT.Properties.UserData.folderPath = folderPath;

end