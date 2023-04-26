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

%% Check Inputs
if ~isnumeric(env) || ~iscolumn(env)
    error([mfilename '(): Input env failed verification test.'])
end
if ~isnumeric(fm) || ~iscolumn(fm)
    error([mfilename '(): Input fm failed verification test.'])
end
if ~isnumeric(T) || ~isscalar(T)
    error([mfilename '(): Input T failed verification test.'])
end
if ~isnumeric(fsp) || ~isscalar(fsp)
    error([mfilename '(): Input fsp failed verification test.'])
end
if ~isnumeric(fs) || ~isscalar(fs)
    error([mfilename '(): Input fs failed verification test.'])
end
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
