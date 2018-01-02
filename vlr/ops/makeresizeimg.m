function [X] = makeresizeimg(h,xr,Xr,pad,filt)
% define the resized data
Xr( h.sam.Mr) = xr;  % add data to zeros image
Xr(~h.sam.Mr) = pad; % define out-of-mask values
Xr(isnan(Xr)) = pad; % just in case
% resize to MNI space [145, 121, 121]
X = ndresize(Xr,1/h.sam.resize,size(h.M));
% apply the smoothing filter
X = filt(X);
% just in case again
X(~h.M) = pad;