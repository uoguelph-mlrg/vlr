% READNICENII
% Read a .nii file and immediately apply some basic pre-processing.
% M is a brain mask (must be same size as I)
% mm is a 2 element vector denoting the quantiles (0-1) for clipping the data
% and rescaling to the range [0,1]

function [I,x] = readnicenii(fname,M,mm)
if nargin == 2, e = 0.0001; mm = [e,1-e]; end
[I,x] = readnii(fname);
I = imrotate(I,180);
I(isnan(I)) = 0;
I = max(0,I);
if nargin == 2
  I(M<0.5) = 0;
  I = momi(alphaclip(I,mm,M>0.5));
end
I = single(I);
