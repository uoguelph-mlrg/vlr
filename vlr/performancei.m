% PERFORMANCEI
% This function computes the performance analysis for a number of images,
% selected by ivec (indices in 1:h.Ni).
% This function expects the file tpmname('c',c,'.mat') to exist, and contain the
% variables h, B, thr, where B is in MNI space.
% B is warped to patient space using mni2ptx, inference is computed, post-
% processing is applied, then performance is analyzed.
% TP, FP, and FN images are warped from pt space to MNI space for later use.
% Outputs are saved in the variable p to tmpname('i',i,'.mat').

function [] = performancei(c,ivec)
load(tmpname('c',c,'.mat'),'h','B','thr');
for i = ivec
  % load all images into pt space
  [I,x] = readnicenii(imglutname('FLAIRm',h.Ni,i));
  [G]   = readnicenii(imglutname('mans',  h.Ni,i));
  % warp the B images to pt space
  [Bi{1},Bi{2},Mi] = mni2ptx(h.Ni,i,B{:},h.M);
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
  C = postpro(h,C0,x,thr);
  % analyze performance
  [p.si,p.pr,p.re,p.ll,p.lle,TPi,FPi,FNi] = performance(C,G,x/10);
  % warp the TP FP FN
  [p.FP,p.TP,p.FN] = ptx2mni(h.Ni,i,FPi,TPi,FNi);
  % write to file if not captured output
  save(tmpname('i',i,'.mat'),'p');
end

function [p] = pdef()
p.si  = nan;
p.pr  = nan;
p.re  = nan;
p.ll  = nan;
p.lle = nan;
p.FP  = nan([145,121,121]);
p.TP  = nan([145,121,121]);
p.FN  = nan([145,121,121]);