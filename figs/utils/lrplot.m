function [] = lrplot(Y,C,B,varargin)
N = 512;
y = linspace(0,1,N); hold on;
c = 1./(1+exp(-(B(1)+y.*B(2))));
ylim([-0.1,+1.1]); ylabel('Lesion Class Probability ($\hat{c}$)','interpreter','latex');
xlim([ 0  , 1  ]); xlabel('Graylevel (y)','interpreter','latex');
plot(y,c,'linewidth',2,varargin{:});
if ~isempty(Y) && ~isempty(C)
  plot(Y(:),C(:),'kd','linewidth',2,'markersize',2);
end
set(gca,'xtick',[0:0.25:1],'ytick',[0:0.25:1]);
tightsubs(1,1,gca,[0.2,0.2,0.12,0.12]);