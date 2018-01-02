function [cmap] = america(m)
% colormap: blue-white-red (for difference images)
if nargin < 1
   m = size(get(gcf,'colormap'),1);
end
n = fix(m/2);
r = [(1:+1:n)/n   ones(1,n)]';
g = [(1:+1:n)/n  (n:-1:1)/n]';
b = [ones(1,n)   (n:-1:1)/n]';
cmap = [r,g,b];
