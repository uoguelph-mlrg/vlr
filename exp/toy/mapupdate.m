% MAPUPDATE(Y,C)
% This function computes the map update for a given B, Y, C, lam combination
% for one voxel data (not in parallel).

function [B] = mapupdate(B,Y,C,lam,alpha)
Y = Y(:)';
C = C(:)';
% transform the features by the class
Y1 = [ones(size(Y));Y];
Y1(:,~C) = -Y1(:,~C);
% compute the update
s1 = 1./(1+exp(B'*Y1));
a  = s1.*(1-s1);
g  = Y1*s1' - (lam.*[0,1])*B; % lam
H  = (Y1.*[a;a])*Y1' + lam*[0,0;0,1]; % lam
togglewarnings('off');
dB = H\g;
togglewarnings('on');
% apply the update
B  = B + alpha*dB;

function [] = togglewarnings(onoff)
% supress annoying msg in known bad scenarios
warning(onoff,'MATLAB:illConditionedMatrix');
warning(onoff,'MATLAB:singularMatrix');
warning(onoff,'MATLAB:nearlySingularMatrix');
warning(onoff,'MATLAB:legend:IgnoringExtraEntries');
