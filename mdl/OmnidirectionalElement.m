function E = OmnidirectionalElement(Element,lambda,psi,theta,varargin) %#ok<INUSL>
%% function E = OmnidirectionalElement(Element,lambda,psi,theta)
% function E = OmnidirectionalElement(Element,lambda,psi,theta,lambda,gammar,thetar,psir)
%
% Calculates the element pattern for an omnidirectional sensor over 
% azimuthal angles psi and elevation angles theta.
%
% Inputs:
%           Element - Element structure with the following fields
%               .type   - Element type string
%               .baffle - Element baffle enumeration
%                         0 = no baffle
%                         1 = hard baffle
%                         2 = raised cosine baffle
%           lambda  - Acoustic wavelength, m (unused)
%           psi     - Azimuthal angle vector or matrix, deg
%           theta   - Elevation angle vector or matrix, deg
%
% Optional Inputs:
%           gammar  - Roll rotation angle, deg
%           thetar  - Elevation rotation angle, deg
%           psir    - Azimuthal rotation angle, deg
%
% Outputs:
%           E       - Element pattern, linear units
%

%% Check Input Dimensions
resize = 0;
thetaSize = size(theta);
psiSize = size(psi);
if min(thetaSize)==1
    if min(psiSize)==1
        resize = 1;
    else
        disp('OmnidirectionalElement: Inputs psi and theta have incompatible dimensions')
        return
    end
else
    if min(psiSize)==1
        disp('OmnidirectionalElement: Inputs psi and theta have incompatible dimensions')
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
if isfield(Element,'baffle')
    if ~isempty(Element.baffle)
        baffle = Element.baffle;
    end
end
%% Rotate Computational Grid
X0 = cosd(-Theta).*cosd(Psi);
Y0 = cosd(-Theta).*sind(Psi);
Z0 = sind(-Theta);
ROT = RotationMatrix(gammar,thetar,psir)';
X = ROT(1,1)*X0 + ROT(1,2)*Y0 + ROT(1,3)*Z0;
Y = ROT(2,1)*X0 + ROT(2,2)*Y0 + ROT(2,3)*Z0;
Z = ROT(3,1)*X0 + ROT(3,2)*Y0 + ROT(3,3)*Z0;
Theta = -asind(Z);
Psi = atan2d(Y,X);
%% Calculate Element Pattern
E = ones(size(Theta));
%% Baffle Pattern
if baffle>0
    Baf = ComputeBaffle(baffle,Psi,Theta);
    E = E.*Baf;
end