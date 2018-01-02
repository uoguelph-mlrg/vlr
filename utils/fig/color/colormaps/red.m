function [cmap] = red(m)
% colormap: red
if nargin < 1
   m = size(get(gcf,'colormap'),1);
end
r = linspace(0,1,m)';
g = zeros(1,m)';
b = zeros(1,m)';
cmap = [r,g,b];
