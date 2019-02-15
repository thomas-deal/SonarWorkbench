function D = BeamPattern(ex,ey,ez,epsi,etheta,ew,etype,baffle,psi,theta,lambda,varargin)
%% function D = BeamPattern(ex,ey,ez,epsi,etheta,ew,etype,baffle,psi,theta,lambda)
% function D = BeamPattern(ex,ey,ez,epsi,etheta,ew,etype=0,baffle,psi,theta,lambda)
% function D = BeamPattern(ex,ey,ez,epsi,etheta,ew,etype=1,baffle,psi,theta,lambda,a)
% function D = BeamPattern(ex,ey,ez,epsi,etheta,ew,etype=2,baffle,psi,theta,lambda,w,h)
% function D = BeamPattern(ex,ey,ez,epsi,etheta,ew,etype=3,baffle,psi,theta,lambda,a,rotate)
%
% Computes the beam pattern for an array of identical elements at
% coordinates (ex,ey,ez) rotated (epsi,etheta) from the x axis with complex
% element weights ew at wavelength lambda over azimuthal angles psi and
% elevation angles theta. Supported element types are omnidirectional,
% circular piston, rectangular piston, and hexagonal piston. When element
% parameters are not specified, default values are used which assume half
% wavelength dimensions for all elements.
%
% Inputs:
%           ex      - Element x position vector, m
%           ey      - Element y position vector, m
%           ez      - Element z position vector, m
%           epsi    - Element normal azimuth vector, deg
%           etheta  - Element normal elevation vector, deg
%           ew      - Complex element weight vector
%           etype   - Element type enumeration
%                     0 = omnidirectional
%                     1 = circular plane piston
%                     2 = rectangular plane piston
%                     3 = hexagonal plane piston
%           baffle  - Element baffle enumeration
%                     0 = No baffle
%                     1 = Hard baffle
%                     2 = Raised cosine baffle
%           psi     - Azimuthal angle vector, deg
%           theta   - Elevation angle vector, deg
%           lambda  - Acoustic wavelength, m
% 
% Optional Inputs:
%           a       - Circular piston diameter, m
%           w       - Rectangular piston width, m
%           h       - Rectangular piston height, m
%           a       - Hexagonal element inscribed circle radius, m
%           rotate  - Hexagonal element rotation, see 
%                     HexagonalPistonElement.m for details
%
% Outputs:
%           D       - Beam pattern, complex linear units
%

%% Check Input Arguments
a = lambda/4;
w = lambda/2;
h = lambda/2;
rotate = 0;
switch etype
    case 1
        if nargin==12&&~isempty(varargin{1})
            a = varargin{1};
        end
    case 2
        if nargin==13
            if ~isempty(varargin{1})
                w = varargin{1};
            end
            if ~isempty(varargin{2})
                h = varargin{2};
            end
        end
    case 3
        if nargin>=12
            if ~isempty(varargin{1})
                a = varargin{1};
            end
            if nargin==13&&~isempty(varargin{2})
                rotate = varargin{2};
            end
        end
end
baffle = max(min(baffle,2),0);
%% Computational Grid
[Theta,Psi] = ndgrid(theta,psi);
fx = cosd(-Theta).*cosd(Psi)/lambda;
fy = cosd(-Theta).*sind(Psi)/lambda;
fz = sind(-Theta)/lambda;
%% Compute Beam Pattern
psilast = NaN;
thetalast = NaN;
D = zeros(size(Psi));
Ne = length(ex);
hwait = waitbar(0,'Processing');
set(hwait,'Name','BeamPattern')
for i=1:Ne
    waitbar(i/Ne,hwait,['Processing Element ' num2str(i) '/' num2str(Ne)]);
    if(epsi(i)~=psilast)||(etheta(i)~=thetalast)
        psilast = epsi(i);
        thetalast = etheta(i);
        switch etype
            case 0     
                E = OmnidirectionalElement(psi-epsi(i),theta-etheta(i));
            case 1
                E = CircularPistonElement(psi-epsi(i),theta-etheta(i),lambda,a);
            case 2
                E = RectangularPistonElement(psi-epsi(i),theta-etheta(i),lambda,w,h);
            case 3
                E = HexagonalPistonElement(psi-epsi(i),theta-etheta(i),lambda,a,rotate);
        end
        if baffle>0
            % Baffle element with array structure
            Phi = acosd(cosd(Psi-epsi(i)).*cosd(Theta-etheta(i)));
            switch baffle
                case 1      % Hard baffle
                    Baf = ones(size(E));
                    Baf(Phi>90) = eps;
                case 2      % Raised cosine baffle
                    Baf = 1/2+1/2*cosd(4*Phi);
                    Baf(Phi<=90) = 1;
                    Baf(Phi>135) = eps;
                otherwise   % No baffle
                    Baf = ones(size(E));
            end
            E = E.*Baf;
        end
    end
    D = D + ew(i)*E.*exp(1i*2*pi*fx*ex(i)).*exp(1i*2*pi*fy*ey(i)).*exp(1i*2*pi*fz*ez(i));
end
close(hwait)
%% Normalize
D = D/sum(abs(ew));