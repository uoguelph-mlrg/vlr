function [] = figresize(h,fsize)
% resizes the current figure to the size fsize, and centers the image on screen.

screen = get(0,'screensize');
set(h,'position',[screen(3:4)/2-fsize/2,fsize]);
