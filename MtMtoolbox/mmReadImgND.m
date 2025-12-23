function [IMGND, metadata] = mmReadImgND(file_path)
%MMREADIMGND This function uses the bio-formats toolbox to read in
%multidimensional image stacks
%
% INPUTS (optional)
% - file_path is a path to a file. If you don't input a file path, you will
% be prompted for a path
%
% OUTPUTS:
% - IMGND - an XYZCT multidimensional array
% - metadata - the metadata from the array in XML format
%
% EXAMPLE:
%
% [IMGND, metadata] = mmReadImgND(file_path)
% ---
% AUTHOR: Ernesto Salcedo, PhD University of Colorado School of Medicine
% Created: 1-Sep-2017
% Updated: 29-Sep-2021

if exist("bfmatlab","dir")
    status = bfCheckJavaPath(1);
    assert(status, ['Missing Bio-Formats library. Either add bioformats_package.jar '...
        'to the static Java path or add it to the Matlab path.']);
else
    disp("bioformats toolbox not found. Be sure to add 'bfmatlab' to the file path")
    return
end

% Prompt for a file if not input
if nargin == 0 || exist(file_path, 'file') == 0
    [file, path] = uigetfile(bfGetFileExtensions, 'Choose a file to open');
    file_path = fullfile(path, file);
    if isequal(path, 0) || isequal(file, 0), return; end
end

% set up logger - part of bioformats
bfInitLogging();

% initialize stack reader
% r = bfGetReader(char(fullPath));

% Memoizer - for speed in reading
r = bfGetReader();
r = loci.formats.Memoizer(r); % seems to crash on PCs
r.setId(char(file_path));


% load OME metadata
omeMeta = r.getMetadataStore(); % different from imfinfo


% set series (should only be one series)
num_series = r.getSeriesCount;

if num_series > 1
    s = listdlg('PromptString', 'Select series number to load','ListString',string(0:num_series-1));
    series_jidx = s-1;
else
    series_jidx = 0;
end

bit_string = char(omeMeta.getPixelsType(series_jidx)); % get bit depth

r.setSeries(series_jidx);


% get stack info
ChannelCount = r.getSizeC;
PlaneCount = r.getSizeZ;
TimeCount= r.getSizeT;


IMGND = zeros(r.getSizeY, r.getSizeX, ChannelCount, PlaneCount, TimeCount, bit_string);


for t = 0:TimeCount-1
    for z=0:PlaneCount-1
        for c = 0:ChannelCount-1
            PlaneIndex = r.getIndex(z, c, t);
            IMGND(:,:,c+1,z+1,t+1) = bfGetPlane(r,PlaneIndex+1);
        end
    end
end

metadata.filename = file_path;
metadata.StudyDescription = char(omeMeta.getImageName(series_jidx));
metadata.SeriesSelected = series_jidx;
metadata.Width = double(omeMeta.getPixelsSizeX(series_jidx).getNumberValue);
metadata.Height = double(omeMeta.getPixelsSizeY(series_jidx).getNumberValue);
metadata.BitDepth = double(omeMeta.getPixelsSignificantBits(series_jidx).getNumberValue);

try
    % get pixel dimensions
    PhysicalSizeX = double(omeMeta.getPixelsPhysicalSizeX(series_jidx).value);
    PhysicalSizeY = double(omeMeta.getPixelsPhysicalSizeY(series_jidx).value);
    metadata.PixelSpacing = [PhysicalSizeX PhysicalSizeY];
catch
    disp('Physical Pixel Size not found')
end

metadata.ChannelCount = ChannelCount;
metadata.PlaneCount = PlaneCount;
metadata.TimeCount = TimeCount;

metadata.XML = string(omeMeta.dumpXML);
metadata.XML = regexprep(metadata.XML,'><','>\n<'); % add line returns and display
% disp(metadata.XML)
close(r)

end

