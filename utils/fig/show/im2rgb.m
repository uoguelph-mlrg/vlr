% IM2RGB
% This function converts an image (2D or 3D) from grayscale to color using the
% specified colormap.
% Dependencies: biny

function [RGB] = im2rgb(I,map,varargin)
% get the size of the colormap
M = size(map,1);
% bin the image data
if isempty(varargin), varargin{1} = []; end
IU = biny(I,varargin{:},[1,M],M);
% parse the RGB channels
RGB(:,1) = map(IU,1);
RGB(:,2) = map(IU,2);
RGB(:,3) = map(IU,3);
% reshape to the appropriate size
RGB = reshape(RGB,[size(I),3]);

