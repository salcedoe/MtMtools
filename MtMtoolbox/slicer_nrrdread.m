function img = slicer_nrrdread(filename)
% Read image and metadata from a NRRD file (see http://teem.sourceforge.net/nrrd/format.html)
%   img = cli_imageread(filename) reads the image volume and associated metadata
%
%   img.pixelData: pixel data array
%   img.ijkToLpsTransform: pixel (IJK) to physical (LPS, assuming 'space' is 'left-posterior-superior')
%     coordinate system transformation, the origin of the IJK coordinate system is (1,1,1) to match Matlab matrix indexing
%   img.metaData: contains all the descriptive information in the image header
%   img.metaDataFieldNames: Contains full names of metadata fields that cannot be used as Matlab field names because they contains
%     special characters (space, dot, etc). Special characters in field names are replaced by underscore by default when the NRRD
%     file is read. Full field names are used when writing the image to NRRD file.
%
%  Supports reading of 3D and 4D volumes.
%
%   Current limitations/caveats:
%   * Block datatype is not supported.
%   * Only tested with "gzip" and "raw" file encodings.
%
% Partly based on the nrrdread.m function with copyright 2012 The MathWorks, Inc.

fid = fopen(filename, 'rb');
assert(fid > 0, 'Could not open file.');
cleaner = onCleanup(@() fclose(fid));

% NRRD files must start with the NRRD word and a version number
theLine = fgetl(fid);
assert(numel(theLine) >= 4, 'Bad signature in file.')
assert(isequal(theLine(1:4), 'NRRD'), 'Bad signature in file.')

% The general format of a NRRD file (with attached header) is:
% 
%     NRRD000X
%     <field>: <desc>
%     <field>: <desc>
%     # <comment>
%     ...
%     <field>: <desc>
%     <key>:=<value>
%     <key>:=<value>
%     <key>:=<value>
%     # <comment>
% 
%     <data><data><data><data><data><data>...

img.metaData = {};
img.metaDataFieldNames = {};
% Parse the file a line at a time.
while (true)

  theLine = fgetl(fid);
  
  if (isempty(theLine) || feof(fid))
    % End of the header.
    break;
  end
  
  if (isequal(theLine(1), '#'))
      % Comment line.
      continue;
  end
  
  % "fieldname:= value" or "fieldname: value" or "fieldname:value"
  parsedLine = regexp(theLine, ':=?\s*', 'split','once');
  
  assert(numel(parsedLine) == 2, 'Parsing error')
  
  field = parsedLine{1};
  value = parsedLine{2};
      
  % Cannot use special characters in field names, so replace them by underscore
  % and store the original field name in img.metaDataFieldNames so that it can be
  % restored when writing the data.
  fieldName=regexprep(field,'\W','_');
  if ~strcmp(fieldName,field)
    img.metaDataFieldNames.(fieldName) = field;
  end
  
  img.metaData(1).(fieldName) = value;
  
end

datatype = getDatatype(img.metaData.type);

% Get the size of the data.
assert(isfield(img.metaData, 'sizes') && ...
       isfield(img.metaData, 'dimension') && ...
       isfield(img.metaData, 'encoding'), ...
       'Missing required metadata fields (sizes, dimension, or encoding).')

dims = sscanf(img.metaData.sizes, '%d');
ndims = sscanf(img.metaData.dimension, '%d');
assert(numel(dims) == ndims);

data = readData(fid, img.metaData, datatype);
if isfield(img.metaData, 'endian')
    data = adjustEndian(data, img.metaData);
end

img.pixelData = reshape(data, dims');

% For convenience, compute the transformation matrix between physical and pixel coordinates
switch (ndims)
 case {3}
  axes_directions=reshape(sscanf(img.metaData.space_directions,'(%f,%f,%f) (%f,%f,%f) (%f,%f,%f)'),3,3);
 case {4}
  axes_directions=reshape(sscanf(img.metaData.space_directions,'none (%f,%f,%f) (%f,%f,%f) (%f,%f,%f)'),3,3);
 otherwise
  assert(false, 'Unsupported pixel data dimension')
end
axes_origin=sscanf(img.metaData.space_origin,'(%f,%f,%f)');
ijkZeroBasedToLpsTransform=[[axes_directions, axes_origin]; [0 0 0 1]];
ijkOneBasedToIjkZeroBasedTransform=[[eye(3), [-1;-1;-1] ]; [0 0 0 1]];
ijkOneBasedToLpsTransform=ijkZeroBasedToLpsTransform*ijkOneBasedToIjkZeroBasedTransform;
% Use the one-based IJK transform (origin is at [1,1,1])
img.ijkToLpsTransform=ijkOneBasedToLpsTransform;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function datatype = getDatatype(metaType)
% Determine the datatype
switch (metaType)
 case {'signed char', 'int8', 'int8_t'}
  datatype = 'int8';  
 case {'uchar', 'unsigned char', 'uint8', 'uint8_t'}
  datatype = 'uint8';
 case {'short', 'short int', 'signed short', 'signed short int', ...
       'int16', 'int16_t'}
  datatype = 'int16';
 case {'ushort', 'unsigned short', 'unsigned short int', 'uint16', ...
       'uint16_t'}
  datatype = 'uint16';
 case {'int', 'signed int', 'int32', 'int32_t'}
  datatype = 'int32';
 case {'uint', 'unsigned int', 'uint32', 'uint32_t'}
  datatype = 'uint32';
 case {'longlong', 'long long', 'long long int', 'signed long long', ...
       'signed long long int', 'int64', 'int64_t'}
  datatype = 'int64';
 case {'ulonglong', 'unsigned long long', 'unsigned long long int', ...
       'uint64', 'uint64_t'}
  datatype = 'uint64';
 case {'float'}
  datatype = 'single';
 case {'double'}
  datatype = 'double';
 otherwise
  assert(false, 'Unknown datatype')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = readData(fidIn, meta, datatype)

switch (meta.encoding)
 case {'raw'}
  data = fread(fidIn, inf, [datatype '=>' datatype]);
 case {'gzip', 'gz'}
  compressedData  = fread(fidIn, inf, 'uchar=>uint8');
  try
    data = zlib_decompress(compressedData,datatype);
  catch noMemory
    disp('Not enough Java heap space (it can be increased in Matlab preferences)');
    return;
  end
 case {'txt', 'text', 'ascii'}  
  data = fscanf(fidIn, '%f');
  data = cast(data, datatype);  
 otherwise
  assert(false, 'Unsupported encoding')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = adjustEndian(data, meta)
% For ignoring unused parameters dummy variables (dummy1 and dummy2) are
% used instead of ~ to maintain compatibility with Matlab R2009b version
[dummy1,dummy2,endian] = computer();
needToSwap = (isequal(endian, 'B') && isequal(lower(meta.endian), 'little')) || ...
         (isequal(endian, 'L') && isequal(lower(meta.endian), 'big'));
if (needToSwap)
data = swapbytes(data);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function M = zlib_decompress(Z,DataType)
% Function for decompressing pixel data 
%   Z: pixel data to decompress (from uchar to uint8)
%   DataType: data type of the volume
% Returns: decompressed pixel data
% Examples:
%   pixelData = zlib_decompress(Z,int32);

  import com.mathworks.mlwidgets.io.InterruptibleStreamCopier
  a=java.io.ByteArrayInputStream(Z);
  b=java.util.zip.GZIPInputStream(a);
  isc = InterruptibleStreamCopier.getInterruptibleStreamCopier;
  c = java.io.ByteArrayOutputStream;
  isc.copyStream(b,c);
  M=typecast(c.toByteArray,DataType);
