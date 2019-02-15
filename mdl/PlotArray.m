figure
hold on
R = 1.5*max(sqrt(ex.^2+ey.^2+ez.^2));
plot3(R*[0 1],[0 0],[0 0],'k')
text(R*1.1,0,0,'x','horizontalalignment','center','verticalalignment','middle')
plot3([0 0],R*[0 1],[0 0],'k')
text(0,R*1.1,0,'y','horizontalalignment','center','verticalalignment','middle')
plot3([0 0],[0 0],R*[0 1],'k')
text(0,0,R*1.1,'z','horizontalalignment','center','verticalalignment','middle')
for i=1:Ne
    plot3(ex(i)+shapex,ey(i)+shapey,ez(i)+shapez,'b')
    patch(ex(i)+shapex,ey(i)+shapey,ez(i)+shapez,[0.5 0.5 1],'FaceAlpha',ea(i))
    text(ex(i),ey(i),ez(i),num2str(i),'horizontalalignment','center','verticalalignment','middle')
end
hold off
set(gca,'YDir','reverse','ZDir','reverse')
axis equal
axis off
view([60 15])
    