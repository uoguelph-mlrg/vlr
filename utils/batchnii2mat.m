% BATCHNII2MAT
% This function loads .nii and .nii.gz image files (from IMG/NII)
% and saves them to .mat files (in IMG/MAT/).
% This function is poorly written for one-time use.

function [] = batchnii2mat()
% warning('off','MATLAB:MKDIR:DirectoryExists');
for i = 1:129
  fmt2mat(fmtdef,i);
end
warning('on','MATLAB:MKDIR:DirectoryExists');

function [fmt] = fmtdef()
oki = [1:75,109:129]; % images which were processed with VLR
fmt.Original    .im   .vol    = @(i)basicload('FLAIR',    i,'single');
fmt.Standardized.im   .final  = @(i)stdload(  'mni:FLAIR',i,'single');
fmt.Standardized.im   .reg    = @(i)basicload('mni:FLAIR',i,'single');
fmt.Standardized.im   .tform  = @(i)basicload('xform',    i,'single');
fmt.Standardized.im   .itform = @(i)basicload('ixform',   i,'single');
fmt.BrainSeg    .brain.seg    = @(i)tformload('mni:brain',i,'single');
fmt.BrainSeg    .brain.reg    = @(i)basicload('mni:brain',i,'single');
fmt.wmlGT       .wml  .gt     = @(i)basicload('mans',     i,'single');
fmt.wmlGT       .wml  .gts    = @(i)loadmultimans(        i,'single');
fmt.wmlGT       .wml  .reg    = @(i)basicload('mni:mans', i,'single');
fmt.wmlSeg      .wml  .prob   = @(i)checkload('les',      i,'single',oki);
fmt.wmlSeg      .wml  .seg    = @(i)thrload(  'les',      i,'single',oki);

function [setname,setdir,subjname] = setlut(setkey,setnum)
lut.h17  = '17wmhseg';
lut.m16  = '16msseg';
lut.m08  = '08msseg';
lut.cain = 'inhouse';
lut.i15  = '15isbi';
setname  = lut.(setkey);
setdir   = fullfile('D:','DATA','WML','MAT',setname);
subjname = [setname,'_FLAIR_',num2str(setnum,'%03.f')];

function [] = fmt2mat(fmt,i)
[~,setkey,setnum] = imglutname('FLAIR',129,i);
[~,setdir,subjname] = setlut(setkey,setnum);
fprintf('Working on: %s\n',subjname);
mkdir(setdir);
d = fields(fmt); % directories
for di = 1:numel(d)  
  % savedir
  savedir = fullfile(setdir,d{di});
  savemat = fullfile(savedir,subjname);
  mkdir(savedir);
  % image i/o
  fprintf(' / %s\n',d{di});
  s = fields(fmt.(d{di})); % structs
  for si = 1:numel(s)
    fprintf('   > %s\n',s{si});
    f = fields(fmt.(d{di}).(s{si})); % fields
    for fi = 1:numel(f)
      imgfun = fmt.(d{di}).(s{si}).(f{fi});
      fprintf('     . %s ',f{fi});
      eval([s{si},'.',f{fi},' = imgfun(i);']); % pls forgive eval usage here <3
      fprintf('\n');
    end
  end
  save(savemat,s{:});
end

function [I] = loadimg(fname,class)
I = cast(readnii(fname),class);

function [I] = basicload(imgkey,i,class)
I = loadimg(imglutname(imgkey,129,i),class);

function [I] = checkload(imgkey,i,class,oki)
if any(i==oki)
  I = basicload(imgkey,i,class);
else
  I = [];
end

function [I] = thrload(imgkey,i,class,oki)
% datestamp: 2017-12-21, from: mni96-m3-r=0.5-e-default-loso.mat
lut(  1: 20) = 0.54990; % h17-1
lut( 21: 40) = 0.51982; % h17-2
lut( 41: 60) = 0.59590; % h17-3
lut( 61: 65) = 0.52344; % m16-1
lut( 66: 70) = 0.52461; % m16-2
lut( 71: 75) = 0.52617; % m16-3
lut( 76: 95) = nan;     % m08
lut( 96:108) = nan;     % cain
lut(109:129) = 0.53945; % i15
I = cast(checkload(imgkey,i,class,oki) > lut(i), class);

function [I] = tformload(imgkey,i,class)
I = mni2ptx(129,i,loadimg(imglutname(imgkey,129,i),class));

function [I] = loadmultimans(i,class)
[~,setkey,setnum] = imglutname('FLAIR',129,i);
switch setkey
  case 'm16'
    for m = 1:7
      I{m} = loadimg(strrep(imgname('m16:mans7',setnum,0),'*',num2str(m)),class);
    end
  case 'i15'
    for m = 1:2
      I{m} = loadimg(imgname(['i15:mans',num2str(m)],setnum),class);
    end
  otherwise
    I = {};
end

function [I] = stdload(imgkey,i,class)
% datestamp: 2017-12-21, from: mni96-m3-r=0.5-e-default-loso.mat
I = basicload(imgkey,i,class);
M = basicload('mni:brain',i,'single');
I = standardize(I,M,'m3',pmfdef('lskew'));

