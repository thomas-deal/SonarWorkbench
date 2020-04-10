function Plot3DBP(theta,psi,BP,varargin)
%% function Plot3DBP(theta,psi,BP)
% function Plot3DBP(theta,psi,BP,PlotType)
% function Plot3DBP(theta,psi,BP,PlotType,dBScale)
% function Plot3DBP(theta,psi,BP,PlotType,dBScale,hax)
% function Plot3DBP(theta,psi,BP,PlotType,dBScale,hax,ax,ay,az)
%
% Plots a beam pattern in 3D space. Beam pattern is defined over azimuthal
% angles psi and elevation angles theta. User can choose to plot in a new
% figure or in an existing axis.
%
% Inputs:
%           theta   - Elevation angle vector, deg
%           psi     - Azimuthal angle vector, deg
%           BP      - Beam pattern matrix with elevation angles in rows,
%                     azimuthal angles in columns, complex linear units
%
% Optional Inputs:
%           PlotType - Plot type enumeration
%                      1 = Plot beam dimensions in 3D
%                      2 = Plot beam magnitude on constant radius surface
%           dBScale  - Magnitude range for plot, [dBmin, dBmax], dB
%           hax      - Handle to axis for plotting in an existing figure
%           ax       - Array x position, m
%           ay       - Array y position, m
%           az       - Array z position, m
%

%% Check Input Arguments
PlotType = 1;
dBScale = [-40 0];
hax = [];
ax = 0;
ay = 0;
az = 0;
switch nargin
    case 4
        if ~isempty(varargin{1})
            PlotType = varargin{1};
        end
    case 5
        if ~isempty(varargin{1})
            PlotType = varargin{1};
        end
        if ~isempty(varargin{2})
            dBScale = varargin{2};
        end
    case 6
        if ~isempty(varargin{1})
            PlotType = varargin{1};
        end
        if ~isempty(varargin{2})
            dBScale = varargin{2};
        end
        if ~isempty(varargin{3})
            hax = varargin{3};
        end
    case 9
        if ~isempty(varargin{1})
            PlotType = varargin{1};
        end
        if ~isempty(varargin{2})
            dBScale = varargin{2};
        end
        if ~isempty(varargin{3})
            hax = varargin{3};
        end
        if ~isempty(varargin{4})&&~isempty(varargin{5})&&~isempty(varargin{6})
            ax = varargin{4};
            ay = varargin{5};
            az = varargin{6};
        end
end
%% Computational Grid
[Theta,Psi] = ndgrid(theta,psi);
%% Beam Pattern Magnitude
BPdB = 20*log10(abs(BP));
BPdB(BPdB<dBScale(1)) = dBScale(1);
BPdB(BPdB>dBScale(2)) = dBScale(2);
BPdB = BPdB - dBScale(1);
%% Convert Polar to Cartesian
ux = cosd(-Theta).*cosd(Psi);
uy = cosd(-Theta).*sind(Psi);
uz = sind(-Theta);
BPX = BPdB/diff(dBScale).*ux;
BPY = BPdB/diff(dBScale).*uy;
BPZ = BPdB/diff(dBScale).*uz;
%% Plot Pattern
if ~isempty(hax)
    axes(hax)
else
    figure
end
hold on
if PlotType==1
    hp = surf(ax+BPX,ay+BPY,az+BPZ);
else
    hp = surf(ax+ux,ay+uy,az+uz);
end
hold off
set(hp,'CData',BPdB+dBScale(1),'FaceAlpha',0.8);
shading interp
colorbar('location','southoutside','orientation','horizontal')
axis equal
axis off
colormap jet
caxis(dBScale)
set(gca,'zdir','reverse','ydir','reverse')
view([60 15])
        