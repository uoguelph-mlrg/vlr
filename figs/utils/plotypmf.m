% PLOTYPMF
% This function plots he histogram of the data in Y
% stratified by image (dim 2), and coloured by scanner.

function [] = plotypmf(Y,h,leg)
if nargin < 3, leg = 0; end % dont pring legend by default
if max(Y(:)) > 1
  Y = bsxfun(@rdivide,Y,max(Y));
end
n = 1:size(Y,2)/h.Ni:size(Y,2);
N = 128;
u = linspace(0,1,N);
P = arrayfun(@(i)ksdensity(Y(:,i),u,'width',0.02),n,'un',0);
scannerplot(h,cat(1,P{:}),u,leg);
xlim([0,1]); xlabel('Graylevel $y$','interpreter','latex');
ylim([0,6]); ylabel('PMF $f_y(y)$','interpreter','latex');
tightsubs(1,1,gca,0.5*[0.2,0.3,0.12,0.12]);