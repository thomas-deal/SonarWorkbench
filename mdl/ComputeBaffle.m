function B = ComputeBaffle(baffle,theta,psi)
%% function B = ComputeBaffle(baffle,theta,psi)
%
% Creates a matrix that simulates the effect of baffling when multiplied by
% a beam pattern. Assumes azimuthal angles psi and elevation angles theta
% have been rotated such that (0,0) is the direction of the baffle normal
% vector.
%
% Inputs:
%           baffle  - Element baffle enumeration
%                     0 = No baffle
%                     1 = Hard baffle
%                     2 = Raised cosine baffle
%                     3 = Torpedo nose baffle
%           theta   - Elevation angle vector or matrix, deg
%           psi     - Azimuthal angle vector or matrix, deg
%
% Outputs:
%           E       - Baffle matrix
%

%% Initialize
B = 1;
%% Check Input Dimensions
[Theta, Psi] = GenerateGrid(theta,psi,'ComputeBaffle');
if any([isnan(Theta(:)) isnan(Psi(:))])
    return
end
%% Create Baffle
if baffle>0
    Phi = acosd(cosd(Psi).*cosd(Theta));
    switch baffle
        case 1    % Hard baffle
            B = ones(size(Theta));
            B(Phi>90) = eps;
        case 2    % Raised cosine baffle
            B = 1/2+1/2*cosd(4*Phi);
            B(Phi<=90) = 1;
            B(Phi>135) = eps;
        case 3    % Torpedo nose baffle
            B = 1/2+1.2*cosd(4*(Phi-45));
            B(Phi<=45) = 1;
            B(Phi>90) = eps;
    end
end
