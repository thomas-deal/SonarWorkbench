%% Array Design
Nw = 5;                                 % Number of elements wide
Nh = 10;                                % Number of elements high
dy = Element.params_m(1);               % Horizontal spacing, m
dz = Element.params_m(2);               % Vertical spacing, m
Array.Ne = Nw*Nh;                       % Number of elements
Array.Net = 1;                          % Homogeneous array
Array.Element = Element;
Array.ex_m = zeros(Array.Ne,1);         % Element x positions, m
Array.ey_m = ...
    repmat((-(Nw-1)/2:(Nw-1)/2)'*dy,Nh,1);                   
                                        % Element y positions, m
Array.ez_m = ...
    reshape(repmat((-(Nh-1)/2:(Nh-1)/2)*dz,Nw,1),Array.Ne,1);   
                                        % Element z positions, m
Array.egamma_deg = zeros(Array.Ne,1);   % Element rolls, deg
Array.etheta_deg = zeros(Array.Ne,1);   % Element elevations, deg
Array.epsi_deg = zeros(Array.Ne,1);     % Element azimuths, deg
Array.ax_m = 0;                         % Array x position, m
Array.ay_m = 0;                         % Array y position, m
Array.az_m = 0;                         % Array z position, m
