function E = LinearElement(Element,lambda,psi,theta,varargin)
%% function E = LinearElement(Element,lambda,psi,theta)
% function E = LinearElement(Element,lambda,psi,theta,psir,thetar)
%
% Calculates the element pattern for an ideal linear element of length L at
% wavelength lambda over azimuthal angles psi and elevation angles theta.
%
% Inputs:
%           Element - Element structure with the following fields
%               .type   - Element type string
%               .baffle - Element baffle enumeration
%                         0 = no baffle
%                         1 = hard baffle
%                         2 = raised cosine baffle
%               .L      - Linear element length, m
%               .axis   - Axis element is parallel to before rotation,
%                         'x','y','z'
%           lambda  - Acoustic wavelength, 1/m
%           psi     - Azimuthal angle vector or matrix, deg
%           theta   - Elevation angle vector or matrix, deg
%
% Optional Inputs:
%           psir    - Azimuthal rotation angle, deg
%           thetar  - Elevation rotation angle, deg
%
% Outputs:
%           E       - Element pattern, linear units
%

%% Initialize
E = 1;
%% Check Input Dimensions
resize = 0;
thetaSize = size(theta);
psiSize = size(psi);
if min(thetaSize)==1
    if min(psiSize)==1
        resize = 1;
    else
        disp('LinearElement: Inputs psi and theta have incompatible dimensions')
        return
    end
else
    if min(psiSize)==1
        disp('LinearElement: Inputs psi and theta have incompatible dimensions')
        return
    end
end
if resize
    [Theta,Psi] = ndgrid(theta,psi);
else
    Theta = theta;
    Psi = psi;
end
%% Check Input Arguments
L = lambda/2;
eaxis = 'z';
baffle = 0;
psir = 0;
thetar = 0;
if nargin==6
    if ~isempty(varargin{1})
        psir = varargin{1};
    end
    if ~isempty(varargin{2})
        thetar = varargin{2};
    end
end
if isfield(Element,'L')
    if ~isempty(Element.L)
        L = Element.L;
    end
end
if isfield(Element,'axis')
    if ~isempty(Element.axis)
        eaxis = Element.axis;
    end
end
if isfield(Element,'baffle')
    if ~isempty(Element.baffle)
        baffle = Element.baffle;
    end
end
%% Rotate Computational Grid
X = cosd(thetar)*cosd(Theta).*cosd(Psi-psir) + sind(thetar)*sind(Theta);
Y = cosd(Theta).*sind(Psi-psir);
Z = sind(thetar)*cosd(Theta).*cosd(Psi-psir) - cosd(thetar)*sind(Theta);
Theta = -asind(Z);
Psi = atan2d(Y,X);
%% Spatial Grid
fx = cosd(-Theta).*cosd(Psi)/lambda;
fy = cosd(-Theta).*sind(Psi)/lambda;
fz = sind(-Theta)/lambda;
%% Calculate Element Pattern
switch eaxis
    case 'x'
        fL = fx;
    case 'y'
        fL = fy;
    case 'z'
        fL = fz;
end
E = sinc(fL*L);
%% Baffle Pattern
if baffle>0
    Baf = ComputeBaffle(baffle,Psi,Theta);
    E = E.*Baf;
end