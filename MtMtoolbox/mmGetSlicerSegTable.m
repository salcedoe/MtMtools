function T = mmGetSlicerSegTable(file_name)
%MMGETSLICERSEGNAMES Returns the segmentation names found in seg.nrrd files
%   INPUTS: file_name of a segmentation file
%   OUTPUT: a table with segmentation names, layer, label, and color values
%
% EXAMPLE
%
% segT = mmGetSlicerSegTable(seg_file)
%
% Works with Slicer 4.11.2020 and higher
% ---
% Ernesto Salcedo, PhD
% Updated: 10-20-2025
% University of Colorado Modern Human Anatomy

if ~contains(file_name,".seg.nrrd")
    beep
    disp("Slicer *.seg.nrrd files only")
    return
elseif ~exist("nrrdinfo","file")
    beep
    disp("Medical Toolbox required")
    return
end

info = nrrdinfo(file_name);
meta = info.RawAttributes;

FN = string(fieldnames(meta));
%     FNsegment = FN(startsWith(FN,"Segment"+digitsPattern(1))); % find Segment FN
FNsegment = FN(~cellfun(@isempty, regexp(FN,'segment\d+')));
seg_count = max(str2double(string(regexp(FNsegment,'(?<=segment)\d+','match'))))+1;

T = table(strings(seg_count,1), zeros(seg_count,1), zeros(seg_count,1), zeros(seg_count,3),...
    'VariableNames',{'SegName','Layer','LabelValue','Color'}); % changed Name to Segment

for n = 1:seg_count
    T.SegName(n) = meta.(sprintf('segment%d_name',n-1)); % changed to SegName
    T.Layer(n) = str2double(meta.(sprintf('segment%d_layer',n-1)))+1; % convert to mlb index
    T.LabelValue(n) = str2double(meta.(sprintf('segment%d_labelvalue',n-1)));
    T.Color(n,:) = str2num(meta.(sprintf('segment%d_color',n-1)));
end

T = sortrows(T,"LabelValue");

T.Properties.UserData = info; % attach metadata back to table
end

