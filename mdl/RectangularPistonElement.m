function E = RectangularPistonElement(Element,lambda,theta,psi,ori)
%% function E = RectangularPistonElement(Element,lambda,theta,psi,ori)
%
% Calculates the element pattern for an ideal rectangular plane piston
% of width w and height h at wavelength lambda over azimuthal angles psi
% and elevation angles theta.
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
%                             params m(1) = Rectangular piston width, m
%                             params_m(2) = Rectangular piston height, m
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
[Theta, Psi] = GenerateGrid(theta,psi,'RectangularPistonElement');
%% Check Input Arguments
w = lambda/2;
h = lambda/2;
baffle = 0;
if nargin==5
    ori = [0;0;0];
end
if Element.params_m(1)~=0
    w = Element.params_m(1);
end
if Element.params_m(2)~=0
    h = Element.params_m(2);
end  
if isfield(Element,'baffle')
    if ~isempty(Element.baffle)
        baffle = Element.baffle;
    end
end
%% Rotate Computational Grid
[Theta,Psi] = RotateComputationalGrid(Theta,Psi,ori);
%% Spatial Grid
fy = cosd(-Theta).*sind(Psi)/lambda;
fz = sind(-Theta)/lambda;
%% Calculate Element Pattern
E = sinc(fy*w).*sinc(fz*h);
%% Baffle Pattern
if baffle>0
    Baf = ComputeBaffle(baffle,Theta,Psi);
    E = E.*Baf;
end
