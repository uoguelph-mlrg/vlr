function [M,Mf] = brainfun()
Mf = readnicenii(imgname('mni:brain',''));
M  = Mf > 0.5;