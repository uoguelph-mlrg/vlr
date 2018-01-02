% [pXYW,U] = pofwxy(Y,X,W,op,varargin)
% 
% POFWXY computes the weighted conditional probability of X given Y using
%   the user specified weighted conditional probability operator.
%   This implementation uses a relatively fast sort-lookup technique.
%
% Inputs:
%   Y  - N-D data which is binned, then for each bin, the matching indices
%        are used to select data in X for computing the probability.
%   X  - N-D data (same size) on which the probability operation acts.
%   W  - N-D (same size) weights for each value in X
%   op - weighted probability operator - e.g. @wmean or
%        @(x,w)ksdensity(x,0.5,'weights',w);
% 
%   varargin: passed straight to biny to bin the values in Y (see help biny).
%             N  - number of bins
%             mi - minmax (input)
%             mo - minmax (output)
% 
% Outputs:
%   pXYW - weighted conditional probability of x given y, by w
%   U    - unique bin values (of Y)
% 
% Jesse Knight 2016

function [pXYW,U] = pofwxy(Y,X,W,op,varargin)
% bin the data for easy lookup
[YU,U] = biny(Y,varargin{:});
% sort the data for faster lookup of paired data
[YS,s] = sort(YU(:));  % sorting source data
XS     = X(s);         % sorting paired data same order
WS     = W(s);         % sorting weights same order
% initialize the source data histogram (internal)
pY = nan(numel(U),1);
% calculating source histogram
for u = 1:numel(U)
  idx     = (YS(:)==U(u));  % lookup indices
  pY(u)   = sum(idx);       % count these
end
% initialize paired data output
pXYW = zeros(numel(U),1);
% index ranges in sorted XS and WS: faster than lookup
idx = [0,cumsum(pY')];
% calculating paired data weighted histogram
for u = 1:numel(U)
  if (idx(u+1) > idx(u)+1) % not empty indices
    idxu = idx(u)+1:idx(u+1);
    if any(WS(idxu)) % not empty weights
      pXYW(u) = op( XS(idxu), WS(idxu) );
    else % empty weights
      pXYW(u) = nan;
    end
  else % empty indices
    pXYW(u) = nan;
  end
end
