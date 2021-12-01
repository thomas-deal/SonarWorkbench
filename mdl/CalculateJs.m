function Js = CalculateJs(psi,BP1,BP2)
%% function Js = CalculateJs(psi,BP1,BP2)
%
% Calculates the surface reverb directivity index of beam pattern BP1 and 
% BP2 defined over azimuthal angles psi. Any azimuths for which the beam 
% patterns are not defined are assumed to contribute zero energy to the 
% beam patterns.
%
% Inputs:
%           psi     - Azimuthal angle vector, deg
%           BP1     - Beam pattern matrix with azimuthal angles in columns,
%                     complex linear units
%           BP2     - Beam pattern matrix with azimuthal angles in columns,
%                     complex linear units
%
% Outputs:
%           Js      - Reverb directivity index, dB
%

%% Normalze
BP1 = BP1/max(abs(BP1(:)));
BP2 = BP2/max(abs(BP2(:)));
%% Integrate
F = abs(BP1).*abs(BP2);
D = 2*pi/trapz(psi*pi/180,F);
Js = 10*log10(D);
