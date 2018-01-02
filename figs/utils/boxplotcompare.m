function [] = boxplotcompare(h,metrics,mlabs,llthr,savename,leg,pfun,tn)
% clean up inputs
if nargin < 3,          mlabs = metrics;     end
if nargin < 4,          llthr = [];          end
if nargin < 5,          savename = '';       end
if nargin < 6,          leg = {};            end
if nargin < 7,          pfun = [];           end
if nargin < 8,          tn = {'fig','seg'};  end
if isa(metrics,'char'), metrics = {metrics}; end
if isa(mlabs,'char'),   mlabs = {mlabs};     end
% initializations
N.m = length(metrics);
N.h = numel(h);
N.t = length(llthr)+1;
X = cell(N.t,N.h,N.m);
% collect the data in a sincle cell for boxplotn
for n = 1:N.h
  o = load(h{n}.save.name,'o');
  [idx,labs] = ll2idx(o.o.ll,llthr);
  for i = 1:size(idx,2)
    for m = 1:N.m
      X{i,n,m} = o.o.(metrics{m})(idx(:,i));
    end
  end
end
% make the box plots
cmap = rainbow7;
for m = 1:N.m
  preplot();
  boxplotn(X(:,:,m),cmap,labs);
  postplot(N,mlabs{m});
  if ~isempty(savename)
    print(thesisname(tn{:},[savename,'-',metrics{m},'.eps']),'-depsc');
    close(gcf);
  end
  if ~isempty(pfun)
    statscompare(pfun,X(:,:,m),mlabs{m},labs);
  end
end
if ~isempty(leg)
  extralegend(leg,cmap,[1,numel(leg)]);
  if ~isempty(savename)
    print(thesisname(tn{:},[savename,'-leg.eps']),'-depsc');
    close(gcf);
  end
end

function [idx,labs] = ll2idx(ll,llthr)
% make binary group selector by lesion load,
% using thresholds llthr
if isempty(llthr)
  idx = true(size(ll(:)));
  labs = {''};
else
  idx   = false(length(ll),length(llthr)+1);
  llthr = [0;llthr(:);inf];
  Nt    = numel(llthr)-1;
  for t = 1:Nt
    idx(:,t) = (ll>llthr(t)) & (ll<llthr(t+1));
    switch t
      case 1
        labs{t} = sprintf('<%0.0f',llthr(t+1));
      case Nt
        labs{t} = sprintf('>%0.0f',llthr(t));
      otherwise
        labs{t} = sprintf('%0.0f-%0.0f',llthr(t),llthr(t+1));
    end
  end
end

function [] = preplot()
figure;
hold on;
for l = 0.2:0.2:0.8
  plot([0,1/eps],[l,l],'-','linewidth',1,'color',lighten([0,0,0],0.8));
end

function [wid] = postplot(N,mlab)
wid = [150 + 50*N.t*N.h + 100*N.t];
figresize(gcf,[wid,550]);
set(gca,'ylim',[0,1]);
ylabel(mlab,'interpreter','latex');
if N.t > 1
  xlabel(['$LL$ (mL)'],'interpreter','latex');
end
tightsubs(1,1,gca,0.03*[5, 4, 1, 1]);




