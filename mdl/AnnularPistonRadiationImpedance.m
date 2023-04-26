function Zr = AnnularPistonRadiationImpedance(k,a,b,rho0,c0)
%% function Zr = AnnularPistonRadiationImpedance(k,a,b,rho0,c0)
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
%           rho0    - Water density, kg/m^3
%           c0      - Water sound speed, m/s
%
% Outputs:
%           Zr      - Complex radiation impedance, kg/s
%

%% Check Inputs
if nargin<5
    c0 = 1500;
end
if nargin<4
    rho0 = 1000;
end
%% Calculate
Zr = CircularRadiationImpedance(k,a,rho0,c0) - CircularPistonRadiationImpedance(k,b,rho0,c0);