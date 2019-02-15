function E = OmnidirectionalElement(psi,theta)
%% function E = OmnidirectionalElement(psi,theta)
%
% Calculates the 2D element pattern for an omnidirectional sensor over 
% azimuthal angles psi and elevation angles theta.
%
% Inputs:
%           psi     - Azimuthal angle vector, deg
%           theta   - Elevation angle vector, deg
%
% Outputs:
%           E       - Element pattern, linear units
%

%% Computational Grid
[Theta,~] = ndgrid(theta,psi);
%% Calculate Element Pattern
E = ones(size(Theta));
end