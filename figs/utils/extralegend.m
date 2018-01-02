function [] = extralegend(leg,cmap,nynx,varargin)
if nargin < 3 || isempty(nynx)
  [ny,nx] = size(leg);
  leg = leg';
else 
  ny = nynx(1);
  nx = nynx(2);
end
assert(numel(leg) <= ny*nx, 'Too many legend entries.');
figure;
figresize(gcf,[160*nx,40*ny]);
for x = 1:nx
  a = subplot(1,nx,x);
  set(a,'visible','off');%,'handlevisibility','off','hittest','off');
  hold('on');
  for y = 1:ny
    plot(0,nan,'color',cmap((x-1)*ny+y,:));
  end
  legi = leg((x-1)*ny+1:min(x*ny,numel(leg)));
  h = legend(legi,'interpreter','latex',varargin{:});
  set(h,'position',[(x-1)/nx,1-numel(legi)/ny,1/nx,numel(legi)/ny],'box','off');
end
set(gcf,'inverthardcopy','off');