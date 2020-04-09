clearvars -except psi0 theta0
close all
%% Setup Path
path(pathdef)
addpath(fullfile('..','mdl'))
%% Computational Grid
psi = -180:180;
theta = -90:90;
%% Design Parameters
lambda = 0.04;      % Acoustic wavelength, m
%% Define Element, Array, and Beam
SampleElement
SampleArray
SampleBeam
%% Calculate Beam Pattern
Beam.psi = psi;
Beam.theta = theta;
Beam.lambda = lambda;
Beam.BP = BeamPattern(Array,Element,Beam,lambda,psi,theta);
%% Analyze Beam Pattern
Beam.DI = CalculateDI(psi,theta,Beam.BP);
[Beam.BWH, Beam.BWV] = BeamWidth3D(psi,theta,Beam.BP);
PlotArray(Array,Element,Beam)
Plot3DBP(psi,theta,Beam.BP,[],[],gca,Array.ax,Array.ay,Array.az)
title(['Sample Beam Pattern, ', ...
       '\psi_0 = ' num2str(psi0,'%2.1f') '\circ, ', ...
       '\theta_0 = ' num2str(theta0,'%2.1f') '\circ, ', ...
       'DI = ' num2str(Beam.DI,'%2.1f') ' dB, ', ...
       'BW = ' num2str(Beam.BWH,'%2.1f') '\circ x ' num2str(Beam.BWV,'%2.1f') '\circ'])
       