function [] = exp_ystd()
[Y0,C,h,names] = init;
for s = 1:numel(h)
  Y{s} = standardize(Y0,[],h{s}.std.type,h{s}.std.args{:});
  J{1,s} = jsepdiff(Y{s},C);
  J{2,s} = jsepconv(Y{s},C); % long compute time
  statusbar(numel(h),s,h{s}.Ni/3,1);
end
save('D:/DATA/WML/mat/mni96-ystd.mat','h','names','Y','C','J','-v7.3');

function [Y0,C,h,names] = init()
% load the raw data (should be pre-computed)
hraw = hypdef_final;
hraw.std.type  = 'na';
hraw.std.agrs  = {};
hraw.sam.fresh = 0;
hraw.lr.pad    = 0;
hraw = hypfill(hraw);
[~,Y0,C] = gettrainingdata(hraw);
% define the conditions for testing
[h,names] = defhypset('ystd-full');