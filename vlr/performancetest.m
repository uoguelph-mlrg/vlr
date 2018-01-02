% PERFORMANCETEST
% This function analyzes the performance of *any* segmentation model,
% provided the initial segmentations (can be probabilistic) are saved as nii.
% These segmentations are loaded using imglutname with the key specified.
% Segmentations are thresholded using either the default threshold specified
% in h.pp.thr.def, or loaded from the file:
% ['data/',h.name.data,'-thropt-',key,'.mat']
% (if the threshold has been optimized in cross validation, for instance).

function [o,h] = performancetest(h, key, o, flag)
if nargin < 3, flag = ''; end
% try to load optimal thresholds
[h] = loadthropt(h,key,flag);
for i = 1:h.Ni
  % load nii images from file (no mrf)
  [C,G,x] = loadkeyimg(h,key,i);
  % analyze performance
  [o.si(i),o.pr(i),o.re(i),o.ll(i),o.lle(i),TP,FP,FN] = performance(C,G,x/10);
  % store the TP FP FN
  [t.FP{i},t.TP{i},t.FN{i}] = ptx2mni(h.Ni, i, single(FP), single(TP), single(FN));
  % update status bar
  statusbar(h.Ni,i,h.Ni/3,1); fclose('all');
end

function [C,G,x] = loadkeyimg(h,key,i)
% read and threshold the images for comparison
[C,x] = readnicenii(imglutname(lower(key), h.Ni,i));
[G]   = readnicenii(imglutname('mans',     h.Ni,i));
G     = G > 0.5;
C     = C > h.pp.thr.opt(h.cv.i(i));

function [h] = loadthropt(h,key,flag)
% try to load the optimal threshold file, if it exists
% make sure it has the same data key as the current data
if isfield(h.pp.thr,'opt')
  assert(strcmp(h.name.key,key) || strcmp(flag,'-h'),[...
    'Keys do not match - h: ''%s'', given: ''%s''\n'...
    'Are you sure you want to use these optimal thresholds?\n',...
    'If so: use the flag ''-h''.'],...
    h.name.key, key);
else
  throptmat = ['data/',h.name.data,'-thropt-',key,'.mat'];
  assert(exist(throptmat,'file') || strcmp(flag,'-d'),[...
    'Can''t find optimal thresholds file: ''%s''\n',...
    'To use h.pp.thr.def instead, use the flag ''-d''.'],...
    throptmat);
  if exist(throptmat,'file')
    load(throptmat);
    h.pp.thr.opt = thr;
  else
    h.pp.thr.opt = h.pp.thr.def * ones(size(h.cv.N));
  end
end