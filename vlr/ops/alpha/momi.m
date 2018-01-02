% [X,mm] = momi(X);
% 
% MOMI normalizes the data in X to the range [0,1] using the max-min
%   of the data.
% 
% Jesse Knight 2016

function [X,mm] = momi(X)
mm = [min(X(:)),max(X(:))];
X = (X-mm(1))./diff(mm);