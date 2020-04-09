clear
close all
%% Setup Path
path(pathdef)
addpath(fullfile('..','..','mdl'))
%% Plot Settings
pos = [0 0 1400 800];
%% Acoustic Parameters
d = 0.1;            % Common element size, m
lambda = d/2;       % Wavelength, m
%% Computational Grid
psi = -180:180;
theta = -90:90;
%% Setup Elements
% Omnidirectional Element
OmniElement.type = 'OmnidirectionalElement';
OmniElement.baffle = 0;
OmniElement = AddElementShape(OmniElement);
% Linear Element
LineElement.type = 'LinearElement';
LineElement.baffle = 0;
LineElement.L = d;
LineElement.axis = 'y';
LineElement = AddElementShape(LineElement);
% Cosine Element
CosElement.type = 'CosineElement';
CosElement.baffle = 0;
CosElement = AddElementShape(CosElement);
% Circular Piston Element
CircElement.type = 'CircularPistonElement';
CircElement.baffle = 1;
CircElement.a = d/2;
CircElement = AddElementShape(CircElement);
% Rectangular Piston Element
RectElement.type = 'RectangularPistonElement';
RectElement.baffle = 1;
RectElement.w = d;
RectElement.h = d/2;
RectElement = AddElementShape(RectElement);
% Annular Piston Element
AnnElement.type = 'AnnularPistonElement';
AnnElement.baffle = 1;
AnnElement.a = d/2;
AnnElement.b = 3/8*d;
AnnElement = AddElementShape(AnnElement);
% Hexagonal Piston Element
HexElement.type = 'HexagonalPistonElement';
HexElement.baffle = 1;
HexElement.a = d/2;
HexElement = AddElementShape(HexElement);
%% Setup Single Element Array
Array.Ne = 1;
Array.ex = 0;
Array.ey = 0;
Array.ez = 0;
Array.egamma = 0;
Array.etheta = 0;
Array.epsi = 0;
Array.ax = 0;
Array.ay = 0;
Array.az = 0;
%% Generate Element Patterns
% Omnidirectional Element
OmniBeam.ew = 1;
OmniBeam.psi = psi;
OmniBeam.theta = theta;
OmniBeam.lambda = lambda;
OmniBeam.BP = BeamPattern(Array,OmniElement,OmniBeam,lambda,psi,theta);
% Linear Element
LineBeam.ew = 1;
LineBeam.psi = psi;
LineBeam.theta = theta;
LineBeam.lambda = lambda;
LineBeam.BP = BeamPattern(Array,LineElement,LineBeam,lambda,psi,theta);
% Cosine Element
CosBeam.ew = 1;
CosBeam.psi = psi;
CosBeam.theta = theta;
CosBeam.lambda = lambda;
CosBeam.BP = BeamPattern(Array,CosElement,CosBeam,lambda,psi,theta);
% Circular Piston Element
CircBeam.ew = 1;
CircBeam.psi = psi;
CircBeam.theta = theta;
CircBeam.lambda = lambda;
CircBeam.BP = BeamPattern(Array,CircElement,CircBeam,lambda,psi,theta);
% Rectangular Piston Element
RectBeam.ew = 1;
RectBeam.psi = psi;
RectBeam.theta = theta;
RectBeam.lambda = lambda;
RectBeam.BP = BeamPattern(Array,RectElement,RectBeam,lambda,psi,theta);
% Annular Piston Element
AnnBeam.ew = 1;
AnnBeam.psi = psi;
AnnBeam.theta = theta;
AnnBeam.lambda = lambda;
AnnBeam.BP = BeamPattern(Array,AnnElement,AnnBeam,lambda,psi,theta);
% Hexagonal Piston Element
HexBeam.ew = 1;
HexBeam.psi = psi;
HexBeam.theta = theta;
HexBeam.lambda = lambda;
HexBeam.BP = BeamPattern(Array,HexElement,HexBeam,lambda,psi,theta);
%% Plot Element Patterns
figure
set(gcf,'Position',pos)
% Omnidirectional Element
subplot(2,3,1)
PlotArray(Array,OmniElement,OmniBeam,gca,1)
Plot3DBP(psi,theta,OmniBeam.BP,[],[],gca,Array.ax,Array.ay,Array.az)
title('Omnidirectional')
% Linear Element
subplot(2,3,2)
PlotArray(Array,LineElement,LineBeam,gca,1)
Plot3DBP(psi,theta,LineBeam.BP,[],[],gca,Array.ax,Array.ay,Array.az)
title('Uniform Line')
% Cosine Element
subplot(2,3,3)
PlotArray(Array,CosElement,CosBeam,gca,1)
Plot3DBP(psi,theta,CosBeam.BP,[],[],gca,Array.ax,Array.ay,Array.az)
title('Cosine')
% Circular Piston Element
subplot(2,4,5)
PlotArray(Array,CircElement,CircBeam,gca,1)
Plot3DBP(psi,theta,CircBeam.BP,[],[],gca,Array.ax,Array.ay,Array.az)
title('Circular Piston')
% Rectangular Piston Element
subplot(2,4,6)
PlotArray(Array,RectElement,RectBeam,gca,1)
Plot3DBP(psi,theta,RectBeam.BP,[],[],gca,Array.ax,Array.ay,Array.az)
title('Rectangular Piston')
% Annular Piston Element
subplot(2,4,7)
PlotArray(Array,AnnElement,AnnBeam,gca,1)
Plot3DBP(psi,theta,AnnBeam.BP,[],[],gca,Array.ax,Array.ay,Array.az)
title('Annular Piston')
% Hexagonal Piston Element
subplot(2,4,8)
PlotArray(Array,HexElement,HexBeam,gca,1)
Plot3DBP(psi,theta,HexBeam.BP,[],[],gca,Array.ax,Array.ay,Array.az)
title('Hexagonal Piston')
%% Save Plot
orient(gcf,'landscape')
set(gcf,'Renderer','Painters','PaperPositionMode','auto')
try
    print(gcf,'-dpng', 'ElementPatterns.png')
catch me
    disp('Unable to save ElementPatterns.png, check write status.')
end