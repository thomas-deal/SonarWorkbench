function E = CircularPistonElement(Element,lambda,psi,theta,varargin)
%% function E = CircularPistonElement(Element,lambda,psi,theta)
% function E = CircularPistonElement(Element,lambda,psi,theta,psir,thetar)
%
% Calculates the element pattern for an ideal circular plane piston of
% radius a at wavelength lambda over azimuthal angles psi and elevation
% angles theta.
%
% Inputs:
%           Element - Element structure with the following fields
%               .type   - Element type string
%               .baffle - Element baffle enumeration
%                         0 = No baffle
%                         1 = Hard baffle
%                         2 = Raised cosine baffle
%               .a      - Circular piston radius, m
%           lambda  - Acoustic wavelength, 1/m
%           psi     - Azimuthal angle vector or matrix, deg
%           theta   - Elevation angle vector or matrix, deg
%
% Optional Inputs:
%           psir    - Azimuthal rotation angle, deg
%           thetar  - Elevation rotationangle, deg
%
% Outputs:
%           E       - Element pattern, linear units
%

%% Initialize
E = 1;
%% Check Input Dimensions
resize = 0;
thetaSize = size(theta);
psiSize = size(psi);
if min(thetaSize)==1
    if min(psiSize)==1
        resize = 1;
    else
        disp('CircularPistonElement: Inputs psi and theta have incompatible dimensions')
        return
    end
else
    if min(psiSize)==1
        disp('CircularPistonElement: Inputs psi and theta have incompatible dimensions')
        return
    end
end
if resize
    [Theta,Psi] = ndgrid(theta,psi);
else
    Theta = theta;
    Psi = psi;
end
%% Check Input Arguments
a = lambda/4;
baffle = 0;
psir = 0;
thetar = 0;
if nargin==6
    if ~isempty(varargin{1})
        psir = varargin{1};
    end
    if ~isempty(varargin{2})
        thetar = varargin{2};
    end
end
if isfield(Element,'a')
    if ~isempty(Element.a)
        a = Element.a;
    end
end
if isfield(Element,'baffle')
    if ~isempty(Element.baffle)
        baffle = Element.baffle;
    end
end
%% Rotate Computational Grid
X = cosd(thetar)*cosd(Theta).*cosd(Psi-psir) + sind(thetar)*sind(Theta);
Y = cosd(Theta).*sind(Psi-psir);
Z = sind(thetar)*cosd(Theta).*cosd(Psi-psir) - cosd(thetar)*sind(Theta);
Theta = -asind(Z);
Psi = atan2d(Y,X);
%% Spatial Grid
fy = cosd(-Theta).*sind(Psi)/lambda;
fz = sind(-Theta)/lambda;
%% Calculate Element Pattern
fr = sqrt(fy.^2+fz.^2);
E = besselj(1,2*pi*fr*a)./(pi*fr*a);
E(fr==0) = 1;
%% Baffle Pattern
if baffle>0
    Baf = ComputeBaffle(baffle,Psi,Theta);
    E = E.*Baf;
end