% TMPNAME
% This function generates a string for a temporary file name using concatenated
% varargin arguments. Numbers are converted to '%03.f' format.

function [matname] = tmpname(sub,varargin)
droot  = fullfile(pwd);
tmpdir = fullfile(droot,'data','tmp');
if ~exist(tmpdir,'dir')
  mkdir(tmpdir);
end
tmpstr = fullfile(tmpdir,'*');
for v = 1:numel(varargin)
  if isnumeric(varargin{v})
    varargin{v} = num2str(varargin{v},'%03.f');
  end
  sub = [sub,varargin{v}];
end
matname = strrep(tmpstr,'*',sub);