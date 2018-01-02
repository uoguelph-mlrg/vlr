% hypdef(h)
% This function fills in the repetitive parameters and info related to one VLR
% cross validation run.
% hypdef must be called first.

function [h] = hypfill(h)
% load scanner parameters
[names,short,N,vsize,tERI,Y4] = arrayfun(@scanparams,h.scan.idx,'un',0);
h.scan.names  = names;
h.scan.short  = short;
h.scan.N      = cell2mat(N);
n = 1;
for i = 1:numel(h.scan.N)
  for ni = 1:h.scan.N(i)
    h.scan.i    (n)   = i;
    h.scan.vsize(n,:) = vsize{i};
    h.scan.tERI (n,:) = tERI{i};
    h.scan.Y4   (n,:) = Y4{i};
    n = n + 1;
  end
end
h.Ni = sum(h.scan.N);
% cross validation parameters
switch h.name.cv
  case 'loso'
    h.cv.N = h.scan.N;
    h.cv.i = [];
    for i = 1:numel(h.cv.N)
      h.cv.i(end+1:end+h.cv.N(i)) = i;
    end
    h.cv.names = h.scan.names;
  case 'kfcv'
    h.cv.N = h.scan.N;
    idx = kfcvidx(h);
    for i = 1:numel(idx)
      h.cv.i(idx{i}) = i;
    end
    h.cv.names = arrayfun(@(i)sprintf('Group %02.0f',i),1:max(h.cv.i),'un',0);
  case 'loo'
    h.cv.N = ones([1,h.Ni]);
    h.cv.i = 1:h.Ni;
    h.cv.names = arrayfun(@(i)num2str(i,'%02.0f'),1:96,'un',0);
  case 'nocv'
    h.cv.N = h.Ni;
    h.cv.i = ones(1,h.cv.N);
    h.cv.names = {'All'};
  case 'osaat'
    h.cv.N = ones([1,h.Ni]);
    h.cv.i = 1:h.Ni;
    h.cv.names = arrayfun(@(i)num2str(i,'%02.0f'),1:96,'un',0);
  otherwise
    error('Unrecognized CV option: %s',h.name.cv);
end
h.cv.cpu = 5;
% savenames
outroot = 'C:\Users\Jesse\Documents\Research\working-docs\results\';
h.name.resize  = ['r=',num2str(h.sam.resize,'%1.1f')];
h.name.aug     = ['a=',num2str([h.sam.flip,size(h.sam.dx,1)>1],'%0.0f')];
h.name.train   = [h.name.data,'-train-',...
                  h.std.type,       '-',...
                  h.name.resize,    '-',...
                  h.name.aug];
if h.name.key(1) == 'e'
  h.name.full    = [h.name.data,  '-',...
                    h.std.type,   '-',...
                    h.name.resize,'-',...
                    h.name.key,   '-',...
                    h.name.cv];
else
  h.name.full    = [h.name.data,'-',h.name.key]; 
end
h.save.train   = fullfile('data','train',[h.name.train,'.mat']);
h.save.name    = fullfile('data',      [h.name.full,'.mat']);
h.save.ples    = fullfile('data',      [h.name.full,'-ples.mat']);
h.save.outdir  = fullfile(outroot,      h.name.full);
h.save.pdf     = fullfile(h.save.outdir,h.name.full);
h.save.figdir  = fullfile(h.save.outdir,'figs');


