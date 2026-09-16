function mmGetScript(unit_num)
%MMGETSCRIPT Download Class Live scripts from github repository
%   Input the unit number
%   Select Files when prompted
%   Select Folder to save files in when prompted

arguments (Input)
    unit_num (1,1) {mustBeInteger, mustBeGreaterThanOrEqual(unit_num,1), ...
        mustBeLessThanOrEqual(unit_num,4)} = 1
end

% read content from github
user = "salcedoe";
repo = "MtMtools";
branch = "main";
folder = "scripts/unit"+unit_num;

apiURL = "https://api.github.com/repos/" + user + "/" + repo + ...
    "/contents/" + folder + "?ref=" + branch;

items = webread(apiURL);
% Keep only .m files
isFile = strcmp({items.type}, "file");
names = string({items.name});
lsFiles = names(isFile & endsWith(names, ".m")); % only live scripts

[selectn,ok] = listdlg("PromptString","Select File(s) to download:", ...
    "SelectionMode","multiple", ...
    "ListString",lsFiles);

if ok
    path2save = uigetdir(pwd,"Choose Folder");

    if path2save
        % Download each file to the current MATLAB folder
        baseURL = "https://raw.githubusercontent.com/" + user + "/" + repo + ...
            "/" + branch + "/" + folder + "/";

        for file = lsFiles(selectn)
            websave(fullfile(path2save,file), baseURL + file);
        end

        fprintf('Selected files saved in %s\n',path2save)
        fprintf('- %s\n',lsFiles(selectn))
    end
else
    disp('download canceled...')
end
end