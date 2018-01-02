function [varargout] = imprep(rot,varargin)
for v = 1:numel(varargin)
  varargout{v} = single(imrotate(varargin{v},rot));
end