function [M] = makecvmasks(h)
load(h.save.train);
Zr = zeros(size(h.sam.Mr));
for c = 1:numel(h.cv.N)
  idx = makeidx(h,c);
  t1  = any(C(:,idx.s.train),2);
  v1  = any(C(:,idx.s.valid),2);
  M.t1{c} = makeresizeimg(h,t1,Zr,0,@(x)(x)) >= 0.5;
  M.v1{c} = makeresizeimg(h,v1,Zr,0,@(x)(x)) >= 0.5;
  M.t0{c} = (h.M) & (~M.t1{c});
  M.t0v1{c} = (M.t0{c}) & (M.v1{c});
  statusbar(numel(h.cv.N),c,h.Ni/3,1);
end
