function Zr = RectangularPistonRadiationImpedance(k,w,h,rho0,c0)
%% function Zr = RectangularPistonRadiationImpedance(k,w,h,rho0,c0)
%
% Calculates the radiation impedance for a rectangular piston element in an
% infinite plane baffle. The closed form solution to this problem requires 
% the use of the symbolic math toolbox. If that package is not available,
% the radiation impedance is approximated by that for a circular piston
% with equal surface area. This formulation uses the convention 
% exp(jkx-jwt) for a plane wave traveling in the +x direction. Conjugate 
% the output for the convention exp(-jkx+jwt).
%
% Inputs:
%           k       - Wavenumber, m^-1
%           w       - Piston width, m
%           h       - Piston height, m
%           rho0    - Water density, kg/m^3
%           c0      - Water sound speed, m/s
%
% Outputs:
%           Zr      - Complex radiation impedance, kg/s
%

%% Calculate
if license('test','symbolic_toolbox')
    q = h/w;
    ax = w/2;
    Nf = length(k);
    Rr = zeros(size(k));
    Xr = zeros(size(k));
    for i=1:Nf
        N = 5 + round((1+2*sqrt(2)*q)*k(i)*ax);
        M = N;
        tmpR = 0;
        % Calculate resistance
        for m=0:M
            for n=0:N
                tmpR = tmpR + (-1)^(m+n)*q^(2*n+1)*(k(i)*ax)^(2*m+2*n+2) / ...
                             ((2*m+1)*(2*n+1)*factorial(m+1)*factorial(n+1)*gamma(m+n+3/2));
            end
        end
        Rr(i) = rho0*c0/sqrt(pi)*tmpR;
        % Calculate reactance
        rmpX = 0;
        for m=0:M
            gmn = 0;
            for n=0:m
                tmpg1 = 0;
                for p=n:m
                    tmpg1 = tmpg1 + (-1)^(p-n)*q^(2*n-1)*nchoosek(m-n,p-n) / ...
                                   ((2*p-1)*(1+q^2)^(p-1/2));
                end
                tmpg2 = 0;
                for p=m-n:m
                    tmpg2 = tmpg2 + (-1)^(p-m+n)*q^(2*n+2)*nchoosek(n,p-m+n) / ...
                                   ((2*p-1)*(1+q^2)^(p-1/2));
                end
                gmn = gmn + nchoosek(2*m+3,2*n)*tmpg1 + nchoosek(2*m+3,2*n+3)*tmpg2;
            end
            fm = (hypergeom([1 m+1/2],m+3/2,1/(1+q^2))+hypergeom([1 m+1/2],m+3/2,1/(1+q^(-2)))) / ...
                 ((2*m+1)*(1+q^(-2))^(m+1/2)) + ...
                 1/(2*m+3)*gmn;
             tmpX = tmpX + (-1)^m*(k(i)*ax)^(2*m+1)*fm / ...
                          ((2*m+1)*factorial(m)*factorial(m+1));
        end
        Xr(i) = rho0*c0/pi*((1-sinc(2*k(i)*ax/pi)+q*(1-sinc(2*q*k(i)*ax/pi)))/(q*k(i)*ax) + 2*tmpX);
    end
    Zr = (w*h)*(Rr - 1i*Xr);
else
    a = sqrt(w*h/pi);
    Zr = CircularPistonRadiationImpedance(k,a,rho0,c0);
end
