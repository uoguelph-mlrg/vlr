% READNII
% read a .nii file: image data and voxel size (optional)

function [I,vsize] = readnii(fname)
[~,~,ftype] = fileparts(fname);
if ~exist(fname,'file')
  error('Cannot find NIFTI file: %s',fname);
elseif ~any(strcmp(ftype,{'.nii','.gz'}))
  error('File: %s is not NIFTI',fname);
end
try
  NII = load_untouch_nii(fname);
  I   = double(imrotate(NII.img,-90));
  %I   = I./max(I(:));
catch ME
  disp( getReport( ME, 'extended', 'hyperlinks', 'on' ) );
end
try
  vsize = NII.hdr.dime.pixdim([3,2,4]);
catch
  vsize = [];
end