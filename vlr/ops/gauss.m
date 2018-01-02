% [G] = gauss(sig)
% 
% GAUSS generates an N-D Gaussian probability density function having the 
%   standard deviations specified in the vector sig. Each element in sig 
%   corresponds to a dimension. Guaranteed to have unit norm.
% 
% Inputs:
%   sig - N-vector corresponding to the standard deviations requested for each 
%         of N dimensions.
% 
%   wid - (optional) width of the kernel (in both directions) in units of
%         standard deviations. Default: 3
% 
% Outputs:
%   G   - N-D Gaussian kernel.
% 
% Jesse Knight 2016

function [G] = gauss(sig,wid)
if nargin == 1
  wid = 3;        % how many std to include?
end
N = numel(sig); % num dims
X = cell(1,N);  % N-D grid coordinates
W = cell(1,N);  % store size of the kernel later
for n = 1:N
  R{n} = floor(-wid*sig(n)):ceil(+wid*sig(n)); % sampling points in each dim
end
[X{:}] = ndgrid(R{:},1); % transform to grid N-D arrays
W(:)   = cellfun(@numel,R,'uni',false); % track exact size
for n = 1:N
  X{n} = X{n}(:); % vectorize the grids for mvnpdf below
end
G = mvnpdf(cat(2,X{:}),zeros(1,N),sig); % compute vectorized kernel values
G = reshape(G,cat(2,W{:},1)); % reshape to N-D array
G = G./sum(G(:)); % assert unit norm

