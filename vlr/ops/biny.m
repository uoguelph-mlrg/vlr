% [YB,U] = biny(Y,varargin)
% 
% BINY re-bins data to evenly spaced bins using user specified min-max
%   specifications for both input and output data ranges, and the number of
%   bins. Input data outside the input range is saturated (set to min or
%   max value, before continuing).
% 
% Args:
%   Y  - ND array of real-valued data
%   N  - number of bins  - integer value; can appear before or after mi/mo
%   mi - minmax (input)  - [low,high] appears first;  [] to use default
%   mo - minmax (output) - [low,high] appears second; [] to use default
%   
% This function was designed for look-up table transforms of ND-arrays:
%   Y - ND-array of real valued data
%   T - vector lookup table transform with N values
% 
% e.g. to use default [min(Y(:)),max(Y(:))] as input range:
%   Ybin = biny(Y,[],[1,N],N);
% e.g. saturating anything below 0.1 and above 1.5 in input range:
%   Ybin = biny(Y,[0.1,1.5],[1,N],N);
% then, to perform the look-up (because Ybin has values 1,...,N):
%   YT = T(Ybin);
% 
% Jesse Knight 2016

function [YB,U] = biny(Y,varargin)
dtype = class(Y); % store original data type
Y = double(Y);    % faster than single, and need non-int precision
minmax = [min(Y(:)),max(Y(:))]; % default if no user specification
% parse args - check if user has specified the {mi, mo, N} arguments
[mi,mo,N] = parseargs(minmax,varargin);
% bin data, re-cast
[YB] = cast(binit(Y,mi,mo,N),dtype);
% bin dummy data to give vector of levels
[U] = binit(linspace(mi(1),mi(2),N),mi,mo,N);

function [YB] = binit(Y,mi,mo,N)
% saturate with input minmax
YS = min(mi(2),max(mi(1),Y));
% bin to 0:1
YL = round(((YS - mi(1)) ./ diff(mi)) .* (N-1)) ./ (N-1);
% scale to output minmax
YB = (YL .* diff(mo)) + mo(1);

function [minmaxi,minmaxo,N] = parseargs(minmax,vargs)
% defaults
N       = 256;
minmaxi = minmax;
minmaxo = [0,1];
% parsing user specs
nminmax = 0;
for v = 1:numel(vargs)
  if (numel(size(vargs{v})) == 2) % arg must be "2D" (including [1,1])
    if     (all(size(vargs{v}) == [1,1])) % number of levels
      N = vargs{v};
    elseif (all(size(vargs{v}) == [1,2])) % minmax
      if nminmax == 0       % input specified (appears first)
        minmaxi = vargs{v};
        nminmax = 1;
      elseif nminmax == 1   % output too (appears second)
        minmaxo = vargs{v};
        nminmax = -1;
      end
    elseif isempty(vargs{v}) && isnumeric(vargs{v})
      if nminmax == 0       % input specified (default)
        minmaxi = minmax;
        nminmax = 1;
      elseif nminmax == 1   % output too (default)
        minmaxo = minmax;
        nminmax = -1;
      end
    end
  else
    warning('Binning specifications must be 1 or 2 element vectors.');
  end
end

