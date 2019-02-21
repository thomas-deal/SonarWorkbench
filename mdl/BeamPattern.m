function D = BeamPattern(Array,Element,lambda,psi,theta)
%% function D = BeamPattern(Array,Element,lambda,psi,theta)
%
% Computes the beam pattern for an array of identical elements at
% coordinates (ex,ey,ez) rotated (epsi,etheta) from the x axis with complex
% element weights ew at wavelength lambda over azimuthal angles psi and
% elevation angles theta. Supported element types are omnidirectional,
% linear, circular piston, rectangular piston, and hexagonal piston. When 
% element parameters are not specified, default values are used which 
% assume half wavelength dimensions for all elements.
%
% Inputs:
%           Array   - Array structure with the following fields
%               .ex     - Element x position vector, m
%               .ey     - Element y position vector, m
%               .ez     - Element z position vector, m
%               .epsi   - Element normal azimuth vector, deg
%               .etheta - Element normal elevation vector, deg
%               .ew     - Complex element weight vector
%           Element - Element structure with the following fields
%               .type   - Element type string
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
%               .rotate - Hexagonal element rotation, see 
%                         HexagonalPistonElement.m for details
%           lambda  - Acoustic wavelength, m
%           psi     - Azimuthal angle vector or matrix, deg
%           theta   - Elevation angle vector or matrix, deg
% 
%
% Outputs:
%           D       - Beam pattern, complex linear units
%

%% Initialize
D = 1;
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
%% Spatial Grid
fx = cosd(-Theta).*cosd(Psi)/lambda;
fy = cosd(-Theta).*sind(Psi)/lambda;
fz = sind(-Theta)/lambda;
%% Compute Beam Pattern
psilast = NaN;
thetalast = NaN;
D = zeros(size(Psi));
hwait = waitbar(0,'Processing');
set(hwait,'Name','BeamPattern')
for i=1:Array.Ne
    waitbar(i/Array.Ne,hwait,['Processing Element ' num2str(i) '/' num2str(Array.Ne)]);
    if(Array.epsi(i)~=psilast)||(Array.etheta(i)~=thetalast)
        psilast = Array.epsi(i);
        thetalast = Array.etheta(i);
        switch Element.type
            case 'Omnidirectional'     
                E = OmnidirectionalElement(Element,lambda,Psi,Theta,Array.epsi(i),Array.etheta(i));
            case 'Linear'
                E = LinearElement(Element,lambda,Psi,Theta,Array.epsi(i),Array.etheta(i));
            case 'CircularPiston'
                E = CircularPistonElement(Element,lambda,Psi,Theta,Array.epsi(i),Array.etheta(i));
            case 'RectangularPiston'
                E = RectangularPistonElement(Element,lambda,Psi,Theta,Array.epsi(i),Array.etheta(i));
            case 'HexagonalPiston'
                E = HexagonalPistonElement(Element,lambda,Psi,Theta,Array.epsi(i),Array.etheta(i));
            otherwise     
                E = OmnidirectionalElement(Element,lambda,Psi,Theta,Array.epsi(i),Array.etheta(i));
        end
    end
    D = D + Array.ew(i)*E.*exp(1i*2*pi*fx*Array.ex(i)).*exp(1i*2*pi*fy*Array.ey(i)).*exp(1i*2*pi*fz*Array.ez(i));
end
close(hwait)
%% Normalize
D = D/sum(abs(Array.ew));