function fm = GenerateBasebandModulation(f1,f2,T,fc,fs,scheme,varargin)
%% function fm = GenerateBasebandModulation(f1,f2,T,fc,fs,scheme)
% function fm = GenerateBasebandModulation(f1,f2,T,fc,fs,scheme,<name>,<value>)
%
% Generates a vector representing the frequency deviation from a center
% frequency due to modulation according to the specified scheme. Optional
% parameters are passed as <name>,<value> pairs.
%
% Inputs:
%       f1      - Start frequency, Hz
%       f2      - Stop frequency, Hz
%       T       - Duration, s
%       fc      - Center frequency, Hz
%       fs      - Sample frequency, Hz
%       scheme  - Modulation scheme
%
% Optional Inputs:
%       alpha   - Hyperbolic fm exponent parameter <1>
%       beta    - Taylor fm limit parameter <0.9>
%
% Outputs:
%       fm      - Baseband modulation, Hz
%

%% Parse Input Arguments
par = inputParser;
addRequired(par,'f1',@(x) isnumeric(x) && isscalar(x));
addRequired(par,'f2',@(x) isnumeric(x) && isscalar(x));
addRequired(par,'T',@(x) isnumeric(x) && isscalar(x));
addRequired(par,'fc',@(x) isnumeric(x) && isscalar(x));
addRequired(par,'fs',@(x) isnumeric(x) && isscalar(x));
addRequired(par,'scheme',@(x) isnumeric(x) && isscalar(x));
addParameter(par,'alpha',1,@(x) isnumeric(x) && isscalar(x));
addParameter(par,'beta',0.9,@(x) isnumeric(x) && isscalar(x) && x < 1);
parse(par,f1,f2,T,fc,fs,scheme,varargin{:});
f1 = par.Results.f1;
f2 = par.Results.f2;
T = par.Results.T;
fc = par.Results.fc;
fs = par.Results.fs;
scheme = par.Results.scheme;
alpha = par.Results.alpha;
beta = par.Results.beta;
%% Generate Time Vector
t = (0:1/fs:T)';
%% Generate Passband Modulation
switch scheme
    case 1          % Linear
        fm = f1 + (f2-f1)/T*t;
    case 2          % Hyperbolic
        fm = (1./(1/f1^alpha + (1/f2^alpha-1/f1^alpha)/T*t)).^(1/alpha);
    case 3          % Exponential
        fm = exp(log(f1) + (log(f2)-log(f1))/T*t);
    case 4          % Taylor
        fm = f1 + (f2-f1) * (1/2+1/2*tan(beta*pi*(t/T-1/2))/tan(beta*pi/2));
    otherwise       % Constant
        fm = sqrt(f1*f2)*ones(size(t));
end
%% Baseband
fm = fm - fc;
