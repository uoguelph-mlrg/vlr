% HYPDEF_BASELINE(h)
% This function defines all model hyperparameters for the segmentation pipeline.
% Default values shown.
% Some shorthands used here are expanded by hypfill.
% EXP: baseline
% DO NOT EDIT!

function [h] = hypdef_baseline(h)
% flag-like names
h.name.key    = 'e-base';  % h.name.key     = 'LPA';
h.name.data   = 'mni96';   % h.name.data    = 'mni109';
h.name.cv     = 'loso';    % h.name.cv      = 'nocv';
% scanner parameters
h.cmap        = inferno;
h.Ni          = [];
h.scan.idx    = [1,2,3,4,5,6,9]; % h.scan.idx    = [1,2,3,4,5,6,9,7,8,10];
h.scan.clr    = rainbow7;        % h.scan.clr    = rainbow10;
% sampling parameters
h.sam.fresh   = 1;
h.sam.resize  = 0.5;
h.sam.dx      = [0,0,0];
h.sam.flip    = 0;
% grey standardization parameters
h.std.type    = 'm3';
h.std.args    = {pmfdef('lskew')};
% logistic regression parameters
h.lr.Nit      = 30;
h.lr.B        = [0,0];
h.lr.alpha    = 1;
h.lr.reg.la   = 0;
h.lr.reg.py   = [];
h.lr.reg.pc   = [];
h.lr.pad      = [-1.5;1];
h.lr.pp.filter= @(B)(B);
% post processing parameters
h.pp.saveles  = 'les';
h.pp.thr.def  = 0.5;
h.pp.thr.Nit  = 30;
h.pp.minmm3   = 5;
% cross validation and scanner
h = hypfill(h);

