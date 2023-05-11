function DI = CalculateDI(theta,psi,BP)
%% function DI = CalculateDI(theta,psi,BP)
%
% Calculates the directivity index of beam pattern BP defined over
% elevation angles theta and azimuthal angles psi. (Directivity Index is a
% special case of array gain for isotropic noise.) It is assumed that theta
% spans +/-90 degrees. Any azimuths for which the beam pattern is not
% defined are assumed to contribute zero energy to the beam pattern.
%
% Inputs:
%           theta   - Elevation angle vector, deg
%           psi     - Azimuthal angle vector, deg
%           BP      - Beam pattern matrix with elevation angles in rows,
%                     azimuthal angles in columns, complex linear units
%
% Outputs:
%           DI      - Directivity Index, dB
%

%% Computational Grid
[Theta,~] = ndgrid(theta,psi);
% Theta = repmat(theta(:),1,length(psi));
%% Normalze
BP = BP/max(abs(BP(:)));
%% Integrate
F = BP.*conj(BP).*sind(Theta+90);
D = 4*pi/trapz(theta*pi/180,trapz(psi*pi/180,F,2));
DI = 10*log10(D);
