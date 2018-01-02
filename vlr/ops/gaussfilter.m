function [IG] = gaussfilter(I,sig)
G  = gausssep(sig);
IG = I;
for g = 1:numel(G)
  IG = imfilter(IG,G{g},'replicate');
end
