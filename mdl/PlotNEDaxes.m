function PlotNEDaxes(Pos_m,Ori_deg,varargin)
%% function PlotNEDaxes(Pos_m,Ori_deg)
% function PlotNEDaxes(Pos_m,Ori_deg,hax)
%
% Plots orthogonal x, y, and z axes for a NED coordinate frame
%
% Inputs:
%           Pos_m   - Frame position vector, m
%           Ori_deg - Frame orientation vector, deg
%
% Optional Inputs:
%           hax     - Handle to axis for plotting in an existing figure
%

%% Check Inputs
hax = [];
if nargin==3
    hax = varargin{1};
end
%% Rotate Axes
ROT = RotationMatrix(Ori_deg);
x = ROT*[0 1;0 0;0 0];
y = ROT*[0 0;0 1;0 0];
z = ROT*[0 0;0 0;0 1];
%% Plot
if ~isempty(hax)
    axes(hax)
else
    figure
end
hold on
plot3(Pos_m(1)+x(1,:),Pos_m(2)+x(2,:),Pos_m(3)+x(3,:),'k')
text(Pos_m(1)+1.1*x(1,2),Pos_m(2)+1.1*x(2,2),Pos_m(3)+1.1*x(3,2),'x', ...
     'horizontalalignment','center','verticalalignment','middle')
plot3(Pos_m(1)+y(1,:),Pos_m(2)+y(2,:),Pos_m(3)+y(3,:),'k')
text(Pos_m(1)+1.1*y(1,2),Pos_m(2)+1.1*y(2,2),Pos_m(3)+1.1*y(3,2),'y', ...
     'horizontalalignment','center','verticalalignment','middle')
plot3(Pos_m(1)+z(1,:),Pos_m(2)+z(2,:),Pos_m(3)+z(3,:),'k')
text(Pos_m(1)+1.1*z(1,2),Pos_m(2)+1.1*z(2,2),Pos_m(3)+1.1*z(3,2),'z', ...
     'horizontalalignment','center','verticalalignment','middle')
