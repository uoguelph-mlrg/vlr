function [] = blandaltman(ll,lle,logspace,labels)
if nargin == 2, logspace = 0; end
if logspace
  ll  = log(ll);
  lle = log(lle); 
  x   = isinf(ll) | isnan(ll) | isinf(lle) | isnan(lle);
  ll(x) = []; lle(x) = [];
  logstr = 'Log ';
else
  logstr = '';
end
m = double(max([ll(:);lle(:)]));
% calculate statistics
B = polyfit(ll,lle,1);
E = polyfit(ll,lle-ll,1);
R = corr(ll',lle');
% plotting auto vs man
figure; hold on;
scatter(ll,lle,'ko');
plot([0,m],[B(2),B(1)*m],'r--');
plot([0,m],[0,m],'k','linewidth',0.75);
axis('equal'); xlim([0,m]); ylim([0,m]);
text(0.05*m,0.95*m,['$$A = ',num2str(B(2),'%.03f'),'+',num2str(B(1),'%.03f'),'\cdot M$$'],...
  'interpreter','latex');
text(0.05*m,0.85*m,['$$R^2=',num2str(R,'%.03f'),'$$'],...
  'interpreter','latex');
xlabel([logstr,labels{2},' ',labels{1}],'interpreter','latex');
ylabel([logstr,labels{3},' ',labels{1}],'interpreter','latex');
figresize(gcf,[500,450]);
tightsubs(1,1,gca,0.12*[1.5,1,1,0]);
% plotting (man-auto) vs man
figure; hold on;
scatter(ll,lle-ll,'ko');
plot([0,m],[E(2),E(1)*m],'r--');
plot([0,m],[0,0],'k','linewidth',0.75);
daspect([2,1,1]); xlim([0,m]); ylim([-0.25*m,+0.25*m]);
xlabel([logstr,labels{2},' ',labels{1}],'interpreter','latex');
ylabel(['Difference (',logstr,labels{3},' $$-$$ ',labels{2},') ',labels{1}],'interpreter','latex');
figresize(gcf,[500,450]);
tightsubs(1,1,gca,0.12*[1.5,1,1,0]);
