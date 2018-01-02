% MNI2PTX
% This function uses spmdeform to warp pt space inputs (varargin) to MNI space,
% using the deformation specified by imglutname('xform',N,n) -- i.e. for pt 'n'

function [varargout] = mni2ptx(N,n,varargin)
xform     = load(imglutname('mni2ptx',N,n,1)); % xform
varargout = cell([1,numel(varargin)]);
[varargout{:}] = imprep(-90,varargin{:});
[varargout{:}] = spmdeform(xform.T,xform.so,varargout{:});
[varargout{:}] = imprep(+90,varargout{:});
