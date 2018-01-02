% READNIIVSIZE
% Read just the voxel size from a .nii file

function [vsize] = readniivsize(fname)
[~,~,ftype] = fileparts(fname);
if ~exist(fname,'file')
  error('Cannot find NIFTI file: %s',fname);
elseif ~any(strcmp(ftype,{'.nii','.gz'}))
  error('File: %s is not NIFTI',fname);
end
try
  hdr = load_untouch_header_only(fname);
catch ME
  disp( getReport( ME, 'extended', 'hyperlinks', 'on' ) );
end
try
  vsize = hdr.dime.pixdim([3,2,4]);
catch
  vsize = [];
end