function E = RectangularPistonElement(psi,theta,lambda,w,h)
%% function E = RectangularPistonElement(psi,theta,lambda,w,h)
%
% Calculates the 2D element pattern for an ideal rectangular plane piston
% of width w and height h at wavelength lambda over azimuthal angles psi
% and elevation angles theta.
%
% Inputs:
%           psi     - Azimuthal angle vector, deg
%           theta   - Elevation angle vector, deg
%           lambda  - Acoustic wavelength, 1/m
%           w       - Piston width, m
%           h       - Piston height, m
%
% Outputs:
%           E       - Element pattern, linear units
%

%% Computational Grid
[Theta,Psi] = ndgrid(theta,psi);
fy = cosd(-Theta).*sind(Psi)/lambda;
fz = sind(-Theta)/lambda;
%% Calculate Element Pattern
E = sinc(fy*w).*sinc(fz*h);
end