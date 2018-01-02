% MATX
% This function spawns an external MATLAB instance to run in the background
% The code specified in codestr is executed by the spawn.
% Spawns close when complete, but this function does not wait for this.
% Arguments to spawsn *must* be passed via .mat file save/load.

function [cmdstr] = matx(codestr)
if nargin < 1, error('Must supply a string of code for evaluation.'); end
bdir = 'C:\Program Files\MATLAB\R2011a\bin';
codewrap = 'cd(''__bdir__''); startup; cd(''__cdir__''); __code__; exit;';
cmdstr = ['matlab -nodesktop -nodisplay -nosplash -minimize -r "',codewrap,'"'];
cmdstr = strrep(cmdstr,'__bdir__',bdir);
cmdstr = strrep(cmdstr,'__cdir__',pwd);
cmdstr = strrep(cmdstr,'__code__',codestr);
if nargout == 0  % hide output (nul), call cmd from matlab, dont wait for it
  eval(['!',cmdstr,'> nul &']);
else             % append newline and return the cmd as a string
  cmdstr = ['start ',cmdstr];
end
