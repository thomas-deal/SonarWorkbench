function D = BeamPattern(ex,ey,ez,epsi,etheta,ew,Element,lambda,psi,theta)
%% function D = BeamPattern(ex,ey,ez,epsi,etheta,ew,Element,lambda,psi,theta)
%
% Computes the beam pattern for an array of identical elements at
% coordinates (ex,ey,ez) rotated (epsi,etheta) from the x axis with complex
% element weights ew at wavelength lambda over azimuthal angles psi and
% elevation angles theta. Supported element types are omnidirectional,
% circular piston, rectangular piston, and hexagonal piston. When element
% parameters are not specified, default values are used which assume half
% wavelength dimensions for all elements.
%
% Inputs:
%           ex      - Element x position vector, m
%           ey      - Element y position vector, m
%           ez      - Element z position vector, m
%           epsi    - Element normal azimuth vector, deg
%           etheta  - Element normal elevation vector, deg
%           ew      - Complex element weight vector
%           Element - Element structure with the following fields
%               .type   - Element type enumeration
%                         0 = omnidirectional
%                         1 = circular plane piston
%                         2 = rectangular plane piston
%                         3 = hexagonal plane piston
%               .baffle - Element baffle enumeration
%                         0 = No baffle
%                         1 = Hard baffle
%                         2 = Raised cosine baffle
%               .a      - Circular piston diameter, m
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
    dtheta = diff(Theta(1:2,1));
    thetamin = min(Theta(:));
    thetamax = max(Theta(:));
    dpsi = diff(Psi(1,1:2));
    psimin = min(Psi(:));
    psimax = max(Psi(:));
    theta = thetamin:dtheta:thetamax;
    psi = psimin:dpsi:psimax;
end
%% Check Input Arguments
a = lambda/4;
w = lambda/2;
h = lambda/2;
rotate = 0;
baffle = 0;
if isfield(Element,'a')
    if ~isempty(Element.a)
        a = Element.a;
    end
end
if isfield(Element,'w')
    if ~isempty(Element.w)
        w = Element.w;
    end
end
if isfield(Element,'h')
    if ~isempty(Element.h)
        h = Element.h;
    end
end
if isfield(Element,'rotate')
    if ~isempty(Element.rotate)
        rotate = Element.rotate;
    end
end
if isfield(Element,'baffle')
    if ~isempty(Element.baffle)
        baffle = Element.baffle;
    end
end
%% Spatial Grid
fx = cosd(-Theta).*cosd(Psi)/lambda;
fy = cosd(-Theta).*sind(Psi)/lambda;
fz = sind(-Theta)/lambda;
%% Compute Beam Pattern
psilast = NaN;
thetalast = NaN;
D = zeros(size(Psi));
Ne = length(ex);
hwait = waitbar(0,'Processing');
set(hwait,'Name','BeamPattern')
for i=1:Ne
    waitbar(i/Ne,hwait,['Processing Element ' num2str(i) '/' num2str(Ne)]);
    if(epsi(i)~=psilast)||(etheta(i)~=thetalast)
        psilast = epsi(i);
        thetalast = etheta(i);
        switch Element.type
            case 0     
                E = OmnidirectionalElement(psi,theta);
            case 1
                E = CircularPistonElement(a,lambda,Psi,Theta,epsi(i),etheta(i),baffle);
            case 2
                E = RectangularPistonElement(w,h,lambda,Psi,Theta,epsi(i),etheta(i),baffle);
            case 3
                E = HexagonalPistonElement(a,lambda,Psi,Theta,epsi(i),etheta(i),baffle,rotate);
        end
    end
    D = D + ew(i)*E.*exp(1i*2*pi*fx*ex(i)).*exp(1i*2*pi*fy*ey(i)).*exp(1i*2*pi*fz*ez(i));
end
close(hwait)
%% Normalize
D = D/sum(abs(ew));