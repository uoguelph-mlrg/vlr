% [pXY,pY,U] = pofxy(Y,X,op,varargin)
% 
% POFXY computes the conditional probability of X given Y - p(X|Y),
%   "p of given y", using the user specified conditional probability operator.
%   This implementation uses a relatively fast sort-lookup technique.
%
% Inputs:
%   Y  - N-D data which is binned, then for each bin, the matching indices
%        are used to select data in X for computing the probability.
%   X  - N-D data (same size) on which the probability operation acts.
%   op - probability operator - e.g. @mean or @(x)ksdensity(x,0.5);
% 
%   varargin: passed straight to biny to bin the values in Y (see help biny).
%             N  - number of bins
%             mi - minmax (input)
%             mo - minmax (output)
% 
% Outputs:
%   pXY - conditional probability of x given y
%   pY  - normalized histogram of Y
%   U   - unique bin values (of Y)
% 
% Jesse Knight 2016

function [pXY,pY,U] = pofxy(Y,X,op,varargin)
assert(strcmp(class(Y),class(X)),'Class of Y and X must match.');
% bin the data for easy lookup
[YU,U] = biny(Y,varargin{:});
% sort the data for faster lookup of paired data
[YS,s] = sort(YU(:));  % sorting source data
XS     = X(s);         % sorting paired data same order
% initialize the source data output
pY = nan(numel(U),1);
% calculating source histogram
for u = 1:numel(U)
  idx     = (YS(:)==U(u));  % lookup indices
  pY(u)   = sum(idx);       % count these
end
% initialize paired data output
pXY = zeros(numel(U),1);
% index ranges in sorted XS: faster than lookup
idx = [0,cumsum(pY')];
% calculating paired data histogram
for u = 1:numel(U)
  if idx(u+1) > idx(u)+1 % not empty
    idxu = idx(u)+1 : idx(u+1);
    pXY(u) = op(XS(idxu));
  else % empty
    pXY(u) = nan;
  end
end
pY = pY'./numel(XS); % normalize the source histogram
