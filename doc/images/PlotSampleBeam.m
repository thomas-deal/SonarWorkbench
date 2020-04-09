%% Setup Path
addpath(fullfile('..','..','mdl'))
addpath(fullfile('..','..','examples'))
%% Plot Settings
pos = [0 0 800 600];
%% Acoustic Parameters
lambda = 1;         % Wavelength, m
%% Computational Grid
psi = -180:180;
theta = -90:90;
%% Define Element, Array, and Beam
SampleElement
SampleArray
SampleBeam
%% Calculate Beam Pattern
Beam.psi = psi;
Beam.theta = theta;
Beam.lambda = lambda;
Beam.BP = BeamPattern(Array,Element,Beam,lambda,psi,theta);
%% Plot
PlotArray(Array,Element,Beam)
Plot3DBP(psi,theta,Beam.BP,[],[],gca,Array.ax,Array.ay,Array.az)
%% Finish Plot
set(gca,'SortMethod','ChildOrder')
set(gcf,'Position',pos)
%% Save Plot
set(gcf,'Renderer','painters','PaperPositionMode','auto')
try
    print(gcf,'-dpng','SampleBeam.png')
catch me
    disp('Unable to save SampleBeam.png, check write status.')
end