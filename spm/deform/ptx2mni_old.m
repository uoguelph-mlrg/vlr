% MNI2PTX
% This function uses spmdeform to warp MNI space inputs (varargin) to pt space,
% using the deformation specified by imglutname('ixform',N,n) -- i.e. for pt 'n'

function [varargout] = ptx2mni_old(N,n,varargin)
xform     = imglutname('ixform', N,n,1);            % xform
templatei = imglutname('FLAIR',  N,n,1);            % pt  space template
templateo = imgname   ('mni:FLAIR',n,1);            % mni space template
varargout = cell(size(varargin));
[varargout{:}] = imprep(+90,varargin{:});
[varargout{:}] = spmdeform_old(xform,templatei,templateo,varargin{:});
[varargout{:}] = imprep(-90,varargout{:});


