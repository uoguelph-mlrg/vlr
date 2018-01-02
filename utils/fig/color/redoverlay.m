function [O] = redoverlay(I,C,mm)
a = 0.5;
d = numel(size(I));
W =  ones(size(C));
Z = zeros(size(C));
K = double(C & (I <= mm(1)));
O = im2rgb(I,gray,mm).*cat(d+1,W,W-a*C,W-a*C) + cat(d+1,K,Z,Z);