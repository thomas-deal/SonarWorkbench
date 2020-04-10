clearvars -except ea psi0 theta0
close all
%% Setup Path
path(pathdef)
addpath(fullfile('..','mdl'))
%% Define Elements
Element(1).type = 'OmnidirectionalElement';
Element(1).baffle = 0;
Element(1).shapex = [0 0];
Element(1).shapey = [0 0];
Element(1).shapez = [0 0];
Element(2).type = 'CosineElement';
Element(2).baffle = 0;
Element(2).shapex = [1 -1];
Element(2).shapey = [0 0];
Element(2).shapez = [0 0];
%% Define Vector Sensor
VS.Ne = 4;
VS.ex = zeros(VS.Ne,1);
VS.ey = zeros(VS.Ne,1);
VS.ez = zeros(VS.Ne,1);
VS.egamma = zeros(VS.Ne,1);
VS.etheta = [0; 0; 0; 90];
VS.epsi = [0; 0; 90; 0];
VS.ax = 0;
VS.ay = 0;
VS.az = 0;
VS.eindex = [1; 2; 2; 2];
%% Cardioid Beam Pattern
% Amplitude Weights
if ~exist('ea','var')
	ea = [1 1 1 1];
end
% Phase Weights
if ~exist('psi0','var')
	psi0 = 0;
end
if ~exist('theta0','var')
	theta0 = 0;
end
ep = [1 cosd(theta0)*cosd(psi0) cosd(theta0)*sind(psi0) sind(theta0)];
Beam.ew = ea.*ep;
%% Computational Grid
psi = -180:180;
theta = -90:90;
lambda = 1;
%% Calculate Beam Pattern
Beam.psi = psi;
Beam.theta = theta;
Beam.lambda = lambda;
Beam.BP = BeamPattern(VS,Element,Beam,lambda,theta,psi);
%% Analyze Beam Pattern
Beam.DI = CalculateDI(theta,psi,Beam.BP);
[Beam.BWV, Beam.BWH] = BeamWidth3D(theta,psi,Beam.BP);
PlotArray(VS,Element,Beam)
Plot3DBP(theta,psi,Beam.BP,[],[],gca,VS.ax,VS.ay,VS.az)
title(['Cardioid Beam Pattern, ', ...
	   '\theta_0 = ' num2str(theta0,'%2.1f') '\circ, ', ...
	   '\psi_0 = ' num2str(psi0,'%2.1f') '\circ, ', ...
	   'DI = ' num2str(Beam.DI,'%2.1f') ' dB, ', ...
	   'BW = ' num2str(Beam.BWV,'%2.1f') '\circ x ' num2str(Beam.BWH,'%2.1f') '\circ'])

