%% Load Array Definition
SampleArray
%% Amplitude Weights
ea = repmat(chebwin(Nw,30)',1,Nh) .* ...
     reshape(repmat(chebwin(Nh,30)',Nw,1),1,Array.Ne);
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
