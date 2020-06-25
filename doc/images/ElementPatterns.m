%% Setup Path
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
OmniElement.type = 0;
OmniElement.baffle = 0;
OmniElement = AddElementShape(OmniElement);
% Cosine Element
CosElement.type = 1;
CosElement.baffle = 0;
CosElement = AddElementShape(CosElement);
% Linear Element
LineElement.type = 2;
LineElement.baffle = 0;
LineElement.L = d;
LineElement.axis = 1;
LineElement = AddElementShape(LineElement);
% Circular Piston Element
CircElement.type = 3;
CircElement.baffle = 1;
CircElement.a = d/2;
CircElement = AddElementShape(CircElement);
% Rectangular Piston Element
RectElement.type = 4;
RectElement.baffle = 1;
RectElement.w = d;
RectElement.h = d/2;
RectElement = AddElementShape(RectElement);
% Hexagonal Piston Element
HexElement.type = 5;
HexElement.baffle = 1;
HexElement.a = d/2;
HexElement = AddElementShape(HexElement);
% Annular Piston Element
AnnElement.type = 6;
AnnElement.baffle = 1;
AnnElement.a = d/2;
AnnElement.b = 3/8*d;
AnnElement = AddElementShape(AnnElement);
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
OmniBeam.BP = BeamPattern(Array,OmniElement,OmniBeam,lambda,theta,psi);
% Cosine Element
CosBeam.ew = 1;
CosBeam.psi = psi;
CosBeam.theta = theta;
CosBeam.lambda = lambda;
CosBeam.BP = BeamPattern(Array,CosElement,CosBeam,lambda,theta,psi);
% Linear Element
LineBeam.ew = 1;
LineBeam.psi = psi;
LineBeam.theta = theta;
LineBeam.lambda = lambda;
LineBeam.BP = BeamPattern(Array,LineElement,LineBeam,lambda,theta,psi);
% Circular Piston Element
CircBeam.ew = 1;
CircBeam.psi = psi;
CircBeam.theta = theta;
CircBeam.lambda = lambda;
CircBeam.BP = BeamPattern(Array,CircElement,CircBeam,lambda,theta,psi);
% Rectangular Piston Element
RectBeam.ew = 1;
RectBeam.psi = psi;
RectBeam.theta = theta;
RectBeam.lambda = lambda;
RectBeam.BP = BeamPattern(Array,RectElement,RectBeam,lambda,theta,psi);
% Hexagonal Piston Element
HexBeam.ew = 1;
HexBeam.psi = psi;
HexBeam.theta = theta;
HexBeam.lambda = lambda;
HexBeam.BP = BeamPattern(Array,HexElement,HexBeam,lambda,theta,psi);
% Annular Piston Element
AnnBeam.ew = 1;
AnnBeam.psi = psi;
AnnBeam.theta = theta;
AnnBeam.lambda = lambda;
AnnBeam.BP = BeamPattern(Array,AnnElement,AnnBeam,lambda,theta,psi);
%% Plot Element Patterns
figure
set(gcf,'Position',pos)
% Omnidirectional Element
subplot(2,3,1)
PlotArray(Array,OmniElement,OmniBeam,gca,1)
Plot3DBP(theta,psi,OmniBeam.BP,[],[],gca,Array.ax,Array.ay,Array.az)
title('Omnidirectional')
% Cosine Element
subplot(2,3,2)
PlotArray(Array,CosElement,CosBeam,gca,1)
Plot3DBP(theta,psi,CosBeam.BP,[],[],gca,Array.ax,Array.ay,Array.az)
title('Cosine')
% Linear Element
subplot(2,3,3)
PlotArray(Array,LineElement,LineBeam,gca,1)
Plot3DBP(theta,psi,LineBeam.BP,[],[],gca,Array.ax,Array.ay,Array.az)
title('Uniform Line')
% Circular Piston Element
subplot(2,4,5)
PlotArray(Array,CircElement,CircBeam,gca,1)
Plot3DBP(theta,psi,CircBeam.BP,[],[],gca,Array.ax,Array.ay,Array.az)
title('Circular Piston')
% Rectangular Piston Element
subplot(2,4,6)
PlotArray(Array,RectElement,RectBeam,gca,1)
Plot3DBP(theta,psi,RectBeam.BP,[],[],gca,Array.ax,Array.ay,Array.az)
title('Rectangular Piston')
% Hexagonal Piston Element
subplot(2,4,7)
PlotArray(Array,HexElement,HexBeam,gca,1)
Plot3DBP(theta,psi,HexBeam.BP,[],[],gca,Array.ax,Array.ay,Array.az)
title('Hexagonal Piston')
% Annular Piston Element
subplot(2,4,8)
PlotArray(Array,AnnElement,AnnBeam,gca,1)
Plot3DBP(theta,psi,AnnBeam.BP,[],[],gca,Array.ax,Array.ay,Array.az)
title('Annular Piston')
%% Save Plot
orient(gcf,'landscape')
set(gcf,'Renderer','zbuffer','PaperPositionMode','auto')
try
    print(gcf,'-dpng', 'ElementPatterns.png')
catch me
    disp('Unable to save ElementPatterns.png, check write status.')
end