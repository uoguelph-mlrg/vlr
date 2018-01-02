function [idx] = makeidx(h,c)
idx.c       = c;
idx.i.train = h.cv.i ~= c; % training   (img)
idx.i.valid = h.cv.i == c; % validation (img)
% % special case: osaat
if strcmp(h.name.cv,'osaat')
  idx.i.train = idx.i.train & (h.scan.i == h.scan.i(c));
end
idx.s.train = any(bsxfun(@eq,h.sam.i,find(idx.i.train)'),1); % training   (data)
idx.s.valid = any(bsxfun(@eq,h.sam.i,find(idx.i.valid)'),1); % validation (data)
% special case: no-cv
if strcmp(h.name.cv,'nocv')
  idx.i.train = idx.i.valid;
  idx.s.train = idx.s.valid;
end