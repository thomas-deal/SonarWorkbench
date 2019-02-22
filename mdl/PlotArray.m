function PlotArray(Array,Element,varargin)
%% function PlotArray(Array,Element)
% function PlotArray(Array,Element,Beam)
% function PlotArray(Array,Element,Beam,hax)
%
% Plots the physical layout of an array, including amplitude shading if a
% Beam is defined.
%
% Inputs:
%           Array   - Array structure with the following required fields
%               .ex     - Element x position vector, m
%               .ey     - Element y position vector, m
%               .ez     - Element z position vector, m
%               .epsi   - Element normal azimuth vector, deg
%               .etheta - Element normal elevation vector, deg
%           Element - Element structure with the following required fields
%               .shapex - Element shape x coordinates, m
%               .shapey - Element shape y coordinates, m
%               .shapez - Element shape z coordinates, m
%
% Optional Inputs:
%           Beam        - Beam structure with the following required fields
%               .ew     - Complex element weight vector
%           hax         - Handle to axis for plotting in an existing figure
%

%% Check Input Arguments
Beam = [];
hax = [];
switch nargin
    case 3
        Beam = varargin{1};
    case 4
        Beam = varargin{1};
        hax = varargin{2};
end
if isempty(Beam)||~isfield(Beam,'ew')
    ew = 0.5*ones(Array.Ne,1);
else
    ew = Beam.ew;
end
%% Plot Array
if ~isempty(hax)
    axes(hax)
else
    figure
end
hold on
R = 1.5*max(sqrt(Array.ex.^2+Array.ey.^2+Array.ez.^2));
plot3([0 1],[0 0],[0 0],'k')
text(1.1,0,0,'x','horizontalalignment','center','verticalalignment','middle')
plot3([0 0],[0 1],[0 0],'k')
text(0,1.1,0,'y','horizontalalignment','center','verticalalignment','middle')
plot3([0 0],[0 0],[0 1],'k')
text(0,0,1.1,'z','horizontalalignment','center','verticalalignment','middle')
for i=1:Array.Ne
    % Rotate Element Shape
    ROT = [cosd(-Array.etheta(i)) 0 -sind(-Array.etheta(i)); ...
           0 1 0; ...
           sind(-Array.etheta(i)) 0 cosd(-Array.etheta(i))] * ...
          [cosd(-Array.epsi(i)) -sind(-Array.epsi(i)) 0; ...
           sind(-Array.epsi(i)) cosd(-Array.epsi(i)) 0; ...
           0 0 1];
    shapex = ROT(1,1)*Element.shapex + ROT(1,2)*Element.shapey + ROT(1,3)*Element.shapez;
    shapey = ROT(2,1)*Element.shapex + ROT(2,2)*Element.shapey + ROT(2,3)*Element.shapez;
    shapez = ROT(3,1)*Element.shapex + ROT(3,2)*Element.shapey + ROT(3,3)*Element.shapez;
    % Plot Element with Amplitude Weight and Element Number
    patch(Array.ex(i)/R+shapex/R,Array.ey(i)/R+shapey/R,Array.ez(i)/R+shapez/R,[0.5 0.5 1],'FaceVertexCData',repmat([0.5 0.5 1],length(shapex),1),'FaceAlpha',abs(ew(i)))    
    plot3(Array.ex(i)/R+shapex/R,Array.ey(i)/R+shapey/R,Array.ez(i)/R+shapez/R,'k')
    if isfield(Array,'etxt')
        etxt = Array.etxt{i};
    else
        etxt = num2str(i);
    end
    text(Array.ex(i)/R,Array.ey(i)/R,Array.ez(i)/R,etxt,'horizontalalignment','center','verticalalignment','middle')
end
hold off
set(gca,'YDir','reverse','ZDir','reverse')
axis equal
axis off
view([60 15])
    