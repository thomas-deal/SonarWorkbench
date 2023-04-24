function [env,hfm] = CompositeHFM(f1,f2,T,fc,fs,gamma)
%% function [env,hfm] = CompositeHFM(f1,f2,T,fc,fs,gamma)
%
% Generates a hyperbolic frequency modulation vector and a pulse envelope
% that flattens its frequency response and reduces it spectral ripple.
% Input gamma sets the amount of ripple reduction.
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
%       gamma   - Ripple reduction parameter <0.1>
%
% Outputs:
%       env     - Pulse envelope, normalized
%       hfm     - Baseband modulation, Hz
%

%% Check Inputs
if nargin<6
    gamma = 0.1;
end
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
hfm = GenerateBasebandModulation(f1c,f2c,T,fc,fs,2,'alpha',1);
