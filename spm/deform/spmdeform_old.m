% SPMDEFORM
% This function calls SPM's deform tool to warp 3D image arrays (varargin)
% according to the transformation file xform 
% (this is given as a filename: the xform estimated by SPM previously).
% This requires saving the images as nii temporarily.
% The xform filename is used as a temporary directory.
% All input images for warping are saved using the format spmdef_#.
% All output images after warping are saved using the format ospmdef_#.
% On completion, the temporary images are read in as MATLAB 3D arrays,
% and the nii files deleted (but not the temporary directory).

function [varargout] = spmdeform_old(xform,templatei,templateo,varargin)
[~,tmp,~] = fileparts(xform);
tdir = tmpname(tmp);
if ~exist(tdir,'dir'), mkdir(tdir); end
fname = fullfile(tdir,'@spmdef_#.nii');
for i = 1:numel(varargin)
  % generate file name
  namei{i,1} = strrep(strrep(fname,'@', ''),'#',num2str(i));
  nameo{i,1} = strrep(strrep(fname,'@','o'),'#',num2str(i));
  % write the input image to file using templatei
  writenii(imrotate(varargin{i},180), namei{i}, templatei);
end
while ~all(cellfun(@(f)exist(f,'file'),namei)), pause(0.05); end
% run the SPM deformation module
matlabbatch = makebatch(xform,namei,templateo);
spm_jobman('run',matlabbatch);
% read the outputs from file and delete the temporary nii files
while ~all(cellfun(@(f)exist(f,'file'),nameo)), pause(0.05); end
for i = 1:numel(varargin)
  varargout{i} = imrotate(readnii(nameo{i}),180);
end
pause(0.5);
for i = 1:numel(varargin)
  delete(namei{i},nameo{i});
end

function [matlabbatch] = makebatch(xform,namei,templateo)
matlabbatch{1}.spm.util.defs.comp{1}.def = {xform};
matlabbatch{1}.spm.util.defs.out{1}.push.fnames = namei;
matlabbatch{1}.spm.util.defs.out{1}.push.weight = {''};
matlabbatch{1}.spm.util.defs.out{1}.push.savedir.savesrc = 1;
matlabbatch{1}.spm.util.defs.out{1}.push.fov.file = {templateo};
matlabbatch{1}.spm.util.defs.out{1}.push.preserve = 0;
matlabbatch{1}.spm.util.defs.out{1}.push.fwhm = [0 0 0];
matlabbatch{1}.spm.util.defs.out{1}.push.prefix = 'o';