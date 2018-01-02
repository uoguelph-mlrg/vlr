% POSTPRO
% This function computes the post-processing for a single image C:
% 1. thresholding
% 2. minimum lesion size (converted here from voxels to pixel count); 26 connect

function [C] = postpro(h,C,x,thr)
% defaults:
if nargin < 3, x = [1,1,1];        end % assumed voxel size = [1,1,1]
if nargin < 4, thr = h.pp.thr.def; end % non-optimized threshold
C = C > thr;
C = bwareaopen(C,ceil(h.pp.minmm3*prod(x)),26);