%% Settings
LineWidth = 2;
FontSize = 20;
ArrowColor = [0 0 0];
pos = [10 10 800 600];
%% Arrow
arrow.h = 0.05;
arrow.a = 0.025;
r = [0 1];
th = 0:10:360;
[R,T] = meshgrid(r,th) ;
arrow.x = arrow.h - arrow.h*R ;
arrow.y = arrow.a*R.*cosd(T) ;
arrow.z = arrow.a*R.*sind(T) ;
%% Draw Coordinate Axes
figure
hold on
% x axis
plot3([0 1],[0 0],[0 0],'k','LineWidth',LineWidth)
surf(1+arrow.x,arrow.y,arrow.z,'FaceColor',ArrowColor,'EdgeColor',ArrowColor)
text(1.1,0,0,'$x$','interpreter','latex','FontSize',FontSize,'VerticalAlignment','middle','HorizontalAlignment','center')
% y axis
plot3([0 0],[0 1],[0 0],'k','LineWidth',LineWidth)
surf(arrow.y,1+arrow.x,arrow.z,'FaceColor',ArrowColor,'EdgeColor',ArrowColor)
text(0,1.1,0,'$y$','interpreter','latex','FontSize',FontSize,'VerticalAlignment','middle','HorizontalAlignment','center')
% z axis
plot3([0 0],[0 0],[0 1],'k','LineWidth',LineWidth)
surf(arrow.y,arrow.z,1+arrow.x,'FaceColor',ArrowColor,'EdgeColor',ArrowColor)
text(0,0,1.1,'$z$','interpreter','latex','FontSize',FontSize,'VerticalAlignment','middle','HorizontalAlignment','center')
%% Draw Rotations
ang = 0:270;
a = 0.1;
% roll
plot3(0.5*[1 1],[0 0],-a*[0 2],'k--')
text(0.5,0,-2*a-0.05,'$0^\circ$','interpreter','latex','FontSize',FontSize-6,'VerticalAlignment','middle','HorizontalAlignment','center')
plot3(0.5*ones(size(ang)),a*sind(ang),-a*cosd(ang),'k','LineWidth',LineWidth)
surf(0.5+arrow.y,-a+arrow.z,-arrow.x,'FaceColor',ArrowColor,'EdgeColor',ArrowColor)
text(0.5,-a,-a,'$\gamma$','interpreter','latex','FontSize',FontSize,'VerticalAlignment','middle','HorizontalAlignment','center')
% pitch
plot3(a*[0 2],0.5*[1 1],[0 0],'k--')
text(2*a+0.05,0.5,0,'$0^\circ$','interpreter','latex','FontSize',FontSize-6,'VerticalAlignment','middle','HorizontalAlignment','center')
plot3(a*cosd(ang),0.5*ones(size(ang)),-a*sind(ang),'k','LineWidth',LineWidth)
surf(arrow.x,0.5+arrow.y,a+arrow.z,'FaceColor',ArrowColor,'EdgeColor',ArrowColor)
text(a,0.5,a,'$\theta$','interpreter','latex','FontSize',FontSize,'VerticalAlignment','middle','HorizontalAlignment','center')
% yaw
plot3(a*[0 2],[0 0],0.5*[1 1],'k--')
text(2*a+0.05,0,0.5,'$0^\circ$','interpreter','latex','FontSize',FontSize-6,'VerticalAlignment','middle','HorizontalAlignment','center')
plot3(a*cosd(ang),a*sind(ang),0.5*ones(size(ang)),'k','LineWidth',LineWidth)
surf(arrow.x,-a+arrow.y,0.5+arrow.z,'FaceColor',ArrowColor,'EdgeColor',ArrowColor)
text(a,-a,0.5,'$\psi$','interpreter','latex','FontSize',FontSize,'VerticalAlignment','middle','HorizontalAlignment','center')
%% Finish Plot
hold off
set(gca,'ydir','reverse','zdir','reverse')
view([45,30])
axis equal
axis off
%% Save Plot
set(gcf,'Position',pos,'Renderer','painters','PaperPositionMode','auto')
try
    print(gcf,'-depsc2','NEDCoordinateSystem.eps')
catch me
    disp('Unable to save NEDCoordinateSystem.eps, check write status.')
end