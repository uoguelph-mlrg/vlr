% COPYTHESISRESULTS
% Since by default, cross validation batches print results to a unique folder,
% this function collects a few used directly in the thesis and copies them into
% the thesis figure directory. Since MATLAB copying is slow, the (windows)
% command line copy is used

function [] = copythesisresults()
todo = deftodo();
for k = 1:numel(todo)
  for i = 1:numel(todo{k}.figs)
    todo{k}.copy(todo{k}.figs{i});
  end
end

function [todo] = deftodo()
tabnames = {};
h = hypdef_final;
i = 0;
i = i + 1;
todo{i}  = onekey(key2hyp(h,'e[P--L--A--F--]'),'base','seg',...
                 resultsname('tab'),...
                 resultsname('box','si'),...
                 resultsname('box','pr'),...
                 resultsname('box','re'),...
                 resultsname('ba',1),...
                 resultsname('ba',2),...
                 resultsname('img','T'),...
                 resultsname('img','S'),...
                 resultsname('cmap','T'),...
                 resultsname('cmap','S'));
i = i + 1;
todo{i}  = onekey(hypdef_final,'final','seg',...
                 resultsname('tab'),...
                 resultsname('box','si'),...
                 resultsname('box','pr'),...
                 resultsname('box','re'),...
                 resultsname('scat','si'),...
                 resultsname('scat','pr'),...
                 resultsname('scat','re'),...
                 resultsname('ba',1),...
                 resultsname('ba',2),...
                 resultsname('img','T'),...
                 resultsname('img','S'),...
                 resultsname('img','TP'),...
                 resultsname('img','FP'),...
                 resultsname('img','FN'),...
                 resultsname('cmap','T'),...
                 resultsname('cmap','S'),...
                 resultsname('cmap','tri'));
i = i + 1;
tabnames{end+1} = ['Baseline/base-',resultsname('tab')];
todo{i}  = onekey(key2hyp(h,'e[P--L--A--F--]'),'base','tab',resultsname('tab'));
i = i + 1;
tabnames{end+1} = ['Final/final-',resultsname('tab')];
todo{i}  = onekey(hypdef_final,'final','tab',resultsname('tab'));
%todo{i}  = onekey(key2hyp(h,'e[P1-L3-Ab-Fg2]'),'final','tab',resultsname('tab'));
sets   = {   'ovb',    'cv',    'ystd',   'lam',    'beta'};
keyfun = {@key2hyp, @cv2hyp, @ystd2hyp, @key2hyp, @key2hyp};
for s = 1:numel(sets)
  [h,names,params] = defhypset(sets{s});
  for k = 1:numel(h)
    i = i + 1;
    hk = keyfun{s}(h{k},params{k,1:end-1});
    todo{i}  = onekey(hk,params{k,1},'tab',resultsname('tab'));
    tabnames{end+1} = [names{k},'/',params{k,1},'-',resultsname('tab')];
  end
end
fid = fopen(thesisname('fig','tab','table-index.tex'),'w+');
fprintf(fid,maketabnames(tabnames));
fclose(fid);

function [key] = onekey(h,okey,dir,varargin)
for v = 1:numel(varargin)
  key.figs{v} = varargin{v};
end
key.copy = @(name)fcopy(h,okey,dir,name);

function [] = fcopy(h,outkey,dir,name)
load(h.save.name,'h');
iname = fullfile(h.save.figdir,name);
oname = thesisname('fig',dir,[outkey,'-',name]);
evalstr = ['!copy "',iname,'" "',oname,'"'];
fprintf(['> copying to: ',outkey,'-',name,'\n']);
eval(evalstr);

function [tabnamestr] = maketabnames(tabnames)
tabnamestr = '';
for i = 1:numel(tabnames)
  tabnamei   = strrep(strrep(tabnames{i},'\','\\'),'.tex','');
  tabnamestr = [tabnamestr,tabnamei,','];
end
tabnamestr = tabnamestr(1:end-1);
  
