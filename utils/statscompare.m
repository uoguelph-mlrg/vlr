function [] = statscompare(pfun,X,name,labs)
if nargin < 4, labs = {}; end
statusupdate(21); statusupdate(name); statusupdate; statusupdate(21);
X(end+1,:)  = arrayfun(@(i)cat(2,X{:,i}),1:size(X,2),'un',0);
labs(end+1) = {'ALL ---------------'};
for i = 1:size(X,1)
  fprintf('  %s\n',labs{i});
  combs = nchoosek(1:size(X,2),2);
  for c = 1:size(combs,1)
    p   = pfun(X{i,combs(c,1)},X{i,combs(c,2)});
    pre = sprintf('[%d:%d] [%.03f : %.03f] -',...
      combs(c,1),combs(c,2),median(X{i,combs(c,1)}),median(X{i,combs(c,2)}));
    printpval(pre,p);
  end
end