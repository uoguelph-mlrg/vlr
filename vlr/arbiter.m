% ARBITER
% This function runs one entire cross validation 
% of the segmentation model:
% 1. Load the experiment hyperparameters
% 2. Load training data
% 3. For all cross valiation folds:
%   3.1. Define the training-testing indices
%   3.2. Fit the VLR model
%   3.3. Inference & post processing on test images
%   3.4. Performance evaluation on test images
%   3.5. Save results to file
% 4. Summarize the results with automated plotting
%    and PDF report generation.
% `h` can be defined as in hypdef_final, hypdef_base, etc.

function [] = arbiter(h)
% ==================================================
statusupdate(80);
statusupdate([h.name.full]); statusupdate();
statusupdate(80);
% --------------------------------------------------
statusupdate('loading training data...'); statusupdate();
[h,Y,C,Yx,Cx] = gettrainingdata(h); t = [];
% ==================================================
for c = 1:numel(h.cv.N)
  statusupdate(80);
  % ------------------------------------------------
  statusupdate(c,numel(h.cv.N)); statusupdate();
  [idx] = makeidx(h,c);
  % ------------------------------------------------
  statusupdate('computing regression...'); statusupdate();
  [o.B{c}] = trainlogreg(h,idx,Y,C);
  % ------------------------------------------------
  statusupdate('optimizing threshold...'); statusupdate();
  [o.thr(c)] = thropt(h,Yx,Cx,o.B{c},find(idx.i.train));
  % ------------------------------------------------
  statusupdate('measuring test performance...');
  %[o,t] = performancebat(h,o,t,idx); % fast matlab spawns
  [o,t] = performancebati(h,o,t,idx); % slow singleton
  %[o,h] = performancetest(h,'loso'); % for LPA, etc.
  % ------------------------------------------------
  statusupdate('saving...'); statusupdate();
  save(h.save.name,'h','o','t','-v7.3');
end
statusupdate(80);
% ==================================================
statusupdate('summarizing results...'); statusupdate();
summarizeresults(h, o, t);
% --------------------------------------------------
statusupdate('done');statusupdate();
statusupdate(80);
% ==================================================

function [B] = trainlogreg(h,idx,Y,C)
% append the pseudolesions
[Y,C,idx] = dataregfun(h.lr.reg.py,h.lr.reg.pc,Y,C,idx);
% compute the regression
[b] = vlrmap(h, Y(:,idx.s.train), C(:,idx.s.train));
% reconstruct the parameter images
B = reconparams(h, b);




