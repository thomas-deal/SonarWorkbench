function E = AnnularPistonElement(Element,lambda,theta,psi,varargin)
%% function E = AnnularPistonElement(Element,lambda,theta,psi)
% function E = AnnularPistonElement(Element,lambda,theta,psi,gammar,thetar,psir)
%
% Calculates the element pattern for an ideal annular plane piston of
% outer radius a and iner radius b at wavelength lambda over azimuthal
% angles psi and elevation angles theta.
%
% Inputs:
%           Element - Element structure with the following fields
%               .type       - Element type string
%               .baffle     - Element baffle enumeration
%                             0 = No baffle
%                             1 = Hard baffle
%                             2 = Raised cosine baffle
%                             3 = Torpedo nose baffle
%               .params_m   - Element shape parameter vector
%                             params_m(1) = Element outer radius, m
%                             params_m(2) = Element inner radius, m
%           lambda  - Acoustic wavelength, 1/m
%           theta   - Elevation angle vector or matrix, deg
%           psi     - Azimuthal angle vector or matrix, deg
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
[Theta, Psi] = GenerateGrid(theta,psi,'AnnularPistonElement');
if any([isnan(Theta(:)) isnan(Psi(:))])
    return
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
if Element.params_m(1)~=0
    a = Element.params_m(1);
end
if Element.params_m(2)~=0
    b = Element.params_m(2);
end
if isfield(Element,'baffle')
    if ~isempty(Element.baffle)
        baffle = Element.baffle;
    end
end
%% Rotate Computational Grid
[Theta,Psi] = RotateComputationalGrid(Theta,Psi,gammar,thetar,psir);
%% Spatial Grid
fy = cosd(-Theta).*sind(Psi)/lambda;
fz = sind(-Theta)/lambda;
%% Calculate Element Pattern
fr = sqrt(fy.^2+fz.^2);
E = 2*(a*besselj(1,2*pi*fr*a) - b*besselj(1,2*pi*fr*b))./(2*pi*fr*(a^2-b^2));
E(fr==0) = 1;
%% Baffle Pattern
if baffle>0
    Baf = ComputeBaffle(baffle,Theta,Psi);
    E = E.*Baf;
end
