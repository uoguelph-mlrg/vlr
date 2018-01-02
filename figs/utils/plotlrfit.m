function [Bt,ct,y] = plotlrfit(B,Y,C,lam,alpha,ts,clr)
N = 512;
y = linspace(0,1,N)';
tmin = ts(1);
tmax = ts(end);
cfun = @(B)(1./(1+exp(-(B(1)+B(2)*y))));
hold on;
Bt = {};
if tmin == 0
  co = cfun(B);
  Bt{end+1} = B;
end
for t = 1:tmax
  B = mapupdate(B,Y,C,lam,alpha);
  if t == tmin
    co = cfun(B);
    Bt{end+1} = B;
  end
  ti = find(t==ts(2:end));
  if ti
    ct = cfun(B);
    light = (1-ti/numel(ts))^2;
    fill([y;flipud(y)],[ct;flipud(co)],lighten(clr,light),'edgecolor','none');
    co = ct;
    Bt{end+1} = B;
  end
end
