function PlotNEDaxes(aPos_m,varargin)
%% function PlotNEDaxes(aPos_m)
% function PlotNEDaxes(aPos_m,hax)
%
% Plots orthogonal x, y, and z axes for a NED coordinate frame
%
% Inputs:
%           aPos_m  - Array position vector, m
%
% Optional Inputs:
%           hax     - Handle to axis for plotting in an existing figure

%% Check Inputs
hax = [];
if nargin==2
    hax = varargin{1};
end
%% Plot
if ~isempty(hax)
    axes(hax)
else
    figure
end
hold on
plot3(aPos_m(1)+[0 1],aPos_m(2)+[0 0],aPos_m(3)+[0 0],'k')
text(aPos_m(1)+1.1,aPos_m(2)+0,aPos_m(3)+0,'x', ...
     'horizontalalignment','center','verticalalignment','middle')
plot3(aPos_m(1)+[0 0],aPos_m(2)+[0 1],aPos_m(3)+[0 0],'k')
text(aPos_m(1)+0,aPos_m(2)+1.1,aPos_m(3)+0,'y', ...
     'horizontalalignment','center','verticalalignment','middle')
plot3(aPos_m(1)+[0 0],aPos_m(2)+[0 0],aPos_m(3)+[0 1],'k')
text(aPos_m(1)+0,aPos_m(2)+0,aPos_m(3)+1.1,'z', ...
     'horizontalalignment','center','verticalalignment','middle')
