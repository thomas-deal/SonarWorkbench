function phiq = Interp1Bearing(u,phi,uq)
%% function phiq = Interp1Bearing(u,phi,uq)
%
% Interpolates bearing data accounting for 360 degree wraparound. Output is
% in the range (-180, 180].
%
% Inputs:
%           u       - Independent variable for bearing data
%           phi     - Bearing data, deg
%           uq      - Pointe to evaluate bearing data
%
% Outputs:
%           phiq    - Interpolated bearing, deg
%

%% Convert to x/y
x = cosd(phi);
y = sind(phi);
%% Interpolate
xq = interp1(u,x,uq,'linear','extrap');
yq = interp1(u,y,uq,'linear','extrap');
%% Convert to Bearing
phiq = atan2d(yq,xq);