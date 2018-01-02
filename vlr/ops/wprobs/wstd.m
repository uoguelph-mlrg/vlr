% [mu] = wstd(Y,X)
% 
% WSTD gives the standard deviation of Y, weighted by X
% 
% Jesse Knight 2016

function [sig] = wstd(Y,X,wm)
if nargin == 2
  wm = wmean(Y,X);
end
sig = sqrt(sum(((Y(:)-wm).^2).*X(:)) / sum(X(:)));