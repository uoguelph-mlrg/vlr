function [] = fig_hypcompare(todo)
if nargin < 1, todo = {'ovb','cv','ystd','lam'}; end
metrics = {{'si','pr','re'},{'$SI$','$Pr$','$Re$'}};
tests   = deftests();
for i = 1:numel(todo)
  switch todo{i}
    case {'cv','ovb','lam'}
      [h,names] = defhypset(todo{i});
      boxplotcompare(h,metrics{:},[],[todo{i},'-box'],names,tests.rank.pair);
    case {'beta'}
      [h,names] = defhypset(todo{i});
      boxplotcompare(h,metrics{:},[],[todo{i},'-box'],names,tests.rank.pair);
      show_betas(defhypset(todo{i}),56);
    case {'ystd'}
      [h,names] = defhypset(todo{i});
      boxplotcompare(h,metrics{:},[4,22],[todo{i},'-box'],names,tests.rank.pair);
      show_ystd(defhypset(todo{i}));
    otherwise
      warning('Unrecognized todo: %s',todo{i});
  end
end

function [tests] = deftests()
tests.rank.pair = @(x1,x2)signrank([x1(:)-x2(:)]);
tests.rank.unpr = @(x1,x2)ranksum(x1(:),x2(:));
tests.norm.pair = @(x1,x2)outwo(@ttest,[x1(:)-x2(:)]);
tests.norm.unpr = @(x1,x2)outwo(@ttest2,x1(:),x2(:));

function [out] = outwo(fun,varargin)
[~,out] = fun(varargin{:});