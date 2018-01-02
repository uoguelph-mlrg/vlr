function [J,P,Pmin] = jsepconv(Y,C)
makefig = 1;
cthr = 70;
N = 128;
w = 0.03;
u = linspace(0-2*w,1+2*w,N);
C = C >= 0.5;
P{1} = zeros(size(Y,1),N);
P{2} = zeros(size(Y,1),N);
if makefig
  k = 0; clr{1} = blu(500); clr{2} = red(500);
end
for i = 1:size(Y,1)
  if any(C(i,:))
    %P{1}(i,:) = ksdensity(Y(i,~C(i,:)),u,'width',0.1);
    %P{2}(i,:) = ksdensity(Y(i, C(i,:)),u,'width',0.1);
    P{1}(i,:) = ksd(Y(i,~C(i,:)),u,@normal,w).*sum(~C(i,:));
    P{2}(i,:) = ksd(Y(i, C(i,:)),u,@normal,w).*sum( C(i,:));
    if makefig && sum(C(i,:)) >= cthr
      hold on;
      k = k + 1;
      plot(linspace(0,1,N),P{1}(i,:),'color',clr{1}(k,:));
      plot(linspace(0,1,N),P{2}(i,:),'color',clr{2}(k,:));
      drawnow;
    end
  end
  %statusbar(size(Y,1),i,96/3,1);
end
Pmax = max(cat(3,P{1},P{2}),[],3);
Pmin = min(cat(3,P{1},P{2}),[],3);
P = {P{1},P{2}};
J = sum(Pmin,2)./sum(Pmax,2);
J(isnan(J)) = 0;
% J1 = Pmin./Pmax;
% J1(isnan(J1)) = 0;
% J = mean(J1,2);



