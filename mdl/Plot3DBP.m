function Plot3DBP(theta,psi,BP,varargin)
%% function Plot3DBP(theta,psi,BP)
% function Plot3DBP(theta,psi,BP,PlotType)
% function Plot3DBP(theta,psi,BP,PlotType,dBScale)
% function Plot3DBP(theta,psi,BP,PlotType,dBScale,hax)
% function Plot3DBP(theta,psi,BP,PlotType,dBScale,hax,aPos_m)
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
%           aPos_m   - Array position vector, m
%

%% Check Input Arguments
PlotType = 1;
dBScale = [-40 0];
hax = [];
aPos_m = [0;0;0];
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
    case 7
        if ~isempty(varargin{1})
            PlotType = varargin{1};
        end
        if ~isempty(varargin{2})
            dBScale = varargin{2};
        end
        if ~isempty(varargin{3})
            hax = varargin{3};
        end
        if ~isempty(varargin{4})
            aPos_m = varargin{4};
        end
end
%% Computational Grid
[Theta,Psi] = ndgrid(theta,psi);
%% Beam Pattern Magnitude
BPdB = 10*log10(BP.*conj(BP));
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
    hp = surf(aPos_m(1)+BPX,aPos_m(2)+BPY,aPos_m(3)+BPZ);
else
    hp = surf(aPos_m(1)+ux,aPos_m(2)+uy,aPos_m(3)+uz);
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
        