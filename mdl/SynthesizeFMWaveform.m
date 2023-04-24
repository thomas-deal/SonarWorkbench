function s = SynthesizeFMWaveform(env,fm,T,fsp,fs)
%% function s = SynthesizeFMWaveform(env,fm,T,fsp,fs)
%
% Generate matched filter coefficients for the specified FM pulse for
% detection in white noise.
%
% Inputs:
%       env     - Pulse envelope, normalized
%       fm      - Baseband modulation, Hz
%       T       - Duration, s
%       fsp     - Envelope and modulation sample frequency, Hz
%       fs      - Filter sample frequency, Hz
%
% Outputs:
%       s       - Complex baseband FM waveform
%

%% Generate Time Vectors
tp = (0:1/fsp:T)';
t = (0:1/fs:T)';
%% Resample Inputs
env = interp1(tp,env,t);
fm = interp1(tp,fm,t);
%% Synthesize Waveform
s = env.*exp(2i*pi*cumtrapz(fm)/fs);
