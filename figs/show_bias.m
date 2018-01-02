function [] = show_bias()
cmap = inferno;
idx = 11;
z = 20;
mm = [300,800];
I{1} = niceimg(readnii(imgname('h17:FLAIR' ,idx,1)),z,mm,cmap);
I{2} = niceimg(readnii(imgname('h17:FLAIRm',idx,1)),z,mm,cmap);
I{3} = niceimg(readnii(imgname('h17:bias',  idx,1)),z,[0,3],cmap);
for i = 1:numel(I)
  timshow(I{i},0);
  print(thesisname('fig',['pre-bias-',num2str(i),'.png']),'-dpng');
  close(gcf);
end
vcolorbar(0:1:3,cmap);
print(thesisname('fig',['cmap-pre-bias.eps']),'-depsc');
close(gcf);

function [I] = niceimg(I,z,mm,cmap)
I = momi(clip(I(:,:,z),mm));
I = im2rgb(I,cmap);

