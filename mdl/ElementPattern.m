function E = ElementPattern(Element,lambda,theta,psi,gammar,thetar,psir)
%% function E = ElementPattern(Element,lambda,theta,psi,gammar,thetar,psir)
%
% Calculates the element pattern for one of the built-in types at 
% wavelength lambda over azimuthal angles psi and elevation angles theta.
%
% Inputs:
%           Element - Element structure with the following fields
%               .type   - Element type string
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

%% Calculate
switch Element.type
    case 'AnnularPistonElement'
        E = AnnularPistonElement(Element,lambda,theta,psi,gammar,thetar,psir);
    case 'CircularPistonElement'
        E = CircularPistonElement(Element,lambda,theta,psi,gammar,thetar,psir);
    case 'CosineElement'
        E = CosineElement(Element,lambda,theta,psi,gammar,thetar,psir);
    case 'HexagonalPistonElement'
        E = HexagonalPistonElement(Element,lambda,theta,psi,gammar,thetar,psir);
    case 'LinearElement'
        E = LinearElement(Element,lambda,theta,psi,gammar,thetar,psir);
    case 'OmnidirectionalElement'
        E = OmnidirectionalElement(Element,lambda,theta,psi,gammar,thetar,psir);
    case 'RectangularPistonElement'
        E = RectangularPistonElement(Element,lambda,theta,psi,gammar,thetar,psir);
    otherwise
        disp(['Element pattern generator ' Element.type '.m does not exist. Using omnidirectional element instead.'])               
        E = OmnidirectionalElement(Element,lambda,theta,psi,gammar,thetar,psir); 
end
