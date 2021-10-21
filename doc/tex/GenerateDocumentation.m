clc
clear
close all
path(pathdef)
%% Path Settings
TEXPath = pwd;
cd(fullfile('..','..'))
SWBPath = pwd;
DOCPath = fullfile(SWBPath,'doc');
IMGPath = fullfile(DOCPath,'images');
%% Update Images
cd(IMGPath)
GenerateAllImages
close all
%% Update Documentation
texFile = 'SonarWorkbench';
cd(TEXPath)
latexCMD = ['pdflatex -shell-escape ' texFile];
system(latexCMD);
system(['bibtex ' texFile]);
system(latexCMD);
system(latexCMD);
if ~exist(DOCPath,'dir')
    mkdir(DOCPath)
end
copyfile([texFile '.pdf'],DOCPath)
open(fullfile(DOCPath,[texFile '.pdf']))
%% Clean Up
CleanupList = {'.aux' '.bbl' '.blg' '.lof' '.log' '.lot' '.out' '.pdf' '.toc'};
for i=1:length(CleanupList)
    try
        delete(['*' CleanupList{i}])
    catch me
    end
end