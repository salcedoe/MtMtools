function mmSaveViewer3D(FigHandle,Fullpath)
%MMSAVEVIEWER3D Save uifigures (created by fullshow as screen grabs
% INPUT
% FigHandle - created when you create a figure using viewer3d
%
% EXAMPLE
% mmSaveViewer3D(hvwr.Parent)
% ---
% Author: Ernesto Salcedo, PhD.
% Created: 9-Nov-2023

if nargin==1
    [Filepath,Folderpath] = uiputfile('*.png');
    Fullpath = fullfile(Folderpath, Filepath);
end
exportapp(FigHandle,Fullpath)
end