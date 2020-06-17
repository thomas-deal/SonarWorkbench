function E = ElementPattern(Element,lambda,theta,psi,gammar,thetar,psir)
%% function E = ElementPattern(Element,lambda,theta,psi,gammar,thetar,psir)
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
%
% Optional Inputs:
%           gammar  - Roll rotation angle, deg
%           thetar  - Elevation rotation angle, deg
%           psir    - Azimuthal rotation angle, deg
%
% Outputs:
%           E       - Element pattern, linear units
%

%% Support for Element Pattern Generator Name
if ischar(Element.type)
    switch Element.type
        case 'OmnidirectionalElement'
            etype = 0;
        case 'CosineElement'
            etype = 1;
        case 'LinearElement'
            etype = 2;
        case 'CircularPistonElement'
            etype = 3;
        case 'RectangularPistonElement'
            etype = 4;
        case 'HexagonalPistonElement'
            etype = 5;
        case 'AnnularPistonElement'
            etype = 6;
        otherwise
            disp(['Element pattern generator ' Element.type '.m does not exist. Using omnidirectional element instead.'])  
            etype = 0;
    end
else
    etype = Element.type;
end
%% Calculate
switch etype
    case 0
        E = OmnidirectionalElement(Element,lambda,theta,psi,gammar,thetar,psir);
    case 1
        E = CosineElement(Element,lambda,theta,psi,gammar,thetar,psir);
    case 2
        E = LinearElement(Element,lambda,theta,psi,gammar,thetar,psir);
    case 3
        E = CircularPistonElement(Element,lambda,theta,psi,gammar,thetar,psir);
    case 4
        E = RectangularPistonElement(Element,lambda,theta,psi,gammar,thetar,psir);
    case 5
        E = HexagonalPistonElement(Element,lambda,theta,psi,gammar,thetar,psir);
    case 6
        E = AnnularPistonElement(Element,lambda,theta,psi,gammar,thetar,psir);
end
