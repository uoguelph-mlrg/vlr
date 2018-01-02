function [C] = nd2cell(I4,dim)
I4 = shiftdim(I4,dim-1);
for d = 1:size(I4,1)
  C{d} = squeeze(I4(d,:,:,:,:,:,:,:,:,:));
end
