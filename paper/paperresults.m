function [] = paperresults()
% ------------------------------------------------------------------------------
% statusupdate(50); statusupdate('stats results'); statusupdate();
% paperstats;
% ------------------------------------------------------------------------------
% statusupdate(50); statusupdate('param results'); statusupdate();
% [h,names] = defhypset('lam');
% roicompare   (h,names,'lam');
% [h,names] = defhypset('psu');
% roicompare   (h,names,'psu');
% ------------------------------------------------------------------------------
statusupdate(50); statusupdate('copying results'); statusupdate();
h.final = hypdef_final;
d.final = fullfile(h.final.save.figdir);
d.thesis = thesisname('fig');
tocopy = deftocopy(d);
for k = 1:numel(tocopy)
  for i = 1:numel(tocopy{k}.item)
    tocopy{k}.copy(tocopy{k}.item{i});
  end
end
statusupdate('done'); statusupdate(); statusupdate(50); statusupdate();

function [tocopy] = deftocopy(d)
tocopy{1} = copyitem(d.final,'','final',{...
  resultsname('tab'),...
  resultsname('scat','si'),...
  resultsname('scat','pr'),...
  resultsname('scat','re'),...
  resultsname('ba',1),...
  resultsname('ba',2),...
  resultsname('img','T'),...
  resultsname('img','S'),...
  resultsname('img','Y'),...
  resultsname('cmap','T'),...
  resultsname('cmap','S'),...
  resultsname('cmap','Y'),...
  resultsname('tab'),...
  });
tocopy{2} = copyitem(fullfile(d.thesis,'seg'),'exseg','exseg',{...
  'I.png',...
  'J.png',...
  'T.png',...
  'S.png',...
  'Q.png',...
  'C.png',...
  'G.png',...
  'P.png',...
  });
tocopy{3} = copyitem(fullfile(d.thesis,'seg'),'lpa','lpa',{...
  resultsname('box','si'),...
  resultsname('box','pr'),...
  resultsname('box','re'),...
  resultsname('box','leg'),...
  });
tocopy{4} = copyitem(fullfile(d.thesis,'seg'),'cv','cv',{
  resultsname('box','si'),...
  resultsname('box','pr'),...
  resultsname('box','re'),...
  resultsname('box','leg'),...
  });

function [C] = copyitem(idir,ipref,opref,inames)
for v = 1:numel(inames)
  C.item{v} = inames{v};
end
C.copy = @(name)fcopy(idir,ipref,opref,name);

function [] = fcopy(idir,ipref,opref,name)
statusupdate(sprintf('%s [%s -> %s]',name,ipref,opref));
statusupdate();
if ~isempty(ipref)
  ipref = [ipref,'-'];
end
if ~isempty(opref)
  opref = [opref,'-'];
end
iname = fullfile(idir,[ipref,name]);
oname = thesisname('paper',[opref,name]);
evalstr = ['!copy "',iname,'" "',oname,'" > nul'];
%evalstr = ['!copy "',iname,'" "',oname,'"'];
eval(evalstr);

function [] = roicompare(h,names,lab)
test = @(x1,x2)signrank([x1(:)-x2(:)]);
metrics = {{'si','pr','re'},{'$SI$','$Pr$','$Re$'}};
for i = 1:numel(h)
  h{i} = hroi(h{i},'t0');
end
boxplotcompare(h,metrics{:},[],['roi-',lab,'-box'],names,test,{'paper'});





