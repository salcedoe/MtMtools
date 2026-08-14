totalseg_set_license -l aca_DI2SOEHRCCC256 
%%
%[text] Path created using the following steps in Apple terminal
%[text] 1. Navigate to totalseg\_project
%[text] 2. Run the following command \
echo "$VIRTUAL_ENV/bin/python"
%%

%%
% Point MATLAB explicitly to your TotalSegmentator sandbox
totSegvenv = '/Users/ernesto/Documents/Python/totalseg_project/.venv/bin/python' %[output:277a17c3]
pyenv('Version', totSegvenv) %[output:5702af96] %[output:0d61939d]
% Test if MATLAB can see the TotalSegmentator library
py.importmodule('totalsegmentator') %[output:53f0788f]


%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:277a17c3]
%   data: {"dataType":"textualVariable","outputData":{"name":"totSegvenv","value":"'\/Users\/ernesto\/Documents\/Python\/totalseg_project\/.venv\/bin\/python'"}}
%---
%[output:5702af96]
%   data: {"dataType":"warning","outputData":{"text":"Warning: Python version 3.14 is not supported. See <a href=\"https:\/\/www.mathworks.com\/content\/dam\/mathworks\/mathworks-dot-com\/support\/sysreq\/files\/python-support.pdf\">this topic.<\/a>"}}
%---
%[output:0d61939d]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"  <a href=\"matlab:helpPopup('matlab.pyclient.PythonEnvironment')\" style=\"font-weight:bold\">PythonEnvironment<\/a> with properties:\n\n          Version: \"3.14\"\n       Executable: \"\/Users\/ernesto\/Documents\/Python\/totalseg_project\/.venv\/bin\/python\"\n          Library: \"\/opt\/homebrew\/opt\/python@3.14\/Frameworks\/Python.framework\/Versions\/3.14\/lib\/libpython3.14.dylib\"\n             Home: \"\/Users\/ernesto\/Documents\/Python\/totalseg_project\/.venv\"\n           Status: NotLoaded\n    ExecutionMode: OutOfProcess\n"}}
%---
%[output:53f0788f]
%   data: {"dataType":"error","outputData":{"errorType":"runtime","text":"Python Error: ModuleNotFoundError: No module named 'importmodule'"}}
%---
