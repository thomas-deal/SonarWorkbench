%% Setup Path
addpath(fullfile('..','..','mdl'))
addpath(fullfile('..','..','test'))
addpath(fullfile('..','..','resources','Utilities'))
%% Plot Settings
pos = [0 0 800 600];
%% Acoustic Parameters
lambda = 1;         % Wavelength, m
%% Generate Element and Array
SampleElement
SampleArray
Beam.ew = zeros(Array.Ne,1);
Beam.lambda = lambda;
%% Plot
PlotArray(Array,Beam,[],[])
%% Save Plot
set(gcf,'Position',pos,'Renderer','painters','PaperPositionMode','auto')
try
    print(gcf,'-depsc2','SampleArray.eps')
catch me
    disp('Unable to save SampleArray.eps, check write status.')
end
