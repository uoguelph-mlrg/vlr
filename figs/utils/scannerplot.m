function [] = scannerplot(h,y,x,leg)
if nargin < 4, leg = 0; end
if ~all(size(x)==size(y))
  x = repmat(x(:)',[size(y,1),1]);
end
hold on;
clr = [];
for s = 1:numel(h.scan.N)
  clr = [clr;monomap(h.scan.clr(s,:),h.scan.N(s),[0,+0.8])];
  if leg
    plot(0,nan,'color',h.scan.clr(s,:))
  end
end
nmax = max(h.scan.N);
NC   = cumsum([0,h.scan.N]);
for n = nmax:-1:1
  for s = 1:numel(h.scan.N)
    if n <= h.scan.N(s)
      i = n + NC(s);
      plot(x(i,:),y(i,:),'color',clr(i,:));
    end
  end
end
% for i = 1:h.Ni
%   plot(x,y(i,:),'color',clr(i,:));
% end
if leg
  legend(h.scan.names,'location',leg,'fontsize',10);
end

