% DARKEN
% darken the clr by factor f \in [0,1]
function [clr] = darken(clr,f)
clr = clr.*(1-f);