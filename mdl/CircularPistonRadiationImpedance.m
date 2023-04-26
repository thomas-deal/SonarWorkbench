function Zr = CircularPistonRadiationImpedance(k,a,rho0,c0)
%% function Zr = CircularPistonRadiationImpedance(k,a,rho0,c0)
%
% Calculates the radiation impedance for a circular piston element in an
% infinite plane baffle. Uses function StruveH1 from Matlab Central. This
% formulation uses the convention exp(jkx-jwt) for a plane wave traveling
% in the +x direction. Conjugate the output for the convention
% exp(-jkx+jwt).
%
% Inputs:
%           k       - Wavenumber, m^-1
%           a       - Piston radius, m
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
Zr = rho0*c0*pi*a.^2*(1-besselj(1,2*k.*a)./(k.*a) - 1i*StruveH1(2*k.*a)./(k.*a));
Zr(k==0) = 0;
return

function fun=StruveH1(z)
%
% StruveH1 calculates the function StruveH1 for complex argument z
%
% Author : T.P. Theodoulidis
% Date   : 11 June 2012
% Revised: 28 June 2012
%
% Arguments
% z : can be scalar, vector, matrix
% 
% External routines called         : cheval, StruveH1Y1
% Matlab intrinsic routines called : bessely, besselh
%
bn=[1.174772580755468e-001 -2.063239340271849e-001  1.751320915325495e-001...
   -1.476097803805857e-001  1.182404335502399e-001 -9.137328954211181e-002...
    6.802445516286525e-002 -4.319280526221906e-002  2.138865768076921e-002...
   -8.127801352215093e-003  2.408890594971285e-003 -5.700262395462067e-004...
    1.101362259325982e-004 -1.771568288128481e-005  2.411640097064378e-006...
   -2.817186005983407e-007  2.857457024734533e-008 -2.542050586813256e-009...
    2.000851282790685e-010 -1.404022573627935e-011  8.842338744683481e-013...
   -5.027697609094073e-014  2.594649322424009e-015 -1.221125551378858e-016...
    5.263554297072107e-018 -2.086067833557006e-019  7.628743889512747e-021...
   -2.582665191720707e-022  8.118488058768003e-024 -2.376158518887718e-025...
    6.492040011606459e-027 -1.659684657836811e-028  3.978970933012760e-030...
   -8.964275720784261e-032  1.901515474817625e-033];
%
x=z(:);
%
% |x|<=16
i1=abs(x)<=16;
x1=x(i1);
if isempty(x1)==0
    z1=x1.^2/400;
    fun1=cheval('shifted',bn,z1).*x1.^2*2/3/pi;
else
    fun1=[];
end
%
% |x|>16
i2=abs(x)>16;
x2=x(i2);
if isempty(x2)==0
    fun2=StruveH1Y1(x2)+bessely(1,x2);
else
    fun2=[];
end
%
fun=x*0;
fun(i1)=fun1;
fun(i2)=fun2;
%
fun=reshape(fun,size(z));
%
return

function eval = cheval(Ctype,An,xv)
%
% cheval evaluates any one of the four types of Chebyshev series.
% It is a Matlab translation of the Fortran function EVAL
% found in page 20 of:
% Y.L. Luke, Algorithms for the computation of mathematical functions
% Academic Press, 1977, p.20
%
% Author : T.P. Theodoulidis
% Date   : 11 June 2012
%
% Ctype (string): type of Chebyshev polynomial
%                 'regular' T_n(x)
%                 'shifted' T*_n(x)
%                 'even'    T_2n(x)
%                 'odd'     T_2n+1(x)
% An            : vector of Chebyshev coefficients
% z             : argument, can be scalar, vector, matrix
%
switch Ctype
    case {'regular'}
        log1=1; log2=1;
    case {'shifted'}
        log1=1; log2=0;
    case {'even'}
        log1=0; log2=1;
    case {'odd'}
        log1=0; log2=0;
    otherwise
        return;
end
%
x=xv(:);
%
xfac=2*(2*x-1);
if log1 && log2, xfac=2*x; end
if ~log1, xfac=2*(2*x.*x-1); end
n=length(An);
n1=n+1;
Bn=zeros(length(x),n1+1);
%
for j=1:n
    Bn(:,n1-j)=xfac.*Bn(:,n1+1-j)-Bn(:,n1+2-j)+An(n1-j);
end
eval=Bn(:,1)-xfac.*Bn(:,2)/2;
if ~log1 && ~log2, eval=x.*(Bn(:,1)-Bn(:,2)); end
eval=reshape(eval,size(xv));
%
return

function fun=StruveH1Y1(z)
%
% StruveH1Y1 calculates the function StruveH1-BesselY1 for complex argument z
%
% Author : T.P. Theodoulidis
% Date   : 11 June 2012
%
% Arguments
% z : can be scalar, vector, matrix
% 
% External routines called         : cheval, StruveH1
% Matlab intrinsic routines called : bessely, besselh
%
nom=[4,0,9648             ,0,8187030           ,...
       0,3120922350       ,0,568839210030      ,... 
       0,49108208584050   ,0,1884052853216100  ,...
       0,28131914180758500,0,126232526316723750,...
       0,97007862050064000,0,2246438344775625];
%
den=[4,0,9660              ,0,8215830           ,...
       0,3145141440        ,0,577919739600      ,...
       0,50712457149900    ,0,2014411492343250  ,...
       0,32559467386446000 ,0,177511711616489250,...
       0,230107774317671250,0,31378332861500625];
%
x=z(:);
%
% |x|<=16
i1=abs(x)<=16;
x1=x(i1);
if isempty(x1)==0
    fun1=StruveH1(x1)-bessely(1,x1);
else
    fun1=[];
end
%
% |x|>16 and real(x)<0 and imag(x)<0
i2=(abs(x)>16 & real(x)<0 & imag(x)<0);
x2=x(i2);
if isempty(x2)==0
    x2=-x2;
    fun2=2/pi+2/pi./x2.^2.*polyval(nom,x2)./polyval(den,x2)-2i*besselh(1,1,x2);
else
    fun2=[];
end
% |x|>16 and real(x)<0 and imag(x)>=0
i3=(abs(x)>16 & real(x)<0 & imag(x)>=0);
x3=x(i3);
if isempty(x3)==0
    x3=-x3;
    fun3=2/pi+2/pi./x3.^2.*polyval(nom,x3)./polyval(den,x3)+2i*besselh(1,2,x3);    
else
    fun3=[];
end
% |x|>16 and real(x)>=0
i4=(abs(x)>16 & real(x)>=0);
x4=x(i4);
if isempty(x4)==0
    fun4=2/pi+2/pi./x4.^2.*polyval(nom,x4)./polyval(den,x4);
else
    fun4=[];
end
fun=x*0;
fun(i1)=fun1;
fun(i2)=fun2;
fun(i3)=fun3;
fun(i4)=fun4;
%
fun=reshape(fun,size(z));
%
return
        