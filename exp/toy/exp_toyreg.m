function [] = exp_toyreg(todo)
if nargin < 1
  todo = {'tab-pmf','plt-pmf','plt-lam','plt-psu','srf-lam'};%,'srf-psu'};
end
[D,R] = data;
if any(strcmp('tab-pmf',todo)), tab_distribs(R); end
if any(strcmp('plt-pmf',todo)), plt_distribs(D,R); end
if any(strcmp('plt-lam',todo)), plt_lambdas(D);  end
if any(strcmp('plt-psu',todo)), plt_psuedos(D);  end
if any(strcmp('srf-lam',todo)), srf_lambdas(D);  end
%if any(strcmp('srf-psu',todo)), srf_psuedos;  end

% sub-main functions

function [] = tab_distribs(R)
DM = cell2mat(R);
DM = num2cell(DM(:,[1,3,5,2,4,6]));
str = '';
title = {'','\\multicolumn{3}{c}{$c=0$}','\\multicolumn{3}{c}{$c=1$}';
         '\\cmidrule(lr){2-4}\\cmidrule(lr){5-7}\n\\#',...
         '$\\mu$ & $\\sigma$ & $N$','$\\mu$ & $\\sigma$ & $N$'};
str   = [str,textable('top',title,'ccccccc')];
for r = 1:size(R,1)
  for i = [3,6]
    if DM{r,i} == 0
      DM(r,i-2:i-1) = {'---','---'};
    end
  end
  fmt = {'%c','%.01f','%.02f','%d','%.01f','%.02f','%d'};
  str = [str,textable('line',{r+96,DM{r,:}},fmt)];
end
str = [str,textable('bottom')];
fid = fopen(thesisname('fig','toy','toy-pmf-tab.tex'),'w');
fprintf(fid,str);
fclose(fid);

function [] = plt_distribs(D,R)
for d = 1:size(R,1)
  plotdistribs(D{d},R(d,:));
  legend({'$c=0$','$c=1$'},'location','nw','interpreter','latex');
  print(gcf,thesisname('fig','toy',num2str(d,'toy-pmf-%d.eps')),'-depsc');
  close(gcf);
end

function [] = plt_lambdas(D)
T = time;
clr = rainbow6;
lam = lambdas();
for d = 1:6 % #notalldistributions
  for l = 1:4
    L(l) = LINE(lam(l),zeros(2,0),clr(l,:),D{d});
  end
  figure(d);
  X = VOX(L,0.5,T);
  X = initplot(X);
  plotloop(X);
  initplot(X);
  leg = {'$\lambda = 0$',...
         '$\lambda = 10^{-3}$',...
         '$\lambda = 10^{-2}$',...
         '$\lambda = 10^{-1}$'};
  legend(leg,'location','nw','interpreter','latex');
  print(gcf,thesisname('fig','toy',num2str(d,'toy-lam-%d.eps')),'-depsc');
  close(gcf);
end

function [] = plt_psuedos(D)
T = time;
P = psuedos;
clr = rainbow6;
for d = 1:numel(D)
  for l = numel(P):-1:1
    L(l) = LINE(10.^(-3),P{l},clr(l,:),D{d});
  end
  figure(d);
  X = VOX(L,0.5,T);
  X = initplot(X);
  plotloop(X);
  initplot(X);
  plotpsu(X);
  leg = arrayfun(@(i)sprintf('$V = %d$',i),[0,1,3,9],'un',0);
  legend(leg,'location','nw','interpreter','latex');
  print(gcf,thesisname('fig','toy',num2str(d,'toy-psu-%d.eps')),'-depsc');
  close(gcf);
end

function [] = srf_lambdas(D)
d = 5;
lam = lambdas();
NL  = numel(lam);
for l = 1:NL
  % lambda only
  surfmapj([],[],lam(l),[0,1]);
  print(gcf,thesisname('fig',num2str(5-l,'toy-srf-lamo-%d.eps')),'-depsc');
  close(gcf);
  % lambda and data
  surfmapj(D{d}.Y,D{d}.C,lam(l));
  print(gcf,thesisname('fig','toy',num2str(5-l,'toy-srf-lamy-%d.eps')),'-depsc');
  close(gcf);
end

% dataset definitions

function [ts] = time()
ts = round(10.^[0:0.2:3]);

