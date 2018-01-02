function [] = plot_mri_spin_echo()
figure;
N = 100;
clr.RF  = darken(red(1),0.5);
clr.psi = blu(1);
clr.T2  = lighten(blu(1),0.5);
clr.T1  = lighten([1.0,0.5,0.0],0.5);

t2   = linspace(0,2,3*N);
t1   = linspace(-1,+1,N);
curv = 0.02*linspace(1,0,1.5*N);
tz   = zeros(1,N);
p090 = 1*sinc(3*t1);
p180 = 2*sinc(3*t1);
RF   = [tz,p090,tz,tz,p180,tz,tz,tz,tz,tz,tz,tz];
t    = linspace(0,1,numel(RF));
T2   = [zeros(1,N*1.5),  exp(-2*t(1:end-N*1.5))];
T1   = [zeros(1,N*1.5),1-exp(-0.5*t(1:end-N*1.5))];
T2x  = [zeros(1,N*1.5),  exp(-3*t2),exp(3*t2-6),exp(-3*t2)];
T2x  = [T2x,zeros(1,size(T2,2)-size(T2x,2))];
psi  = cos(400*t).*T2.*T2x;

T2(1:N*1.5) = nan;
T1(1:N*1.5) = nan;
psi  = 10*[psi,nan*t1,psi(1:4*N)];
RF   =  1*[RF, nan*t1, RF(1:4*N)];
T2   = 10*[T2, nan*t1,   curv, T2(N*1.5+1:4*N)*1];
T1   = 10*[T1, nan*t1, 1-curv, T1(N*1.5+1:4*N)*1];

ax(1) = subplot(2,1,1); hold on;

plot(14+3*RF,'color',clr.RF);
plot(psi,'color',clr.psi);
plot(T2,'color',clr.T2);
plot(T1,'color',clr.T1);
plot(psi,'color',clr.psi);
doublearrow([N*1.5,N*04.5],-10,20,0.5,'$TE/2$','k');
doublearrow([N*1.5,N*07.5],-14,20,0.5,'$TE$','k');
doublearrow([N*1.5,N*14.5],-18,20,0.5,'$TR$','k');
set(gca,'xtick',[],'ytick',[],'xlim',[1,numel(RF)],'xcolor','w','ycolor','w');
ylim(10*[-2.5,+2.5]);
xlim([1,numel(psi)])
text(12.5*N,14,'$\cdots$','interpreter','latex','color','k',...
  'horizontalalignment','center','verticalalignment','middle');
text(12.5*N, 0,'$\cdots$','interpreter','latex','color','k',...
  'horizontalalignment','center','verticalalignment','middle');
text( 1.5*N,22,'$90^{\circ}$','interpreter','latex','color',clr.RF,...
  'horizontalalignment','center','verticalalignment','middle');
text( 4.5*N,22,'$180^{\circ}$','interpreter','latex','color',clr.RF,...
  'horizontalalignment','center','verticalalignment','middle');
text(14.5*N,22,'$90^{\circ}$','interpreter','latex','color',clr.RF,...
  'horizontalalignment','center','verticalalignment','middle');
text( 7.5*N, 6,'$SE$','interpreter','latex','color',clr.psi,...
  'horizontalalignment','center','verticalalignment','middle');
legend({'$RF$','$\Psi$','$\Psi_{T2}$','$\Psi_{T1}$'},'interpreter','latex','location','eastoutside');
tightsubs(1,1,ax,0.05*[1,1,3,1]);
figresize(gcf,[1000,700]);
print(gcf,thesisname('fig','mrispinecho.eps'),'-depsc');
close(gcf);

function [] = doublearrow(t,x,dt,dx,label,color)
plot(t+[+dt,-dt],[x,x],'color',color);
fill([t(1),t(1)+dt,t(1)+dt,t(1)],[x,x+dx,x-dx,x],color,'edgecolor','none');
fill([t(2),t(2)-dt,t(2)-dt,t(2)],[x,x+dx,x-dx,x],color,'edgecolor','none');
text(mean(t),x-dx,label,'interpreter','latex','color',color,...
  'horizontalalignment','center','verticalalignment','top');