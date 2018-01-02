function [] = show_brain_mask()
M = brainfun;
Z = zeros(size(M));
[~,~,~,~,TERI,~] = scanparams(5);
F = simflair(TERI,'wm');
F = ndresize(F,mean(size(M)./size(F)),size(M));
img = redoverlay(F,1-M,[-eps,3])+cat(4,bwperim(M,4),Z,Z);
sliceshow(img,10:10:100,'5x2');
print(thesisname('fig',['brainmask.png']),'-dpng');
close(gcf);