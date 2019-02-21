%% Design Parameters
f0 = 37.5e3;                        % Design frequency, Hz
c0 = 1500;                          % Sound speed, m/s
lambda = c0/f0;                     % Acoustic wavelength, m
%% Element Design
Element.type = 'RectangularPiston';
Element.w = lambda/2;               % Element face width, m
Element.h = lambda/4;               % Element face height, m
Element.baffle = 1;                 % Hard Baffle
%% Element Shape
shapex = zeros(1,5);
shapey = Element.w/2*[-1 1 1 -1 -1];
shapez = Element.h/2*[-1 -1 1 1 -1];
%% Array Design
Nw = 5;                             % Number of elements wide
Nh = 10;                            % Number of elements high
dy = Element.w;                     % Element horizontal spacing, m
dz = Element.h;                     % Element vertical spacing, m
Array.Ne = Nw*Nh;                   % Number of elements
Array.ex = zeros(Array.Ne,1);       % Element x positions, m
Array.ey = repmat((-(Nw-1)/2:(Nw-1)/2)'*dy,Nh,1);                   
                                    % Element y positions, m
Array.ez = reshape(repmat((-(Nh-1)/2:(Nh-1)/2)*dz,Nw,1),Array.Ne,1);   
                                    % Element z positions, m
Array.epsi = zeros(Array.Ne,1);     % Element azimuths, deg
Array.etheta = zeros(Array.Ne,1);   % Element elevations, deg
%% Array Weights
% Amplitude Weights
ea = repmat(chebwin(Nw,30),Nh,1).*reshape(repmat(chebwin(Nh,30)',Nw,1),Array.Ne,1);
% Phase Weights
if ~exist('psi0','var')
    psi0 = 0;
end
if ~exist('theta0','var')
    theta0 = 0;
end
ep = exp(-1i*2*pi*cosd(-theta0).*sind(psi0)/lambda*Array.ey).*exp(-1i*2*pi*sind(-theta0)/lambda*Array.ez);
% Complex Weights
Array.ew = ea.*ep;