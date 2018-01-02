% [X] = clip(X,mm);
% 
% CLIP truncates the data in X to the range mm so that no values are outside
%   this range.
% 
% Jesse Knight 2016

function [X] = clip(X,mm)
X = max(mm(1),min(mm(2),X));