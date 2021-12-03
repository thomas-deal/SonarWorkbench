%% Array Design
Nw = 5;                                 % Number of elements wide
Nh = 10;                                % Number of elements high
dy = Element.params_m(1);               % Horizontal spacing, m
dz = Element.params_m(2);               % Vertical spacing, m
Array.Ne = Nw*Nh;                       % Number of elements
Array.Net = 1;                          % Homogeneous array
Array.Element = Element;
Array.ePos_m = [zeros(1,Array.Ne); ...
                repmat((-(Nw-1)/2:(Nw-1)/2)*dy,1,Nh); ...
                reshape(repmat((-(Nh-1)/2:(Nh-1)/2)*dz,Nw,1),1,Array.Ne)];
                                        % Element position matrix, m
Array.eOri_deg = zeros(3,Array.Ne);     % Element oritnation matrix, deg
Array.aPos_m = zeros(3,1);              % Array position matrix, m
Array.aOri_deg = zeros(3,1);            % Array orientation matrix, deg
