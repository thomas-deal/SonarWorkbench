function y = wrap180(u)
%% function y = wrap180(u)
%
% Restricts input to the range (-180,180].
%

%% Calculate
y = mod(u,360);
y(y>180) = y(y>180)-360;
end