function [Theta,Psi] = RotateComputationalGrid(Theta,Psi,gammar,thetar,psir)
%% function [Theta,Psi] = RotateComputationalGrid(Theta,Psi,gammar,thetar,psir)
%
% Rotates a computational grid of azimuth and elevation angles from one
% frame to another.
% 
% Inputs:
%           Theta   - Elevation angle grid, deg
%           Psi     - Azimuthal angle grid, deg
%           gammar  - Roll rotation angle, deg
%           thetar  - Elevation rotation angle, deg
%           psir    - Azimuthal rotation angle, deg
%
% Outputs:
%           Theta   - Rotated elevation angle grid, deg
%           Psi     - Rotated aAzimuthal angle grid, deg
%

%% Calculate
X0 = cosd(-Theta).*cosd(Psi);
Y0 = cosd(-Theta).*sind(Psi);
Z0 = sind(-Theta);
ROT = RotationMatrix(gammar,thetar,psir)';
X = ROT(1,1)*X0 + ROT(1,2)*Y0 + ROT(1,3)*Z0;
Y = ROT(2,1)*X0 + ROT(2,2)*Y0 + ROT(2,3)*Z0;
Z = ROT(3,1)*X0 + ROT(3,2)*Y0 + ROT(3,3)*Z0;
Z(Z>1) = 1;
Z(Z<-1) = -1;
Theta = -asind(Z);
Psi = atan2d(Y,X);
