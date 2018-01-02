function [] = show_registration()
x = {[200,135,23],[130,69,52]};
[I] = getimg([5,9,19]);
for i = 1:2
  compareslice(I(i,:),x{i},i);
end

function [I] = getimg(idx)
for i = 1:numel(idx)
  I{1,i} = flip(imrotate(readnicenii(imgname('h17:FLAIR',idx(i),1)),180));
  I{2,i} = readnicenii(imgname('mni:FLAIR',idx(i),1));
end

function [] = compareslice(I,x,k)
figure;
for i = 1:numel(I)
  I{i} = padarray(I{i}(:,:,x(3)),[15,0],0,'post');
  IX{i} = im2rgb(I{i},gray,[0,1600]); 
  IX{i}(:,x(2),1) = 1;
  IX{i}(x(1),:,1) = 1;
end
timshow(IX{:});
set(gcf,'color','w');
print(thesisname('fig',['pre-registration-',num2str(k),'.png']),'-dpng');
close(gcf);

function [If] = flip(I)
If = I(:,end:-1:1,:);