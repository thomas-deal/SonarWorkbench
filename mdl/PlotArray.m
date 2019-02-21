figure
hold on
R = 1.5*max(sqrt(Array.ex.^2+Array.ey.^2+Array.ez.^2));
plot3(R*[0 1],[0 0],[0 0],'k')
text(R*1.1,0,0,'x','horizontalalignment','center','verticalalignment','middle')
plot3([0 0],R*[0 1],[0 0],'k')
text(0,R*1.1,0,'y','horizontalalignment','center','verticalalignment','middle')
plot3([0 0],[0 0],R*[0 1],'k')
text(0,0,R*1.1,'z','horizontalalignment','center','verticalalignment','middle')
for i=1:Array.Ne
    plot3(Array.ex(i)+shapex,Array.ey(i)+shapey,Array.ez(i)+shapez,'b')
    patch(Array.ex(i)+shapex,Array.ey(i)+shapey,Array.ez(i)+shapez,[0.5 0.5 1],'FaceAlpha',abs(Array.ew(i)))
    text(Array.ex(i),Array.ey(i),Array.ez(i),num2str(i),'horizontalalignment','center','verticalalignment','middle')
end
hold off
set(gca,'YDir','reverse','ZDir','reverse')
axis equal
axis off
view([60 15])
    