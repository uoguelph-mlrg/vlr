% KERNELSHIFTS
% Returns the shift amounts (relative to center element)
% of all other nonzero kernel elements (i.e. binary to [x1,x2,x3] coordinates)

function [dx] = kernelshifts(K)
cx = round([size(K,1),size(K,2),size(K,3)]/2);
ksize = size(K);
x  = cell([numel(ksize),1]);
dx = zeros([0,numel(ksize)]);
for i = 1:numel(K)
  if K(i)
    [x{:}] = ind2sub(ksize,i);
    dx(end+1,:) = cx - cat(2,x{:});
  end
end