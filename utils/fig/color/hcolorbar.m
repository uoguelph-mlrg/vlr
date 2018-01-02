% HCOLORBAR
% Create a horizontal colorbar size [600,80]
% with ticks specified, and colormap cmap

function [ax] = hcolorbar(ctick,cmap)
N = size(cmap,1);
C = linspace(1,N,N);
figure;
imagesc(cat(3,cmap(C,1)',cmap(C,2)',cmap(C,3)'));
ax = gca;
set(ax,'ytick',[],'xtick',linspace(1,N,numel(ctick)),'xticklabel',ctick,'fontsize',30);
tightsubs(1,1,ax,[0.05, 0.5, 0.05, 0.0])
figresize(gcf,[600,80]);
