function E = CosineElement(Element,lambda,theta,psi,ori) %#ok<INUSL>
%% function E = CosineElement(Element,lambda,theta,psi,ori)
%
% Calculates the element pattern for a sensor with cosine directivity over 
% azimuthal angles psi and elevation angles theta.
%
% Inputs:
%           Element - Element structure with the following fields
%               .type   - Element type string
%               .baffle - Element baffle enumeration
%                         0 = No baffle
%                         1 = Hard baffle
%                         2 = Raised cosine baffle
%                         3 = Torpedo nose baffle
%           lambda  - Acoustic wavelength, m (unused)
%           theta   - Elevation angle vector or matrix, deg
%           psi     - Azimuthal angle vector or matrix, deg
%           ori     - Element normal orientation vector, deg
%
% Outputs:
%           E       - Element pattern, linear units
%

%% Initialize
E = 1;
%% Check Input Dimensions
[Theta, Psi] = GenerateGrid(theta,psi,'CosineElement');
if any([isnan(Theta(:)) isnan(Psi(:))])
    return
end
%% Check Input Arguments
baffle = int32(0);
if nargin<5
    ori = [0;0;0];
end
if isfield(Element,'baffle')
    if ~isempty(Element.baffle)
        baffle = int32(Element.baffle);
    end
end
%% Rotate Computational Grid
[Theta,Psi] = RotateComputationalGrid(Theta,Psi,ori);
%% Calculate Element Pattern
E = cosd(Psi).*cosd(Theta);
%% Baffle Pattern
if baffle>int32(0)
    Baf = ComputeBaffle(baffle,Theta,Psi);
    E = E.*Baf;
end
