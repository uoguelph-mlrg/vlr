% MNI2PTX
% This function uses spmdeform to warp pt space inputs (varargin) to MNI space,
% using the deformation specified by imglutname('xform',N,n) -- i.e. for pt 'n'

function [varargout] = mni2ptx_old(N,n,varargin)
xform     = imglutname('xform',  N,n,1);            % xform
templatei = imgname   ('mni:FLAIR',n,1);            % mni space template
templateo = imglutname('FLAIR',  N,n,1);            % pt  space template
varargout = cell([1,numel(varargin)]);
[varargout{:}] = imprep(+90,varargin{:});
[varargout{:}] = spmdeform_old(xform,templatei,templateo,varargin{:});
[varargout{:}] = imprep(-90,varargout{:});
