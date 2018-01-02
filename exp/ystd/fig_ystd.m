function [] = fig_ystd(todo)
if nargin < 1, todo = {'ypmf','tpmf','Z1','Z2'}; end % 
matfile = 'D:/DATA/WML/thesis/mni96-ystd.mat';
[h,names] = defhypset('ystd-full');
for i = 1:numel(todo)
  switch todo{i}
    case 'ypmf'
      load(matfile,'Y','h');
      doplotypmf(Y,h,names);
    case 'tpmf'
      load(matfile,'h');
      doplottpmf(h,names);
    case 'Z1'
      load(matfile,'J','h');
      doshowzx(J,h,1,names);
    case 'Z2'
      load(matfile,'J','h');
      doshowzx(J,h,2,names);
    otherwise
      warning('Unrecognized todo: %s',todo{i});
  end
end

function [idx] = hlabelfind(names,lab)
idx = find(strcmp(arrayfun(@(i)names{i}(9:end-1),1:numel(names),'un',0),lab));

function [] = doplotypmf(Y,h,names)
i = hlabelfind(names,'Raw');
plotypmf(Y{i},h{i},'nw');
print(thesisname('fig','ystd','ystd-pmf-na.eps'),'-depsc'); close(gcf);
i = hlabelfind(names,'HE');
plotypmf(Y{i},h{i},'nw');
print(thesisname('fig','ystd','ystd-pmf-he.eps'),'-depsc'); close(gcf);
i = hlabelfind(names,'HM3');
plotypmf(Y{i},h{i},'nw');
print(thesisname('fig','ystd','ystd-pmf-m3.eps'),'-depsc'); close(gcf);

function [] = doplottpmf(h,names)
clr = rainbow6;
figure; hold on;
leg = {'HE','HM1','HM2','HM3'};
for i = 1:numel(leg)
  plotpmf(h{hlabelfind(names,leg{i})}.std.args{1},clr(i,:));
end
legend(leg,'location','nw','interpreter','latex');
print(thesisname('fig','ystd','ystd-pmf-hm123.eps'),'-depsc'); close(gcf);

function [] = doshowzx(J,h,j,names)
cmap = inferno;
ii = hlabelfind(names,'RM1');
io = hlabelfind(names,'HM3');
for s = [ii,io];%[1,i]%1:size(J,2)
  h{s}.M = brainfun;
  h{s}.sam.Mr = ndresize(h{s}.M,h{s}.sam.resize);
  Z{j,s} = reconparams(h{s},J{j,s}(:));
  Z{j,s} = Z{j,s}{1};
end
mm{1} = {[0,300],[-80,+80]};
dd{1} = {100,40};
mm{2} = {[0,0.15],[-0.05,+0.05]};
dd{2} = {0.05,0.05};
fname = strrep(thesisname('fig','ystd',['ystd-zx-*-#.png']),'#',num2str(j));
cname = strrep(thesisname('fig','ystd',['cbar-zx-*-#.eps']),'#',num2str(j));
% slice plots
sliceshow(Z{j,ii},zfun,mm{j}{1},cmap);
print(strrep(fname,'*','na'),'-dpng'); close(gcf);
sliceshow(Z{j,io},zfun,mm{j}{1},cmap);
print(strrep(fname,'*','op'),'-dpng'); close(gcf);
sliceshow(Z{j,ii}-Z{j,io},zfun,mm{j}{2},spiderman);
print(strrep(fname,'*','naop'),'-dpng'); close(gcf);
% vcolorbars
vcolorbar(mm{j}{1}(1):dd{j}{1}:mm{j}{1}(2),cmap);
print(strrep(cname,'*','i'),'-depsc'); close(gcf);
vcolorbar(mm{j}{2}(1):dd{j}{2}:mm{j}{2}(2),spiderman);
print(strrep(cname,'*','d'),'-depsc'); close(gcf);

function [] = plotpmf(pmf,clr)
u = linspace(0,1,numel(pmf));
plot(u,pmf,'color',clr);
xlim([0,1]); xlabel('Graylevel $y$','interpreter','latex');
ylim([0,0.05]); ylabel('PMF $f_y(y)$','interpreter','latex');
tightsubs(1,1,gca,0.5*[0.3,0.3,0.12,0.12]);
