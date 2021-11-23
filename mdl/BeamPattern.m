function BP = BeamPattern(Array,Beam,lambda,theta,psi)
%% function BP = BeamPattern(Array,Beam,lambda,theta,psi)
%
% Computes the beam pattern for an array of elements at coordinates
% (ex_m,ey_m,ez_m) rotated (egamma_deg,etheta_deg,epsi_deg) from the x axis
% with complex element weights ew at wavelength lambda over elevation
% angles theta and azimuthal angles psi. Supported element types are
% omnidirectional, linear, cosine, circular piston, rectangular piston,
% hexagonal piston, and annular piston.
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
%               .eindex     - Vector of indices into element structure
%                             vector to support non-uniform element arrays
%           Beam        - Beam structure with the following required fields
%               .ew         - Complex element weight vector
%           lambda          - Acoustic wavelength, m
%           theta           - Elevation angle vector or matrix, deg
%           psi             - Azimuthal angle vector or matrix, deg
% 
% Outputs:
%           BP          - Beam pattern, complex linear units
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
if (thetaSize(2) == 1) && (psiSize(2) == 1) && (thetaSize(1) == psiSize(1))
    resize = 0;
    % When theta and psi are passed as column vectors of identical size,
    % treat as coordinate pairs for evaluation, not grid coordinates.
end
if resize
    [Theta,Psi] = ndgrid(theta, psi);
else
    Theta = theta;
    Psi = psi;
end
%% Support for Non-Uniform Arrays
eindex = ones(Array.Ne,1);
if isfield(Array,'eindex')
    if ~isempty(Array.eindex)
        if length(Array.eindex)==1
            eindex = double(Array.eindex(1))*ones(Array.Ne,1) ;
        else
            eindex(1:Array.Ne) = double(Array.eindex(1:Array.Ne));
        end
    end
end
if max(eindex) > length(Array.Element)
    disp('BeamPattern: Not enough elements defined for non-uniform array, reverting to uniform array of type Array.Element(1)')
    eindex = ones(Array.Ne,1);
end
%% Spatial Grid
fx = cosd(-Theta).*cosd(Psi)/lambda;
fy = cosd(-Theta).*sind(Psi)/lambda;
fz = sind(-Theta)/lambda;
%% Compute Beam Pattern
gammalast = NaN;
thetalast = NaN;
psilast = NaN;
eindexlast = NaN;
BP = complex(zeros(size(Psi)));
E = complex(ones(size(Psi)));
for i=1:Array.Ne
    if(Array.egamma_deg(i)~=gammalast)||(Array.epsi_deg(i)~=psilast)||(Array.etheta_deg(i)~=thetalast)||(eindex(i)~=eindexlast)
        gammalast = Array.egamma_deg(i);
        thetalast = Array.etheta_deg(i);
        psilast = Array.epsi_deg(i);
        eindexlast = eindex(i);
        E = ElementPattern(Array.Element(eindex(i)),lambda,Theta,Psi,Array.egamma_deg(i),Array.etheta_deg(i),Array.epsi_deg(i));
    end
    BP = BP + Beam.ew(i)*E.*exp(1i*2*pi*fx*Array.ex_m(i)).*exp(1i*2*pi*fy*Array.ey_m(i)).*exp(1i*2*pi*fz*Array.ez_m(i));
end
%% Normalize
BP = BP/sum(abs(Beam.ew) );
