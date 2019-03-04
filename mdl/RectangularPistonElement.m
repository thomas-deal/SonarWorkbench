function E = RectangularPistonElement(Element,lambda,psi,theta,varargin)
%% function E = RectangularPistonElement(Element,lambda,psi,theta)
% function E = RectangularPistonElement(Element,lambda,psi,theta,gammar,thetar,psir)
%
% Calculates the element pattern for an ideal rectangular plane piston
% of width w and height h at wavelength lambda over azimuthal angles psi
% and elevation angles theta.
%
% Inputs:
%           Element - Element structure with the following fields
%               .type   - Element type string
%               .baffle - Element baffle enumeration
%                         0 = No baffle
%                         1 = Hard baffle
%                         2 = Raised cosine baffle
%               .w      - Rectangular piston width, m
%               .h      - Rectangular piston height, m
%           lambda  - Acoustic wavelength, 1/m
%           psi     - Azimuthal angle vector or matrix, deg
%           theta   - Elevation angle vector or matrix, deg
%
% Optional Inputs:
%           gammar  - Roll rotation angle, deg
%           thetar  - Elevation rotation angle, deg
%           psir    - Azimuthal rotation angle, deg
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
        disp('RectangularPistonElement: Inputs psi and theta have incompatible dimensions')
        return
    end
else
    if min(psiSize)==1
        disp('RectangularPistonElement: Inputs psi and theta have incompatible dimensions')
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
w = lambda/2;
h = lambda/2;
baffle = 0;
gammar = 0;
thetar = 0;
psir = 0;
if nargin==7
    if ~isempty(varargin{1})
        gammar = varargin{1};
    end
    if ~isempty(varargin{2})
        thetar = varargin{2};
    end
    if ~isempty(varargin{3})
        psir = varargin{3};
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
if isfield(Element,'baffle')
    if ~isempty(Element.baffle)
        baffle = Element.baffle;
    end
end
%% Rotate Computational Grid
X0 = cosd(-Theta).*cosd(Psi);
Y0 = cosd(-Theta).*sind(Psi);
Z0 = sind(-Theta);
ROT = RotationMatrix(gammar,thetar,psir)';
X = ROT(1,1)*X0 + ROT(1,2)*Y0 + ROT(1,3)*Z0;
Y = ROT(2,1)*X0 + ROT(2,2)*Y0 + ROT(2,3)*Z0;
Z = ROT(3,1)*X0 + ROT(3,2)*Y0 + ROT(3,3)*Z0;
Theta = -asind(Z);
Psi = atan2d(Y,X);
%% Spatial Grid
fy = cosd(-Theta).*sind(Psi)/lambda;
fz = sind(-Theta)/lambda;
%% Calculate Element Pattern
E = sinc(fy*w).*sinc(fz*h);
%% Baffle Pattern
if baffle>0
    Baf = ComputeBaffle(baffle,Psi,Theta);
    E = E.*Baf;
end