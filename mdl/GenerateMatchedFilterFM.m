function b = GenerateMatchedFilterFM(env,fm,T,fsp,fs)
%% function b = GenerateMatchedFilterFM(env,fm,T,fsp,fs)
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
%       b       - Matched filter coefficients
%

%% Parse Input Arguments
par = inputParser;
addRequired(par,'env',@(x) isnumeric(x) && iscolumn(x));
addRequired(par,'fm',@(x) isnumeric(x) && iscolumn(x));
addRequired(par,'T',@(x) isnumeric(x) && isscalar(x));
addRequired(par,'fsp',@(x) isnumeric(x) && isscalar(x));
addRequired(par,'fs',@(x) isnumeric(x) && isscalar(x));
parse(par,env,fm,T,fsp,fs);
env = par.Results.env;
fm = par.Results.fm;
T = par.Results.T;
fsp = par.Results.fsp;
fs = par.Results.fs;
%% Generate Time Vectors
tp = (0:1/fsp:T)';
t = (0:1/fs:T)';
%% Resample Inputs
env = interp1(tp,env,t);
fm = interp1(tp,fm,t);
%% Synthesize Waveform
s = env.*exp(2i*pi*cumtrapz(fm)/fs);
%% Generate Matched Filter
b = conj(flipud(s));
b = b/sum(abs(b));
