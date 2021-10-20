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
Beam.theta = theta;
Beam.psi = psi;
Beam.lambda = lambda;
Beam.BP = BeamPattern(Array,Beam,lambda,theta,psi);
%% Analyze Beam Pattern
Beam.DI = CalculateDI(theta,psi,Beam.BP);
[Beam.BWV, Beam.BWH] = BeamWidth3D(theta,psi,Beam.BP);
PlotArray(Array,Beam)
Plot3DBP(theta,psi,Beam.BP,[],[],gca,Array.ax_m,Array.ay_m,Array.az_m)
title(['Sample Beam Pattern,', newline, ...
       '\theta_0 = ' num2str(theta0,'%2.1f') '\circ, ', ...
       '\psi_0 = ' num2str(psi0,'%2.1f') '\circ,', newline ...
       'DI = ' num2str(Beam.DI,'%2.1f') ' dB, ', ...
       'BW = ' num2str(Beam.BWV,'%2.1f') '\circ x ' num2str(Beam.BWH,'%2.1f') '\circ'])
       