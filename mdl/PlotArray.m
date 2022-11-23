function PlotArray(Array,varargin)
%% function PlotArray(Array)
% function PlotArray(Array,Beam)
% function PlotArray(Array,Beam,hax)
% function PlotArray(Array,Beam,hax,actualsize)
% function PlotArray(Array,Beam,hax,actualsize,color)
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
%               .aPos_m     - Array position vector, m
%               .aOri_deg   - Array orientation vector, deg
%           [optional ]
%               .eindex     - Vector of indices into element structure 
%                             vector to support non-uniform element arrays
%
% Optional Inputs:
%           Beam        - Beam structure with the following required fields
%               .ew     - Complex element weight vector
%           hax         - Handle to axis for plotting in an existing figure
%           actualsize  - Plot array elements without scaling
%           color       - RGB triple with elements in [0,1]
%

%% Check Input Arguments
Beam = [];
hax = [];
actualsize = 0;
color = [0.5 0.5 1];
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
    case 5
        Beam = varargin{1};
        hax = varargin{2};
        if ~isempty(varargin{3})
            actualsize = varargin{3};
        end
        if ~isempty(varargin{4})
            tmp = varargin{4};
            if length(tmp) == 3
                color = tmp(:)';
            end 
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
        if R==0
            R = 1;
        end
    end
end
if any(Array.aPos_m~=0) || any(Array.aOri_deg~=0)
    % Earth frame
    PlotNEDaxes([0;0;0],[0;0;0],hax)
end
% Array frame
PlotNEDaxes(Array.aPos_m,Array.aOri_deg,hax)
AROT = RotationMatrix(Array.aOri_deg);
for i=1:Array.Ne
    % Element position
    ePos = Array.aPos_m + AROT*Array.ePos_m(:,i)/R;
    if Array.Element(eindex(i)).type < 2
        % Monopole or dipole
        theta = -90:90;
        psi = -180:180;
        theta0 = Array.eOri_deg(2,i);
        psi0 = Array.eOri_deg(3,i);
        LOS0 = [cosd(psi0).*cosd(-theta0); ...
                sind(psi0).*cosd(-theta0); ...
                sind(-theta0)];
        LOS = AROT*LOS0;
        theta0 = -asind(LOS(3,:));
        psi0 = atan2d(LOS(2,:),LOS(1,:));
        EP = ElementPattern(Array.Element(eindex(i)), ...
                            1, ...
                            theta, ...
                            psi, ...
                            [0;theta0;psi0]);
        [Theta,Psi] = ndgrid(theta,psi);
        dBScale = [-6 0];
        EPdB = 10*log10(EP.*conj(EP));
        EPdB(EPdB<dBScale(1)) = dBScale(1);
        EPdB(EPdB>dBScale(2)) = dBScale(2);
        EPdB = EPdB - dBScale(1);
        ux = cosd(-Theta).*cosd(Psi);
        uy = cosd(-Theta).*sind(Psi);
        uz = sind(-Theta);
        Esize = 0.1;
        if Array.Element(eindex(i)).params_m(1) > 0
            Esize = Array.Element(eindex(i)).params_m(1)/R;
        end
        EPX = Esize*EPdB/diff(dBScale).*ux;
        EPY = Esize*EPdB/diff(dBScale).*uy;
        EPZ = Esize*EPdB/diff(dBScale).*uz;
        CData = zeros(length(theta),length(psi),3);
        if Array.Element(eindex(i)).type == 1
            % Dipole orientation: + => red, - => blue
            CData(:,:,1) = sign(max(EP,0));
            CData(:,:,3) = -sign(min(EP,0)); 
            CData(CData == 0) = 0.4;
        else
            for j = 1:3
                CData(:,:,j) = color(j);
            end
        end
        hp = surf(ePos(1)+EPX,ePos(2)+EPY,ePos(3)+EPZ,CData);
        set(hp,'FaceAlpha',abs(ew(i)));
        shading interp
    else
        % Rotate element shape
        EROT = RotationMatrix(Array.eOri_deg(:,i));
        shape = Array.aPos_m + ...
                AROT*(Array.ePos_m(:,i) + ...
                      EROT*ElementShape(Array.Element(eindex(i))))/R;
        % Plot element with amplitude weight and element number
        patch(shape(1,:), ...
              shape(2,:), ...
              shape(3,:), ...
              color, ...
              'FaceVertexCData',repmat(color,size(shape,2),1), ...
              'FaceAlpha',abs(ew(i)))    
        plot3(shape(1,:), ...
              shape(2,:), ...
              shape(3,:), ...
              'k')
    end
    if isfield(Array,'etxt')
        etxt = Array.etxt{i};
    else
        etxt = num2str(i);
    end
    text(ePos(1),ePos(2),ePos(3), ...
         etxt, ...
         'horizontalalignment','center', ...
         'verticalalignment','middle')
end
hold off
set(gca,'YDir','reverse','ZDir','reverse')
axis equal
axis off
view([60 15])
    