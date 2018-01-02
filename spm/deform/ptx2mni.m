% MNI2PTX
% This function uses spmdeform to warp MNI space inputs (varargin) to pt space,
% using the deformation specified by imglutname('ixform',N,n) -- i.e. for pt 'n'

function [varargout] = ptx2mni(N,n,varargin)
xform     = load(imglutname('ptx2mni',N,n,1)); % xform
varargout = cell(size(varargin));
[varargout{:}] = imprep(-90,varargin{:});
[varargout{:}] = spmdeform(xform.T,xform.so,varargout{:});
[varargout{:}] = imprep(+90,varargout{:});


