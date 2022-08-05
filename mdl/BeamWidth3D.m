function [BWV, BWH] = BeamWidth3D(theta,psi,BP,varargin)
%% function [BWV, BWH] = BeamWidth3D(theta,psi,BP)
% function [BWV, BWH] = BeamWidth3D(theta,psi,BP,theta0,psi0)
% function [BWV, BWH] = BeamWidth3D(theta,psi,BP,theta0,psi0,renorm)
%
% Calculates the horizontal and vertical -3 dB beam widths of a 3D beam
% pattern. Peak location can be aided with optional parameters psi0 and
% theta0. Beam width can be calculated using beam pattern amplitude as 
% entered or by re-normalizing the beam pattern about the desired peak 
% value.
%
% Inputs:
%           theta   - Elevation angle vector, deg
%           psi     - Azimuthal angle vector, deg
%           BP      - Beam pattern matrix with elevation angles in rows,
%                     azimuthal angles in columns, complex linear units
%
% Optional Inputs:
%           theta0  - Initial elevation estimate for peak search, deg
%           psi0    - Initial azimuth estimate for peak search, deg
%           renorm  - Re-normalize beam pattern about peak value
%
% Outputs:
%           BWV      - Vertical beam width, deg
%           BWH      - Horizontal beam width, deg
%

%% Check Input Arguments
findpeak = 1;
psi0 = 0;
theta0 = 0;
renorm = 0;
switch nargin
    case 4
        if ~isempty(varargin{1})
            findpeak = 0;
            theta0 = varargin{1};
        end
    case 5
        if ~isempty(varargin{1})
            findpeak = 0;
            theta0 = varargin{1};
        end
        if ~isempty(varargin{2})
            findpeak = 0;
            psi0 = varargin{2};
        end
    case 6
        if ~isempty(varargin{1})
            findpeak = 0;
            theta0 = varargin{1};
        end
        if ~isempty(varargin{2})
            findpeak = 0;
            psi0 = varargin{2};
        end
        if ~isempty(varargin{3})
            renorm = varargin{3};
        end
end
%% Find Peak
if findpeak
    [maxvec,ivec] = max(abs(BP),[],1);
    [bpmax,j0] = max(maxvec);
    i0 = ivec(j0);
    theta0 = theta(i0);
    psi0 = psi(j0);
    if renorm
        BP = BP/bpmax;
    end
else
    [~,i0] = min(abs(wrap180(theta-theta0)));
    [~,j0] = min(abs(wrap180(psi-psi0)));
    if renorm
        BP = BP/abs(BP(i0,j0));
    end
end
%% Get Vertical Beam Width
[slice,phi] = ExtractBeamSlice(theta,psi,BP,[-90;theta0;psi0]);
BWV = BeamWidth(phi,slice,0);
%% Get Horizontal Beam Width
[slice,phi] = ExtractBeamSlice(theta,psi,BP,[0;theta0;psi0]);
BWH = BeamWidth(phi,slice,0);
