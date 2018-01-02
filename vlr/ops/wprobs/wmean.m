% [mu] = wmean(Y,X)
% 
% WMEAN gives the mean of Y, weighted by X
% 
% Jesse Knight 2016

function [mu] = wmean(Y,X)
mu = sum(Y(:).*X(:)) / sum(X(:));
