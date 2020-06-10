function Element = AddElementShape(Element)
%% function Element = AddElementShape(Element)
%
% Generates x,y,z coordinates of element face shape for canonical elements.
% Defaults to single point (0,0,0) if input element type is not recognized.
%
% Inputs:
%           Element - Element structure with the following fields
%               [required]
%               .type   - Element pattern generator string
%                         (name of .m file)
%               [optional]
%               .L      - Linear element length, m
%               .axis   - Axis linear element is parallel to before
%                         rotation, 'x','y','z'
%               .a      - Circular piston radius, m
%               .w      - Rectangular piston width, m
%               .h      - Rectangular piston height, m
%               .a      - Hexagonal element inscribed circle radius, m
%
% Outputs:
%           Element - Copy of input Element structure with the added fields
%               .shapex - x coordinates of element shape, m
%               .shapey - y coordinates of element shape, m
%               .shapez - z coordinates of element shape, m
%

%% Initialize
Element.shapex = 0;
Element.shapey = 0;
Element.shapez = 0;
%% Check Input
if ~isfield(Element,'type')
    disp('Element type not defined in Element.type. Exiting.')
    return
end
%% Generate Shape
switch Element.type
    case 'OmnidirectionalElement'
        % Use default
    case 'LinearElement'
        if ~isfield(Element,'axis')
            disp('Linear element aligned axis not defined in Element.axis. Aligning element with z axis.')
            Element.axis = 'z';
        end
        switch Element.axis
            case 'x'
                Element.shapex = Element.L/2*[-1 1];
                Element.shapey = [0 0];
                Element.shapez = [0 0];
            case 'y'
                Element.shapex = [0 0];
                Element.shapey = Element.L/2*[-1 1];
                Element.shapez = [0 0];
            case 'z'
                Element.shapex = [0 0];
                Element.shapey = [0 0];
                Element.shapez = Element.L/2*[-1 1];
        end
    case 'CosineElement'
        % Use default
    case 'CircularPistonElement'
        if ~isfield(Element,'a')
            disp('Circular piston element radius not defined in Element.a. Using default radius 1 cm.')
            Element.a = 0.01;
        end
        Element.shapex = zeros(1,361);
        Element.shapey = Element.a*cosd(0:360);
        Element.shapez = Element.a*sind(0:360);
    case 'RectangularPistonElement'
        if ~isfield(Element,'w')
            if ~isfield(Element,'h')
                disp('Rectangular piston element width and height not defined in Element.w and Element.h. Using default values of 1 cm.')
                Element.w = 0.01;
                Element.h = 0.01;
            else
                disp(['Rectangular piston element width not defined in Element.w. Using element height ' num2str(Element.h*100) ' cm.'])
                Element.w = Element.h;
            end
        end
        if ~isfield(Element,'h')
            if ~isfield(Element,'w')
                disp('Rectangular piston element width and height not defined in Element.w and Element.h. Using default values of 1 cm.')
                Element.w = 0.01;
                Element.h = 0.01;
            else
                disp(['Rectangular piston element height not defined in Element.h. Using element width ' num2str(Element.w*100) ' cm.'])
                Element.h = Element.w;
            end
        end    
        Element.shapex = zeros(1,5);
        Element.shapey = Element.w/2*[-1 1 1 -1 -1];
        Element.shapez = Element.h/2*[-1 -1 1 1 -1];
    case 'AnnularPistonElement'
        if ~isfield(Element,'a')
            if ~isfield(Element,'b')
                disp('Annular piston element outer and inner radii not defined in Element.a and Element.b. Using default radii 1 cm and 0.75 cm.')
                Element.a = 0.01;
                Element.b = 0.0075;
            else
                disp(['Annular piston element outer radius not defined in Element.a. Using default outer radius 4/3*inner radius = ' num2str(4/3*Element.b*100) ' cm.'])
                Element.a = 4/3*Element.b;
            end
        end
        if ~isfield(Element,'b')
            if ~isfield(Element,'a')
                disp('Annular piston element outer and inner radii not defined in Element.a and Element.b. Using default radii 1 cm and 0.75 cm.')
                Element.a = 0.01;
                Element.b = 0.0075;
            else
                disp(['Annular piston element inner radius not defined in Element.b. Using default inner radius 3/4*outer radius = ' num2str(3/4*Element.a*100) ' cm.'])
                Element.b = 3/4*Element.a;
            end
        end
        Element.shapex = zeros(1,2*361+1);
        Element.shapey = [Element.a*sind(0:360) Element.b*sind(360:-1:0) Element.a*sind(0)];
        Element.shapez = [Element.a*cosd(0:360) Element.b*cosd(360:-1:0) Element.a*cosd(0)];
    case 'HexagonalPistonElement'
        if ~isfield(Element,'a')
            disp('Hexagonal piston element inscribed circle radius not defined in Element.a. Using default radius 1 cm.')
            Element.a = 0.01;
        end
        Element.shapex = zeros(1,7);
        Element.shapey = 2/sqrt(3)*Element.a*cosd(30:60:390);
        Element.shapez = 2/sqrt(3)*Element.a*sind(30:60:390);
    otherwise
        disp(['Element type ' Element.type ' not recognized.'])
        Element.shapex = 0;
        Element.shapey = 0;
        Element.shapez = 0;
end