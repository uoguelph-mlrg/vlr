% SUMMARIZERESULTS
% This function creates various figures, and a table which summarize
% the performance of a segmentation model.
% These can be compiled in a PDF report using the 'pdf' option,
% so long as the necessary template is available (specific to the CV type)

function [] = summarizeresults(h, o, t, todo)
doall = {'scatter','box','table','tpfpfn','betas','egy','baplot','pdf'};
if nargin == 3 || isempty(todo) % default: run all
  todo = doall;
end
if any(strcmp('scatter',todo)),  scannerscatter(h,o);  end
if any(strcmp('box',todo)),      llboxplot(h,o);       end
if any(strcmp('table',todo)),    textableres(h,o);     end
if any(strcmp('baplot',todo)),   blandaltmanplot(h,o); end
if any(strcmp('tpfpfn',todo)),   tpfpfn(h,t);          end
if any(strcmp('betas',todo)),    betas(h,o,3);         end
if any(strcmp('egy',todo)),      egy(h,62);            end % 0 | 62
if any(strcmp('pdf',todo)),      makepdf(h);           end
for i = 1:numel(todo)
  if ~any(strcmp(todo{i},doall))
    warning('Unrecognized todo: %s',todo{i});
  end
end

function [] = makepdf(h)
tname   = strrep(fullfile(['C:\Users\Jesse\Documents\Research\working-docs\',...
                           'results\templates\template-$.tex']),'$',h.name.cv);
fid = fopen([h.save.pdf,'.tex'],'w');
fprintf(fid,strrep(strrep(strrep(fileread(tname),'TITLE',h.name.key),'%','%%'),'\','\\'));
fclose(fid);
compiletex(h.save.pdf);
eval(['!foxitreader "',h.save.pdf,'.pdf" &']);

function [] = scannerscatter(h,o)
text(nan,nan,'','interpreter','latex');
titles = {'Similarity Index (SI)','Precision (Pr)','Recall (Re)'};
names  = {'si','pr','re'};
y      = {o.si, o.pr, o.re};
N   = max(h.scan.i);
ymm = [0,1];
for i = 1:3
  plot(zeros(1,N),nan(N),'-'); hold on;
  polyfitplot(o.ll,y{i},3,linspace(0,max(o.ll),256),0.1);
  for s = 1:N
    plot(o.ll(:,h.scan.i==s),y{i}(:,h.scan.i==s),'o','color',h.scan.clr(s,:));
  end
  xlabel('Lesion Load (ml)','interpreter','latex');
  ylabel(titles{i},'interpreter','latex');
  ylim(ymm);
  figresize(gcf,[800,550]);
  printfig(h,resultsname('scat',names{i}));
end

function [] = llboxplot(h,o)
text(nan,nan,'','interpreter','latex');
titles = {'Similarity Index (SI)','Precision (P)','Recall (R)'};
names  = {'si','pr','re'};
y      = {o.si, o.pr, o.re};
ll3    = 4-sum(bsxfun(@lt,o.ll,[0,4,22,inf]'));
labels = {'<4','4-22','>22'};
ymm    = [0,1];
for i = 1:3
  boxplot(y{i},ll3,'labels',labels,'colors','k','symbol','k+');
  xlabel('LL (ml)','interpreter','latex');
  ylabel(titles{i},'interpreter','latex');
  ylim(ymm);
  figresize(gcf,[800,550]);
  tightsubs(1,1,gca,[0.20,0.15,0.05,0.05]);
  printfig(h,resultsname('box',names{i}));
end

function [] = betas(h,o,c)
c = min(c,numel(o.B));
if isempty(o.B{c})
  warning('B is empty. Skipping...');
  return;
end
M    = brainfun;
I{1} = -o.B{c}{1}./o.B{c}{2}.*M;
I{2} = o.B{c}{2}.*M;
names = {        'T',       'S'};
cmaps = {     h.cmap,    h.cmap};
mm    = {    [0.2,1],    [0,60]};
mmx   = {[0.2:0.2:1], [0:20:60]};
for i = 1:2
  sliceshow(I{i},zfun,mm{i},cmaps{i}); drawnow;
  printfig(h,resultsname('img',names{i}));
  vcolorbar(mmx{i},cmaps{i});
  printfig(h,resultsname('cmap',names{i}));
end

function [] = egy(h,n)
M  = brainfun;
J  = readnicenii(imgname('mni:FLAIRm',n,1));
I  = standardize(J,M,h.std.type,h.std.args{:});
cmap = gray;
mm = [0.2,1]; mmx = [0.2:0.2:1];
sliceshow(I,zfun,mm,cmap); drawnow;
printfig(h,resultsname('img','Y'));
vcolorbar(mmx,cmap);
printfig(h,resultsname('cmap','Y'));

function [] = tpfpfn(h,t)
N = numel(t.TP);
Z  = zeros(size(t.TP{1}));
T{1} = Z; T{2} = Z; T{3} = Z;
for i = 1:N
  T{1} = T{1} + single(t.FP{i})/N; % false positive (red)
  T{2} = T{2} + single(t.TP{i})/N; % true  positive (green)
  T{3} = T{3} + single(t.FN{i})/N; % false negative (blue)
end
names = {'FP','TP','FN'};
mm  = [0,0.2];
mmx = 0.00 : 0.05 : 0.2;
for t = 1:3
  figure;
  sliceshow(T{t},zfun,mm,h.cmap); drawnow;
  printfig(h,resultsname('img',names{t}));
end
vcolorbar(mmx,h.cmap);
printfig(h,resultsname('cmap','tri'));

function [] = blandaltmanplot(h,o)
blandaltman(o.ll,o.lle,1,{'LL (mL)','Manual','Auto.'});
printfig(h,resultsname('ba',2));
printfig(h,resultsname('ba',1));

function [] = printfig(h,name)
[~,~,ext] = fileparts(name);
switch ext
  case '.png'
    flag = '-dpng';
  case '.eps'
    flag = '-depsc';
  otherwise 
    error('Unrecognized figure format: %s',ext);
end
print(gcf,fullfile(h.save.figdir,name),flag);
close(gcf);
