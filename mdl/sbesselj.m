function j = sbesselj(nu,z)
%% function j = sbesselj(nu,z)
%
% Spherical bessel function of the first kind.
%

%% Calculate
j = sqrt(pi/2./z).*besselj(nu+1/2,z);
% Asymptotic result for small values
smallz = 1e-10;
if nu==0
    j(z<smallz) = 1;
else
    if mod(nu,1)    % noninteger
        j(z<smallz) = 0;
    else            % integer
        j(z<smallz) = z(z<smallz).^nu/fact2(nu);
    end
end
end

function y = fact2(u)
%% function y = fact2(u)
%
% Double factorial y = u!!
%

%% Calculate
switch u
    case -1
        y = 1;
    case 0
        y = 1;
    otherwise
        if mod(u,2)     % odd
            y = prod(1:2:u);
        else            % even
            y = prod(2:2:u);
        end
end
end