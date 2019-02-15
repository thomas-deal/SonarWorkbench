function C = IdealSurfaceNoiseCSD(x1,y1,z1,x2,y2,z2,B1,B2,psi,theta,lambda,varargin)
%% function C = IdealSurfaceNoiseCSD(x1,y1,z1,x2,y2,z2,B1,B2,psi,theta,lambda)
% function C = IdealSurfaceNoiseCSD(x1,y1,z1,x2,y2,z2,B1,B2,psi,theta,lambda,nord)
%
% Computes the cross-spectral density for two sensors located at
% coordinates (x1,y1,z1) and (x2,y2,z2) with beam patterns B1 and B2 at
% wavelength lambda defined over azimuthal angles psi and elevation angles
% theta.
%
% Inputs:
%           x1          - Beam 1 x coordinate, m
%           y1          - Beam 1 y coordinate, m
%           z1          - Beam 1 z coordinate, m
%           x2          - Beam 2 x coordinate, m
%           y2          - Beam 2 y coordinate, m
%           z2          - Beam 2 z coordinate, m
%           B1          - Beam 1 pattern, complex linear units
%           B2          - Beam 2 pattern, complex linear units
%           psi         - Azimuthal angle vector, deg
%           theta       - Elevation angle vector, deg
%           lambda      - Acoustic wavelength, m
%
% Optional Inputs:
%           nord        - Surface noise source order
%
% Outputs:
%           C           - Complex cross-spectral density
%

%% Check Input Arguments
nord = 1;
switch nargin
    case 12
        if ~isempty(varargin{1})
            nord = varargin{1};
        end
end
%% Computational Grid
[Theta,Psi] = ndgrid(theta,psi);
%% Define Element Patterns over Positive Elevation Angles
thp = theta(thea>=0)'*pi/180;
Thp = Theta(theta>=0,:)*pi/180;
Psp = Psi(theta>=0,:)*pi/180;
B1p = B1(theta>=0,:);
B2p = B2(theta>=0,:);
%% Compute Cross-Spectral Density
k = 2*pi/lambda;
dtheta = diff(theta(1:2))*pi/180;
dpsi = diff(psi(1:2))*pi/180;
dx = x2-x1;
dy = y2-y1;
dz = z2-z1;
zeta = atan2(dy,dx);
C = 1/pi*trapz(sin(thp).^(2*nord-1).*cos(thp).*exp(-1i*k*dz*sin(thp)).* ...
    trapz(B1p.*B2p.*exp(-1i*k*dy*cos(Thp).*cos(Psp-zeta))*dpsi,2)*dtheta,1);