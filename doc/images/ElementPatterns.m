%% Setup Path
addpath(fullfile('..','..','mdl'))
addpath(fullfile('..','..','resources','Utilities'))
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
% Cosine Element
CosElement.type = 1;
CosElement.baffle = 0;
% Linear Element
LineElement.type = 2;
LineElement.baffle = 0;
LineElement.params_m = [0;d;0];
% Circular Piston Element
CircElement.type = 3;
CircElement.baffle = 1;
CircElement.params_m = [d/2;0;0];
% Rectangular Piston Element
RectElement.type = 4;
RectElement.baffle = 1;
RectElement.params_m = [d;d/2;0];
% Hexagonal Piston Element
HexElement.type = 5;
HexElement.baffle = 1;
HexElement.params_m = [d/2;0;0];
% Annular Piston Element
AnnElement.type = 6;
AnnElement.baffle = 1;
AnnElement.params_m = [d/2;3/8*d;0];
%% Setup Single Element Array
Array.Ne = 1;
Array.Net = 1;
Array.ex_m = 0;
Array.ey_m = 0;
Array.ez_m = 0;
Array.egamma_deg = 0;
Array.etheta_deg = 0;
Array.epsi_deg = 0;
Array.ax_m = 0;
Array.ay_m = 0;
Array.az_m = 0;
%% Generate Element Patterns
% Omnidirectional Element
Array.Element = OmniElement;
OmniBeam.ew = 1;
OmniBeam.psi = psi;
OmniBeam.theta = theta;
OmniBeam.lambda = lambda;
OmniBeam.BP = BeamPattern(Array,OmniBeam,lambda,theta,psi);
% Cosine Element
Array.Element = CosElement;
CosBeam.ew = 1;
CosBeam.psi = psi;
CosBeam.theta = theta;
CosBeam.lambda = lambda;
CosBeam.BP = BeamPattern(Array,CosBeam,lambda,theta,psi);
% Linear Element
Array.Element = LineElement;
LineBeam.ew = 1;
LineBeam.psi = psi;
LineBeam.theta = theta;
LineBeam.lambda = lambda;
LineBeam.BP = BeamPattern(Array,LineBeam,lambda,theta,psi);
% Circular Piston Element
Array.Element = CircElement;
CircBeam.ew = 1;
CircBeam.psi = psi;
CircBeam.theta = theta;
CircBeam.lambda = lambda;
CircBeam.BP = BeamPattern(Array,CircBeam,lambda,theta,psi);
% Rectangular Piston Element
Array.Element = RectElement;
RectBeam.ew = 1;
RectBeam.psi = psi;
RectBeam.theta = theta;
RectBeam.lambda = lambda;
RectBeam.BP = BeamPattern(Array,RectBeam,lambda,theta,psi);
% Hexagonal Piston Element
Array.Element = HexElement;
HexBeam.ew = 1;
HexBeam.psi = psi;
HexBeam.theta = theta;
HexBeam.lambda = lambda;
HexBeam.BP = BeamPattern(Array,HexBeam,lambda,theta,psi);
% Annular Piston Element
Array.Element = AnnElement;
AnnBeam.ew = 1;
AnnBeam.psi = psi;
AnnBeam.theta = theta;
AnnBeam.lambda = lambda;
AnnBeam.BP = BeamPattern(Array,AnnBeam,lambda,theta,psi);
%% Plot Element Patterns
figure
set(gcf,'Position',pos)
% Omnidirectional Element
subplot(2,3,1)
Array.Element = OmniElement;
PlotArray(Array,OmniBeam,gca,1)
Plot3DBP(theta,psi,OmniBeam.BP,[],[],gca,Array.ax_m,Array.ay_m,Array.az_m)
title('Omnidirectional')
% Cosine Element
Array.Element = CosElement;
subplot(2,3,2)
PlotArray(Array,CosBeam,gca,1)
Plot3DBP(theta,psi,CosBeam.BP,[],[],gca,Array.ax_m,Array.ay_m,Array.az_m)
title('Cosine')
% Linear Element
Array.Element = LineElement;
subplot(2,3,3)
PlotArray(Array,LineBeam,gca,1)
Plot3DBP(theta,psi,LineBeam.BP,[],[],gca,Array.ax_m,Array.ay_m,Array.az_m)
title('Uniform Line')
% Circular Piston Element
Array.Element = CircElement;
subplot(2,4,5)
PlotArray(Array,CircBeam,gca,1)
Plot3DBP(theta,psi,CircBeam.BP,[],[],gca,Array.ax_m,Array.ay_m,Array.az_m)
title('Circular Piston')
% Rectangular Piston Element
Array.Element = RectElement;
subplot(2,4,6)
PlotArray(Array,RectBeam,gca,1)
Plot3DBP(theta,psi,RectBeam.BP,[],[],gca,Array.ax_m,Array.ay_m,Array.az_m)
title('Rectangular Piston')
% Hexagonal Piston Element
Array.Element = HexElement;
subplot(2,4,7)
PlotArray(Array,HexBeam,gca,1)
Plot3DBP(theta,psi,HexBeam.BP,[],[],gca,Array.ax_m,Array.ay_m,Array.az_m)
title('Hexagonal Piston')
% Annular Piston Element
Array.Element = AnnElement;
subplot(2,4,8)
PlotArray(Array,AnnBeam,gca,1)
Plot3DBP(theta,psi,AnnBeam.BP,[],[],gca,Array.ax_m,Array.ay_m,Array.az_m)
title('Annular Piston')
colormap inferno
%% Save Plot
orient(gcf,'landscape')
set(gcf,'Renderer','zbuffer','PaperPositionMode','auto')
try
    print(gcf,'-dpng', 'ElementPatterns.png')
catch me
    disp('Unable to save ElementPatterns.png, check write status.')
end
