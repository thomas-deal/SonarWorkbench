function [BPslice,phi] = ExtractBeamSlice(theta,psi,BP,Ori)
%% function [BPslice,phi] = ExtractBeamSlice(theta,psi,BP,Ori)
%
% Extracts a 2D slice from a 3D beam pattern along the great circle with 
% the specified orientation. Ori(2:3) specifies the center of the  slice in
% the (theta,psi) plane, and Ori(1) sets the angle of the slice within that
% plane, measured clockwise from the positive psi axis. For a vertical 
% slice (phi=theta), set Ori(1) = 90, and for a horizontal slice (phi=psi),
% set Ori(1) = 0.
%
% Inputs:
%           theta   - Elevation angle vector, deg
%           psi     - Azimuthal angle vector, deg
%           BP      - Beam pattern matrix with elevation angles in rows,
%                     azimuthal angles in columns, complex linear units
%           Ori     - Slice orientation vector, deg
%
% Outputs:
%           BPslice  - Beam pattern slice, complex linear units
%           phi      - Slice angle vector relative to Ori(2:3), deg
%

%% Calculate
phi = -180:180;
Nphi = 361;
ROT = RotationMatrix(Ori);
slice = ROT*[cosd(phi);zeros(1,Nphi);sind(-phi)];
slice = slice./repmat(sqrt(sum(slice.^2,1)),3,1);
Rtheta = -asind(slice(3,:));
Rpsi = atan2d(slice(2,:),slice(1,:));
BPslice = interp2(psi,theta,BP,Rpsi,Rtheta);
