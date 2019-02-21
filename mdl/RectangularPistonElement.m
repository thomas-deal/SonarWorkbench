function E = RectangularPistonElement(w,h,lambda,psi,theta,varargin)
%% function E = RectangularPistonElement(w,h,lambda,psi,theta)
% function E = RectangularPistonElement(w,h,lambda,psi,theta,psir,thetar)
% function E = RectangularPistonElement(w,h,lambda,psi,theta,psir,thetar,baffle)
%
% Calculates the 2D element pattern for an ideal rectangular plane piston
% of width w and height h at wavelength lambda over azimuthal angles psi
% and elevation angles theta.
%
% Inputs:
%           w       - Piston width, m
%           h       - Piston height, m
%           lambda  - Acoustic wavelength, 1/m
%           psi     - Azimuthal angle vector, deg
%           theta   - Elevation angle vector, deg
%
% Optional Inputs:
%           psir    - Azimuthal rotation angle, deg
%           thetar  - Elevation rotationangle, deg
%           baffle  - Element baffle enumeration
%                     0 = No baffle
%                     1 = Hard baffle
%                     2 = Raised cosine baffle
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
    case 7
        if ~isempty(varargin{1})
            psir = varargin{1};
        end
        if ~isempty(varargin{2})
            thetar = varargin{2};
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
E = sinc(fy*w).*sinc(fz*h);
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