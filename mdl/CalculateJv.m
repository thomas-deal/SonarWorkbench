function Jv = CalculateJv(theta,psi,BP1,BP2)
%% function Jv = CalculateJv(theta,psi,BP1,BP2)
%
% Calculates the reverb directivity index of beam pattern BP1 and BBP2 
% defined over elevation angles theta and azimuthal angles psi. It is 
% assumed that theta spans +/-90 degrees. Any azimuths for which the beam 
% patterns are not defined are assumed to contribute zero energy to the 
% beam patterns.
%
% Inputs:
%           theta   - Elevation angle vector, deg
%           psi     - Azimuthal angle vector, deg
%           BP1     - Beam pattern matrix with elevation angles in rows,
%                     azimuthal angles in columns, complex linear units
%           BP2     - Beam pattern matrix with elevation angles in rows,
%                     azimuthal angles in columns, complex linear units
%
% Outputs:
%           Jv      - Reverb directivity index, dB
%

%% Computational Grid
[Theta,~] = ndgrid(theta,psi);
%% Normalze
BP1 = BP1/max(abs(BP1(:)));
BP2 = BP2/max(abs(BP2(:)));
%% Integrate
F = abs(BP1).*abs(BP2).*sind(Theta+90);
D = 4*pi/trapz(theta*pi/180,trapz(psi*pi/180,F,2));
Jv = 10*log10(D);
