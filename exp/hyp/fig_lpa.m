function [] = fig_lpa(todo,hvlr)
if nargin < 1, todo = {'beta','compare'}; end
if nargin < 2
  h{1} = hypdef_final;
else
  h{1} = hvlr;
end
h{2} = getfield(load(fullfile('data','misc','mni96-LPA-loso.mat'),'h'),'h');
names   = {'VLR','LPA'};
metrics = {{'si','pr','re'},{'$SI$','$Pr$','$Re$'}};
test = @(x1,x2)signrank([x1(:)-x2(:)]);
for i = 1:numel(todo)
  switch todo{i}
    case 'beta'
      showbeta;
    case 'compare'
      boxplotcompare(h,metrics{:},[4,22],'lpa-box',names,test);
  end
end

function [varargout] = lpaimg(varargin)
lpamatfile = 'C:\program files\matlab\spm12\toolbox\LST\LST_lpa_stuff.mat';
data = load(lpamatfile,'bp_mni',varargin{:});
Z = zeros([121,145,121]);
for v = 1:numel(varargin)
  varargout{v} = Z;
  varargout{v}(data.bp_mni) = data.(varargin{v});
  varargout{v} = imrotate(varargout{v},90);
end

function [B] = vlrbeta(BX)
M = brainfun;
s = std(BX(M));
%[h,names] = defhypset('ystd');
%i = find(strcmp(arrayfun(@(i)names{i}(9:end-1),1:numel(names),'un',0),'SS'));
%load(h{i}.save.name,'o');
h = hypdef_final;
load(h.save.name,'o');
BC = arrayfun(@(i)(o.B{i}{1}),1:numel(o.B),'un',0);
B  = mean(cat(4,BC{:}),4);
B  = s*(B - median(B(M)))./std(B(M));

function [] = showbeta()
cmap = inferno;
bmm   = [-2,+3];
btick = [-2:+3];
M     = brainfun;
% LPA beta_0
B.LPA = lpaimg('sp_mni2_Bf2');
% VLR beta_0
B.VLR = vlrbeta(B.LPA);
% black oob
B.LPA(~M) = -inf;
B.VLR(~M) = -inf;
% show the results
sliceshow(B.LPA,zfun,cmap,bmm);
print(gcf,thesisname('fig','seg','b0-LPA.png'),'-dpng');
close(gcf);
sliceshow(B.VLR,zfun,cmap,bmm);
print(gcf,thesisname('fig','seg','b0-VLR.png'),'-dpng');
close(gcf);
vcolorbar(btick,cmap);
print(gcf,thesisname('fig','seg','cmap-LPA.eps'),'-depsc');
close(gcf);
