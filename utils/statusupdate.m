function [] = statusupdate(str,den)
wid = 30;
if nargin == 1
  if ischar(str)   % starting task
    fprintf([upper(str),repmat(' ',[1,wid-numel(str)])]); tic;
  elseif str == 0  % ending task: print time
    fprintf('dt = %5.f',toc);
  else             % title bar (as long as the number str)
    fprintf([char(61*ones(1,str)),'\n']);
  end
elseif nargin == 2 % batch count (right justify)
  fprintf([char(32*ones(1,wid-13)),'[ %03.f / %03.f ]'],str,den);
elseif nargin == 0 % what are you doing? print newline
  fprintf('\n');
end