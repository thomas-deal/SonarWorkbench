function [shapex, shapey, shapez] = ElementShape(Element)
%% function [shapex, shapey, shapez] = ElementShape(Element)
%
% Generates x,y,z coordinates of element face shape for canonical elements.
% Defaults to single point (0,0,0) if input element type is not recognized.
%
% Inputs:
%           Element     - Element structure with the following required fields
%               .type       - Element pattern generator enumeration
%               .params_m   - Element shape parameter vector
%                             Linear element:
%                             params_m(1) = Linear element length if
%                                           parallel to x axis, m
%                             params_m(2) = Linear element length if
%                                           parallel to y axis, m
%                             params_m(3) = Linear element length if
%                                           parallel to z axis, m
%                             Circular Piston Element:
%                             params_m(1) = Circular piston radius, m
%                             Rectangular Piston Element:
%                             params m(1) = Rectangular piston width, m
%                             params_m(2) = Rectangular piston height, m
%                             Hexagonal Piston Element:
%                             params_m(1) = Hexagonal element inscribed
%                                           circle radius, m
%                             Annular Piston Element:
%                             params_m(1) = Element outer radius, m
%                             params_m(2) = Element inner radius, m
%
% Outputs:
%           shapex - x coordinates of element shape, m
%           shapey - y coordinates of element shape, m
%           shapez - z coordinates of element shape, m
%

%% Initialize
shapex = 0;
shapey = 0;
shapez = 0;
%% Check Input
if ~isfield(Element,'type')
    disp('Element type not defined in Element.type. Exiting.')
    return
end
%% Generate Shape
switch Element.type
    case 0      % Omnidirectional Element
        % Use default
    case 1      % Cosine Element
        % Use default
    case 2      % Linear Element
        L = 0.01;
        eaxis = 'z';
        if Element.params_m(1)~=0
            L = Element.params_m(1);
            eaxis = 'x';
        elseif Element.params_m(2)~=0
            L = Element.params_m(2);
            eaxis = 'y';
        elseif Element.params_m(3)~=0
            L = Element.params_m(3);
            eaxis = 'z';
        end
        switch eaxis
            case 0
                shapex = L/2*[-1 1];
                shapey = [0 0];
                shapez = [0 0];
            case 1
                shapex = [0 0];
                shapey = L/2*[-1 1];
                shapez = [0 0];
            case 2
                shapex = [0 0];
                shapey = [0 0];
                shapez = L/2*[-1 1];
        end
    case 3      % Circular Piston Element
        a = 0.01;
        if Element.params_m(1)~=0
            a = Element.params_m(1);
        end
        shapex = zeros(1,361);
        shapey = a*cosd(0:360);
        shapez = a*sind(0:360);
    case 4      % Rectangular Piston Element
        w = 0.01;
        h = 0.01;
        if Element.params_m(1)~=0
            w = Element.params_m(1);
        end
        if Element.params_m(2)~=0
            h = Element.params_m(2);
        end  
        shapex = zeros(1,5);
        shapey = w/2*[-1 1 1 -1 -1];
        shapez = h/2*[-1 -1 1 1 -1];
    case 5      % Hexagonal Piston Element
        a = 0.01;
        if Element.params_m(1)~=0
            a = Element.params_m(1);
        end
        shapex = zeros(1,7);
        shapey = 2/sqrt(3)*a*cosd(30:60:390);
        shapez = 2/sqrt(3)*a*sind(30:60:390);
    case 6      % Annular Piston Element
        a = 0.01;
        b = 0.0075;
        if Element.params_m(1)~=0
            a = Element.params_m(1);
        end
        if Element.params_m(2)~=0
            b = Element.params_m(2);
        end
        shapex = zeros(1,2*361+1);
        shapey = [a*sind(0:360) b*sind(360:-1:0) a*sind(0)];
        shapez = [a*cosd(0:360) b*cosd(360:-1:0) a*cosd(0)];
    otherwise
        disp(['Element type ' num2str(Element.type) ' not recognized.'])
        shapex = 0;
        shapey = 0;
        shapez = 0;
end
