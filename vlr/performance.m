% PERFORMANCE
% This function computes the performance metrics, and TP/FP/FN images for one
% comparison of Ce (estimated) and Ct (true)

function [si,pr,re,ll,lle,TP,FP,FN] = performance(Ce,Ct,x)
% TP/FP/FN images
TP =  Ce &  Ct;
FP =  Ce & ~Ct;
FN = ~Ce &  Ct;
% TP/FP/FN voxel counts
nTP = sum(TP(:));
nFP = sum(FP(:));
nFN = sum(FN(:));
% metrics
si  = (2*nTP) ./ ((2*nTP) + nFP + nFN + eps); % similarity index 
pr  = nTP ./ (nTP + nFP + eps);               % precision
re  = nTP ./ (nTP + nFN + eps);               % recall
% lesion loads
if nargin == 2, x = 1; end % assume 1mm3 voxel volume
ll  = sum(Ct(:))*prod(x);  % true
lle = sum(Ce(:))*prod(x);  % estimated