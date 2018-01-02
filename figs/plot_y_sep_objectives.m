function [] = plot_y_sep_objectives()
for t = 1:3
  switch t
    case 1
      Y = {[0.1,0.15,0.18,0.25,0.29,0.36,0.48,0.72],...
           [0.43,0.52,0.62,0.67,0.75,0.78,0.85]};
    case 2
      Y = {[0.1,0.15,0.18,0.25,0.29,0.36,0.41,0.49],...
           [0.51,0.54,0.61,0.75,0.78,0.85]};
    case 3
      Y = {[0.1,0.15,0.18,0.25,0.29,0.36,0.40,0.43],...
           [0.61,0.64,0.69,0.75,0.78,0.85]};
  end
  C = [zeros(size(Y{1})),ones(size(Y{2}))];
  Y = cat(2,Y{:});
  plotsave(['jsep-diff-',num2str(t)],@Jdiff,Y,C);
  plotsave(['jsep-conv-',num2str(t)],@Jconv,Y,C);
end

function [] = Jdiff(Y,C)
[J,YS,CS] = jsepdiff(Y,C);
plot(YS,CS,'-','color',lighten(red(1),0.5));
j = 0;
for i = 1:numel(YS)-1
  if CS(i) ~= CS(i+1)
    j = j + 1;
    text(mean([YS(i),YS(i+1)]),0.5,num2str(j),'backgroundcolor','w',...
      'horizontalalignment','center','verticalalignment','middle');
  end
end
text(0.05,1,['$\mathcal{Z} = ',num2str(J),'$'],'interpreter','latex');

function [] = Jconv(Y,C)
[J,P,Po] = jsepconv(Y,C);
N = numel(Po);
scale = 0.04;
clr = {lighten(blu(1),0.2),lighten(blu(1),0.5)};
area(linspace(0,1,N),scale*P{2},'facecolor',lighten(clr{2},0.5),'edgecolor',clr{2});
area(linspace(0,1,N),scale*P{1},'facecolor',lighten(clr{1},0.5),'edgecolor',clr{1});
area(linspace(0,1,N),scale*Po,  'facecolor',lighten(red(1),0.3),'edgecolor',red(1));
text(0.05,1,['$\mathcal{Z} = ',num2str(J,'%.02f'),'$'],'interpreter','latex');

function [] = plotsave(name,fun,Y,C)
figure; hold on;
plot(Y,C,'ko','markersize',10);
fun(Y,C);
plot(Y,C,'ko','markersize',10);
xlim([0,1]);       xlabel('Transformed Graylevels $(\tilde{y})$','interpreter','latex')
ylim([-0.1,+1.1]); ylabel('Lesion Class $(c)$','interpreter','latex');
tightsubs(1,1,gca,[0.2,0.2,0.05,0.05]);
print(gcf,thesisname('fig',name),'-depsc');
close(gcf);