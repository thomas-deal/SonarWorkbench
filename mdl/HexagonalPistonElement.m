function E = HexagonalPistonElement(psi,theta,lambda,a,varargin)
%% function E = HexagonalPistonElement(psi,theta,lambda,a)
% function E = HexagonalPistonElement(psi,theta,lambda,a,rotate)
%
% Calculates the 2D element pattern for an ideal hexagonal plane piston
% with inscribed circle radius a at wavelength lambda over azimuthal angles
% psi and elevation angles theta. Default orientation has left and right
% sides parallel. Element can be rotated 90 degrees such that top and
% bottom sides are parallel using optional argument
%
% Inputs:
%           psi     - Azimuthal angle vector, deg
%           theta   - Elevation angle vector, deg
%           lambda  - Acoustic wavelength, 1/m
%           a       - Element inscribed circle radius, m
%
% Optional Inputs:
%           rotate  - Rotate element 90 degrees from vertical
%
% Outputs:
%           E       - Element pattern, linear units
%

%% Check Input Arguments
rotate = 0;
switch nargin
    case 5
        if ~isempty(varargin{1})
            rotate = varargin{1};
        end
end
%% Computational Grid
[Theta,Psi] = ndgrid(theta,psi);
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
% Triangle 1
E1 = exp(-1i*2*pi*fz*2/sqrt(3)*a)/(sqrt(3)*pi).*((1+exp(1i*2*pi*fz*a/sqrt(3)).*(-cos(2*pi*fy*a) + 1i/sqrt(3)*fz./fy.*sin(2*pi*fy*a)))./(2*pi*(fy-fz/sqrt(3)).*(fy+fz/sqrt(3))));
E1(E1==0) = a^2/sqrt(3);    % Area of Triangle
% Center Rectangle
E2 = 4/sqrt(3)*a^2*sinc(fy*2*a).*sinc(fz*2/sqrt(3)*a);
% Triangle 2
E3 = exp(1i*2*pi*fz*a/sqrt(3))/(sqrt(3)*pi).*((exp(1i*2*pi*fz*a/sqrt(3))-cos(2*pi*fy*a) - 1i/sqrt(3)*fz./fy.*sin(2*pi*fy*a))./(2*pi*(fy-fz/sqrt(3)).*(fy+fz/sqrt(3))));
E3(E3==0) = a^2/sqrt(3);    % Area of Triangle
%% Combine
E = E1 + E2 + E3;
E = E/(2*sqrt(3)*a^2);      % Area of Hexagon
end