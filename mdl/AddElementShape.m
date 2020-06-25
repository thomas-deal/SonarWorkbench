function Element = AddElementShape(Element,eindex)
%% function Element = AddElementShape(Element,eindex)
%
% Generates x,y,z coordinates of element face shape for canonical elements.
% Defaults to single point (0,0,0) if input element type is not recognized.
%
% Inputs:
%           Element - Element structure with the following fields
%               [required]
%               .type   - Element type enumeration
%               [optional]
%               .L      - Linear element length, m
%               .axis   - Axis linear element is parallel to before
%                         rotation, 0=x,1=y,2=z
%               .a      - Circular piston radius, m
%               .w      - Rectangular piston width, m
%               .h      - Rectangular piston height, m
%               .a      - Hexagonal element inscribed circle radius, m
%           eindex  - Index of element for heterogrneous arrays
%
% Outputs:
%           Element - Copy of input Element structure with the added fields
%               .shapex{eindex} - x coordinates of element shape, m
%               .shapey{eindex} - y coordinates of element shape, m
%               .shapez{eindex} - z coordinates of element shape, m
%

%% Check Inputs
if nargin==1
    eindex = 1;
else
    if isempty(eindex)
        eindex = 1;
    end
end
%% Initialize
Element.shapex{eindex} = 0;
Element.shapey{eindex} = 0;
Element.shapez{eindex} = 0;
%% Check Input
if ~isfield(Element,'type')
    disp('Element type not defined in Element.type. Exiting.')
    return
end
%% Generate Shape
switch Element.type(eindex)
    case 0      % Omnidirectional Element
        % Use default
    case 1      % Cosine Element
        % Use default
    case 2      % Linear Element
        if ~isfield(Element,'axis')
            disp('Linear element aligned axis not defined in Element.axis. Aligning element with z axis.')
            Element.axis = 2;
        end
        switch Element.axis
            case 0
                Element.shapex{eindex} = Element.L/2*[-1 1];
                Element.shapey{eindex} = [0 0];
                Element.shapez{eindex} = [0 0];
            case 1
                Element.shapex{eindex} = [0 0];
                Element.shapey{eindex} = Element.L/2*[-1 1];
                Element.shapez{eindex} = [0 0];
            case 2
                Element.shapex{eindex} = [0 0];
                Element.shapey{eindex} = [0 0];
                Element.shapez{eindex} = Element.L/2*[-1 1];
        end
    case 3      % Circular Piston Element
        if ~isfield(Element,'a')
            disp('Circular piston element radius not defined in Element.a. Using default radius 1 cm.')
            Element.a = 0.01;
        end
        Element.shapex{eindex} = zeros(1,361);
        Element.shapey{eindex} = Element.a*cosd(0:360);
        Element.shapez{eindex} = Element.a*sind(0:360);
    case 4      % Rectangular Piston Element
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
        Element.shapex{eindex} = zeros(1,5);
        Element.shapey{eindex} = Element.w/2*[-1 1 1 -1 -1];
        Element.shapez{eindex} = Element.h/2*[-1 -1 1 1 -1];
    case 5      % Hexagonal Piston Element
        if ~isfield(Element,'a')
            disp('Hexagonal piston element inscribed circle radius not defined in Element.a. Using default radius 1 cm.')
            Element.a = 0.01;
        end
        Element.shapex{eindex} = zeros(1,7);
        Element.shapey{eindex} = 2/sqrt(3)*Element.a*cosd(30:60:390);
        Element.shapez{eindex} = 2/sqrt(3)*Element.a*sind(30:60:390);
    case 6      % Annular Piston Element
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
        Element.shapex{eindex} = zeros(1,2*361+1);
        Element.shapey{eindex} = [Element.a*sind(0:360) Element.b*sind(360:-1:0) Element.a*sind(0)];
        Element.shapez{eindex} = [Element.a*cosd(0:360) Element.b*cosd(360:-1:0) Element.a*cosd(0)];
    otherwise
        disp(['Element type ' num2str(Element.type(eindex)) ' not recognized.'])
        Element.shapex{eindex} = 0;
        Element.shapey{eindex} = 0;
        Element.shapez{eindex} = 0;
end