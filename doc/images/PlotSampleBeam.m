%% Setup Path
addpath(fullfile('..','..','mdl'))
addpath(fullfile('..','..','examples'))
%% Plot Settings
pos = [0 0 1000 600];
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
Beam.BP = BeamPattern(Array,Element,Beam,lambda,theta,psi);
%% Plot
figure
subplot(1,2,1)
PlotArray(Array,Element,Beam,gca)
Plot3DBP(theta,psi,Beam.BP,1,[],gca)
set(gca,'SortMethod','ChildOrder')
subplot(1,2,2)
PlotArray(Array,Element,Beam,gca)
Plot3DBP(theta,psi,Beam.BP,2,[],gca)
set(gca,'SortMethod','ChildOrder')
%% Finish Plot
set(gcf,'Position',pos)
%% Save Plot
set(gcf,'Renderer','painters','PaperPositionMode','auto')
try
    print(gcf,'-dpng','SampleBeam.png')
catch me
    disp('Unable to save SampleBeam.png, check write status.')
end