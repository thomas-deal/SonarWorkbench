%% Setup Path
addpath(fullfile('..','..','mdl'))
addpath(fullfile('..','..','resources','Utilities'))
%% Plot Settings
LineWidth = 2;
FontSize = 20;
BodyColor = [0 0 0];
ArrayColor = [1 0 0];
ElementColor = [0 0 1];
pos = [10 10 800 600];
%% Body Parameters
body.a = 2;
body.l = 5;
%% Array Position and Orientation
array.w = 2;
array.vang = 60;
array.ax = 3;
array.ay = body.a;
array.az = 0;
array.agamma = 0;
array.atheta = 0;
array.apsi = 90;
%% Element Position and Orientation
element.w = 0.2;
element.vang = 5;
element.vpos = -50;
element.ex = array.ax+0.4;
element.ey = body.a*cosd(element.vpos);
element.ez = body.a*sind(element.vpos);
%% Arrow
arrow.h = 0.05;
arrow.a = 0.025;
r = [0 1];
th = 0:10:360;
[R,T] = meshgrid(r,th) ;
arrow.x = arrow.h - arrow.h*R ;
arrow.y = arrow.a*R.*cosd(T) ;
arrow.z = arrow.a*R.*sind(T) ;
%% Create Figure
figure
hold on
%% Plot Array and Element Coordinates
% Array
plot3([0 array.ax],[0 0],[0 0],'--','Color',ArrayColor)
plot3(array.ax*[1 1],[0 array.ay],[0 0],'--','Color',ArrayColor)
plot3(array.ax+0.5*[0 1],array.ay*[1 1],array.az*[1 1],'-','Color',ArrayColor)
plot3(array.ax+0.4*cosd(0:10:array.apsi),array.ay+0.4*sind(0:10:array.apsi),0*(0:10:array.apsi),'--','Color',ArrayColor)
% Element
plot3(array.ax*[1 1],[array.ay element.ey],array.az*[1 1],'--','Color',ElementColor)
plot3([array.ax element.ex],element.ey*[1 1],array.az*[1 1],'--','Color',ElementColor)
plot3(element.ex*[1 1],element.ey*[1 1],[array.az element.ez],'--','Color',ElementColor)
plot3(element.ex+[0 0],element.ey+0.5*[0 1],element.ez*[1 1],'-','Color',ElementColor)
plot3(element.ex+0*cosd(0:-10:element.vpos),element.ey+0.4*cosd(0:-10:element.vpos),element.ez+0.4*sind(0:-10:element.vpos),'--','Color',ElementColor)
%% Draw Frame Body Axes
% x axis
hbf = plot3([0 1],[0 0],[0 0],'Color',BodyColor,'LineWidth',LineWidth);
surf(1+arrow.x,arrow.y,arrow.z,'FaceColor',BodyColor,'EdgeColor',BodyColor)
text(1.1,0,0,'$x$','interpreter','latex','Color',BodyColor,'FontSize',FontSize,'VerticalAlignment','middle','HorizontalAlignment','center')
% y axis
plot3([0 0],[0 1],[0 0],'Color',BodyColor,'LineWidth',LineWidth)
surf(arrow.y,1+arrow.x,arrow.z,'FaceColor',BodyColor,'EdgeColor',BodyColor)
text(0,1.1,0,'$y$','interpreter','latex','Color',BodyColor,'FontSize',FontSize,'VerticalAlignment','middle','HorizontalAlignment','center')
% z axis
plot3([0 0],[0 0],[0 1],'Color',BodyColor,'LineWidth',LineWidth)
surf(arrow.y,arrow.z,1+arrow.x,'FaceColor',BodyColor,'EdgeColor',BodyColor)
text(0,0,1.1,'$z$','interpreter','latex','Color',BodyColor,'FontSize',FontSize,'VerticalAlignment','middle','HorizontalAlignment','center')
%% Draw Body
hb = patch([0*cosd(-90:90) body.l+0*cosd(90:-1:-90) 0], ...
      [body.a*cosd(-90:90) body.a*cosd(90:-1:-90) body.a*cosd(-90)], ...
      [body.a*sind(-90:90) body.a*sind(90:-1:-90) body.a*sind(-90)], ...
      0.25*[1 1 1],'FaceAlpha',0.25,'EdgeColor',BodyColor);
