% VLRMAP
% This function estimates a [V,2] matrix of beta parameters (B) for V parallel
% logistic regression models.
% The training data are specified in Y (size: [V,N,K]) and C (size: [V,N,1])
% V is the number of voxels
% N is the number of training examples
% K is the number of features (must be K=1 here for efficient implementation)
% Uses gpuArray -- if you don't have GPU set up, just remove all calls of
% gpuArray, gather, and gpuDevice. You can set Nb = 1 and Nd = V.

function [B,dB] = vlrmap(h,Y,C)
[V,N,K] = size(Y);
dBout = (nargout == 2);
% expand the parameters to match size if not done already
B = h.lr.B; % size(B) needs to be [V, 1, 2] for multiply compatibility
if size(B,1) == 1
  B = padarray(shiftdim(B,-1),[V-1,0,0],'post','replicate');
end
if dBout
  dB = zeros([size(squeeze(B)),h.lr.Nit]);
end
% prepend a row of ones for multipl compatibility
Y = padarray(Y,[0,0,1],1,'pre');
% transform the features by the labels for efficient implementation
C(C>=0.5) = +1;
C(C< 0.5) = -1;
for k = 1:K+1
  YS(:,:,k) = Y(:,:,k).*C;
end
clearvars('C','Y');
% computing max batch size for GPU
GPU = gpuDevice(1);
Nf  = 9;                               % empirical memory scale factor
Nb  = ceil(4*(V*N*Nf)/GPU.FreeMemory); % 4-bytes x [size] x Nf vars
Nd  = ceil(V/Nb);
% for each batch (if cannot fit all data on GPU)
for b = 1:Nb
  % select the batch indices for GPU
  bi  = ((b-1)*Nd)+1 : min(b*Nd,V);
  % transfer to GPU
  Yb  = gpuArray(single(YS(bi,:,:))); % features
  Bb  = gpuArray(single( B(bi,:,:))); % beta
  % run the optimization
  statusupdate(b,Nb);
  for t = 1:h.lr.Nit
    if dBout
      [Bb,dBbt] = update(Yb,Bb,h.lr.alpha,h.lr.reg.la);
      dB(bi,:,t) = squeeze(gather(dBbt));
    else
      Bb = update(Yb,Bb,h.lr.alpha,h.lr.reg.la);
    end
    % statusbar
    statusbar(h.lr.Nit,t,h.Ni/3,1);
  end
  % gather from GPU 
  B(bi,:,:) = gather(Bb);
  reset(GPU);
end
B = squeeze(B); % [V,1,2] -> [V,2]

function [Bout,dB] = update(Y,B0,alpha,la)
% compute the activation
B = padarray(B0,[0,size(Y,2)-1,0],'replicate','post');
S = B.*Y; S = S(:,:,1) + S(:,:,2); % could be sum(B.*Y,3) but CUDA error win10
S = 1./(1+exp(S));
clear('B');
% compute the Hessian elements
A   = S.*(1-S);
H11 = sum(A.*Y(:,:,1).*Y(:,:,1), 2);% + la;
H22 = sum(A.*Y(:,:,2).*Y(:,:,2), 2) + la;
H12 = sum(A.*Y(:,:,1).*Y(:,:,2), 2);
Hd  = H11.*H22 - H12.*H12; % determinate for inversion
clear('A');
% compute the gradient elements
G1  = sum(Y(:,:,1).*S,2);% - la.*B0(:,:,1);
G2  = sum(Y(:,:,2).*S,2) - la.*B0(:,:,2);
clear('S');
% compute the update
dB = reshape([(H22.*G1 - H12.*G2)./Hd, (H11.*G2 - H12.*G1)./Hd],size(B0));
% apply the update
Bout = B0 + alpha*dB;
