function [] = show_beta_r()
h = hypdef_final;
load(h.save.name,'h','o');
c = 1;
for b = 1:2
  Br{c}{b} = ndresize(o.B{c}{b},h.sam.resize);
  B {c}{b} = o.B{c}{b};
end
I{1,1} = -B {c}{1}./B{c}{2}.*h.M;
I{1,2} =  B {c}{2}.*h.M;
I{2,1} = -Br{c}{1}./Br{c}{2}.*h.sam.Mr;
I{2,2} =  Br{c}{2}.*h.sam.Mr;
names = {        'T',       'S'};
cmaps = {     h.cmap,    h.cmap};
mm    = {    [0.2,1],    [0,60]};
mmx   = {[0.2:0.2:1], [0:20:60]};
for i = 1:2
  for r = 1:2
    sliceshow(I{r,i},round(zfun/r),mm{i},cmaps{i}); drawnow;
    figname = thesisname('fig','seg',[names{i},'-r',num2str(r),'.png']);
    print(gcf,figname,'-dpng');
    close(gcf);
  end
  vcolorbar(mmx{i},cmaps{i});
  print(gcf,thesisname('fig','seg',['cmap-r-',names{i},'.eps']),'-depsc');
  close(gcf);
end
