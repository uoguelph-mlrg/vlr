% THROPT
% This function uses fminsearch to optimize the threshold (thr) applied to 
% probabilistic predictions of the lesion class (all data vectorized).
% The objective is to maximize the mean similarity index on the training data.

function [thr] = thropt(h,Y,C,B,nidx)
% compute the probabilistic output
statusupdate(1,2);
for i = 1:numel(nidx)
  [B0,B1,M] = mni2ptx(h.Ni,nidx(i),B{:},h.M);
  Q{i} = 1./(1+exp(-bsxfun(@plus,B0(M>0.5),bsxfun(@times,Y{nidx(i)}(:),B1(M>0.5)))));
  G{i} = C{nidx(i)}(:);
  statusbar(numel(nidx),i,h.Ni/3,1);
end
% define the inputs of the optimization by fminsearch
optfun  = @(t)objective(Q,G,t);
udfun   = @(x,ovals,state)updatefun(h.pp.thr.Nit,h.Ni/3,x,ovals,state);
fminopt = optimset('maxiter',h.pp.thr.Nit,'OutputFcn',udfun,'Display','off');
% run the optimization
statusupdate(2,2);
[thr,~,flag] = fminsearch(optfun, h.pp.thr.def, fminopt);
% print complete statusbar if early convergence
statusbar(h.pp.thr.Nit,h.pp.thr.Nit,h.Ni/3,1);

function [J] = objective(Q,C,thr)
for i = 1:numel(Q)
  Qi = Q{i} > thr;
  Ci = C{i} > 0.5;
  SI(i) = 2*sum(Qi.*Ci) ./ sum(Qi+Ci);
end
SI(isnan(SI)) = [];
J = -gather(mean(SI)); % gather mean from GPU
%fprintf('%.03f\n',J);

function [stop] = updatefun(Nit,wid,~,ovals,~,~)
% statusbar to show progress (might stop early if convergence)
stop = false;
if (ovals.iteration > 0) && (ovals.iteration < Nit)
  statusbar(Nit,ovals.iteration,wid,1);
end





