% HYPDEF(h)
% This function defines all model hyperparameters for the segmentation pipeline.
% This version (vs _final and _baseline) is for experimenting with parameters.
% Some shorthands used here are expanded by hypfill.

function [h] = hypdef(h)
% flag-like names
h.name.key    = 'test'; % h.name.key     = 'LPA';
h.name.data   = 'mni96';     % h.name.data    = 'mni109';
h.name.cv     = 'loso';      % h.name.cv      = 'nocv';
% scanner parameters
h.cmap        = inferno;
h.Ni          = [];
h.scan.idx    = [1,2,3,4,5,6,9]; % h.scan.idx    = [1,2,3,4,5,6,9,7,8,10];
h.scan.clr    = rainbow7;        % h.scan.clr    = rainbow10;
% sampling parameters
h.sam.fresh   = 0;
h.sam.resize  = 0.5;
h.sam.dx      = kernelshifts(binsphere(1));
h.sam.flip    = 1;
% grey standardization parameters
h.std.type    = 'm3';
h.std.args    = {pmfdef('lskew')};
% logistic regression parameters
h.lr.Nit      = 30;
h.lr.B        = [0,0];
h.lr.alpha    = 1;
h.lr.reg.la   = 1e-3;
h.lr.reg.py   = [1];
h.lr.reg.pc   = [1];
h.lr.pad      = [-20,20];%[-1.5;1];
h.lr.pp.filter= @(B)(gaussfilter(B,[2,2,2]));
% post processing parameters
h.pp.saveles  = 'test';
h.pp.thr.def  = 0.5;
h.pp.thr.Nit  = 30;
h.pp.minmm3   = 5;
% cross validation and scanner
h = hypfill(h);

