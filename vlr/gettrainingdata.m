% GETTRAININGDATA
% This function either:
% - preps the training data from scratch (h.sam.fresj = 1)
% - loads the training data from file    (h.sam.fresj = 0)
% and returns the results in
% h (some metadata changed) and
% Y and C both size: [V,N], for V voxels, and N subjects

function [h,Y,C,Yx,Cx] = gettrainingdata(h)
if ~exist(h.save.figdir), mkdir(h.save.figdir); end
if h.sam.fresh
  statusupdate(1,2);
  [h,Y,C]   = maketrainingdata(h);
  statusupdate(2,2);
  [Yx,Cx]   = maketestingdata(h);
  ho.M      = h.M;
  ho.sam.Mr = h.sam.Mr;
  ho.sam.i  = h.sam.i;
  save(h.save.train,'-v7.3','Y','C','Yx','Cx','ho');
else
  load(h.save.train,'Y','C','Yx','Cx','ho');
  h.M      = ho.M;
  h.sam.Mr = ho.sam.Mr;
  h.sam.i  = ho.sam.i;
end