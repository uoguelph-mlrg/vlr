% SLICESHOW
% Show slices of a volume I at the indices z
% using timshow, with varargin{:} passed directly to timshow

function [ax] = sliceshow(I,z,varargin)
N = numel(z);
mm = [min(I(:)),max(I(:))];
for i = 1:N
  S{i} = squeeze(I(:,:,z(i),:));
end
numstr = num2str(N,'%dx1');
ax = timshow(S{:},numstr,mm,varargin{:});
for i = 1:N
  text(0.05,0.95,num2str(z(i),'%02.f'),...
    'color','w','parent',ax(i),'units','normalized');
end
set(gcf,'inverthardcopy','off');