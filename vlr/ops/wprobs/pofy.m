% [pY,YU,U] = pofy(Y,varargin)
% 
% POFY is an anaolgue to the hist function - p(Y), "p of y" - with different
%   control over the parameters; also serves as a template for other
%   conditional probability functions: pofxy, pofwy, pofxwy.
%
% Inputs:
%   Y - N-D data for which to compute the probability distribution.
% 
%   varargin: passed straight to biny to bin the values in Y (see help biny).
%             N  - number of bins
%             mi - minmax (input)
%             mo - minmax (output)
% 
% Outputs:
%   pY - normalized histogram of Y
%   YU - values of Y in the specified bins (vectorized)
%   U  - unique bin values
% 
% Jesse Knight 2016

function [pY,YU,U] = pofy(Y,varargin)
% bin the data for easy lookup
[YU,U] = biny(Y,varargin{:});
YU = YU(:);
% initialize the output
pY = nan(numel(U),1);
% calculating histogram
for u = 1:numel(U)
  idx   = (YU==U(u));  % lookup indices
  pY(u) = sum(idx);    % count these
end
pY = pY./numel(Y); % normalize 
