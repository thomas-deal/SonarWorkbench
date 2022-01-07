function [env,hfm] = CompositeHFM(f1,f2,T,fc,fs,varargin)
%% function [env,hfm] = CompositeHFM(f1,f2,T,fc,fs)
% function [env,hfm] = CompositeHFM(f1,f2,T,fc,fs,<name>,<value>)
%
% Generates a hyperbolic frequency modulation vector and a pulse envelope
% that flattens its frequency response and reduces it spectral ripple.
% Optional input gamma passed as <name>,<value> pair sets the amount of
% ripple reduction.
%
% [1] D.M. Drumheller, "Uniform spectral amplitude windowing for hyperbolic
%     frequency modulated waveforms", NRL, Washington, DC,
%     NRL/FR/7140-94-9713, Jul. 1994.
%
% Inputs:
%       f1      - Start frequency, Hz
%       f2      - Stop frequency, Hz
%       T       - Duration, s
%       fc      - Center frequency, Hz
%       fs      - Sample frequency, Hz
%
% Outputs:
%       env     - Pulse envelope, normalized
%       hfm     - Baseband modulation, Hz
%

%% Parse Input Arguments
par = inputParser;
addRequired(par,'f1',@(x) isnumeric(x) && isscalar(x));
addRequired(par,'f2',@(x) isnumeric(x) && isscalar(x));
addRequired(par,'T',@(x) isnumeric(x) && isscalar(x));
addRequired(par,'fc',@(x) isnumeric(x) && isscalar(x));
addRequired(par,'fs',@(x) isnumeric(x) && isscalar(x));
addParameter(par,'gamma',0.1,@(x) isnumeric(x) && isscalar(x));
parse(par,f1,f2,T,fc,fs,varargin{:});
f1 = par.Results.f1;
f2 = par.Results.f2;
T = par.Results.T;
fc = par.Results.fc;
fs = par.Results.fs;
gamma = par.Results.gamma;
%% Generate Time Vector
t = (0:1/fs:T)';
%% Generate Envelope
a = min(f1,f2)./(f2 - (f2-f1)/T*t);
%% Reduce Ripple
w = ones(size(t));
w(t<gamma*T) = 1/2*(1-cos(pi*t(t<gamma*T)/(gamma*T)));
w(t>(1-gamma)*T) = 1/2*(1-cos(pi*(T-t(t>(1-gamma)*T))/(gamma*T)));
env = a.*w;
%% Compensate Bandwidth
f1c = 2*(1-gamma)/((2-gamma)/f1 - gamma/f2);
f2c = 2*(1-gamma)/((2-gamma)/f2 - gamma/f1);
%% Generate Modulation
hfm = GenerateBasebandModulation(f1c,f2c,T,fc,fs,'hfm','alpha',1);
