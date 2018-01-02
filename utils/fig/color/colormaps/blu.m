function [cmap] = blu(m)
% colormap: aqua
if nargin < 1
   m = size(get(gcf,'colormap'),1);
end
r = zeros(1,m)';
g = linspace(0,0.3,m)';
b = linspace(0,1,m)';
cmap = [r,g,b];
