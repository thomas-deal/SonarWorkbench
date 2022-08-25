%% Setup Path
addpath(fullfile('..','..','mdl'))
addpath(fullfile('..','..','test'))
addpath(fullfile('..','..','resources','Utilities'))
%% Plot Settings
pos = [0 0 1000 600];
LineWidth = 2;
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
Beam.BP = BeamPattern(Array,Beam,lambda,theta,psi);
%% 3D Plot
figure
subplot(1,2,1)
PlotArray(Array,Beam,gca)
Plot3DBP(theta,psi,Beam.BP,1,[],gca)
set(gca,'SortMethod','ChildOrder')
subplot(1,2,2)
PlotArray(Array,Beam,gca)
Plot3DBP(theta,psi,Beam.BP,2,[],gca)
set(gca,'SortMethod','ChildOrder')
%% Finish 3D Plot
colormap inferno
set(gcf,'Position',pos)
%% Save 3D Plot
set(gcf,'Renderer','zbuffer','PaperPositionMode','auto')
try
    print(gcf,'-dpng','SampleBeam.png')
catch me
    disp('Unable to save SampleBeam.png, check write status.')
end
%% 2D Plots
figure
hax = zeros(1,4);
h = zeros(1,4);
for i=1:4
    if i > 2
        % Vertical slice
        SliceOri = [-90;0;0];
    else
        % Horizontal slice
        SliceOri = [0;0;0];
    end
    [BPslice,phi] = ExtractBeamSlice(theta,psi,Beam.BP,SliceOri);
    hax(i) = subplot(2,2,i);
    h(i) = Plot2DBP(phi,BPslice,i,[],hax(i));
    set(h(i),'LineWidth',LineWidth);
    title(['PlotType = ' num2str(i)])
end
%% Finish 2D Plot
set(hax(1),'XLim',[-90 90]);
set(hax(1),'XTick',-90:15:90);
set(hax(3),'YLim',[-90 90]);
set(hax(3),'YTick',-90:15:90);
set(gcf,'Position',[0 0 1200 800])
%% Save 2D Plot
set(gcf,'Renderer','painters','PaperPositionMode','auto')
try
    print(gcf,'-depsc2','Plot2DBPexamples.eps')
catch me
    disp('Unable to save Plot2DBPexamples.eps, check write status.')
end
