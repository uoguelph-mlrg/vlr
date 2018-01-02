function [X] = pnorm(x,p)
X = (sum(abs(x).^p)).^(1/p);
