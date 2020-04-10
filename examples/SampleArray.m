%% Array Design
Nw = 5;                             % Number of elements wide
Nh = 10;                            % Number of elements high
dy = Element.w;                     % Horizontal spacing, m
dz = Element.h;                     % Vertical spacing, m
Array.Ne = Nw*Nh;                   % Number of elements
Array.ex = zeros(Array.Ne,1);       % Element x positions, m
Array.ey = ...
    repmat((-(Nw-1)/2:(Nw-1)/2)'*dy,Nh,1);                   
                                    % Element y positions, m
Array.ez = ...
    reshape(repmat((-(Nh-1)/2:(Nh-1)/2)*dz,Nw,1),Array.Ne,1);   
                                    % Element z positions, m
Array.egamma = zeros(Array.Ne,1);   % Element rolls, deg
Array.etheta = zeros(Array.Ne,1);   % Element elevations, deg
Array.epsi = zeros(Array.Ne,1);     % Element azimuths, deg
Array.ax = 0;                       % Array x position, m
Array.ay = 0;                       % Array y position, m
Array.az = 0;                       % Array z position, m