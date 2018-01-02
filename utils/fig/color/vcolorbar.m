% VCOLORBAR
% Create a vertical colorbar size [80,600]
% with ticks specified, and colormap cmap

function [ax] = vcolorbar(ctick,cmap)
N = size(cmap,1);
C = linspace(1,N,N);
figure;
imagesc(imrotate(cat(3,cmap(C,1)',cmap(C,2)',cmap(C,3)'),90));
ax = gca;
ctick = rot90(ctick);
set(ax,'xtick',[],'fontsize',22,...
  'ytick',linspace(1,N,numel(ctick)),'yticklabel',ctick,'YAxisLocation','right');
tightsubs(1,1,ax,[0.05, 0.05, 0.7, 0.05])
figresize(gcf,[80,600]);
