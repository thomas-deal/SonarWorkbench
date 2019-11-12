function Zr = AnnularPistonRadiationImpedance(k,a,b,varargin)
%% function Zr = AnnularPistonRadiationImpedance(k,a,b)
% function Zr = AnnularPistonRadiationImpedance(k,a,b,rho0,c0)
%
% Calculates the radiation impedance for an annular piston element in an
% infinite plane baffle. This formulation uses the convention exp(jkx-jwt) 
% for a plane wave traveling in the +x direction. Conjugate the output for 
% the convention exp(-jkx+jwt).
%
% Inputs:
%           k       - Wavenumber, m^-1
%           a       - Piston outer radius, m
%           b       - Piston inner radius, m
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
Zr = CircularRadiationImpedance(k,a,rho0,c0) - CircularPistonRadiationImpedance(k,b,rho0,c0);