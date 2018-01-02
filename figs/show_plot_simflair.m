function [] = show_plot_simflair()
% get the TE/TR/TI data
si = [1,2,3,4,5,6,  8,9,10,11,12]; % no TERI data from Harvard
[names,~,~,~,TERI,~] = arrayfun(@scanparams,si,'un',0);
TERI = cat(1,TERI{:});
mri  = cat(1,repmat({'ir'},[9,1]),'se','se');
S = size(TERI,1);
z = 90;
%yrng  = [0,3.5];
yrng  = [0.5,2];
noise = 0.03;
cmap = inferno;
% printing the table to file
str = '';
str = [str,textable('top',...
  {'Scanner','\\gm{}','\\wm{}','\\csf{}','\\wmh{}',...
  '$\\frac{\\wmh}{\\gm}$','$\\frac{\\wmh}{\\wm}$','$\\frac{\\wmh}{\\csf}$'},...
  'rccccccc')];
for s = 1:S
  [F,y(:,s),TPM] = simflair(TERI(s,:),'wm',mri{s});
  F = F + noise.*randn(size(F));
  % the business:
  showflair(F(:,:,z),si(s),yrng,cmap);
  plotpmf(F,TPM,si(s),yrng);
  line = cat(1,names{s},num2cell(y(:,s)),num2cell(abs(y(4,s)./y(1:3,s))))';
  str = [str,textable('line',line,'%.02f')];
end
str = [str,textable('bottom')];
fid = fopen(thesisname('dir','simflair.tex'),'w');
fprintf(fid,str);
fclose(fid);
showcolorbar(yrng,cmap);

function [] = showcolorbar(yrng,cmap)
hcolorbar(yrng(1):yrng(2),cmap);
print(gcf,thesisname('fig','hcbar-simflair.eps'),'-depsc');
close(gcf);

function [] = showflair(F,i,yrng,cmap)
cy = 20;
cx = 20;
timshow(F(1+cy:end-cy,1+cx:end-cx),yrng,cmap,'w500');
print(thesisname('fig',['simflair-s=',num2str(i,'%02.f'),'.png']),'-dpng');
%print(['simflair-s=',num2str(i,'%02.f'),'.png'],'-dpng');
close(gcf);

function [] = plotpmf(F,TPM,i,yrng)
clr = rainbow6;
M   = ~isnan(F);
W   = sum(TPM(M));
TPM = nd2cell(TPM,4);
N = 512;
u = linspace(yrng(1),yrng(2),N);
for t = 1:4
  PMF(:,t) = (sum(TPM{t}(M))/W)*pofwy(F(M),TPM{t}(M),yrng,yrng,N);
  PMF(1,t)   = 0;
  PMF(end,t) = 0;
end
figure; hold on;
plot(u,sum(PMF,2),'k','linewidth',1);
PMF(:,t) = 25*PMF(:,t);
for t = 1:4 
  h = fill(u,PMF(:,t),lighten(clr(t,:),0.7),'edgecolor',clr(t,:));
end
leg = {'Full Image','GM','WM','CSF','WMH$\times25$'};  
legend(leg,'location','ne','interpreter','latex');
xlim(yrng);    xlabel('$y$','interpreter','latex');
ylim([0,0.1]); ylabel('$p_{_{\textsc{y}}}(y)$','interpreter','latex');
figresize(gcf,[1200,450]);
print(thesisname('fig',['simflairplot-s=',num2str(i,'%02.f'),'.eps']),'-depsc');
close(gcf);
