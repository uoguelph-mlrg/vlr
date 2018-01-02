% SCANPARAMS
% Returns for a scanner index \in [1,10]:
% the name, imgname slug, number of images, voxel size,
% FLAIR scan paramters, and the simulated graylevels: GM, WM, CSF, WMH

function [name,short,N,x,tERI,Y4] = scanparams(i)
switch i
  case  1, name = 'WMH 2017 (1)'; short = 'h17';  N = 20; x = [0.96,0.96,3.00]; tERI = [125,11000,2800];
  case  2, name = 'WMH 2017 (2)'; short = 'h17';  N = 20; x = [1.00 1.00,3.00]; tERI = [ 82, 9000,2500];
  case  3, name = 'WMH 2017 (3)'; short = 'h17';  N = 20; x = [0.98,1.20,3.00]; tERI = [126, 8000,2340];
  case  4, name = 'MS  2016 (1)'; short = 'm16';  N = 05; x = [0.50,1.10,0.50]; tERI = [360, 5400,1800];
  case  5, name = 'MS  2016 (2)'; short = 'm16';  N = 05; x = [1.04,1.25,1.04]; tERI = [336, 5400,1800];
  case  6, name = 'MS  2016 (3)'; short = 'm16';  N = 05; x = [0.74,0.70,0.74]; tERI = [399, 5000,1800];
  case  7, name = 'MS  2008 CHB'; short = 'm08';  N = 10; x = [0.50,0.50,0.50]; tERI = [  0,    0,   0];
  case  8, name = 'MS  2008 UNC'; short = 'm08';  N = 10; x = [0.50,0.50,0.50]; tERI = [125, 9000,2800];
  case  9, name = 'ISBI MS 2015'; short = 'i15';  N = 21; x = [1.00,1.00,1.00]; tERI = [ 68, 9000,2800];
  case 10, name =     'In-House'; short = 'cain'; N = 13; x = [0.43,0.43,3.00]; tERI = [125, 9000,2800];
  case 11, name =      'T1 e.g.'; short = '';     N =  0; x = [1.00,1.00,1.00]; tERI = [  5,   15, nan];
  case 12, name =      'T2 e.g.'; short = '';     N =  0; x = [1.00,1.00,1.00]; tERI = [100, 5500, nan];
end
Y4 = flairy(tERI);
