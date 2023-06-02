function h = Plot2DBP(phi,BP,varargin)
%% function h = Plot2DBP(phi,BP)
% function h = Plot2DBP(phi,BP,PlotType)
% function h = Plot2DBP(phi,BP,PlotType,dBScale)
% function h = Plot2DBP(phi,BP,PlotType,dBScale,hax)
%
% Plots a 2D beam. Beam pattern is defined over angles phi. User can choose
% to plot in a new figure or in an existing axis. Optionally returns a
% handle to the plot to allow the user to change line properties such as
% color, width, and marker.
%
% Inputs:
%           phi      - Angle vector, deg
%           BP       - Beam pattern vector, complex linear units
%
% Optional Inputs:
%           PlotType - Plot type enumeration
%                      1 = Rectangular plot, phi = x axis
%                      2 = Polar plot, phi = 0 north, CW+
%                      3 = Rectangular plot, phi = y axis
%                      4 = Polar plot, phi = 0 east, CCW+
%           dBScale  - Magnitude range for plot, [dBmin, dBmax], dB
%           hax      - Handle to axis for plotting in an existing figure
%
% Optional Outputs:
%           h        - Handle to plot
%

%% Check Input Arguments
PlotType = 1;
dBScale = [-40 0];
hax = [];
switch nargin
    case 3
        if ~isempty(varargin{1})
            PlotType = varargin{1};
        end
    case 4
        if ~isempty(varargin{1})
            PlotType = varargin{1};
        end
        if ~isempty(varargin{2})
            dBScale = varargin{2};
        end
    case 5
        if ~isempty(varargin{1})
            PlotType = varargin{1};
        end
        if ~isempty(varargin{2})
            dBScale = varargin{2};
        end
        if ~isempty(varargin{3})
            hax = varargin{3};
        end
end
%% Beam Pattern Magnitude
BPdB = 10*log10(BP.*conj(BP));
BPdB(BPdB<dBScale(1)) = dBScale(1);
BPdB(BPdB>dBScale(2)) = dBScale(2);
%% Polar Plot Scaling
if PlotType == 2 || PlotType == 4
    % Polar to Cartesian
    BPdB = BPdB - dBScale(1);
    x = BPdB.*cosd(phi);
    y = BPdB.*sind(phi);
    % Grid scaling
    R = diff(dBScale);
    if R >= 20
        dr = 5;
        dtxt = 0.5;
        dtick = 1;
    else
        dr = max(1,round(R/5));
        dtxt = max(0.1,R/50);
        dtick = max(0.1,R/20);
    end
    rmin = R + dBScale(1) + dr;
    rmax = R + dBScale(2);
    % Axis padding
    axpad = R + dr;
end
%% Plot Pattern
if ~isempty(hax)
    axes(hax)
else
    figure
end
co = get(gca,'ColorOrderIndex');
drawgrid = true;
if ishold(gca)
    drawgrid = false;
end
hold on
switch PlotType
    case 1      % Rectangular plot, phi = x axis
        hp = plot(phi,BPdB);
        ylim(dBScale)
        grid on
    case 2      % Polar plot, phi 0 north, CW+     
        % Plot grid
        if drawgrid
            axis off
            axis equal   
            patch(R*sind(0:360),R*cosd(0:360),[1 1 1])
            plot(R*sind(0:360),R*cosd(0:360),'k')
            for ph = 0:15:350
                plot([rmin rmax]*sind(ph),[rmin rmax]*cosd(ph),'k:')
                plot((rmax+[0 -dtick])*sind(ph), ...
                     (rmax+[0 -dtick])*cosd(ph),'k')
                text((rmax+dtxt)*sind(ph),(rmax+dtxt)*cosd(ph), ...
                     num2str(wrap180(ph)), ...
                     'Rotation',-ph, ...
                     'HorizontalAlignment','center', ...
                     'VerticalAlignment','bottom')
            end
            for r = rmin:dr:rmax-dr
                plot(r*sind(0:360),r*cosd(0:360),'k:')
                text(0,r,[num2str(dBScale(1)+r) ' '], ...
                     'HorizontalAlignment','right', ...
                     'VerticalAlignment','bottom')
            end
            plot(-axpad,-axpad,'LineStyle','none','marker','none')
            plot(axpad,axpad,'LineStyle','none','marker','none')
        end
        % Plot data
        set(gca,'ColorOrderIndex',co)
        hp = plot(y,x);
    case 3      % Rectangular plot, phi = y axis
        hp = plot(BPdB,phi);
        xlim(dBScale)
        grid on
    case 4      % Polar plot, phi 0 east, CCW+
        % Plot grid
        if drawgrid
            axis off
            axis equal   
            rmin = R + dBScale(1) + dr;
            rmax = R + dBScale(2);
            patch(R*cosd(0:360),R*sind(0:360),[1 1 1])
            plot(R*cosd(0:360),R*sind(0:360),'k')
            for ph = 0:15:350
                plot([rmin rmax]*cosd(ph),[rmin rmax]*sind(ph),'k:')
                plot((rmax+[0 -dtick])*cosd(ph), ...
                     (rmax+[0 -dtick])*sind(ph),'k')
                text((rmax+dtxt)*cosd(ph),(rmax+dtxt)*sind(ph), ...
                     num2str(wrap180(ph)), ...
                     'Rotation',ph-90, ...
                     'HorizontalAlignment','center', ...
                     'VerticalAlignment','bottom')
            end
            for r = rmin:dr:rmax-dr
                plot(r*cosd(0:360),r*sind(0:360),'k:')
                text(r,0,num2str(dBScale(1)+r), ...
                     'HorizontalAlignment','center', ...
                     'VerticalAlignment','top')
            end
            plot(-axpad,-axpad,'LineStyle','none','marker','none')
            plot(axpad,axpad,'LineStyle','none','marker','none')
        end
        % Plot data
        set(gca,'ColorOrderIndex',co)
        hp = plot(x,y);
end
hold off
%% Check Output Arguments
if nargout == 1
    h = hp;
end
        