% NYULSTD
% Graylevel standardization proposed by Nyul et al (1999).
% Graylevels in y are piecewise linearly matched so that
% evenly spaced input quantiles match the output quantiles specified in 'qo'.
% The number of quantiles is taken from numel(qo).

function [yt] = nyulstd(y,qo)
N = numel(qo);
qi = quantile(y(:),linspace(0,1,N));
yt = zeros(size(y),class(y));
for i = 1:N-1
  x = (y>=qi(i)) & (y<=qi(i+1));
  yt(x) = qo(i) + (y(x)-qi(i)).*(qo(i+1)-qo(i))./(qi(i+1)-qi(i));
end
