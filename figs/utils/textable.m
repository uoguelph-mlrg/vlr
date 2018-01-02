function [str] = textable(part, varargin)
switch part
  case 'top'
    titles = varargin{1};
    cols = varargin{2};
    str = ['\\begin{tabular}{',cols,'}\n\\toprule\n',...
           linestr(titles),'\\midrule\n'];
  case 'line'
    data = varargin{1};
    fmt = varargin{2};
    str = linestr(data,fmt);
  case 'bottom'
    str = '\\bottomrule\n\\end{tabular}';
end
str = strrep(str,'NaN','---');
str = strrep(str,'Inf','$\\infty$');

function [str] = linestr(X,fmt)
if nargin < 2
  fmt = '%.02f';
end
if isa(fmt,'char')
  fmt = repmat({fmt},size(X));
end
if isa(X,'cell')
    fun = @(j,i)([num2str(X{j,i},fmt{j,i}),' & ']);
end
if isa(X,'numeric')
    fun = @(j,i)([num2str(X(j,i),fmt{j,i}),' & ']);
end
% inject ' & '
str = '';
for j = 1:size(X,1)
  str = [str,cell2mat(arrayfun(@(i)fun(j,i),1:size(X,2),'un',0))];
  str(end-1:end+4) = '\\\\\n';
end

