function [varargout] = polyfitplot(x,y,n,u,alpha)
if nargin < 3 || isempty(n)
  n = 1;
end
if nargin < 4 || isempty(u)
  u = linspace(min(x(:)),max(x(:)),512);
end
if nargin < 5 || isempty(alpha)
  alpha = 0.05;
end
[p,S] = polyfit(x,y,n);
[yp,yci] = polyconf(p,u,S,'alpha',alpha);
set(gca,'clipping','on')
x = x(:); y = y(:); u = u(:); yp = yp(:); yci = yci(:);
h(1) = fill([u;flipud(u)],[yp+yci;flipud(yp-yci)],0.9*[1,1,1],...
  'edgecolor','none');
h(2) = plot(u,yp,'color',0.8*[1,1,1],'linewidth',5);
if nargout == 1
  varargout{1} = h;
end