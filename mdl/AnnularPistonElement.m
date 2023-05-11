function E = AnnularPistonElement(Element,lambda,theta,psi,ori)
%% function E = AnnularPistonElement(Element,lambda,theta,psi,ori)
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
%           ori     - Element normal orientation vector, deg
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
baffle = int32(0);
if nargin<5
    ori = [0;0;0];
end
if Element.params_m(1)~=0
    a = Element.params_m(1);
end
if Element.params_m(2)~=0
    b = Element.params_m(2);
end
if isfield(Element,'baffle')
    if ~isempty(Element.baffle)
        baffle = int32(Element.baffle);
    end
end
%% Rotate Computational Grid
[Theta,Psi] = RotateComputationalGrid(Theta,Psi,ori);
%% Spatial Grid
fy = cosd(-Theta).*sind(Psi)/lambda;
fz = sind(-Theta)/lambda;
%% Calculate Element Pattern
fr = sqrt(fy.^2+fz.^2);
E = 2*(a*besselj(1,2*pi*fr*a) - ...
       b*besselj(1,2*pi*fr*b))./(2*pi*fr*(a^2-b^2));
E(fr==0) = 1;
%% Baffle Pattern
if baffle>int32(0)
    Baf = ComputeBaffle(baffle,Theta,Psi);
    E = E.*Baf;
end
