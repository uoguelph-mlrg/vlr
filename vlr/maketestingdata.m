% MAKETESTINGDATA(h)
% This function loads and preprocesses all testing data specified by h.
% On completion, these data are saved to file to save time.
% If a save file already exists with the specified name, it is loaded.

function [Y,C] = maketestingdata(h)
Y = {}; % graylevel data
C = {}; % labels
% for all subjects...
for n = 1:h.Ni
  [Yn,Cn] = loadone(h,n);
  [Ynt,M] = prepone(h,Yn,n);
  [Y,C]   = sampleone(Y,C,Ynt,Cn,M,n);
  statusbar(h.Ni,n,h.Ni/3,1);
end

function [Yn,Cn] = loadone(h,n)
% load the MNI-space FLAIR and label image
Yn = readnicenii(imglutname('FLAIRm',h.Ni,n),h.M,[0,1]);
Cn = readnicenii(imglutname('mans',  h.Ni,n));
Cn = Cn./max(Cn(:)); % in case not \in [0,1]

function [Ynt,M] = prepone(h,Yn,n)
% warp the brain mask to ptx
M = mni2ptx(h.Ni,n,h.M);
% graylevel standardization
Ynt = standardize(Yn,M,h.std.type,h.std.args{:});

function [Y,C] = sampleone(Y,C,Yn,Cn,M,n)
% Vectorize only the brain voxels for efficiency
Y{n} = Yn(M > 0.5);
C{n} = Cn(M > 0.5);



