function [] = roianalysis(M)
if nargin < 1
  h = hypdef_final;
  load(h.save.name,'h');
  M = makecvmasks(h);
end
printvolumes(M,'t1');
printvolumes(M,'t0');
printvolumes(M,'t0v1');
roi = 't0';
[hs.lam,name.lam] = defhypset('lam');
[hs.psu,name.psu] = defhypset('psu');
performanceroi(hs.lam,M,roi);
performanceroi(hs.psu,M,roi);

function [] = performanceroi(hs,M,roi)
for s = 1:numel(hs)
  statusupdate(s,numel(hs));
  load(hs{s}.save.name,'h','t','o');
  h = hroi(h,roi);
  for i = 1:h.Ni
    [o.si(i),o.pr(i),o.re(i)] = ...
      performanceiroi(M.(roi){h.cv.i(i)},t.TP{i},t.FP{i},t.FN{i});
    o.lle(i) = nan;
    statusbar(h.Ni,i,h.Ni/3,1);
  end
  save(h.save.name,'h','o');
end

function [si,pr,re] = performanceiroi(ROI,TP,FP,FN)
ROI = single(ROI);
TP = sum(TP(:).*ROI(:));
FP = sum(FP(:).*ROI(:));
FN = sum(FN(:).*ROI(:));
si = 2*TP/(2*FP+FP+FN);
pr = TP/(TP+FP);
re = TP/(TP+FN);
si(isnan(si)) = 0;
pr(isnan(pr)) = 0;
re(isnan(re)) = 0;

function [] = printvolumes(M,field)
x  = (1.5^3)/1000;
Mf = M.(field);
v  = x*cell2mat(arrayfun(@(i)sum(Mf{i}(:)),1:numel(Mf),'un',0));
fprintf([field,': \t']);
printiqr(v,'%.0f');

function [] = printiqr(x,fmt)
fprintf(['$',fmt,'\\thinspace[',fmt,'-',fmt,']$\n'],...
  quantile(x,0.5),quantile(x,0.25),quantile(x,0.75));