function [] = plot_basic_lr()
B = 16*[-0.5,1];
y = 0.6;
c = 1./(1+exp(-B*[1,y]'));
figure;
lrplot([],[],B,'color',darken(blu(1),0.5));
plot([y,y],[0,c],':', 'color',lighten(blu(1),0));
plot([0,y],[c,c],'--','color',lighten(blu(1),0.4));
plot(y,c,'o','markersize',10,'color',blu(1));
leg = {'$\hat{c}(y)$','$y_i$','$\hat{c}_i$'};
legend(leg,'interpreter','latex','location','se');
print(gcf,thesisname('fig','lr-basic'),'-depsc');
close(gcf);