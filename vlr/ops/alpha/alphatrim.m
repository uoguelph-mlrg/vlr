% [idx, ytrims] = alphatrim(Y, trims, mask)
% 
% ALPHATRIM computes a mask for an N-D array indicating values which are
%   within the specified alpha-"trims" (on the interval [0,1]).
%   An additional mask can be specified by the user to further refine the 
%   alpha-trim data; however the output indices may contain values outside
%   this mask. The cutoff values are also returned. This implementation
%   uses a fast sorting-based method.
% 
% Inputs:
%   Y      - ND array of real-valued data
%   trims  - 2-element vector on the interval [0,1] dictating what fractions
%            of the data in Y to exclude
%   mask   - (optional) additional mask within which to seach to find the 
%            alpha-trims only.
% 
% Outputs:
%   idx    - indicies of valid elements: within alpha trims
%   ytrims - values corresponding to the alpha trim cutoffs
%   
% Jesse Knight 2016

function [idx, ytrims] = alphatrim(Y, trims, mask)
% vectorize the data with/out the mask
if nargin == 3
  YB = Y(logical(mask));
  if isempty(YB)
    idx = []; ytrims = []; return;
  end
else
  YB = Y(:);
end
NY     = numel(YB); % count the elements 
[YS]   = sort(YB);  % sort the values
ntrims = NY.*trims; % find alpha trims in sorted-index space
ytrims = [YS(round(max(1, ntrims(1)))),...  % store the cutoff values
          YS(round(min(NY,ntrims(2))))];    % ...
idx    = (Y > ytrims(1)) & (Y < ytrims(2)); %

