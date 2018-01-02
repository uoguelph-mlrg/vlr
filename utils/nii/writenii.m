% WRITENII
% Write an image to .nii format using a template .nii file for the header
% I - the image volume data
% fname - the new .nii file name
% niiname - the template .nii file name
% datatype - I don't think this actually works

function [] = writenii(I,fname,niiname,datatype)
if nargin == 3
  datatype = class(I);
end
if ~exist(niiname,'file')
  error('Cannot find NIFTI file: %s',niiname);
elseif ~any(strcmp(filetype(niiname),{'.nii','.gz'}))
  error('File: %s is not NIFTI',niiname);
end
try
  NII = load_untouch_nii(niiname);
%   if ~isempty(extradim) % hax for writing TPM
%     NII.hdr.dime.dim = [4 121 145 121 dim4 1 1 1];
%   end
  I = double(imrotate(I,+90));
  NII.hdr.dime.dim = [4, size(I), ones(1,7-numel(size(I)))];
  NII.img = I;
  [NII.hdr.dime.datatype, NII.hdr.dime.bitpix] = dtypelut(datatype);
  save_untouch_nii(NII,fname);
catch ME
  disp( getReport( ME, 'extended', 'hyperlinks', 'on' ) );
end

function [ft] = filetype(fname)
[~,~,ft] = fileparts(fname);

function [dt,bp] = dtypelut(datatype)
switch datatype
  case 'logical',  dt =    1;   bp =  1;
  case 'int8',     dt =  256;   bp =  8;
  case 'uint8',    dt =  128;   bp =  8;
  case 'int16',    dt =    4;   bp = 16;
  case 'uint16',   dt =  512;   bp = 16;
  case 'int32',    dt =    8;   bp = 32;
  case 'uint32',   dt =  768;   bp = 32;
  case 'int64',    dt = 1024;   bp = 64;
  case 'uint64',   dt = 1280;   bp = 64;
  case 'single',   dt =   16;   bp = 32;
  case 'double',   dt =   64;   bp = 64;
  otherwise, error('Unknown datatype');
end
