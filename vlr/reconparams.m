function  [B] = reconparams(h, b)
% zeros templates
X  = ones(size(h.M));          % MNI space
Xr = ndresize(X,h.sam.resize); % MNI-resized
% compute the parameter images
b(isinf(b(:))) = 0;
b(isnan(b(:))) = 0;
for i = 1:size(b,2)
  B{i} = makeresizeimg(h,b(:,i),Xr,h.lr.pad(i),h.lr.pp.filter);
end



