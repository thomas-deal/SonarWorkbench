function PlotArray(Array,Element,varargin)
%% function PlotArray(Array,Element)
% function PlotArray(Array,Element,Beam)
% function PlotArray(Array,Element,Beam,hax)
% function PlotArray(Array,Element,Beam,hax,actualsize)
%
% Plots the physical layout of an array, including amplitude shading if a
% Beam is defined.
%
% Inputs:
%           Array       - Array structure with the following fields
%               [required]
%               .Ne     - Number of elements
%               .ex     - Element x position vector, m
%               .ey     - Element y position vector, m
%               .ez     - Element z position vector, m
%               .egamma - Element normal roll vector, deg
%               .etheta - Element normal elevation vector, deg
%               .epsi   - Element normal azimuth vector, deg
%               [optional]
%               .ax     - Array x position, m
%               .ay     - Array y position, m
%               .az     - Array z position, m
%               .eindex - Vector of indices into element structure vector
%                         to support non-uniform element arrays
%           Element     - Element structure vector with the following 
%                         required fields
%               .shapex - Element shape x coordinates, m
%               .shapey - Element shape y coordinates, m
%               .shapez - Element shape z coordinates, m
%
% Optional Inputs:
%           Beam        - Beam structure with the following required fields
%               .ew     - Complex element weight vector
%           hax         - Handle to axis for plotting in an existing figure
%           actualsize  - Plot array elements without scaling
%

%% Check Input Arguments
Beam = [];
hax = [];
actualsize = 0;
ax = 0;
ay = 0;
az = 0;
switch nargin
    case 3
        Beam = varargin{1};
    case 4
        Beam = varargin{1};
        hax = varargin{2};
    case 5
        Beam = varargin{1};
        hax = varargin{2};
        if ~isempty(varargin{3})
            actualsize = varargin{3};
        end
end
if isempty(Beam)||~isfield(Beam,'ew')
    ew = 0.5*ones(Array.Ne,1);
else
    ew = Beam.ew;
end
if isfield(Array,'ax')
    ax = Array.ax;
end
if isfield(Array,'ay')
    ay = Array.ay;
end
if isfield(Array,'az')
    az = Array.az;
end
%% Support for Non-Uniform Arrays
eindex = 1;
if isfield(Array,'eindex')
	if ~isempty(Array.eindex)
		eindex = Array.eindex;
	end
end
if length(eindex)==1
	eindex = eindex*ones(Array.Ne,1);
end
if max(eindex) > length(Element.type)
	disp('PlotArray: Not enough elements defined for non-uniform array, reverting to uniform array of type Element(1)')
	eindex = ones(Array.Ne,1);
end
%% Plot Array
if ~isempty(hax)
    axes(hax)
else
    figure
end
hax = gca;
hold on
if actualsize
    R = 1;
else
    R = 1.5*max(sqrt(Array.ex.^2+Array.ey.^2+Array.ez.^2));
    if R==0 % Single-element or co-located elements
		for i=1:Array.Ne
			R = max(R,max(sqrt(Element.shapex{eindex(i)}.^2+Element.shapey{eindex(i)}.^2+Element.shapez{eindex(i)}.^2)));
		end
    end
end
PlotNEDaxes(ax,ay,az,hax)
for i=1:Array.Ne
    % Rotate Element Shape
    ROT = RotationMatrix(Array.egamma(i),Array.etheta(i),Array.epsi(i));
    shapex = ROT(1,1)*Element.shapex{eindex(i)} + ROT(1,2)*Element.shapey{eindex(i)} + ROT(1,3)*Element.shapez{eindex(i)};
    shapey = ROT(2,1)*Element.shapex{eindex(i)} + ROT(2,2)*Element.shapey{eindex(i)} + ROT(2,3)*Element.shapez{eindex(i)};
    shapez = ROT(3,1)*Element.shapex{eindex(i)} + ROT(3,2)*Element.shapey{eindex(i)} + ROT(3,3)*Element.shapez{eindex(i)};
    % Plot Element with Amplitude Weight and Element Number
    patch(ax+Array.ex(i)/R+shapex/R,ay+Array.ey(i)/R+shapey/R,az+Array.ez(i)/R+shapez/R,[0.5 0.5 1],'FaceVertexCData',repmat([0.5 0.5 1],length(shapex),1),'FaceAlpha',abs(ew(i)))    
    plot3(ax+Array.ex(i)/R+shapex/R,ay+Array.ey(i)/R+shapey/R,az+Array.ez(i)/R+shapez/R,'k')
    if isfield(Array,'etxt')
        etxt = Array.etxt{i};
    else
        etxt = num2str(i);
    end
    text(ax+Array.ex(i)/R,ay+Array.ey(i)/R,az+Array.ez(i)/R,etxt,'horizontalalignment','center','verticalalignment','middle')
end
hold off
set(gca,'YDir','reverse','ZDir','reverse')
axis equal
axis off
view([60 15])
    