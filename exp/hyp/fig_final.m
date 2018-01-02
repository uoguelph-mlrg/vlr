function [] = fig_final(todo)
if nargin < 1, todo = {'sum','lpa','man','exseg','thr'}; end
h = hypdef_final;
load(h.save.name,'h','o');
for i = 1:numel(todo)
  switch todo{i}
    case 'sum'
      load(h.save.name,'t');
      summarizeresults(h,o,t);
      copythesisresults;
    case 'lpa'
      fig_lpa({'beta','compare'},h);
    case 'man'
      stats_man(o);
    case 'exseg'
      fig_exseg(h,o);
    case 'thr'
      fig_thropt(h);
  end
end

function [] = stats_man(o)
names = {'i15','m16'};
fprintf('MANUAL COMPARISONS =====================\n');
for n = 1:numel(names)
  man = load(['data/misc/',names{n},'-mantoman.mat']);
  docomparison({man.si(:),o.si(:)},{names{n},'LPA'});
end
fprintf('LL COMPARISON ==========================\n');
icc = ICC([o.ll(:),o.lle(:)],'A-1');
 fprintf('ICC = %.03f\n', icc);


function [] = docomparison(x,names)
p = ranksum(x{:});
pre = sprintf('[%s : %s] [%.03f : %.03f] -',...
  names{:},median(x{1}),median(x{2}));
printpval(pre,p);