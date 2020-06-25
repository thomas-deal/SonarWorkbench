function E = ElementPattern(Element,eindex,lambda,theta,psi,gammar,thetar,psir)
%% function E = ElementPattern(Element,eindex,lambda,theta,psi,gammar,thetar,psir)
%
% Calculates the element pattern for one of the built-in types at 
% wavelength lambda over azimuthal angles psi and elevation angles theta.
%
% Inputs:
%           Element - Element structure with the following fields
%               .type   - Element type string or enumeration
%           eindex  - Index of element for heterogrneous arrays
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

%% Select Element
if eindex > length(Element.type)
    disp('ElementPattern: Not enough elements defined for non-uniform array, reverting to uniform array of type Element(1)')
	eindex = 1;
end
thisElement.type = Element.type(eindex);
if isfield(Element,'baffle')
    thisElement.baffle = Element.baffle(eindex);
else
    thisElement.baffle = 0;
end
if isfield(Element,'a')
    thisElement.a = Element.a(eindex);
end
if isfield(Element,'b')
    thisElement.b = Element.b(eindex);
end
if isfield(Element,'w')
    thisElement.w = Element.w(eindex);
end
if isfield(Element,'h')
    thisElement.h = Element.h(eindex);
end
if isfield(Element,'L')
    thisElement.L = Element.L(eindex);
end
if isfield(Element,'axis')
    thisElement.axis = Element.axis(eindex);
end
%% Support for Element Pattern Generator Name
if ischar(thisElement.type)
    switch thisElement.type
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
            disp(['Element pattern generator ' thisElement.type '.m does not exist. Using omnidirectional element instead.'])  
            etype = 0;
    end
else
    etype = thisElement.type;
end
%% Calculate
switch etype
    case 0
        E = OmnidirectionalElement(thisElement,lambda,theta,psi,gammar,thetar,psir);
    case 1
        E = CosineElement(thisElement,lambda,theta,psi,gammar,thetar,psir);
    case 2
        E = LinearElement(thisElement,lambda,theta,psi,gammar,thetar,psir);
    case 3
        E = CircularPistonElement(thisElement,lambda,theta,psi,gammar,thetar,psir);
    case 4
        E = RectangularPistonElement(thisElement,lambda,theta,psi,gammar,thetar,psir);
    case 5
        E = HexagonalPistonElement(thisElement,lambda,theta,psi,gammar,thetar,psir);
    case 6
        E = AnnularPistonElement(thisElement,lambda,theta,psi,gammar,thetar,psir);
end
