function [] = textableres(h,o,fname,names)
if nargin < 3
  fname = fullfile(h.save.figdir,resultsname('tab'));
end
if ~iscell(o)
  N = 1;
  o = {o};
  fmt = 'rcccc';
  toprows = {'Scanner','LL','SI','Pr','Re'};
else
  N = numel(o);
  fmt = sprintf('rc%s',repmat('ccc',[1,N]));
  R1 = cellfun(@(s)sprintf('\\\\multicolumn{3}{c}{%s}',s),names,'un',0);
  R2 = arrayfun(@(i)(' SI & Pr & Re '),1:N,'un',0);
  RL = arrayfun(@(i)(sprintf('\\\\cmidrule(lr){%d-%d}',3*i+1,3*i+3)),1:N,'un',0);
  toprows = {'','',R1{:};[cell2mat(RL),'Scanner'],'LL',R2{:}};
end
str = '';
str = [str,textable('top',toprows,fmt)];
for i = 1:numel(h.scan.N)
  str = [str,makeline(o,h.scan.i==i,h.scan.names{i},h.scan.clr(i,:))];
end
str = [str,'\\midrule\n'];
str = [str,makeline(o,true(size(h.scan.i)),'ALL',[1,1,1])];
str = [str,textable('bottom')];
f = fopen(fname,'w');
fprintf(f,str);
fclose(f);

function [str] = makeline(o,idx,name,clr)
mop = @median;
N = numel(o);
data = num2cell(cell2mat(arrayfun(@(i)([...
    mop(o{i}.si(idx)),...
    mop(o{i}.pr(idx)),...
    mop(o{i}.re(idx))]...
    ),1:N,'un',0)));
sclr  = sprintf(' %0.02f',clr);
sname = sprintf('%s {\\\\color[rgb]{%s}$\\\\blacksquare$}',name,sclr);
fmt   = arrayfun(@(i)('%.02f'),1:3*N,'un',0);
line  = {sname,mop(o{1}.ll(idx)),data{:}};
str   = textable('line',line,{'','%.0f',fmt{:}});