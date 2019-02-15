%% Array Parameters
f0 = 37.5e3;        % Design frequency, Hz
c0 = 1500;          % Sound speed, m/s
lambda = c0/f0;     % Acoustic wavelength, m
w = lambda/2;       % Element face width, m
h = lambda/4;       % Element face height, m
Nw = 5;             % Number of elements wide
Nh = 10;            % Number of elements high
Ne = Nw*Nh;         % Number of elements in array
dy = w;             % Element horizontal spacing, m
dz = h;             % Element vertical spacing, m
%% Array Geometry
ex = zeros(Ne,1);
ey = repmat((-(Nw-1)/2:(Nw-1)/2)'*dy,Nh,1);
ez = reshape(repmat((-(Nh-1)/2:(Nh-1)/2)*dz,Nw,1),Ne,1);
epsi = zeros(Ne,1);
etheta = zeros(Ne,1);
%% Element Shape
shapex = zeros(1,5);
shapey = w/2*[-1 1 1 -1 -1];
shapez = h/2*[-1 -1 1 1 -1];
