function E = ElementPattern(Element,lambda,theta,psi,ori)
%% function E = ElementPattern(Element,lambda,theta,psi,ori)
%
% Calculates the element pattern for one of the built-in types at 
% wavelength lambda over azimuthal angles psi and elevation angles theta.
%
% Inputs:
%           Element - Element structure with the following fields
%               .type   - Element type string or enumeration
%           lambda  - Acoustic wavelength, 1/m
%           theta   - Elevation angle vector or matrix, deg
%           psi     - Azimuthal angle vector or matrix, deg
%           ori     - Element normal orientation vector, deg
%
% Outputs:
%           E       - Element pattern, linear units
%

%% Calculate
switch Element.type
    case 0
        E = OmnidirectionalElement(Element,lambda,theta,psi,ori);
    case 1
        E = CosineElement(Element,lambda,theta,psi,ori);
    case 2
        E = LinearElement(Element,lambda,theta,psi,ori);
    case 3
        E = CircularPistonElement(Element,lambda,theta,psi,ori);
    case 4
        E = RectangularPistonElement(Element,lambda,theta,psi,ori);
    case 5
        E = HexagonalPistonElement(Element,lambda,theta,psi,ori);
    case 6
        E = AnnularPistonElement(Element,lambda,theta,psi,ori);
    otherwise
        E = OmnidirectionalElement(Element,lambda,theta,psi,ori);
end
