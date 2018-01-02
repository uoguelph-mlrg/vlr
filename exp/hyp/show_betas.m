function [] = show_betas(h,z)
if nargin < 2, z = zfun; end
names = {        'T',       'S'};
mm    = {    [0.2,1],    [0,60]};
mmx   = {[0.2:0.2:1], [0:20:60]};
M = brainfun;
for k = 1:numel(h)
  load(h{k}.save.name,'o');
  B{k,1} = -o.B{k}{1}./o.B{k}{2}.*M;
  B{k,2} = o.B{k}{2}.*M;
  for b = 1:2
    figure;
    sliceshow(B{k,b},z,h{k}.cmap,mm{b},'w500');
    print(gcf,thesisname('fig','seg',[names{b},'-',num2str(k),'.png']),'-dpng');
    close(gcf);
  end
end
for b = 1:2
  vcolorbar(mmx{b},h{1}.cmap);
  cmapname = resultsname('cmap',['beta-',num2str(b)]);
  print(gcf,thesisname('fig','seg',cmapname),'-depsc');
  close(gcf);
end