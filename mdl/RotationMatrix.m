function R = RotationMatrix(gamma,theta,psi)
%% function R = RotationMatrix(gamma,theta,psi)
%
% Creates a rotation matrix for converting Cartesian coordinates from one
% frame to another frame rotated gamma degrees about the x axis, theta
% degrees about the y axis, and psi degrees about the z axis in a
% right-handed coordinate frame. If gamma, theta, and psi are vectors of
% the same length N, R is of dimension 3x3xN.
%
% Inputs:
%           gamma   - Roll angle, deg
%           theta   - Pitch or elevation angle, deg
%           psi     - Yaw or azimuthal angle, deg
%
% Outputs:
%           R       - Rotation matrix
%

%% Initialize
R = eye(3);
%% Check Input Dimensions
[rg,cg] = size(gamma);
[rt,ct] = size(theta);
[rp,cp] = size(psi);
if ~(rg==rt&&rt==rp&&cg==ct&&ct==cp)
    disp('RotationMatrix: inputs gamma, theta, and psi have incompatible dimensions')
    return
end
if min([rg cg])~=1
    disp('RotationMatrix: inputs gamma, theta, and psi must be scalars or vectors, not matrices')
    return
end
%% Calculate
N = max([rg,cg]);
R = zeros(3,3,N);
for i=1:N
    Rx = [1 0 0; ...
          0 cosd(gamma(i)) -sind(gamma(i)); ...
          0 sind(gamma(i)) cosd(gamma(i))];
    Ry = [cosd(theta(i)) 0 sind(theta(i)); ...
          0 1 0; ...
          -sind(theta(i)) 0 cosd(theta(i))];
    Rz = [cosd(psi(i)) -sind(psi(i)) 0; ...
          sind(psi(i)) cosd(psi(i)) 0; ...
          0 0 1];
    R(:,:,i) = Rz*Ry*Rx;
end
