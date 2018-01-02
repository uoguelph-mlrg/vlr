function [] = show_tikzfigs(x,todo)
if nargin < 1, h = hypdef_final; x = load(h.save.name,'h','o'); end
if nargin < 2, todo = {'slice','lr','hist'}; end
for t = 1:numel(todo)
  switch todo{t}
    case 'slice', tikzslice(x);
    case 'lr',    tikzsigmoids;
    case 'hist',  tikzhists;
  end
end
close all;

function [] = tikzslice(x)
n = 2; n2 = 80; nt = 3; c = 3;
z = 61;
cmap = inferno;
% load some raw images
M  = logical(getslice('mni:brain',1,z));
I1 = getslice('mni:FLAIRm',n, z,M);
G1 = getslice('mni:mans',  n, z,M);
I2 = getslice('mni:FLAIRm',n2,z,M);
G2 = getslice('mni:mans',  n2,z,M);
It = getslice('mni:FLAIRm',nt,z,M);
% load some sample model data
T = clip(-x.o.B{c}{1}(:,:,z)./x.o.B{c}{2}(:,:,z),[0.5, 1]).*M;
S = clip( x.o.B{c}{2}(:,:,z),                    [0  ,50]).*M;
%T = T(:,:,z); T(T<=0) = 1;   T = gaussfilter(medfilt2(T,[5,5]),[.5,.5]); T = T.*M;
%S = T(:,:,z); T(S<=1) = 100; S = gaussfilter(medfilt2(S,[5,5]),[.5,.5]); S = S.*M;
% crop for better resolution
I1(I1<1/100) = 0;
[I1,G1,M,I2,G2,T,S,It] = specialcrop(I1,G1,M,I2,G2,T,S,It);
% generate the images of interest
G1 = G1 > 0.5;
G2 = G2 > 0.5;
I1 = momi(max(0,I1));     % raw
I2 = momi(max(0,I2));     % raw
IR = momi(max(0,I1.*M));  % after registration
It = momi(max(0,It.*M));
JR = biny((IR-mean(IR(M)))./std(IR(M)),[-1,+2],[0,1],256); % IR post-standardize
Jt = biny((It-mean(It(M)))./std(It(M)),[-1,+2],[0,1],256); % It post-standardize
Qt = 1./(1+exp(-(S.*(Jt-T)))).*M; % compute the predicted lesions
Lt = postpro(x.h,x.o.thr(x.h.cv.i(nt)),dumthree(Qt));
Lt = Lt(:,:,2); % do the post-process
% convert stuff to RGB
Qt = im2rgb(Qt/1.1,cmap,[0,1]);
T  = im2rgb(T,cmap,[0.5,1.0]);
S  = im2rgb(S,cmap,[0,50]);
imgs  = { I1 , I2 , IR , G1 , G2 , JR , T  , It , Jt , Qt , Lt };
names = {'i1','i2','ir','c1','c2','jr','bb','it','jt','qt','lt'};
% debug: show all
%timshow(imgs{:},[0,1],'5x2');
for i = 1:numel(imgs)
  timshow(imgs{i},[0,1],0,'w200');
  print(gcf,thesisname('fig','tikz',[names{i},'.png']),'-dpng');
  close(gcf);
end

function [I] = getslice(key,n,z,M)
I = imrotate(readnii(imgname(key,n,1)),180);
I = max(0,I(:,:,z));
if nargin == 3, M = ones(size(I)); end
[~,mm] = alphatrim(I,[0,0.995],M);
I = momi(clip(I,mm));

function [I3] = dumthree(I)
I3 = cat(3,I,I,I);

function [C] = postpro(h,thr,C0)
C = C0 > thr;
C = bwareaopen(C,ceil(h.pp.minmm3*1.5^3));

function [varargout] = specialcrop(varargin)
for i = 1:numel(varargin)
  varargout{i} = varargin{i}(5:end-6,4+1:end-4);
end

