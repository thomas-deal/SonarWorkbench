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
%               .ePos_m     - Element position matrix, m
%               .eOri_deg   - Element normal orientation matrix, deg
%           [optional ]
%               .aPos_m     - Array position vector, m
%               .aOri_deg   - Array orientation vector, deg
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
    ew = 0.5*ones(1,Array.Ne);
else
    ew = Beam.ew;
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
    R = 1.5*max(sqrt(sum(Array.ePos_m.^2,1)));
    if R==0 % Single-element or co-located elements
		for i=1:Array.Ne
            shape = ElementShape(Array.Element(eindex(i)));
			R = max(R,max(sqrt(sum(shape.^2,1))));
		end
    end
end
PlotNEDaxes(Array.aPos_m,hax)
for i=1:Array.Ne
    % Rotate Element Shape
    ROT = RotationMatrix(Array.eOri_deg(1,i), ...
                         Array.eOri_deg(2,i), ...
                         Array.eOri_deg(3,i));
    shape = ROT*ElementShape(Array.Element(eindex(i)));
    % Plot Element with Amplitude Weight and Element Number
    patch(Array.aPos_m(1)+Array.ePos_m(1,i)/R+shape(1,:)/R, ...
          Array.aPos_m(2)+Array.ePos_m(2,i)/R+shape(2,:)/R, ...
          Array.aPos_m(3)+Array.ePos_m(3,i)/R+shape(3,:)/R, ...
          [0.5 0.5 1], ...
          'FaceVertexCData',repmat([0.5 0.5 1],size(shape,2),1), ...
          'FaceAlpha',abs(ew(i)))    
    plot3(Array.aPos_m(1)+Array.ePos_m(1,i)/R+shape(1,:)/R, ...
          Array.aPos_m(2)+Array.ePos_m(2,i)/R+shape(2,:)/R, ...
          Array.aPos_m(3)+Array.ePos_m(3,i)/R+shape(3,:)/R, ...
          'k')
    if isfield(Array,'etxt')
        etxt = Array.etxt{i};
    else
        etxt = num2str(i);
    end
    text(Array.aPos_m(1)+Array.ePos_m(1,i)/R, ...
         Array.aPos_m(2)+Array.ePos_m(2,i)/R, ...
         Array.aPos_m(3)+Array.ePos_m(3,i)/R, ...
         etxt, ...
         'horizontalalignment','center', ...
         'verticalalignment','middle')
end
hold off
set(gca,'YDir','reverse','ZDir','reverse')
axis equal
axis off
view([60 15])
    