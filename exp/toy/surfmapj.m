function [] = surfmapj(Y,C,lam,clim)
blim = [-50,+10;-10,+50];
B0 = linspace(blim(1,1),blim(1,2),512);
B1 = linspace(blim(2,1),blim(2,2),512);
% sample the objective surface
jmin = -inf;
for b0 = 1:numel(B0)
  for b1 = 1:numel(B1)
    eta = B0(b0) + B1(b1)*Y;
    J(b0,b1) = sum(C.*eta - log(1+exp(eta))) - lam.*sqrt(B0(b0)^2+B1(b1)^2);
    if J(b0,b1) > jmin 
      B0i = B0(b0);
      B1i = B1(b1);
      jmin = J(b0,b1);
    end
  end
end
% render surface
cla; hold on;
imagesc(B0,B1,exp(J'));
plot3([0,0],blim(2,:),[100,100],'-','linewidth',1,'markersize',10,'color',lighten(blu(1),0.3));
plot3(blim(1,:),[0,0],[100,100],'-','linewidth',1,'markersize',10,'color',lighten(blu(1),0.3));
plot3(B0i,B1i,100,'p','linewidth',2,'markersize',10,'color',lighten(blu(1),0.3)); % optimal
xlabel('$\beta_0$','interpreter','latex');
ylabel('$\beta_1$','interpreter','latex');
axis('equal');
xlim(blim(1,:))
ylim(blim(2,:))
set(gca,'xtick',linspace(blim(1,1),blim(1,2),4),...
        'ytick',linspace(blim(2,1),blim(2,2),4));
if nargin > 3
  set(gca,'clim',clim);
end
colormap(inferno);
tightsubs(1,1,gca,0.05*[3,3,2,1]);
colorbar;
figresize(gcf,[600,500]);



   



