close all hidden
clearvars %[output:36c0c3da]
%%
%[text] ## Load all Segmentation metadata
%[text] The slicer Segmentation table contains the names of the segmentations, so its good to load all the names to ensure the data formats match. 
file_path = fullfile(matlabdrive,"ANAT6205_Dropbox","Femurs",'*.seg.nrrd'); % note the use of a wild card in the file name %[output:76c29fc2]
segT = mmGetAllSegTables(file_path) %[output:3112c3c3] %[output:02e71dcc]
%%
mmGetSlicerSegTable
%%
function RP = getFemurLength(contents)

for n=1:numel(contents)

end

end
%%
%[text] ### Set  paths
paths.project = "/Users/ernesto/MATLAB-Drive/MtMdata/unit3/Femur"; %[control:filebrowser:762f]{"position":[17,66]}
ls(paths.project) % display folder contents %[output:208a0f8b]
%%
paths.intensity = fullfile(paths.project,"6 BODY BONE cropped.nrrd");
paths.segment = fullfile(paths.project,"Salcedo Segmentation.seg.nrrd");
%[text] path check
table(fieldnames(paths),structfun(@(x) exist(x,"file"),paths),VariableNames=["path" "X"]) % make sure paths exist  %[output:029bf88c]
%[text] - a zero in the table means the indicated file path does not exist  \
%%
%[text] ### Load the volumes as medical volumes
mvInt = medicalVolume(paths.intensity) %[text:anchor:TMP_7e79] %[output:1f3c3456]
mVseg = medicalVolume(paths.segment) %[output:94db5e03] %[output:6638bdd1]

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[control:filebrowser:762f]
%   data: {"browserType":"Folder","defaultValue":"\"\"","label":"select Femur folder","run":"Section"}
%---
%[output:36c0c3da]
%   data: {"dataType":"tabular","outputData":{"columnNames":["name","folder","date","bytes","isdir","datenum"],"columns":6,"cornerText":"Fields","dataTypes":["char","char","char","double","logical","double"],"header":"9×1 struct array with fields:","name":"contents","rows":9,"type":"struct","value":[["'Anderson Segmentation.seg.nrrd'","'\/Users\/ernesto\/MATLAB-Drive\/ANAT6205_Dropbox\/Femurs'","'03-Nov-2025 13:02:06'","119677","0","7.3992e+05"],["'Buchanan Femur Segmentation.seg.nrrd'","'\/Users\/ernesto\/MATLAB-Drive\/ANAT6205_Dropbox\/Femurs'","'03-Nov-2025 19:56:46'","132530","0","7.3992e+05"],["'DeBaets Femuh Segmentation.seg.nrrd'","'\/Users\/ernesto\/MATLAB-Drive\/ANAT6205_Dropbox\/Femurs'","'24-Oct-2025 09:02:39'","154522","0","7.3991e+05"],["'Fridrich Segmentation.seg.nrrd'","'\/Users\/ernesto\/MATLAB-Drive\/ANAT6205_Dropbox\/Femurs'","'03-Nov-2025 13:08:34'","127635","0","7.3992e+05"],["'Huchthausen Femur Segmentation.seg.nrrd'","'\/Users\/ernesto\/MATLAB-Drive\/ANAT6205_Dropbox\/Femurs'","'23-Oct-2025 15:24:01'","161953","0","7.3991e+05"],["'Mackawi Segmentation.seg.nrrd'","'\/Users\/ernesto\/MATLAB-Drive\/ANAT6205_Dropbox\/Femurs'","'23-Oct-2025 15:23:56'","193953","0","7.3991e+05"],["'Powers Segmentation.seg.nrrd'","'\/Users\/ernesto\/MATLAB-Drive\/ANAT6205_Dropbox\/Femurs'","'30-Oct-2025 15:17:25'","70476","0","7.3992e+05"],["'Salcedo Segmentation.seg.nrrd'","'\/Users\/ernesto\/MATLAB-Drive\/ANAT6205_Dropbox\/Femurs'","'23-Oct-2025 07:05:30'","319308","0","7.3991e+05"],["'Solomon Seg.seg.nrrd'","'\/Users\/ernesto\/MATLAB-Drive\/ANAT6205_Dropbox\/Femurs'","'30-Oct-2025 15:05:35'","146724","0","7.3992e+05"]]}}
%---
%[output:76c29fc2]
%   data: {"dataType":"textualVariable","outputData":{"name":"file_path","value":"\"\/Users\/ernesto\/MATLAB-Drive\/ANAT6205_Dropbox\/Femurs\/*.seg.nrrd\""}}
%---
%[output:3112c3c3]
%   data: {"dataType":"text","outputData":{"text":"7. Powers. An error occurred when concatenating the table variable 'ImageSize' using vertcat.","truncated":false}}
%---
%[output:02e71dcc]
%   data: {"dataType":"tabular","outputData":{"columnNames":["ID","LastName","SegName","Layer","LabelValue","Color","Color","Color","ImageSize","ImageSize","ImageSize","PixelDimensions","PixelDimensions","PixelDimensions","Filename"],"columns":15,"dataTypes":["double","string","string","double","double","double","double","double","double","double","double","double","double","double","string"],"groupedColumnIndices":[null,null,null,null,null,1,2,3,1,2,3,1,2,3,null],"header":"28×9 table","name":"segT","rows":28,"type":"table","value":[["1","\"Anderson\"","\"left femur\"","1","90","0.66667","0.33333","1","280","183","763","1.0742","1.0742","1.0742","\"Anderson Segmentation.seg.nrrd\""],["1","\"Anderson\"","\"right femur\"","1","91","1","0.93333","0.66667","280","183","763","1.0742","1.0742","1.0742","\"Anderson Segmentation.seg.nrrd\""],["1","\"Anderson\"","\"Implant\"","1","92","0","0.95686","0.92549","280","183","763","1.0742","1.0742","1.0742","\"Anderson Segmentation.seg.nrrd\""],["2","\"Buchanan\"","\"femoral implant\"","1","1","0.68235","0.12157","0.12157","326","187","503","1.0742","1.0742","1.0742","\"Buchanan Femur Segmentation.seg.nrrd\""],["2","\"Buchanan\"","\"tibial implant\"","1","2","0.9451","0.54902","0.094118","326","187","503","1.0742","1.0742","1.0742","\"Buchanan Femur Segmentation.seg.nrrd\""],["2","\"Buchanan\"","\"left femur\"","1","75","0","0.34902","1","326","187","503","1.0742","1.0742","1.0742","\"Buchanan Femur Segmentation.seg.nrrd\""],["2","\"Buchanan\"","\"right femur\"","1","76","0.23529","1","0","326","187","503","1.0742","1.0742","1.0742","\"Buchanan Femur Segmentation.seg.nrrd\""],["3","\"DeBaets\"","\"left femur\"","1","1","1","0.93333","0.66667","330","231","673","1.0742","1.0742","1.0742","\"DeBaets Femuh Segmentation.seg.nrrd\""],["3","\"DeBaets\"","\"Implant\"","1","2","0.50196","0.68235","0.50196","330","231","673","1.0742","1.0742","1.0742","\"DeBaets Femuh Segmentation.seg.nrrd\""],["3","\"DeBaets\"","\"right femur\"","1","3","1","0.93333","0.66667","330","231","673","1.0742","1.0742","1.0742","\"DeBaets Femuh Segmentation.seg.nrrd\""],["4","\"Fridrich\"","\"Implant\"","1","1","0","0.66667","0","290","149","601","1.0742","1.0742","1.0742","\"Fridrich Segmentation.seg.nrrd\""],["4","\"Fridrich\"","\"left femur\"","1","75","0","0.33333","1","290","149","601","1.0742","1.0742","1.0742","\"Fridrich Segmentation.seg.nrrd\""],["4","\"Fridrich\"","\"right femur\"","1","76","1","0","0","290","149","601","1.0742","1.0742","1.0742","\"Fridrich Segmentation.seg.nrrd\""],["5","\"Huchthausen\"","\"left femur\"","1","1","1","0.24314","0.87451","287","223","947","1.0742","1.0742","1.0742","\"Huchthausen Femur Segmentation.seg.nrrd\""]]}}
%---
%[output:208a0f8b]
%   data: {"dataType":"text","outputData":{"text":"2025-10-21-Scene.mrml\t\tSalcedo Segmentation.seg.nrrd\n2025-10-21-Scene.png\t\tSalcedo.mrk.json\n6 BODY BONE cropped.nrrd\tTotal Segmentation.seg.nrrd\nD.mrk.json\t\t\tVolumeProperty.vp\n\n","truncated":false}}
%---
%[output:029bf88c]
%   data: {"dataType":"tabular","outputData":{"columnNames":["path","X"],"columns":2,"dataTypes":["cellstr","double"],"header":"3×2 table","name":"ans","rows":3,"type":"table","value":[["'project'","7"],["'intensity'","2"],["'segment'","2"]]}}
%---
%[output:1f3c3456]
%   data: {"dataType":"textualVariable","outputData":{"name":"mvInt","value":"  <a href=\"matlab:helpPopup('medicalVolume')\" style=\"font-weight:bold\">medicalVolume<\/a> with properties:\n\n                  Voxels: [299×253×1059 int16]\n          VolumeGeometry: [1×1 medicalref3d]\n            SpatialUnits: \"unknown\"\n             Orientation: \"transverse\"\n            VoxelSpacing: [1.0742 1.0742 1.0742]\n            NormalVector: [0 0 1]\n        NumCoronalSlices: 253\n       NumSagittalSlices: 299\n     NumTransverseSlices: 1059\n            PlaneMapping: [\"sagittal\"    \"coronal\"    \"transverse\"]\n    DataDimensionMeaning: [\"right\"    \"anterior\"    \"superior\"]\n                Modality: \"unknown\"\n           WindowCenters: []\n            WindowWidths: []\n"}}
%---
%[output:94db5e03]
%   data: {"dataType":"warning","outputData":{"text":"Warning: Missing 'endian' value in the file metadata. Using host endian. Use swapbytes if necessary."}}
%---
%[output:6638bdd1]
%   data: {"dataType":"textualVariable","outputData":{"name":"mVseg","value":"  <a href=\"matlab:helpPopup('medicalVolume')\" style=\"font-weight:bold\">medicalVolume<\/a> with properties:\n\n                  Voxels: [299×253×1059 uint8]\n          VolumeGeometry: [1×1 medicalref3d]\n            SpatialUnits: \"unknown\"\n             Orientation: \"transverse\"\n            VoxelSpacing: [1.0742 1.0742 1.0742]\n            NormalVector: [0 0 1]\n        NumCoronalSlices: 253\n       NumSagittalSlices: 299\n     NumTransverseSlices: 1059\n            PlaneMapping: [\"sagittal\"    \"coronal\"    \"transverse\"]\n    DataDimensionMeaning: [\"right\"    \"anterior\"    \"superior\"]\n                Modality: \"unknown\"\n           WindowCenters: []\n            WindowWidths: []\n"}}
%---
