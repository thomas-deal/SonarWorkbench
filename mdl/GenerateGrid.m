function [Theta, Psi] = GenerateGrid(theta,psi,caller)
%% function [Theta, Psi] = GenerateGrid(theta,psi,caller)
%
% Checks dimensional compatiiblity and generates computational grid.
%

%% Initialize
Theta = NaN;
Psi = NaN;
%% Calculate
resize = 0;
thetaSize = size(theta);
psiSize = size(psi);
if min(thetaSize)==1
    if min(psiSize)==1
        resize = 1;
    else
        disp([caller ': Inputs psi and theta have incompatible dimensions'])
        return
    end
else
    if min(psiSize)==1
        disp([caller ': Inputs psi and theta have incompatible dimensions'])
        return
    end
end
if (thetaSize(2) == 1) && (psiSize(2) == 1) && (thetaSize(1) == psiSize(1))
    resize = 0;
    % When theta and psi are passed as column vectors of identical size,
    % treat as coordinate pairs for evaluation, not grid coordinates.
end
if resize
    [Theta,Psi] = ndgrid(theta, psi);
else
    Theta = theta;
    Psi = psi;
end
