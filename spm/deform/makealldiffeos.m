% MAKEALLDIFFEOS
% This function pre-computes transformation matrices used by SPM to transform
% between native (ptx) and MNI space. The matrices are expensive to compute, so
% a hack-ish parallelization is used which spawns background matlab instances to
% complete more quickly.

function [] = makealldiffeos()
Ni  = 129;
cpu = 5;
% the bat file
file.bat = 'tmp.bat';
% the code for execution
code = 'makediffeos(%d,[#]);';
% group the indices
bat = {[10]};
% create the file contents
for n = 1:cpu % cpu
  i      = num2cell(n:cpu:Ni);
  nib    = numel(i);
  numstr = sprintf(repmat('%02.f,',[1,nib]),i{:});
  codi   = sprintf(strrep(code,'#',numstr),Ni);
  bat{end+1} = ['@echo COMPUTING DIFFEOS ',numstr,'...',10];
  bat{end+1} = ['@',matx(codi),10];
  bat{end+1} = ['@timeout 0.5 > nul',10];
end
bat{end+1} = 'exit';
% write the file
fid = fopen(file.bat,'w');
fwrite(fid,cat(2,bat{:}));
fclose(fid);
while ~fileready(file.bat,1000), pause(0.1); end
eval(['!call ',file.bat,' &']);     % execute the bat file


% xform is a filename specifying the SPM transform to be applied
% templatei is a filename specifying an input image template (affine xform)
% templateo is a filename specifying the output image template (size, fov, etc)
% varargin are image arrays to be transformed, whose size matches xform