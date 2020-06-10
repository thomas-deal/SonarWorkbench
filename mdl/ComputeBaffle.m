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
%                     0 = no baffle
%                     1 = hard baffle
%                     2 = raised cosine baffle
%           theta   - Elevation angle vector or matrix, deg
%           psi     - Azimuthal angle vector or matrix, deg
%
% Outputs:
%           E       - Baffle matrix
%

%% Initialize
B = 1;
%% Check Input Dimensions
resize = 0;
thetaSize = size(theta);
psiSize = size(psi);
if min(thetaSize)==1
    if min(psiSize)==1
        resize = 1;
    else
        disp('ComputeBaffle: Inputs psi and theta have incompatible dimensions')
        return
    end
else
    if min(psiSize)==1
        disp('ComputeBaffle: Inputs psi and theta have incompatible dimensions')
        return
    end
end
if resize
    [Theta,Psi] = ndgrid(theta,psi);
else
    Theta = theta;
    Psi = psi;
end
%% Create Baffle
if baffle>0
    Phi = acosd(cosd(Psi).*cosd(Theta));
    switch baffle
        case 1        % Hard baffle
            B = ones(size(Theta));
            B(Phi>90) = eps;
        case 2    % Raised cosine baffle
            B = 1/2+1/2*cosd(4*Phi);
            B(Phi<=90) = 1;
            B(Phi>135) = eps;
    end
end
