% STANDARDIZE
% This function standardizes the data in Yn, selected by the mask M
% The standardization type is a string, and additional required
% parameters should be passed to to varargin
% If M is empty, then stdfun operates along the 1st dimension of Y only.

function [Ynt] = standardize(Yn,M,type,varargin)
% define the transformation
switch type
  case 'na'  % none!
    stdfun = @(y)(y);
  case 'rm'  % range matching (quantiles specified)
    qmm    = varargin{1}; ymm = quantile(Yn,qmm,1);
    stdfun = @(y)(bsxfun(@rdivide,bsxfun(@minus,y,ymm(1,:)),diff(ymm)));
  case 'ss'  % statistical standardization
    stdfun = @(y)(bsxfun(@rdivide,bsxfun(@minus,y,mean(y,1)),4*std(y,[],1))+0.5);
  case 'he'  % histogram equalization
    stdfun = @(y)(bsxfun(@(y,i)histeq(y./max(y)),y,1:size(y,2)));
    %stdfun = @(y)(bsxfun(@(y,i)histeq(im2double(y)),y,1:size(y,2)));
  case {'m1','m2','m3'}  % histogram matching (target specified)
    pdf    = varargin{1};
    stdfun = @(y)(bsxfun(@(y,i)histeq(y./max(y),pdf),y,1:size(y,2)));
    %stdfun = @(y)(bsxfun(@(y,i)histeq(im2double(y),pdf),y,1:size(y,2)));
  case 'ny'  % nyul standardization
    qout   = varargin{1};
    stdfun = @(y)(bsxfun(@(y,i)nyulstd(y,qout),y,1:size(y,2)));
  otherwise
    error('Unknown standardization type: %s.',type);
end
% apply the transformation
if ~isempty(M)
  Ynt = zeros(size(Yn),class(Yn));
  Ynt(logical(M)) = stdfun(Yn(logical(M)));
else
  Ynt = stdfun(Yn);
end
% clip outliers
if ~strcmp(type,'na')
  Ynt = clip(Ynt,[0,1]);
end



