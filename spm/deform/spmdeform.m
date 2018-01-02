% SPMDEFORM
% This function is a wrapper for spm_diffeo('push',...)
% as implemented in 'push_def(Def,mat,job)' line 514 of spm_deformations.m
% 
% Outputs will match the ordering of varargin.

function [varargout] = spmdeform(T,so,varargin)
for v = 1:numel(varargin)
  Vi = single(varargin{v});
  [Vo,c] = spm_diffeo('push',Vi,T,so);
  spm_smooth(Vo,Vo,0.25);
  spm_smooth(c,c,0.25);
  varargout{v} = Vo./(c+0.001);
end


