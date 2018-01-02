function [] = statusbar(K,k,wid,timestamp,char)
if nargin < 4, timestamp = 0; end % print timestamps?
if nargin < 5, char = '#'; end    % default character
if timestamp
  if k == 1
    tic;
    dt = repmat(' ',[1,10]);        % start timer, print nothing
  else
    dt = sprintf(' dt = %4.f',toc); % print elapsed time
  end
else
  dt = ''; % no timer
end
% compute number of # (N)
k   = max(1,k);
K   = max(k,K);
wid = ceil(wid);
N   = floor(wid*k/K);
if (k < K) && (N == K)
  N = N - 1;
end
% backspace to overwrite the previous bar (unstable if errors)
backspace = repmat('\b',[1,wid+2+numel(dt)]);
% collect the string
bar = ['[',repmat(char,[1,N]),repmat('-',[1,wid-N]),']',dt]; 
if k > 1
  bar = [backspace,bar];
end
fprintf(bar); % do the print
if k==K
  fprintf('\n'); % done everything: print newline
end