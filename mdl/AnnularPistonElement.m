function E = AnnularPistonElement(Element,lambda,psi,theta,varargin)
%% function E = AnnularPistonElement(Element,lambda,psi,theta)
% function E = AnnularPistonElement(Element,lambda,psi,theta,gammar,thetar,psir)
%
% Calculates the element pattern for an ideal annular plane piston of
% outer radius a and iner radius b at wavelength lambda over azimuthal
% angles psi and elevation angles theta.
%
% Inputs:
%           Element - Element structure with the following fields
%               .type   - Element type string
%               .baffle - Element baffle enumeration
%                         0 = No baffle
%                         1 = Hard baffle
%                         2 = Raised cosine baffle
%               .a      - Element outer radius, m
%               .b      - Element inner radius, m
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
        disp('AnnularPistonElement: Inputs psi and theta have incompatible dimensions')
        return
    end
else
    if min(psiSize)==1
        disp('AnnularPistonElement: Inputs psi and theta have incompatible dimensions')
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
b = lambda/8;
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
if isfield(Element,'a')
    if ~isempty(Element.a)
        a = Element.a;
    end
end
if isfield(Element,'b')
    if ~isempty(Element.b)
        b = Element.b;
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
fr = sqrt(fy.^2+fz.^2);
E = 2*(a*besselj(1,2*pi*fr*a) - b*besselj(1,2*pi*fr*b))./(2*pi*fr*(a^2-b^2));
E(fr==0) = 1;
%% Baffle Pattern
if baffle>0
    Baf = ComputeBaffle(baffle,Psi,Theta);
    E = E.*Baf;
end