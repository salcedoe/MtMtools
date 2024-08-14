function add_slicer_utility_fns
%ADD_SLICER_UTILITY_FNS - finds the path for slicer_utilites and adds to
%search path
% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of COLORADO Modern Human Anatomy
% DATE: Dec-3-2020

file_path = mfilename('fullpath');
fn_folder = fileparts(file_path);
su_folder{1} = fullfile(fn_folder,'slicer_utilities');
su_folder{2} = fullfile(fn_folder,'matGeom-master','matGeom');
% su_folder{2} = fullfile(fn_folder, 'obj_write_fns');

fprintf('Adding to  search path...\n')
for n=1:numel(su_folder)
    if exist(su_folder{n}, 'dir')
        addpath(su_folder{n})
        fprintf('%s\n', su_folder{n})
    else
        fprintf('%s not found\n', su_folder{n})
    end
    
end
end