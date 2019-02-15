function phiq = Interp2Bearing(u,v,phi,uq,vq)
%% function phiq = Interp1Bearing(u,v,phi,uq,vq)
%
% Interpolates bearing data accounting for 360 degree wraparound. Output is
% in the range (-180, 180].
%
% Inputs:
%           u       - Horizontal axis independent variable for bearing data
%           v       - Vertical axis independent variable for bearing data
%           phi     - Bearing data, deg
%           uq      - Horizontal points to evaluate bearing data
%           uq      - Vertical points to evaluate bearing data
%
% Outputs:
%           phiq    - Interpolated bearing, deg
%

%% Convert to x/y
x = cosd(phi);
y = sind(phi);
%% Interpolate
xq = interp2(u,v,x,uq,vq,'linear',0);
yq = interp2(u,v,y,uq,vq,'linear',0);
%% Convert to Bearing
phiq = atan2d(yq,xq);