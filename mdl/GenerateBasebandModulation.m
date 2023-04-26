function fm = GenerateBasebandModulation(f1,f2,T,fc,fs,scheme,alpha,beta)
%% function fm = GenerateBasebandModulation(f1,f2,T,fc,fs,scheme,alpha,beta)
%
% Generates a vector representing the frequency deviation from a center
% frequency due to modulation according to the specified scheme.
%
% Inputs:
%       f1      - Start frequency, Hz
%       f2      - Stop frequency, Hz
%       T       - Duration, s
%       fc      - Center frequency, Hz
%       fs      - Sample frequency, Hz
%       scheme  - Modulation scheme
%       alpha   - Hyperbolic fm exponent parameter <1>
%       beta    - Taylor fm limit parameter <0.9>
%
% Outputs:
%       fm      - Baseband modulation, Hz
%

%% Check Inputs
if nargin<8
    beta = 0.9;
end
if nargin<7
    alpha = 1;
end
if ~isnumeric(f1) || ~isscalar(f1)
    error([mfilename '(): Input f1 failed verification test.'])
end
if ~isnumeric(f2) || ~isscalar(f2)
    error([mfilename '(): Input f2 failed verification test.'])
end
if ~isnumeric(T) || ~isscalar(T)
    error([mfilename '(): Input T failed verification test.'])
end
if ~isnumeric(fc) || ~isscalar(fc)
    error([mfilename '(): Input fc failed verification test.'])
end
if ~isnumeric(fs) || ~isscalar(fs)
    error([mfilename '(): Input fs failed verification test.'])
end
if ~isnumeric(scheme) || ~isscalar(scheme)
    error([mfilename '(): Input scheme failed verification test.'])
end
if ~isnumeric(alpha) || ~isscalar(alpha)
    error([mfilename '(): Input alpha failed verification test.'])
end
if ~isnumeric(beta) || ~isscalar(beta) || beta>=1
    error([mfilename '(): Input beta failed verification test.'])
end
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