%% Draw Array Frame Axes
% x axis
haf = plot3(array.ax+[0 0],array.ay+[0 1],[0 0],'Color',ArrayColor,'LineWidth',LineWidth);
surf(array.ax+arrow.y,array.ay+1+arrow.x,arrow.z,'FaceColor',ArrayColor,'EdgeColor',ArrayColor)
text(array.ax,array.ay+1.1,0,'$x$','interpreter','latex','Color',ArrayColor,'FontSize',FontSize,'VerticalAlignment','middle','HorizontalAlignment','center')
% y axis
plot3(array.ax+[-1 0],array.ay+[0 0],[0 0],'Color',ArrayColor,'LineWidth',LineWidth)
surf(array.ax-1-arrow.x,array.ay+arrow.y,arrow.z,'FaceColor',ArrayColor,'EdgeColor',ArrayColor)
text(array.ax-1.1,array.ay,0,'$y$','interpreter','latex','Color',ArrayColor,'FontSize',FontSize,'VerticalAlignment','middle','HorizontalAlignment','center')
% z axis
plot3(array.ax+[0 0],array.ay+[0 0],[0 1],'Color',ArrayColor,'LineWidth',LineWidth)
surf(array.ax+arrow.y,array.ay+arrow.z,1+arrow.x,'FaceColor',ArrayColor,'EdgeColor',ArrayColor)
text(array.ax,array.ay,1.1,'$z$','interpreter','latex','Color',ArrayColor,'FontSize',FontSize,'VerticalAlignment','middle','HorizontalAlignment','center')
%% Draw Array
ha = patch(array.ax+[-array.w/2+0*cosd(-array.vang:array.vang) array.w/2+0*cosd(array.vang:-1:-array.vang) -array.w/2], ...
      [body.a*cosd(-array.vang:array.vang) body.a*cosd(array.vang:-1:-array.vang) body.a*cosd(-array.vang)], ...
      [body.a*sind(-array.vang:array.vang) body.a*sind(array.vang:-1:-array.vang) body.a*sind(-array.vang)], ...
      ArrayColor,'FaceAlpha',0.25,'EdgeColor',ArrayColor);
%% Draw Element Frame Axes
% x axis
hef = plot3(element.ex+[0 0],element.ey+cosd(element.vpos)*[0 1],element.ez+sind(element.vpos)*[0 1],'Color',ElementColor,'LineWidth',LineWidth);
% Rotate x arrow head
ROT = RotationMatrix(0,-element.vpos,90);
X = ROT(1,1)*(1+arrow.x) + ROT(1,2)*arrow.y + ROT(1,3)*arrow.z;
Y = ROT(2,1)*(1+arrow.x) + ROT(2,2)*arrow.y + ROT(2,3)*arrow.z;
Z = ROT(3,1)*(1+arrow.x) + ROT(3,2)*arrow.y + ROT(3,3)*arrow.z;
surf(element.ex+X,element.ey+Y,element.ez+Z,'FaceColor',ElementColor,'EdgeColor',ElementColor)
text(element.ex,element.ey+1.1*cosd(element.vpos),element.ez+1.1*sind(element.vpos),'$x$','interpreter','latex','Color',ElementColor,'FontSize',FontSize,'VerticalAlignment','middle','HorizontalAlignment','center')
% y axis
plot3(element.ex+[-1 0],element.ey+[0 0],element.ez+[0 0],'Color',ElementColor,'LineWidth',LineWidth);
surf(element.ex-1-arrow.x,element.ey+arrow.y,element.ez+arrow.z,'FaceColor',ElementColor,'EdgeColor',ElementColor)
text(element.ex-1.1,element.ey,element.ez,'$y$','interpreter','latex','Color',ElementColor,'FontSize',FontSize,'VerticalAlignment','middle','HorizontalAlignment','center')
% z axis
plot3(element.ex+[0 0],element.ey-sind(element.vpos)*[0 1],element.ez+cosd(element.vpos)*[0 1],'Color',ElementColor,'LineWidth',LineWidth);
% Rotate z arrow head
ROT = RotationMatrix(0,-90-element.vpos,90);
X = ROT(1,1)*(1+arrow.x) + ROT(1,2)*arrow.y + ROT(1,3)*arrow.z;
Y = ROT(2,1)*(1+arrow.x) + ROT(2,2)*arrow.y + ROT(2,3)*arrow.z;
Z = ROT(3,1)*(1+arrow.x) + ROT(3,2)*arrow.y + ROT(3,3)*arrow.z;
surf(element.ex+X,element.ey+Y,element.ez+Z,'FaceColor',ElementColor,'EdgeColor',ElementColor)
text(element.ex,element.ey-1.1*sind(element.vpos),element.ez+1.1*cosd(element.vpos),'$z$','interpreter','latex','Color',ElementColor,'FontSize',FontSize,'VerticalAlignment','middle','HorizontalAlignment','center')
%% Draw Element
he = patch(element.ex+[-element.w/2+0*cosd(-element.vang:element.vang) element.w/2+0*cosd(element.vang:-1:-element.vang) -element.w/2], ...
      [body.a*cosd(element.vpos+(-element.vang:element.vang)) body.a*cosd(element.vpos+(element.vang:-1:-element.vang)) body.a*cosd(element.vpos-element.vang)], ...
      [body.a*sind(element.vpos+(-element.vang:element.vang)) body.a*sind(element.vpos+(element.vang:-1:-element.vang)) body.a*sind(element.vpos-element.vang)], ...
      ElementColor,'FaceAlpha',0.25,'EdgeColor',ElementColor);
%% Finish Plot
hold off
set(gca,'SortMethod','ChildOrder')
camproj('perspective')
hleg = legend([hb ha he hbf haf hef],'Body','Array','Element','Body Frame','Array Frame','Element Frame','location','eastoutside');
set(hleg,'FontSize',FontSize,'Interpreter','latex')
set(gca,'ydir','reverse','zdir','reverse')
view([40,30])
axis equal
axis off
%% Save Plot
orient(gcf,'landscape')
set(gcf,'Position',pos,'Renderer','Painters','PaperPositionMode','auto')
try
    print(gcf,'-dpdf','BodyArrayElementFrame.pdf')
catch me
    disp('Unable to save BodyArrayElementFrame.pdf, check write status.')
end
