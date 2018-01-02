function [varargout] = show_tpfpfn_raw_thropt(I,G,thr)
cmap = inferno;
key = 'mni96-mni';
N   = 96;
savename = ['data/misc/',key,'-thr.mat'];
if nargin < 2               % load images
  load(['data/misc/',key,'-I.mat']);
  load(['data/misc/',key,'-G.mat']);
  M = brainfun;
  for i = 1:numel(I)
    I{i} = I{i}.*double(M);
  end
end
if nargin < 3
  if exist(savename,'file') % load thresholds
    load(savename)
  else                      % calculate thresholds (expensive)
    for i = 1:numel(I)
      thr(i) = runthropt(I{i},G{i});
      statusbar(numel(I),i,numel(I)/3,1);
    end
    save(savename,'thr');   % save thresholds
  end
end
% create TP FP FN images
[TP,FP,FN] = tpfpfn(I,G,thr);
sliceshow(TP,zfun,cmap,[0,0.25]);
print(gcf,thesisname('fig','rawthropt-tp.png'),'-dpng'); close(gcf);
sliceshow(FP,zfun,cmap,[0,0.25]);
print(gcf,thesisname('fig','rawthropt-fp.png'),'-dpng'); close(gcf);
sliceshow(FN,zfun,cmap,[0,0.25]);
print(gcf,thesisname('fig','rawthropt-fn.png'),'-dpng'); close(gcf);
vcolorbar(0:0.05:0.25,cmap);
print(gcf,thesisname('fig','cmap-rawthropt.eps'),'-depsc'); close(gcf);
if nargout == 3
  varargout = {TP,FP,FN};
else
  varargout = {};
end

function [thr] = runthropt(I,G)
to      = double(quantile(I(:),0.95));
optfun  = @(t)objective(double(I(:)),double(G(:)),t);
fminopt = optimset('maxiter',100,'display','off');
thr     = fminsearch(optfun,to,fminopt);

function [J] = objective(I,G,t)
C   = I>t;
dsc = double(2*sum(C.*G)) ./ double(sum(C+G));
J   = -gather(dsc);

function [TP,FP,FN] = tpfpfn(I,G,thr)
N = numel(I);
TP = zeros(size(I{1}));
FP = zeros(size(I{1}));
FN = zeros(size(I{1}));
for i = 1:N
  Ci = I{i} > thr(i);
  Gi = G{i} > 0.5;
  TP = TP + (1/N)*double( Ci &  Gi);
  FP = FP + (1/N)*double( Ci & ~Gi);
  FN = FN + (1/N)*double(~Ci &  Gi);
end






