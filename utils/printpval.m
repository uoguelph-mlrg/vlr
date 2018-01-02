function [sig] = printpval(pre,p)
sig = floor(min(10,max(0,-log10(p))));
str = sprintf([pre,' p = %.04f ',repmat('*',[1,sig]),'\n'],p);
fprintf(str);