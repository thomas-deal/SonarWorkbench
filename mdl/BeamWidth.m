function BW = BeamWidth(ang,bp,ang0,renorm)
%% function BW = BeamWidth(ang,bp,ang0,renorm)
%
% Calculates the -3 dB beam width of a single beam slice. Peak location can
% be aided with optional parameter ang0. Beam width can be calculated using
% beam pattern amplitude as entered or by re-normalizing the beam pattern
% about the desired peak value.
%
% Inputs:
%           ang     - Angle vector, deg
%           bp      - Beam pattern slice vector, complex linear units
%           ang0    - Initial estimate for peak search, deg
%           renorm  - Re-normalize beam pattern about peak value
%
% Outputs:
%           BW      - Beam width, deg
%

%% Initialize
BW = NaN;
%% Check Input Arguments
findpeak = (nargin<3);
if nargin<4
    renorm = 0;
end
%% Find Peak
if findpeak
    [bpmax,i0] = max(abs(bp));
    if renorm
        bp = bp/bpmax;
    end
else
    angerr = wrap180(ang-ang0);
    [~,i0] = min(abs(angerr));
    if renorm
        bp = bp/abs(bp(i0));
    end
end
%% Convert to dB
BP = 20*log10(abs(bp));
if BP(i0)<=-3
    return
end
%% Find Lower Limit
i1 = i0;
found = false;
while(i1>1)&&~found
    i1 = i1 - 1;
    if BP(i1)<-3.1
        found = true;
    end
end
if BP(i1)>-3
    return
end
i2 = i1;
found = false;
while(i2<i0)&&~found
    i2 = i2 + 1;
    if BP(i2)>-2.9
        found = true;
    end
end
try
    a1 = interp1(BP(i1:i2),ang(i1:i2),-3,'spline','extrap');
catch me
    a1 = NaN;
end
%% Find Upper Limit
i2 = i0;
found = false;
while(i2<length(ang))&&~found
    i2 = i2 + 1;
    if BP(i2)<-3.1
        found = true;
    end
end
if BP(i2)>-3
    return
end
i1 = i2;
found = false;
while(i1>10)&&~found
    i1 = i1 - 1;
    if BP(i1)>-2.9
        found = true;
    end
end
try
    a2 = interp1(BP(i1:i2),ang(i1:i2),-3,'spline','extrap');
catch me
    a2 = NaN;
end
%% Calculate Beam Width
if isnan(a1)||isnan(a2)
    return
end
BW = a2 - a1;
