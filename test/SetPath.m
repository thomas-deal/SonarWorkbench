%% Find Base Path
TestPath = pwd;
seppos = strfind(TestPath,filesep);
BasePath = TestPath(1:seppos(end));
%% Add mdl Folder
addpath(fullfile(BasePath,'mdl'));
%% Add Resources
ResourcePath = fullfile(BasePath,'resources');
addpath(fullfile(ResourcePath,'Utilities'));
%% Clean Up
clear TestPath BasePath ResourcePath seppos
