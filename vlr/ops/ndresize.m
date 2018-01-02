function [IR] = ndresize(I, scale, rsize, method)
if nargin < 3, rsize = round(scale.*size(I)); end
if nargin < 4, method = 'linear'; end
if scale == 1 && all(size(I)==rsize)
  IR = I; return
end
D = numel(size(I));
A = [[scale.*eye(D);zeros([1,D])],[zeros([D,1]);1]];
tform = maketform('affine',A);
resam = makeresampler(method,'replicate');
IR = tformarray(I,tform,resam,1:D,1:D,rsize,[],[]);


