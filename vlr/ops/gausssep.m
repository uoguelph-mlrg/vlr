% [G] = gausssep(sig)
% 
% GAUSSSEP generates N 1D Gaussian probability density functions having the 
%   standard deviations specified in the vector sig. Each element in sig 
%   corresponds to a dimension. Can be used for separate 1D convolutions.
% 
% Inputs:
%   sig - N-vector corresponding to the standard deviations requested for each 
%         of N dimensions.
% 
%   wid - (optional) width of the kernel (in both directions) in units of
%         standard deviations. Default: 3
% 
% Outputs:
%   G   - N 1-D Gaussian kernels (cell).
% 
% Jesse Knight 2016

function [G] = gausssep(sig,wid)
if nargin == 1
  wid = 3;      % how many std to include?
end
N = numel(sig); % num dims
for n = 1:N
  R = floor(-wid*sig(n)):ceil(+wid*sig(n)); % sampling points in each dim
  G{n} = shiftdim(normpdf(R,0,sig(n)),2-n);
  G{n} = G{n}./sum(G{n}(:));
end


