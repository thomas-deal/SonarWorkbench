%% Amplitude Weights
ea = repmat(chebwin(Nw,30),Nh,1).*reshape(repmat(chebwin(Nh,30)',Nw,1),Ne,1);
%% Phase Weights
if ~exist('psi0','var')
    psi0 = 0;
end
if ~exist('theta0','var')
    theta0 = 0;
end
ep = exp(-1i*2*pi*cosd(-theta0).*sind(psi0)/lambda*ey).*exp(-1i*2*pi*sind(-theta0)/lambda*ez);
%% Complex Weights
ew = ea.*ep;