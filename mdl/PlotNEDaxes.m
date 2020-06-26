function PlotNEDaxes(ax,ay,az,varargin)
%% function PlotNEDaxes(ax,ay,az)
% function PlotNEDaxes(ax,ay,az,hax)
%
% Plots orthogonal x, y, and z axes for a NED coordinate frame
%
% Inputs:
%           ax      - Array x position, m
%           ay      - Array y position, m
%           az      - Array z position, m
%
% Optional Inputs:
%           hax     - Handle to axis for plotting in an existing figure

%% Check Inputs
hax = [];
if nargin==4
    hax = varargin{1};
end
%% Plot
if ~isempty(hax)
    axes(hax)
else
    figure
end
hold on
plot3(ax+[0 1],ay+[0 0],az+[0 0],'k')
text(ax+1.1,ay+0,az+0,'x','horizontalalignment','center','verticalalignment','middle')
plot3(ax+[0 0],ay+[0 1],az+[0 0],'k')
text(ax+0,ay+1.1,az+0,'y','horizontalalignment','center','verticalalignment','middle')
plot3(ax+[0 0],ay+[0 0],az+[0 1],'k')
text(ax+0,ay+0,az+1.1,'z','horizontalalignment','center','verticalalignment','middle')
