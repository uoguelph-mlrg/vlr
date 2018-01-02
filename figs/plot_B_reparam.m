function [] = plot_B_reparam()
% vary threshold (t)
B{1} = 16*[-0.4,1.0];
B{2} = 16*[-0.5,1.0];
B{3} = 16*[-0.6,1.0];
leg  = {'$\tau=0.4$','$\tau=0.5$','$\tau=0.6$'};
plotone(B,leg,'reparam-t.eps');

% vary sensitivity (s)
B{1} =  8*[-0.5,1];
B{2} = 16*[-0.5,1];
B{3} = 32*[-0.5,1];
leg  = {'$s=8$','$s=16$','$s=32$'};
plotone(B,leg,'reparam-s.eps');

% vary b0
B{1} = 16*[-0.4,1.0];
B{2} = 16*[-0.5,1.0];
B{3} = 16*[-0.6,1.0];
leg  = {'$\beta^0=12$','$\beta^0=16$','$\beta^0=20$'};
plotone(B,leg,'reparam-b0.eps');

% vary b1
B{1} = [-6,9];
B{2} = [-6,12];
B{3} = [-6,16];
leg  = {'$\beta^1=9$','$\beta^1=12$','$\beta^1=16$'};
plotone(B,leg,'reparam-b1.eps');

function [] = plotone(B,leg,name)
figure;
cmap = monomap(blu(1),3,[-0.5,0.5]);
lrplot([],[],B{1},'color',cmap(1,:));
lrplot([],[],B{2},'color',cmap(2,:));
lrplot([],[],B{3},'color',cmap(3,:));
legend(leg,'location','nw','interpreter','latex');
print(gcf,thesisname('fig',name),'-depsc');
close(gcf);