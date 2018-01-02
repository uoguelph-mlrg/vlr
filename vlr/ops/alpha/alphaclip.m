% ALPHACLIP
% This function calls alphatrim, then clips the data in Y
% according to the computed limits.
% A mask can be used for the alpha computation, but then ignored for the clip.

function [Yclip] = alphaclip(Y, trims, mask)
if nargin == 3
  [~, ytrims] = alphatrim(Y, trims, mask);
elseif nargin == 2
  [~, ytrims] = alphatrim(Y, trims);
end
Yclip = clip(Y,ytrims);