function [] = fig_exseg(h,o,tn)
if nargin < 2, load(h.save.name,'h','o'); end
if nargin < 3, tn = {'fig','seg'}; end
i = 45; z = 50;
[Z,names] = getdata(h,o,i,z);
for n = 1:numel(Z)
  figure;
  timshow(Z{n},0,'w500');
  if strcmp(names{n},'P')
    hold on;  
    area([0,0,0],[0,0,0],'facecolor',grn(1));
    area([0,0,0],[0,0,0],'facecolor',red(1));
    area([0,0,0],[0,0,0],'facecolor',blu(1));
    l = legend({'TP','FP','FN'},'location','ne',...
      'fontsize',32,'TextColor','w','Color','k','fontname','CMU Serif');
    set(l,'position',[0.7,0.75,0.3,0.25]);
  end
  set(gcf,'InvertHardcopy','off');
  print(thesisname(tn{:},['exseg-',names{n},'.png']),'-dpng');
  %close(gcf);
end

function [varargout] = zslice(z,varargin)
dx = 0;
dy = 40;
for i = 1:numel(varargin)
  varargout{i} = varargin{i}(end-dy:-1:dy+1,dx+1:end-dx,z);
end

function [Z,names] = getdata(h,o,i,z)
I = imrotate(readnicenii(imglutname('FLAIRm',96,i)),0);
G = imrotate(readnicenii(imglutname('mans',  96,i)),0) > 0.5;
x = readniivsize(imglutname('FLAIRm',96,i));
[B{1},B{2},M] = mni2ptx(h.Ni,i,o.B{h.cv.i(i)}{:},single(h.M));
M = M > 0.5;
B{1}(~M) = -1.5;
B{2}(~M) = 1;
cmap = inferno;
J = standardize(I,M>0.5,h.std.type,h.std.args{:});
I = momi(alphaclip(I,[0.001,0.999],M));
Q = M./(1+exp(-(B{1}+B{2}.*J)));
T = -B{1}./B{2}.*M;
S = B{2}.*M;
C = logical(postpro(h,Q,x,o.thr(h.cv.i(i))));
P = zeros(size(G)); P( C& G) = 2;  P( C&~G) = 1;  P(~C& G) = 3;
G = single(G); C = single(C);
[I,J,T,S,Q,C,G,P] = zslice(z,I,J,T,S,Q,C,G,P);
Z= {...
  im2rgb(I,gray,[0,1]);
  im2rgb(J,cmap,[0.2,1]);
  im2rgb(T,cmap,[0.2,1]);
  im2rgb(S,cmap,[0,60]);
  im2rgb(Q,cmap,[0,1]);
  im2rgb(C,gray,[0,1]);
  im2rgb(G,gray,[0,1]);
  im2rgb(P,krgb,[0,3])};
names = {'I','J','T','S','Q','C','G','P'};

function [cmap] = krgb()
cmap = [0,0,0; red(1); grn(1); blu(1)];
