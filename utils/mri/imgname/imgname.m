% IMGNAME
% This function is a database of names of saved images. The arguments are:
% key -- format 'setkey:imgkey', where
%        setkey -- one of: h17, m16, i15, m08, cain, mni
%               corresponding to these different datasets (see comments below)
%               note: mni is all the other images in MNI space
%                     where the subject number is from the order in lut-129.txt
%        imgkey -- the type of image, e.g. FLAIR etc.
% num -- a number selecting the subject in the set
% docheck -- check to make sure the image exists (check .nii then .nii.gz)

function [iname] = imgname(key,num,docheck)
if nargin < 3, docheck = 1; end
iroot  = fullfile('D:','DATA','WML');
spmdir = fullfile('spm','default');
[setkey,key] = strtok(key,':');
[imgkey, ~ ] = strtok(key,':');
switch setkey
  % WMHSEG 17 ------------------------------------------------------------------
  case 'h17',  iroot = ff(iroot,'wmhseg17');
    switch imgkey
      case 'FLAIR',  iname = ff(iroot,'FLAIR','h17_FLAIR_#');
      case 'mans',   iname = ff(iroot,'mans','h17_GTC_#');
      case 'les',    iname = ff(iroot,'les','h17_les_#');
      case 'paper',  iname = ff(iroot,'les','h17_paperles_#');
      case 'base',   iname = ff(iroot,'les','h17_baseles_#');
      case 'lpa',    iname = ff(iroot,'spm','lpa','les','ples_lpa_mh17_FLAIR_#');
      case 'FLAIRm', iname = ff(iroot,spmdir,'FLAIRm','mh17_FLAIR_#');
      case 'bias',   iname = ff(iroot,spmdir,'bias',  'BiasField_h17_FLAIR_#');
      case 'c1',     iname = ff(iroot,spmdir,'tpm',   'c1h17_FLAIR_#');
      case 'c2',     iname = ff(iroot,spmdir,'tpm',   'c2h17_FLAIR_#');
      case 'c3',     iname = ff(iroot,spmdir,'tpm',   'c3h17_FLAIR_#');
      case 'xform',  iname = ff(iroot,spmdir,'xform', 'y_h17_FLAIR_#');
      case 'ixform', iname = ff(iroot,spmdir,'xform', 'iy_h17_FLAIR_#');
      case 'mni2ptx',iname = ff(iroot,spmdir,'diffeo','h17_mni2ptx_#');
      case 'ptx2mni',iname = ff(iroot,spmdir,'diffeo','h17_ptx2mni_#');
      case 'mat',    iname = ff(iroot,spmdir,'mat',   'h17_FLAIR_#_seg8');
      case 'root',   iname = iroot;
      otherwise error('Image key not found.');
    end
  % MSSEG 16 -------------------------------------------------------------------
  case 'm16',  iroot = ff(iroot,'msseg16');
    switch imgkey
      case 'FLAIR',  iname = ff(iroot,'FLAIR','m16_FLAIR_#');
      case 'mans',   iname = ff(iroot,'mans','m16_GTC_#');
      case 'mans7',  iname = ff(iroot,'mans','(7)','m16_GT_#_(*)');
      case 'les',    iname = ff(iroot,'les','m16_les_#');
      case 'paper',  iname = ff(iroot,'les','m16_paperles_#');
      case 'base',   iname = ff(iroot,'les','m16_baseles_#');
      case 'lpa',    iname = ff(iroot,'spm','lpa','les','ples_lpa_mm16_FLAIR_#');
      case 'FLAIRm', iname = ff(iroot,spmdir,'FLAIRm','mm16_FLAIR_#');
      case 'bias',   iname = ff(iroot,spmdir,'bias','BiasField_m16_FLAIR_#');
      case 'c1',     iname = ff(iroot,spmdir,'tpm', 'c1m16_FLAIR_#');
      case 'c2',     iname = ff(iroot,spmdir,'tpm', 'c2m16_FLAIR_#');
      case 'c3',     iname = ff(iroot,spmdir,'tpm', 'c3m16_FLAIR_#');
      case 'xform',  iname = ff(iroot,spmdir,'xform','y_m16_FLAIR_#');
      case 'ixform', iname = ff(iroot,spmdir,'xform','iy_m16_FLAIR_#');
      case 'mni2ptx',iname = ff(iroot,spmdir,'diffeo','m16_mni2ptx_#');
      case 'ptx2mni',iname = ff(iroot,spmdir,'diffeo','m16_ptx2mni_#');
      case 'mat',    iname = ff(iroot,spmdir,'mat',  'm16_FLAIR_#_seg8');
      case 'root',   iname = iroot;
      otherwise error('Image key not found.');
    end
  % ISBI 15 -------------------------------------------------------------------
  case 'i15',  iroot = ff(iroot,'isbi15');
    if isnumeric(num)
      Nt   = [4,4,5,4,4]; ti = cell2mat(arrayfun(@(x)(1:x),Nt,'uniformout',0));
      pnum = sum(num > cumsum(Nt)) + 1; num  = ti(num);
      stub = ['training',num2str(pnum,'%02.f'),'_#_*'];
    end
    switch imgkey
      case 'FLAIR',  iname = ff(iroot,'FLAIR',strrep(stub,'*','FLAIR_pp'));
      case 'mans',   iname = ff(iroot,'mans',strrep(stub,'*','mask_and'));
      case 'mans1',  iname = ff(iroot,'mans','(2)+',strrep(stub,'*','mask1'));
      case 'mans2',  iname = ff(iroot,'mans','(2)+',strrep(stub,'*','mask2'));
      case 'mansand',iname = ff(iroot,'mans','(2)+',strrep(stub,'*','mask_and'));
      case 'mansor', iname = ff(iroot,'mans','(2)+',strrep(stub,'*','mask_or'));
      case 'les',    iname = ff(iroot,'les',strrep(stub,'*','les'));
      case 'paper',  iname = ff(iroot,'les',strrep(stub,'*','paperles'));
      case 'base',   iname = ff(iroot,'les',strrep(stub,'*','baseles'));
      case 'lpa',    iname = ff(iroot,'spm','lpa','les',['ples_lpa_m',strrep(stub,'*','FLAIR_pp')]);
      case 'FLAIRm', iname = ff(iroot,spmdir,'FLAIRm',['m',strrep(stub,'*','FLAIR_pp')]);
      case 'bias',   iname = ff(iroot,spmdir,'bias',  ['BiasField_',strrep(stub,'*','FLAIR_pp')]);
      case 'c1',     iname = ff(iroot,spmdir,'tpm',   ['c1',strrep(stub,'*','FLAIR_pp')]);
      case 'c2',     iname = ff(iroot,spmdir,'tpm',   ['c2',strrep(stub,'*','FLAIR_pp')]);
      case 'c3',     iname = ff(iroot,spmdir,'tpm',   ['c3',strrep(stub,'*','FLAIR_pp')]);
      case 'xform',  iname = ff(iroot,spmdir,'xform', ['y_',strrep(stub,'*','FLAIR_pp')]);
      case 'ixform', iname = ff(iroot,spmdir,'xform', ['iy_',strrep(stub,'*','FLAIR_pp')]);
      case 'mni2ptx',iname = ff(iroot,spmdir,'diffeo',[strrep(stub,'*','mni2ptx')]);
      case 'ptx2mni',iname = ff(iroot,spmdir,'diffeo',[strrep(stub,'*','ptx2mni')]);
      case 'mat',    iname = ff(iroot,spmdir,'mat',   [strrep(stub,'*','FLAIR_pp'),'_seg8']);
      case 'root',   iname = iroot;
      otherwise error('Image key not found.');
    end
  % MSSEG 08 -------------------------------------------------------------------
  case 'm08',  iroot = ff(iroot,'msseg08');
    if isnumeric(num)
      if     num <= 10, stub = 'CHB_train_Case#_*'; num = num;
      elseif num >= 11, stub = 'UNC_train_Case#_*'; num = num-10;
      end
    else
      stub = 'CHB_train_Case#_*';
      stub = 'UNC_train_Case#_*';
    end
    switch imgkey
      case 'FLAIR',  iname = ff(iroot,'FLAIR',strrep(stub,'*','FLAIR'));
      case 'mans',   iname = ff(iroot,'mans','segmentations',strrep(stub,'*','lesion_(1)'));  % revisions
      case 'mano',   iname = ff(iroot,'mans','original',strrep(stub,'*','lesion'));           % originals
      case 'les',    iname = ff(iroot,'les',strrep(stub,'*','les'));
      case 'lpa',    iname = ff(iroot,'spm','lpa','les',['ples_lpa_m',strrep(stub,'*','FLAIR')]);
      case 'FLAIRm', iname = ff(iroot,spmdir,'FLAIRm',['m',strrep(stub,'*','FLAIR')]);
      case 'bias',   iname = ff(iroot,spmdir,'bias',  ['BiasField_',strrep(stub,'*','FLAIR')]);
      case 'c1',     iname = ff(iroot,spmdir,'tpm',   ['c1',strrep(stub,'*','FLAIR')]);
      case 'c2',     iname = ff(iroot,spmdir,'tpm',   ['c2',strrep(stub,'*','FLAIR')]);
      case 'c3',     iname = ff(iroot,spmdir,'tpm',   ['c3',strrep(stub,'*','FLAIR')]);
      case 'xform',  iname = ff(iroot,spmdir,'xform', ['y_',strrep(stub,'*','FLAIR')]);
      case 'ixform', iname = ff(iroot,spmdir,'xform', ['iy_',strrep(stub,'*','FLAIR')]);
      case 'mni2ptx',iname = ff(iroot,spmdir,'diffeo',[strrep(stub,'*','mni2ptx')]);
      case 'ptx2mni',iname = ff(iroot,spmdir,'diffeo',[strrep(stub,'*','ptx2mni')]);
      case 'mat',    iname = ff(iroot,spmdir,'mat',   [strrep(stub,'*','FLAIR'),'_seg8']);
      case 'root',   iname = iroot;
      otherwise error('Image key not found.');
    end
  % CAIN -----------------------------------------------------------------------
  case 'cain', iroot = ff(iroot,'cain');
    switch imgkey
      case 'FLAIR',  iname = ff(iroot,'FLAIR','CAIN_FLAIR_#');
      case 'mans',   iname = ff(iroot,'mans','CAIN_GT_#');
      case 'les',    iname = ff(iroot,'les','CAIN_les_#');
      case 'paper',  iname = ff(iroot,'les','CAIN_paperles_#');
      case 'lpa',    iname = ff(iroot,'spm','lpa','les','ples_lpa_mCAIN_FLAIR_#');
      case 'FLAIRm', iname = ff(iroot,spmdir,'FLAIRm','mCAIN_FLAIR_#');
      case 'bias',   iname = ff(iroot,spmdir,'bias','BiasField_CAIN_FLAIR_#');
      case 'c1',     iname = ff(iroot,spmdir,'tpm', 'c1CAIN_FLAIR_#');
      case 'c2',     iname = ff(iroot,spmdir,'tpm', 'c2CAIN_FLAIR_#');
      case 'c3',     iname = ff(iroot,spmdir,'tpm', 'c3CAIN_FLAIR_#');
      case 'xform',  iname = ff(iroot,spmdir,'xform','y_CAIN_FLAIR_#');
      case 'ixform', iname = ff(iroot,spmdir,'xform','iy_CAIN_FLAIR_#');
      case 'mni2ptx',iname = ff(iroot,spmdir,'diffeo','CAIN_mni2ptx_#');
      case 'ptx2mni',iname = ff(iroot,spmdir,'diffeo','CAIN_ptx2mni_#');
      case 'mat',    iname = ff(iroot,spmdir,'mat',  'CAIN_FLAIR_#_seg8');
      case 'root',   iname = iroot;
      otherwise error('Image key not found.');
    end
  % MNI ------------------------------------------------------------------------
  case 'mni',  iroot = ff(iroot,'mni');
    switch imgkey
      case 'FLAIR',  iname = ff(iroot,'FLAIR','mni_FLAIR_#');
      case 'mans',   iname = ff(iroot,'mans','mni_GT_#');
      case 'FLAIRm', iname = ff(iroot,spmdir,'FLAIRm','mni_FLAIRm_#');
      case 'bias',   iname = ff(iroot,spmdir,'bias','mni_bias_#');
      case 'c1',     iname = ff(iroot,spmdir,'tpm', 'mni_c1_#');
      case 'c2',     iname = ff(iroot,spmdir,'tpm', 'mni_c2_#');
      case 'c3',     iname = ff(iroot,spmdir,'tpm', 'mni_c3_#');
      case 'brainx', iname = ff(iroot,'brain','MNI_1.5mm_brain'); % (v4)
      case 'brain',  iname = ff(iroot,'brain','MNI_brain');
      case 'tpm',    iname = ff(iroot,'spm','TPM');
      case 'root',   iname = iroot;
      otherwise error('Image key not found.');
    end
  otherwise error('Set key not found.');
end
% sub the specific number
if isnumeric(num), num = num2str(num,'%02.f'); else, docheck = 0; end
iname = strrep(iname,'#',num);
% make sure it exists (maybe)
if any(strcmp(imgkey,{'mat','mni2ptx','ptx2mni'}))
  iname = [iname,'.mat'];
elseif docheck
  if exist([iname,'.nii'],'file')
    iname = [iname,'.nii'];
    return
  elseif exist([iname,'.nii.gz'],'file')
    iname = [iname,'.nii.gz'];
    return
  else
    error(['Cannot find: ',iname,'.nii(.gz)']);
  end
else
  iname = [iname,'.nii'];
  return
end

function [out] = ff(varargin)
out = fullfile(varargin{:});


