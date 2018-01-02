% BINSPHERE
% make a binary sphere-ish 3D image of radius R (in pixels)

function [V] = binsphere(R)
[x,y,z] = ndgrid(-R:R);
SE = strel(sqrt(x.^2 + y.^2 + z.^2) <=R);
V = double(SE.getnhood());