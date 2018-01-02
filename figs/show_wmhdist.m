function [] = show_wmhdist()
cmap = inferno;
load('mni96-mni-G');
UG = mean(cat(4,G{:}),4);
sliceshow(UG,zfun,[0,0.4],cmap);
print(gcf,thesisname('fig','mean-G.png'),'-dpng');
close(gcf);
vcolorbar([0:0.1:0.4],cmap);
print(gcf,thesisname('fig','cmap-mean-G.eps'),'-depsc');
close(gcf);