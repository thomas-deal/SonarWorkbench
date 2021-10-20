function PlotArray(Array,varargin)
%% function PlotArray(Array)
% function PlotArray(Array,Beam)
% function PlotArray(Array,Beam,hax)
% function PlotArray(Array,Beam,hax,actualsize)
%
% Plots the physical layout of an array, including amplitude shading if a
% Beam is defined.
%
% Inputs:
%           Array       - Array structure with the following fields
%           [required ]
%               .Ne         - Number of elements
%               .Net        - Numer of unique element types
%               .Element    - Array of length .Net element structures 
%                             with the following fields
%                 .type       - Element pattern generator enumeration
%                 .params_m   - Element shape parameter vector, see element
%                               pattern files for details
%               .ex_m       - Element x position vector, m
%               .ey_m       - Element y position vector, m
%               .ez_m       - Element z position vector, m
%               .egamma_deg - Element normal azimuth vector, deg
%               .etheta_deg - Element normal elevation vector, deg
%               .epsi_deg   - Element normal azimuth vector, deg
%           [optional ]
%               .ax_m       - Array x position, m
%               .ay_m       - Array y position, m
%               .az_m       - Array z position, m
%               .eindex     - Vector of indices into element structure 
%                             vector to support non-uniform element arrays
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
    case 2
        Beam = varargin{1};
    case 3
        Beam = varargin{1};
        hax = varargin{2};
    case 4
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
if isfield(Array,'ax_m')
    ax = Array.ax_m;
end
if isfield(Array,'ay_m')
    ay = Array.ay_m;
end
if isfield(Array,'az_m')
    az = Array.az_m;
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
if max(eindex) > length(Array.Element)
	disp('PlotArray: Not enough elements defined for non-uniform array, reverting to uniform array of type Array.Element(1)')
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
    R = 1.5*max(sqrt(Array.ex_m.^2+Array.ey_m.^2+Array.ez_m.^2));
    if R==0 % Single-element or co-located elements
		for i=1:Array.Ne
            [shapex, shapey, shapez] = ElementShape(Array.Element(eindex(i)));
			R = max(R,max(sqrt(shapex.^2+shapey.^2+shapez.^2)));
		end
    end
end
PlotNEDaxes(ax,ay,az,hax)
for i=1:Array.Ne
    % Rotate Element Shape
    [shapex0, shapey0, shapez0] = ElementShape(Array.Element(eindex(i)));
    ROT = RotationMatrix(Array.egamma_deg(i),Array.etheta_deg(i),Array.epsi_deg(i));
    shapex = ROT(1,1)*shapex0 + ROT(1,2)*shapey0 + ROT(1,3)*shapez0;
    shapey = ROT(2,1)*shapex0 + ROT(2,2)*shapey0 + ROT(2,3)*shapez0;
    shapez = ROT(3,1)*shapex0 + ROT(3,2)*shapey0 + ROT(3,3)*shapez0;
    % Plot Element with Amplitude Weight and Element Number
    patch(ax+Array.ex_m(i)/R+shapex/R,ay+Array.ey_m(i)/R+shapey/R,az+Array.ez_m(i)/R+shapez/R,[0.5 0.5 1],'FaceVertexCData',repmat([0.5 0.5 1],length(shapex),1),'FaceAlpha',abs(ew(i)))    
    plot3(ax+Array.ex_m(i)/R+shapex/R,ay+Array.ey_m(i)/R+shapey/R,az+Array.ez_m(i)/R+shapez/R,'k')
    if isfield(Array,'etxt')
        etxt = Array.etxt{i};
    else
        etxt = num2str(i);
    end
    text(ax+Array.ex_m(i)/R,ay+Array.ey_m(i)/R,az+Array.ez_m(i)/R,etxt,'horizontalalignment','center','verticalalignment','middle')
end
hold off
set(gca,'YDir','reverse','ZDir','reverse')
axis equal
axis off
view([60 15])
    