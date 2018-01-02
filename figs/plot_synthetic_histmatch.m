function [] = plot_synthetic_histmatch()
V = 100^3;
src = {'uniform','unimodal','bimodal','trimodal'};
clr = rainbow6; clr = clr([1,2,3,4],:);
tar = {'uniform','unimodal','bimodal','trimodal'};
for s = 1:numel(src), X{s} = data(V,src{s}); end
for t = 1:numel(tar), [T{t},pt{t}] = data(V,tar{t}); end
% plot original
figure; hold on;
for i = 1:numel(src)
  Q(i,:) = plot_quantiles(X{i},clr(i,:),0);
end
saveplot('histmatch-q-original','y','f_{\textsc{y}}(y)',[0,1],[0,5]);
D0 = meanquantilediff(Q);
% plot after different matching
for t = 1:numel(T)
  figure; hold on;
  for i = 1:numel(src)
    Y = histeq(X{i},pt{t});
    Y = Y+0.01*randn(size(Y));
    Q(i,:) = plot_quantiles(Y,clr(i,:),i/15);
  end
  fprintf(['%5.03f\n'],100*meanquantilediff(Q)/D0);
  saveplot(['histmatch-q-',tar{t}],'\tilde{y}','f_{\tilde{\textsc{y}}}(\tilde{y})',[0,1],[0,5]);
end
% legend
figure;
for s = 1:numel(src), plot(nan(2,1),'color',clr(s,:)); hold on; end
plot(nan(2,1),'s','markersize',2,'color',lighten([0,0,0],0.5),'linewidth',2);
figresize(gcf,[300,200]);
leg = {'Uniform source','Unimodal source','Bimodal source','Trimodal source','Quantiles'};
legend(leg);
legend(gca,'boxoff');
set(gca,'xcolor','w','ycolor','w');
print(gcf,thesisname('fig','histmatch-q-legend'),'-depsc');
close(gcf);

function [p,u] = histogram(x)
du = 0.002;
u = 0:du:1;
x(x<0|x>1) = nan;
p = ksdensity(x,u,'support',[0-2*du,1+2*du],'width',5*du);

function [T,pt] = data(V,type)
[~,u] = histogram([0,1]); % dummy call
switch type
  case 'uniform'
    T  = rand ([V,1]);
    pt = ones(size(u));
  case 'unimodal'
    T  = randn([V,1])*0.08 + 0.5;
    pt = normpdf(u,0.5,0.08);
  case 'bimodal'
    T  = [randn([0.5*V,1])*0.05+0.3; ...
          randn([0.5*V,1])*0.05+0.7];
    pt = 0.5*normpdf(u,0.3,0.05) ...
       + 0.5*normpdf(u,0.7,0.05);
  case 'trimodal'
    T  = [randn([0.3*V,1])*0.05+0.25; ...
          randn([0.4*V,1])*0.05+0.5; ...
          randn([0.3*V,1])*0.05+0.75;];
    pt = 0.3*normpdf(u,0.25,0.05) ...
       + 0.4*normpdf(u,0.50,0.05) ...
       + 0.3*normpdf(u,0.75,0.05);
end

function [Q] = plot_quantiles(X,clr,dy)
Q = quantile(X,linspace(0,1,15));
C = monomap(clr,numel(Q),[-1,+1]);
d = 1/4;
[p,u] = histogram(X);
hold on;
for q = 1:numel(Q)
  [~,i] = min(abs(u-Q(q)));
  y = clip([0:d:p(i)]+dy,[0,p(i)]);
  x = Q(q)*ones(size(y));
  plot(x,y,'s','markersize',2,'color',lighten(clr,0.5),'linewidth',2);
end
plot(u,p,'color',darken(clr,0));

function [D] = meanquantilediff(Q)
p = nchoosek(1:size(Q,1),2);
for i = 1:size(p,1)
  D(i) = mean(abs(Q(p(i,1),:)-Q(p(i,2),:)));
end
D = mean(D);

function [] = saveplot(name,x,y,xmm,ymm)
xlim(xmm); xlabel(['$',x,'$'],'interpreter','latex');
ylim(ymm); ylabel(['$',y,'$'],'interpreter','latex');
drawnow;
figresize(gcf,[600,400]);
print(gcf,thesisname('fig',name),'-depsc');
close(gcf);
