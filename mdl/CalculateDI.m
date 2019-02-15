function DI = CalculateDI(psi,theta,BP)
%% function DI = CalculateDI(psi,theta,BP)
%
% Calculates the directivity index of beam pattern BP defined over
% azimuthal angles psi and elevation angles theta. (Directivity Index is a
% special case of array gain for isotropic noise.) It is assumed that theta
% spans +/-90 degrees. Any azimuths for which the beam pattern is not
% defined are assumed to contribute zero energy to the beam pattern.
%
% Inputs:
%           psi     - Azimuthal angle vector, deg
%           theta   - Elevation angle vector, deg
%           BP      - Beam pattern matrix with elevation angles in rows,
%                     azimuthal angles in columns, complex linear units
%
% Outputs:
%           DI      - Directivity Index, dB
%

%% Computational Grid
[Theta,~] = ndgrid(theta,psi);
%% Normalze
BP = BP/max(abs(BP(:)));
%% Integrate
dpsi = diff(psi(1:2))*pi/180;
dtheta = diff(theta(1:2))*pi/180;
D = 4*pi/trapz(trapz(BP.*conj(BP).*sind(Theta+90)*dtheta,1)*dpsi,2);
DI = 10*log10(D);