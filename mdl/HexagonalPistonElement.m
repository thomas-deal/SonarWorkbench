function E = HexagonalPistonElement(Element,lambda,theta,psi,ori)
%% function E = HexagonalPistonElement(Element,lambda,theta,psi,ori)
%
% Calculates the element pattern for an ideal hexagonal plane piston
% with inscribed circle radius a at wavelength lambda over azimuthal angles
% psi and elevation angles theta. Default orientation has left and right
% sides parallel. Element can be rotated 90 degrees such that top and
% bottom sides are parallel using optional argument.
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
%                             params_m(1) = Hexagonal element inscribed
%                                           circle radius, m
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
[Theta, Psi] = GenerateGrid(theta,psi,'HexagonalPistonElement');
if any([isnan(Theta(:)) isnan(Psi(:))])
    return
end
%% Check Input Arguments
a = lambda/4;
baffle = int32(0);
if nargin<5
    ori = [0;0;0];
end
if Element.params_m(1)~=0
    a = Element.params_m(1);
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
%% Element Face Subset Patterns
e0 = 1e-3;
% Lower Triangle
E1 = 2*exp(-1i*4*pi*a/sqrt(3)*fz)/((2*pi)^2*sqrt(3)) .* ...
     (fy + exp(1i*2*pi*a/sqrt(3)*fz) .* ...
     (-fy.*cos(2*pi*a*fy) + ...
     1i/sqrt(3)*fz.*sin(2*pi*a*fy)))./(fy.^3-1/3*fy.*fz.^2);
i0 = find((abs(fy-fz/sqrt(3))<e0)|(abs(fy+fz/sqrt(3))<e0));
E1(i0) = 2*exp(-1i*4*pi*a/sqrt(3)*fz(i0))/((2*pi)^2*sqrt(3)) .* ...
     (1 + exp(1i*2*pi*a/sqrt(3)*fz(i0)).*(-cos(2*pi*a/sqrt(3)*fz(i0)) + ...
     2*pi*a/sqrt(3)*fz(i0).*sin(2*pi*a/sqrt(3)*fz(i0)) + ...
     1i*2*pi*a/sqrt(3)*fz(i0) .* ...
     cos(2*pi*a/sqrt(3)*fz(i0))))./(2/3*fz(i0).^2);
i0 = find(abs(fy)<e0);
E1(i0) = 2*exp(-1i*4*pi*a/sqrt(3)*fz(i0))/((2*pi)^2*sqrt(3)) .* ...
         (1 + exp(1i*2*pi*a/sqrt(3)*fz(i0)) .* ...
         (-1 + 1i*2*pi*a/sqrt(3)*fz(i0)))./(-1/3*fz(i0).^2);
E1((abs(fy)<e0)&(abs(fz)<e0)) = a^2/sqrt(3);    % Area of Triangle
% Center Rectangle
E2 = 4/sqrt(3)*a^2*sinc(fy*2*a).*sinc(fz*2/sqrt(3)*a);
% Upper Triangle
E3 = conj(E1);
%% Combine and Normalize
E = E1 + E2 + E3;
E = E/(2*sqrt(3)*a^2);                          % Area of Hexagon
%% Baffle Pattern
if baffle>int32(0)
    Baf = ComputeBaffle(baffle,Theta,Psi);
    E = E.*Baf;
end
