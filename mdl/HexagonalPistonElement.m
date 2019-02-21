function E = HexagonalPistonElement(a,lambda,psi,theta,varargin)
%% function E = HexagonalPistonElement(a,lambda,psi,theta)
% function E = HexagonalPistonElement(a,lambda,psi,theta,psir,thetar)
% function E = HexagonalPistonElement(a,lambda,psi,theta,psir,thetar,baffle)
% function E = HexagonalPistonElement(a,lambda,psi,theta,psir,thetar,baffle,rotate)
%
% Calculates the 2D element pattern for an ideal hexagonal plane piston
% with inscribed circle radius a at wavelength lambda over azimuthal angles
% psi and elevation angles theta. Default orientation has left and right
% sides parallel. Element can be rotated 90 degrees such that top and
% bottom sides are parallel using optional argument
%
% Inputs:
%           a       - Element inscribed circle radius, m
%           lambda  - Acoustic wavelength, 1/m
%           psi     - Azimuthal angle vector or matrix, deg
%           theta   - Elevation angle vector or matrix, deg
%
% Optional Inputs:
%           psir    - Azimuthal rotation angle, deg
%           thetar  - Elevation rotationangle, deg
%           baffle  - Element baffle enumeration
%                     0 = No baffle
%                     1 = Hard baffle
%                     2 = Raised cosine baffle
%           rotate  - Rotate element 90 degrees from vertical
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
psir = 0;
thetar = 0;
baffle = 0;
switch nargin
    case 6
        if ~isempty(varargin{1})
            psir = varargin{1};
        end
        if ~isempty(varargin{2})
            thetar = varargin{2};
        end
    case 7
        if ~isempty(varargin{1})
            psir = varargin{1};
        end
        if ~isempty(varargin{2})
            thetar = varargin{2};
        end
        if ~isempty(varargin{3})
            baffle = varargin{3};
        end
    case 8
        if ~isempty(varargin{1})
            psir = varargin{1};
        end
        if ~isempty(varargin{2})
            thetar = varargin{2};
        end
        if ~isempty(varargin{3})
            baffle = varargin{3};
        end
        if ~isempty(varargin{4})
            rotate = varargin{4};
        end
end
%% Rotate Computational Grid
X = cosd(thetar)*cosd(Theta).*cosd(Psi-psir) + sind(thetar)*sind(Theta);
Y = cosd(Theta).*sind(Psi-psir);
Z = sind(thetar)*cosd(Theta).*cosd(Psi-psir) - cosd(thetar)*sind(Theta);
Theta = -asind(Z);
Psi = atan2d(Y,X);
%% Spatial Grid
if rotate
    fy = sind(-Theta)/lambda;
    fz = cosd(-Theta).*sind(Psi)/lambda;
else
    fy = cosd(-Theta).*sind(Psi)/lambda;
    fz = sind(-Theta)/lambda;
end
%% Prevent Divide by 0
fy(fy==0) = eps;
fz(fz==0) = eps;
%% Element Face Subset Patterns
e0 = eps;
% Lower Triangle
E1 = 2*exp(-1i*4*pi*a/sqrt(3)*fz)/((2*pi)^2*sqrt(3)).*(fy + exp(1i*2*pi*a/sqrt(3)*fz).*(-fy.*cos(2*pi*a*fy) + 1i/sqrt(3)*fz.*sin(2*pi*a*fy)))./(fy.^3-1/3*fy.*fz.^2);
i0 = find((abs(fy-fz/sqrt(3))<e0)|(abs(fy+fz/sqrt(3))<e0));
E1(i0) = 2*exp(-1i*4*pi*a/sqrt(3)*fz(i0))/((2*pi)^2*sqrt(3)).*(1 + exp(1i*2*pi*a/sqrt(3)*fz(i0)).*(-cos(2*pi*a/sqrt(3)*fz(i0)) + 2*pi*a/sqrt(3)*fz(i0).*sin(2*pi*a/sqrt(3)*fz(i0)) + 1i*2*pi*a/sqrt(3)*fz(i0).*cos(2*pi*a/sqrt(3)*fz(i0))))./(2/3*fz(i0).^2);
i0 = find(abs(fy)<e0);
E1(i0) = 2*exp(-1i*4*pi*a/sqrt(3)*fz(i0))/((2*pi)^2*sqrt(3)).*(1 + exp(1i*2*pi*a/sqrt(3)*fz(i0)).*(-1 + 1i*2*pi*a/sqrt(3)*fz(i0)))./(-1/3*fz(i0).^2);
E1((abs(fy)<e0)&(abs(fz)<e0)) = a^2/sqrt(3);    % Area of Triangle
% Center Rectangle
E2 = 4/sqrt(3)*a^2*sinc(fy*2*a).*sinc(fz*2/sqrt(3)*a);
% Upper Triangle
E3 = conj(E1);
%% Combine
E = E1 + E2 + E3;
E = E/(2*sqrt(3)*a^2);                          % Area of Hexagon
%% Baffle Pattern
if baffle>0
    Phi = acosd(cosd(Psi).*cosd(Theta));
    if baffle==1        % Hard baffle
        Baf = ones(size(E));
        Baf(Phi>90) = eps;
    elseif baffle==2    % Raised cosine baffle
        Baf = 1/2+1/2*cosd(4*Phi);
        Baf(Phi<=90) = 1;
        Baf(Phi>135) = eps;
    else                % Invalid input for baffle
        Baf = ones(size(E));
    end
    E = E.*Baf;
end