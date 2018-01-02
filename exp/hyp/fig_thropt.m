function [] = fig_thropt(h,fresh)
if nargin < 1, h = hypdef_final; end
if nargin < 2, fresh = 0; end
thr = 0:0.01:1;
Qx  = getsampledles(h,fresh);
load(h.save.train,'Cx');
for t = 1:numel(thr)
  for i = 1:h.Ni
    [si(i,t),pr(i,t),re(i,t)] = performance(Qx{i} > thr(t), Cx{i} > 0.5);
  end
  statusbar(numel(thr),t,h.Ni/3,1);
end
pr = fixpr(pr);
plot_prcurve(h,pr,re);
plot_sicurve(h,thr,si);

function [Qx] = getsampledles(h,fresh)
savename = fullfile('data','misc',[h.name.data,'-ptx-Q.mat']);
h.M = brainfun;
if fresh || ~exist(savename,'file')
  for i = 1:h.Ni
    M = mni2ptx(h.Ni,i,h.M);
    Q = readnicenii(imglutname('les',h.Ni,i));
    Qx{i} = Q(M > 0.5);
    statusbar(h.Ni,i,h.Ni/3,1);
  end
  save(savename,'Qx');
else
  load(savename,'Qx');
end

function [pr] = fixpr(pr)
for i = 1:size(pr,1)
  idx = find(pr(i,:)==0,1,'first');
  pr(i,idx:end) = 1;
end

function [] = plot_prcurve(h,pr,re)
fprintf('AUC = %.03f\n',abs(trapz(median(re),median(pr))));
plot(0,nan,'k','linewidth',2);
scannerplot(h,pr,re,'sw');
plot(median(pr),median(re),'k','linewidth',2);
leg = findobj(gcf,'type','legend');
legend(['Median',leg.String(1:end-1)]);
xlabel('Recall (Re)','interpreter','latex');
ylabel('Precision (Pr)','interpreter','latex');
tightsubs(1,1,gca,0.04*[4,4,1,1]);
print(gcf,thesisname('fig','curve-pr-re'),'-depsc');
close(gcf);

function [] = plot_sicurve(h,thr,si)
scannerplot(h,si,thr);
plot(thr,median(si),'k','linewidth',2);
xlabel('Threshold ($\pi$)','interpreter','latex');
ylabel('Similarity Index (SI)','interpreter','latex');
tightsubs(1,1,gca,0.04*[4,4,1,1]);
print(gcf,thesisname('fig','curve-si'),'-depsc');
close(gcf);

