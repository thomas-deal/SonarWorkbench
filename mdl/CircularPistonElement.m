function E = CircularPistonElement(psi,theta,lambda,a)
%% function E = CircularPistonElement(psi,theta,lambda,a)
%
% Calculates the 2D element pattern for an ideal circular plane piston of
% radius a at wavelength lambda over azimuthal angles psi and elevation
% angles theta.
%
% Inputs:
%           psi     - Azimuthal angle vector, deg
%           theta   - Elevation angle vector, deg
%           lambda  - Acoustic wavelength, 1/m
%           a       - Piston radius, m
%
% Outputs:
%           E       - Element pattern, linear units
%

%% Computational Grid
[Theta,Psi] = ndgrid(theta,psi);
fy = cosd(-Theta).*sind(Psi)/lambda;
fz = sind(-Theta)/lambda;
fr = sqrt(fy.^2+fz.^2);
%% Calculate Element Pattern
E = besselj(1,2*pi*fr*a)./(pi*fr*a);
E(fr==0) = 1;
end