function Zr = HexagonalPistonRadiationImpedance(k,a,rho0,c0)
%% function Zr = HexagonalPistonRadiationImpedance(k,a,rho0,c0)
%
% Calculates the radiation impedance for a hexagonal piston element in an
% infinite plane baffle, approximated by that for a circular piston with 
% equal surface area. This formulation uses the convention exp(jkx-jwt) for
% a plane wave traveling in the +x direction. Conjugate the output for the 
% convention exp(-jkx+jwt).
%
% Inputs:
%           k       - Wavenumber, m^-1
%           a       - Piston inscribed circle radius, m
%           rho0    - Water density, kg/m^3
%           c0      - Water sound speed, m/s
%
% Outputs:
%           Zr      - Complex radiation impedance, kg/s
%

%% Check Inputs
if nargin<4
    c0 = 1500;
end
if nargin<3
    rho0 = 1000;
end
%% Calculate
a = sqrt((2*sqrt(3)*a^2)/pi);
Zr = CircularPistonRadiationImpedance(k,a,rho0,c0);
