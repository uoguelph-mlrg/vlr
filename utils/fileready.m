% FILEREADY
% Make sure file fname exists and has not been modified in last [delay] ms
function [ready] = fileready(fname,delay)
if nargin < 2, delay = 1000; end
f = dir(fname);
ready = ~isempty(f) && (1000*60*60*24*(now-f.datenum) > delay);
