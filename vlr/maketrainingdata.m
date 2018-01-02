% MAKETRAININGDATA(h)
% This function loads and preprocesses all training data specified by h.
% On completion, these data are saved to file to save time.
% If a save file already exists with the specified name, it is loaded.

function [h,Y,C] = maketrainingdata(h)
[h,N] = init(h);
Y = nan(N.v,h.Ni*N.a,'single'); % graylevel data
C = nan(N.v,h.Ni*N.a,'single'); % labels
% for all subjects...
for n = 1:h.Ni
  [h,Yn,Cn] = loadone(h,n);
  [Ynt]     = prepone(h,Yn);
  [h,Y,C]   = sampleone(h,Y,C,Ynt,Cn,n,N);
  statusbar(h.Ni,n,h.Ni/3,1);
end
% nan -> 0
Y(isnan(Y) | isnan(C)) = 0;
C(isnan(Y) | isnan(C)) = 0;

function [h,N] = init(h)
% load the MNI-space brain mask
h.M = brainfun;
% resize the mask by the VLR fitting factor
h.sam.Mr = ndresize(h.M,h.sam.resize);
N.s = size(h.sam.dx,1);  % shift augmentation count
N.f = h.sam.flip+1;      % flip augmentation count
N.a = N.s*N.f;           % total augmentation count
N.v = sum(h.sam.Mr(:));  % number of fitted voxels

function [h,Yn,Cn] = loadone(h,n)
% load the MNI-space FLAIR and label image
h.name.img{n} =  imglutname('mni:FLAIRm',h.Ni,n);
Yn = readnicenii(imglutname('mni:FLAIRm',h.Ni,n),h.M,[0,1]);
Cn = readnicenii(imglutname('mni:mans',  h.Ni,n),h.M);
Cn = Cn./max(Cn(:)); % in case not \in [0,1]

function [Ynt] = prepone(h,Yn)
% graylevel standardization
Ynt = standardize(Yn,h.M,h.std.type,h.std.args{:});

function [h,Y,C] = sampleone(h,Y,C,Yn,Cn,n,N)
% Resize the image, perform data augmentation transformations
% then vectorize only the brain voxels for efficiency
r = h.sam.resize;
for f = 1:N.f
  for s = 1:N.s
    xs = h.sam.dx(s,:);
    Yr = flipshiftresize(Yn,f,xs,r); % graylevels
    Cr = flipshiftresize(Cn,f,xs,r); % label
    ia = (n-1)*N.a + (f-1)*N.s + s;
    Y(:,ia) = Yr(h.sam.Mr);
    C(:,ia) = Cr(h.sam.Mr);
    h.sam.i(ia) = n;
  end
end

function [Irsf] = flipshiftresize(I,f,s,r)
if     f==1, If = I(:,1:+1:end,:); % original
elseif f==2, If = I(:,end:-1:1,:); % flipped
end
Irsf = ndresize(imshift(If,s),r);  % shift & resize

function [IS] = imshift(I,T) % easier to use than matlab imshift
if     all(T==[0,0,0]),   IS = I;
elseif all(T==[0,0,+1]),  IS = cat(3, I(:,:,1+1:end), I(:,:,    end));
elseif all(T==[0,0,-1]),  IS = cat(3, I(:,:,      1), I(:,:,1:end-1));
elseif all(T==[0,+1,0]),  IS = cat(2, I(:,1+1:end,:), I(:,    end,:));
elseif all(T==[0,-1,0]),  IS = cat(2, I(:,      1,:), I(:,1:end-1,:));
elseif all(T==[+1,0,0]),  IS = cat(1, I(1+1:end,:,:), I(    end,:,:));
elseif all(T==[-1,0,0]),  IS = cat(1, I(      1,:,:), I(1:end-1,:,:));
else   error('Not implemented: please use standard imshift instead.');
end