function [] = tikzsigmoids()
mu = [0.3,0.8]; sd = [0.2,0.1]; N = [35,9];
yo = 0.6;
s  = 12;
y  = cat(1,mu(1)+sd(1)*randn([N(1),1]),mu(2)+sd(2)*randn([N(2),1]));
c  = cat(1,0*ones([N(1),1]),1*ones([N(2),1]));
yt = 0.72;
ct = 1./(1+exp(-s*(yt-yo)));
% plot the training sigmoid
plotlogit(yo,s);
plot(y,c,'k.','markersize',15);
cs = 0.5+[-1,+1]; ys = yo + 4*(cs-0.5)/s;
yy = [yo,yo]; cy = ylim;
plot(yy,cy,':', 'color',lighten(red(1),0.5));
plot(ys,cs,'--','color',lighten(red(1),0.5));
print(gcf,thesisname('paper','tikz','lr-fit'),'-depsc');
% plot the testing sigmoid
plotlogit(yo,s);
plot([yt,yt],[0,ct],':','color',lighten(red(1),0.5));
plot([0,yt],[ct,ct],':','color',lighten(red(1),0.5));
plot(yt,ct,'k.','markersize',15);
plot(yt,ct,'o','markersize',15,'color',red(1));
print(gcf,thesisname('paper','tikz','lr-test'),'-depsc');

function [] = plotlogit(yo,s)
y  = 0:0.01:1;
c  = 1./(1+exp(-(s.*(y-yo))));
figure;
hold on;
plot(y,c,'-','color',lighten(red(1),0.1));
ylim([-0.1,1.1]);
xlim([0,1]);
ylabel('$$\hat{c} = p(c=1\mid y;\beta)$$','interpreter','latex','fontsize',24);
xlabel('$$y$$','interpreter','latex','fontsize',24);
set(gca,'xtick',[0:0.25:1],'ytick',[0,1]);
figresize(gcf,[400,400]);
tightsubs(1,1,gca,[0.15,0.2,0.15,0.2]);

function [] = tikzhists()
savename = fullfile('data','misc','eg-hist.mat');
if exist(savename,'file')
  load(savename,'y','HI','HJ');
else
  [y,HI,HJ] = makehistdata(savename);
end
yname = {'y','\tilde{y}'};
plothist(y,HI,yname{1}); print(gcf,thesisname('paper','tikz','hist-pre' ),'-depsc');
plothist(y,HJ,yname{2}); print(gcf,thesisname('paper','tikz','hist-post'),'-depsc');

function [] = plothist(y,H,yname)
nscan = [5,5,5,13,5,5];
clr   = get(0,'defaultaxescolororder');
figure; hold on;
for s = numel(nscan):-1:1
  for i = 1:nscan(s)
    clri = lighten(clr(s,:),i/(nscan(s)+5));
    plot(y,H(:,sum(nscan(1:s-1))+i),'color',clri);
  end
end
ylim([0,5]);
xlim([min(y),max(y)]);
xlabel(['$$',yname,'$$'],   'interpreter','latex','fontsize',40);
ylabel(['$$p(',yname,')$$'],'interpreter','latex','fontsize',40);
figresize(gcf,[400,400]);
tightsubs(1,1,gca,[0.2,0.2,0.1,0.1]);

function [y,HI,HJ] = makehistdata(savename)
h = hypdef_final;
h.M = readnicenii(imgname('mni:brain','')) > 0.5;
N = 256;
y = linspace(0,1,N);
for i = 1:h.Ni
  I = readnicenii(imglutname('mni:FLAIRm',109,i)).*h.M;
  I = momi(alphaclip(I,[0.001,0.999],h.M)) + 0.01*randn(size(I));
  J = standardize(I, h.M > 0.5, h.std.type, h.std.args{:});
  HI(:,i) = ksdensity(I(h.M),y,'width',0.02);
  HJ(:,i) = ksdensity(J(h.M),y,'width',0.02);
  statusbar(h.Ni,i,h.Ni/3,1);
end
save(savename,'y','HI','HJ');




