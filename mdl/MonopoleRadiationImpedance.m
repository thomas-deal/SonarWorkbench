function Zr = MonopoleRadiationImpedance(k,a,varargin)
%% function Zr = MonopoleRadiationImpedance(k,a)
% function Zr = MonopoleRadiationImpedance(k,a,rho0,c0)
%
% Calculates the radiation impedance for an oscillating spherical element
% operating as a monopole source. This formulation uses the convention 
% exp(jkx-jwt) for a plane wave traveling in the +x direction. Conjugate 
% the output for the convention exp(-jkx+jwt).
%
% Inputs:
%           k       - Wavenumber, m^-1
%           a       - Sphere radius, m
%
% Optional Inputs:
%           rho0    - Water density, kg/m^3
%           c0      - Water sound speed, m/s
%
% Outputs:
%           Zr      - Complex radiation impedance, kg/s
%

%% Check Input Arguments
% Default values
rho0 = 1e3;
c0 = 1500;
switch nargin
    case 3
        if ~isempty(varargin{1})
            rho0 = varargin{1};
        end
    case 4
        if ~isempty(varargin{1})
            rho0 = varargin{1};
        end
        if ~isempty(varargin{2})
            c0 = varargin{2};
        end
end
%% Calculate
Zr = rho0*c0*4*pi*a.^2./(1-1./(1i*k.*a));
Zr(k==0) = 0;