function [] = plot_mri_decay_3d()
orange = [1.0,0.5,0.0];
figure;

ax(1) = subplot(1,2,1); hold on;
plot3([0,0],[0,0],[0,1.5],'color',orange);
plot3([-1,+1],[0,0],[0,0],'color',blu(1));
plot3([0,0],[-1,+1],[0,0],'color',blu(1));
t = 0:0.01:1;
dx = 0.08;
plot3(zeros(size(t)),-sin(pi/2*t),1.5*cos(pi/2*t),'k:');
plot3([0,-dx],-[1,1],3*[0,dx],'k:');
plot3([0,+dx],-[1,1],3*[0,dx],'k:');
t = 0:0.02:8;
x = -sin(10*t).*exp(-1*t);
y = -cos(10*t).*exp(-1*t);
z = (1-exp(-0.5*t));
X = sqrt(x.^2+y.^2);
N = 10; dN = 1;
plot3(x,y,1.5*z,'k');
plot3([x(N),x(N-dN)+dx],[y(N),y(N-dN)],1.5*[z(N),z(N-dN)],'k');
plot3([x(N),x(N-dN)-dx],[y(N),y(N-dN)],1.5*[z(N),z(N-dN)],'k');
view(3);axis('equal');
set(gca,'xtick',[],'ytick',[],'ztick',[],...
        'xcolor','w','ycolor','w','zcolor','w',...
        'xlim',[-1,+1],'ylim',[-1,+1],'zlim',[0,+1.5],...
        'box','off');
xlabel('$M_x$','interpreter','latex','color',blu(1));
ylabel('$M_y$','interpreter','latex','color',blu(1));
zlabel('$M_z$','interpreter','latex','color',orange);

ax(2) = subplot(1,2,2); hold on;
plot(t,z,'color',orange);
plot(t,X,'color',blu(1));
plot(4*[1.0,1.0],[0,1-X(101)],':','color',orange);
text(4,1-X(101)+0.08,'T1','interpreter','latex','HorizontalAlignment','center');
plot(4*[0.5,0.5],[0,1-z(201)],':','color',blu(1));
text(2,1-z(201)+0.08,'T2','interpreter','latex','HorizontalAlignment','center');
set(gca,'xtick',[],'ytick',[],'xlim',[0,8]);
legend({'$M_z$','$M_{xy}$'},'interpreter','latex','location','east');
ylabel('$M$','interpreter','latex');
xlabel('$t$','interpreter','latex');

tightsubs(2,1,ax,[0.1,0,0,0;0.1,0.2,0.1,0.3]);
figresize(gcf,[1000,600]);
print(gcf,thesisname('fig','mridecay3d.eps'),'-depsc');
close(gcf);
