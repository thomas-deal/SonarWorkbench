function E = LinearElement(Element,lambda,theta,psi,varargin)
%% function E = LinearElement(Element,lambda,theta,psi)
% function E = LinearElement(Element,lambda,theta,psi,gammar,thetar,psir)
%
% Calculates the element pattern for an ideal linear element of length L at
% wavelength lambda over azimuthal angles psi and elevation angles theta.
%
% Inputs:
%           Element - Element structure with the following fields
%               .type       - Element type string
%               .baffle     - Element baffle enumeration
%                             0 = No baffle
%                             1 = Hard baffle
%                             2 = Raised cosine baffle
%                             3 = Torpedo nose baffle
%               .params_m   - Element shape parameter vector
%                             params_m(1) = Linear element length if
%                                           parallel to x axis, m
%                             params_m(2) = Linear element length if
%                                           parallel to y axis, m
%                             params_m(3) = Linear element length if
%                                           parallel to z axis, m
%           lambda  - Acoustic wavelength, 1/m
%           theta   - Elevation angle vector or matrix, deg
%           psi     - Azimuthal angle vector or matrix, deg
%
% Optional Inputs:
%           gammar  - Roll rotation angle, deg
%           thetar  - Elevation rotation angle, deg
%           psir    - Azimuthal rotation angle, deg
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
eaxis = 2;
baffle = 0;
gammar = 0;
thetar = 0;
psir = 0;
if nargin==7
    if ~isempty(varargin{1})
        gammar = varargin{1};
    end
    if ~isempty(varargin{2})
        thetar = varargin{2};
    end
    if ~isempty(varargin{3})
        psir = varargin{3};
    end
end
if Element.params_m(1)~=0
    L = Element.params_m(1);
    eaxis = 0;
elseif Element.params_m(2)~=0
    L = Element.params_m(2);
    eaxis = 1;
elseif Element.params_m(3)~=0
    L = Element.params_m(3);
    eaxis = 2;
end
if isfield(Element,'baffle')
    if ~isempty(Element.baffle)
        baffle = Element.baffle;
    end
end
%% Rotate Computational Grid
[Theta,Psi] = RotateComputationalGrid(Theta,Psi,gammar,thetar,psir);
%% Spatial Grid
fx = cosd(-Theta).*cosd(Psi)/lambda;
fy = cosd(-Theta).*sind(Psi)/lambda;
fz = sind(-Theta)/lambda;
%% Calculate Element Pattern
switch eaxis
    case 0
        fL = fx;
    case 1
        fL = fy;
    case 2
        fL = fz;
    otherwise
        disp('LinearElement: invalid setting for Element.axis. Using default z axis.');
        fL = fz;
end
E = sinc(fL*L);
%% Baffle Pattern
if baffle>0
    Baf = ComputeBaffle(baffle,Theta,Psi);
    E = E.*Baf;
end
