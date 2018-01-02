% LIGHTEN
% lighten the clr by factor f \in [0,1]
function [clr] = lighten(clr,f)
clr = 1-((1-clr).*(1-f));