function [D,R] = data()
N = 100;
R = {...
  [ 0.3, 0.7],[0.12,0.12],N*[1,1.0];
  [ 0.3, 0.7],[0.12,0.12],N*[1,0.1];
  [ 0.3, 0.7],[0.24,0.24],N*[1,0.1];
  [ 0.3, 0.7],[0.06,0.06],N*[1,0.1];
  [ 0.3, 0.7],[0.03,0.03],N*[1,0.1];
  [ 0.6, 0.3],[0.08,0.08],N*[1,0.1];
  [ 0.4, 0.0],[0.10,0.00],N*[1,0.0];
  [ 0.6, 0.0],[0.08,0.00],N*[1,0.0];
  [ 0.8, 0.0],[0.06,0.00],N*[1,0.0];
  };
for x = 1:size(R,1)
  [D{x}.Y,D{x}.C] = cytoy(R{x,:});
end

function [lam] = lambdas()
lam = [10*eps,1e-3,1e-2,1e-1];

function [psu] = psuedos()
N = 100;
psu = {...
  [ones(1,     0);ones(1,     0)];
  [ones(1,     1);ones(1,     1)];
  [ones(1,0.03*N);ones(1,0.03*N)];
  [ones(1,0.09*N);ones(1,0.09*N)];
  };

% 'class' definition: one fitted line

function [L] = LINE(lam,psu,clr,data)
L.B    = [0;0];
L.lam  = lam;
L.Y    = data.Y(:);
L.C    = data.C(:);
L.clr  = clr;
L.ls   = '-';
L.psu  = psu;

% 'class' definition: one voxel location

function [X] = VOX(L,alpha,ts)
X.alpha = alpha;
X.ts    = ts;
X.L     = L;
X.NL    = numel(L);

% 'methods'

function [X] = initplot(X)
ax = gca; hold(ax,'on');
ylim([-0.1,+1.1]); ylabel('Class (c)'    ,'interpreter','latex');
xlim([ 0  , 1  ]); xlabel('Graylevel (y)','interpreter','latex');
for l = 1:X.NL
  plot(0,nan,'color',X.L(l).clr);
end
for l = 1:X.NL
  plot(X.L(l).Y(:),X.L(l).C(:),'ko','linewidth',2);
end
tightsubs(1,1,ax,[0.2,0.2,0.12,0.12]);

function [X] = plotloop(X)
for l = 1:X.NL
  L = X.L(l);
  Y = [L.Y',L.psu(1,:)];
  C = [L.C',L.psu(2,:)];
  Yco = mean(Y(C<0.5));
  C(Y<Yco) = 0;
  [~,c{l},y] = plotlrfit(L.B,Y,C,L.lam,X.alpha,X.ts,L.clr);
end
for l = X.NL:-1:1
  plot(y,c{l},L.ls,'color',X.L(l).clr);
end

function [] = plotpsu(X)
dy = 0.01;
for l = X.NL:-1:1
  np = size(X.L(l).psu,2);
  for i = 1:np
    plot(X.L(l).psu(1,i),X.L(l).psu(2,i)-dy*(np-i),...
      'd','linewidth',2,'markersize',6,'color',X.L(l).clr);
  end
end

function [B] = update(L,alpha)
% kill dark lesions (vs mean of healthy)
Yco = mean(L.Y(L.C<0.5));
L.C(L.Y<Yco) = 0;
% add the psuedo-lesions
if ~isempty(L.psu)
  L.Y = [L.Y;L.psu(1,:)'];
  L.C = [L.C;L.psu(2,:)'];
end
B = mapupdate(L.B,L.Y,L.C,L.lam,alpha);

function [] = plotdistribs(D,DS)
ax = gca; hold(ax,'on');
ylim([-0.1,+1.1]); ylabel('PMF ($f_y(y)$)','interpreter','latex');
xlim([ 0  , 1  ]); xlabel('Graylevel (y)' ,'interpreter','latex');
clr = [lighten(blu(1),0.5);red(1)];
y   = linspace(0,1,512);
for c = 1:2
  P{c} = 0.01*DS{3}(c)*normpdf(y,DS{1}(c),DS{2}(c));
  P{c}(1) = 0; P{c}(end) = 0;
  fill(y,0.15*P{c},lighten(clr(c,:),0.5),'edgecolor',clr(c,:));
end
plot(D.Y(:),D.C(:),'ko','linewidth',2);
tightsubs(1,1,ax,[0.2,0.2,0.12,0.12]);


