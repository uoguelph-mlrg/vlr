% PERFORMANCEBATI
% This function analyzes the performance of the VLR model using the fitted
% parameter images in o.B{idx.c} -- i.e. one cross validation fold.
% This function does not require additional matlab spawns, unlike
% performancebat, and rolls the functionality of performancebat and performancei
% together in one (slower) function.

function [o,t] = performancebati(h,o,t,idx)
cidx = find(idx.i.valid);
for k = 1:numel(cidx)
  i = cidx(k);
  % load all images into pt space
  [I,x] = readnicenii(imglutname('FLAIRm',h.Ni,i));
  [G]   = readnicenii(imglutname('mans',  h.Ni,i));
  % warp the B images to pt space
  [Bi{1},Bi{2},Mi] = mni2ptx(h.Ni,i,o.B{idx.c}{:},h.M);
  % compute the prediction
  G   = G > 0.5;
  Y   = standardize(I,Mi,h.std.type,h.std.args{:});
  eta = Bi{1} + Bi{2}.*Y;
  C0  = Mi./(1+exp(-eta));
  % save the prediction before post-processing
  if h.pp.saveles
    writenii(imrotate(C0,180),imglutname(h.pp.saveles,h.Ni,i,0),...
                              imglutname('mans',      h.Ni,i,1),'double');
  end
  % post-processing
  C = postpro(h,C0,x,o.thr(idx.c));
  % analyze performance
  [p.si,p.pr,p.re,p.ll,p.lle,TPi,FPi,FNi] = performance(C,G,x/10);
  % warp the TP FP FN
  [p.FP,p.TP,p.FN] = ptx2mni(h.Ni,i,FPi,TPi,FNi);
  % gather the results into output data structure
  o.si(i) = p.si; o.pr(i) = p.pr; o.re(i) = p.re;
  o.ll(i) = p.ll; o.lle(i)= p.lle;
  t.TP{i} = p.TP; t.FP{i} = p.FP; t.FN{i} = p.FN;
  statusbar(numel(cidx),k,h.Ni/3,1);
end

