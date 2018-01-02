function [cmap] = spiderman(m)
% colormap: blue-black-red (for difference images)
if nargin < 1
   m = size(get(gcf,'colormap'),1);
end
n = fix(m/2);
r = [    zeros(1,n) (1:+1:n)/n]';
g = [0.3*(n:-1:1)/n zeros(1,n)]';
b = [    (n:-1:1)/n zeros(1,n)]';
cmap = [r,g,b];
