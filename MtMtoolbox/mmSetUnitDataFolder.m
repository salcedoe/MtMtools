function datapath = mmSetUnitDataFolder(unit_num)
%MMSETUNITDATAFOLDER Sets the current folder a unit data folder in the MtMdata Shared Drive
% download the shared drive here: https://drive.mathworks.com/sharing/36f2e302-384d-4c4e-aa98-8e853c1051c0
% INPUT
%   unit - the Unit Number you want set
%
% Example:
%      mmSetUnitDataFolder(2)
% ---
% CU Anschutz School of Medicine Modern Human Anatomy
% Ernesto Salcedo, PhD
% Ernesto.Salcedo@cuanschutz.edu

arguments
    unit_num (1,1) {mustBeNumeric}
end


% paths.toolbox = mfilename("fullpath");
% paths.repo = fileparts(fileparts(paths.toolbox));
% paths.scripts = fullfile(paths.repo,'scripts');
% paths.unit = fullfile(paths.scripts,sprintf('unit%d',unit_num));

dp = fullfile(matlabdrive,"MtMdata", sprintf("unit%d",unit_num));

if ~exist(dp,"dir")
    beep
    fprintf('Indicated MtMdata folder not found. Find the unit%d data folder in the MtMdata folder\n',unit)
    dp = uigetdir;
end

cd(dp)

if nargout>0
    datapath = dp;
else
    fprintf("The current folder is now %s\n",pwd);
end

end