function folder_path = mmSetUnitDataFolder(unit)
%SET_UNIT_DATA_FOLDER Sets the current folder to one of the UNIT data
%folders in ANAT 6205 MATLAB drive folder
%   This function is specific to ANAT 6205 MATLAB folder
%   unit - the Unit Number you want set
%   Example:
%      set_unit_data_folder(2)
% ---
% CU Anschutz School of Medicine Modern Human Anatomy
% Ernesto Salcedo, PhD
% Ernesto.Salcedo@cuanschutz.edu

folder_path = fullfile(matlabdrive,"ANAT6205", sprintf("UNIT %d",unit),"data");

if ~exist(folder_path,"dir")
    beep
    fprintf('MATLAB Drive folder not found. Find the UNIT %d data folder\n',unit)
    folder_path = uigetdir;
end
    cd(folder_path)

fprintf("The current folder is %s",folder_path);
end