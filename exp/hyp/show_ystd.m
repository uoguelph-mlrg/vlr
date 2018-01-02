function [] = show_ystd(h)
[~,~,~,~,TERI] = scanparams(1);
I = simflair(TERI);
I = I + 0.01*randn(size(I));
M = I>0;
z = round(1.5*zfun);
cmap = gray;
for s = 1:numel(h)
  Y{s} = standardize(I,M,h{s}.std.type,h{s}.std.args{:});
  sliceshow(Y{s},z,cmap,[0,1]);
  print(thesisname('fig',['ystd-',h{s}.std.type,'-',resultsname('img','Y')]),'-dpng');
  close(gcf);
end
vcolorbar([0:0.2:1],cmap);
print(thesisname('fig',resultsname('cmap','ystd')),'-depsc');
close(gcf);