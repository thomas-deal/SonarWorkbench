function BP = BeamPattern(Array,Element,Beam,lambda,psi,theta)
%% function BP = BeamPattern(Array,Element,Beam,lambda,psi,theta)
%
% Computes the beam pattern for an array of elements at coordinates
% (ex,ey,ez) rotated (epsi,etheta) from the x axis with complex element
% weights ew at wavelength lambda over azimuthal angles psi and elevation
% angles theta. Supported element types are omnidirectional,
% linear, circular piston, rectangular piston, hexagonal piston, and annular
% piston. When element parameters are not specified, default values are
% used which assume half wavelength dimensions for all elements.
%
% Inputs:
%           Array   - Array structure with the following fields
%			[required]
%			.Ne	  - Number of elements
%               .ex     - Element x position vector, m
%               .ey     - Element y position vector, m
%               .ez     - Element z position vector, m
%               .egamma - Element normal azimuth vector, deg
%               .etheta - Element normal elevation vector, deg
%               .epsi   - Element normal azimuth vector, deg
%			[optional]
%			.eindex - Vector of indices into element structure vector
%				     to support non-uniform element arrays
%           Element - Element structure with the following fields
%               [required]
%               .type   - Element pattern generator string
%                         (name of .m file)
%               [optional]
%               .baffle - Element baffle enumeration
%                         0 = No baffle
%                         1 = Hard baffle
%                         2 = Raised cosine baffle
%               .L      - Linear element length, m
%               .axis   - Axis linear element is parallel to before
%                         rotation, 'x','y','z'
%               .a      - Circular piston radius, m
%               .w      - Rectangular piston width, m
%               .h      - Rectangular piston height, m
%               .a      - Hexagonal element inscribed circle radius, m
%			.a 	  - Annular element outer radius, m
%			.b      - Annular element inner radius, m
%           Beam        - Beam structure with the following required fields
%               .ew     - Complex element weight vector
%           lambda  - Acoustic wavelength, m
%           psi     - Azimuthal angle vector or matrix, deg
%           theta   - Elevation angle vector or matrix, deg
% 
%
% Outputs:
%           BP      - Beam pattern, complex linear units
%

%% Initialize
BP = 1;
%% Check Input Dimensions
resize = 0;
thetaSize = size(theta);
psiSize = size(psi);
if min(thetaSize)==1
    if min(psiSize)==1
        resize = 1;
    else
        disp('BeamPattern: Inputs psi and theta have incompatible dimensions')
        return
    end
else
    if min(psiSize)==1
        disp('BeamPattern: Inputs psi and theta have incompatible dimensions')
        return
    end
end
if resize
    [Theta,Psi] = ndgrid(theta,psi);
else
    Theta = theta;
    Psi = psi;
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
if max(eindex) > length(Element)
	disp('BeamPattern: Not enough elements defined for non-uniform array, reverting to uniform array of type Element(1)')
	eindex = ones(Array.Ne,1);
end
%% Spatial Grid
fx = cosd(-Theta).*cosd(Psi)/lambda;
fy = cosd(-Theta).*sind(Psi)/lambda;
fz = sind(-Theta)/lambda;
%% Compute Beam Pattern
psilast = NaN;
thetalast = NaN;
eindexlast = NaN;
BP = zeros(size(Psi));
hwait = waitbar(0,'Processing');
set(hwait,'Name','BeamPattern')
for i=1:Array.Ne
    waitbar(i/Array.Ne,hwait,['Processing Element ' num2str(i) '/' num2str(Array.Ne)]);
    if(Array.epsi(i)~=psilast)||(Array.etheta(i)~=thetalast)||(eindex(i)~=eindexlast)
        psilast = Array.epsi(i);
        thetalast = Array.etheta(i);
		eindexlast = eindex(i);
        try
            eval(['E = ' Element(eindex(i)).type '(Element(eindex(i)),lambda,Psi,Theta,Array.egamma(i),Array.etheta(i),Array.epsi(i));']);
        catch me %#ok<NASGU>
            disp(['Element pattern generator ' Element(eindex(i)).type '.m does not exist. Using omnidirectional element instead.'])     
            E = OmnidirectionalElement(Element(eindex(i)),lambda,Psi,Theta,Array.egamma(i),Array.etheta(i),Array.epsi(i));
        end
    end
    BP = BP + Beam.ew(i)*E.*exp(1i*2*pi*fx*Array.ex(i)).*exp(1i*2*pi*fy*Array.ey(i)).*exp(1i*2*pi*fz*Array.ez(i));
end
close(hwait)
%% Normalize
BP = BP/sum(abs(Beam.ew));