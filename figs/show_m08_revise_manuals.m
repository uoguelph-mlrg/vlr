function [] = show_m08_revise_manuals()
% n.b. THIS IS VERY EXPENSIVE FUNCTION
% Thanks Harvard for interpolating to 0.5mm in all dimensions
% 1GB for each image, you tryna prove something?
[I,GO,GR] = getimg(1);
%compareslice(I,GO,GR,[500,900],128,0,'m08rev-01-d0-z128');
compareslice(I,GO,GR,[500,900],146,2,'m08rev-01-d2-z146');
[I,GO,GR] = getimg(5);
compareslice(I,GO,GR,[120,230],107,2,'m08rev-05-d2-z107');
[I,GO,GR] = getimg(6);
compareslice(I,GO,GR,[250,500],101,2,'m08rev-06-d2-z101');

function [I,GO,GR] = getimg(i)
I  = ndresize(readnii(imgname('m08:FLAIR',i,1)),0.5);
GO = ndresize(readnii(imgname('m08:mano',i,1)),0.5);
GR = ndresize(readnii(imgname('m08:mans',i,1)),0.5);

function [] = compareslice(I,GO,GR,mm,z,ds,key)
I  = getslice(I, z,ds);
GR = getslice(GR,z,ds);
GO = getslice(GO,z,ds);
timshow(redoverlay(I,GR,mm),0);
print(thesisname('fig',[key,'-r.png']),'-dpng');
timshow(redoverlay(I,GO,mm),0);
print(thesisname('fig',[key,'-o.png']),'-dpng');

function [I] = getslice(I,z,ds)
xc = 25;
I = shiftdim(I,ds);
I = I(xc+1:end-xc,xc+1:end-xc,z);
I = imrotate(I,ds*90);
