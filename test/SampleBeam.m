%% Load Array Definition
SampleArray
%% Amplitude Weights
hweights = [0.3185 0.7683 1.0000 0.7683 0.3185];
vweights = [0.2575 0.4300 0.6692 0.8780 1.0000 1.0000 0.8780 0.6692 0.4300 0.2575];
ea = repmat(hweights,1,Nh) .* ...
     reshape(repmat(vweights,Nw,1),1,Array.Ne);
% Phase Weights
if ~exist('psi0','var')
    psi0 = 0;
end
if ~exist('theta0','var')
    theta0 = 0;
end
ep = exp(-1i*2*pi*cosd(-theta0).*sind(psi0)/lambda*Array.ePos_m(2,:)).* ...
     exp(-1i*2*pi*sind(-theta0)/lambda*Array.ePos_m(3,:));
%% Complex Weights
Beam.ew = ea.*ep;
clear ea ep
