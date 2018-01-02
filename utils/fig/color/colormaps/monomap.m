% MONOMAP
% creates a colormap using the colour clr as a base
% clr - base colour
% m   - number of levels
% mm  - 2 element specifying darken/lighten levels as the limits:
%       negatives: darken  by factor |mm(i)|
%       positives: lighten by factor |mm(i)|

function [cmap] = monomap(clr,m,mm)
if nargin < 2, m  = size(get(gcf,'colormap'),1); end
if nargin < 3, mm = [-0.5,0.5]; end
f = linspace(mm(1),mm(2),m);
cmap = [];
for i = 1:m
  if f(i) <= 0
    cmap = [cmap;darken(clr,abs(f(i)))];
  else
    cmap = [cmap;lighten(clr,abs(f(i)))];
  end
end

