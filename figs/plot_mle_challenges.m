function [] = plot_mle_challenges()
% challenge 1: separable classes
Y = [clip(0.25+0.05*randn(32,1),[0.0,0.5]);
     clip(0.75+0.05*randn(32,1),[0.5,1.0])];
C = [0*ones(32,1),1*ones(32,1)];
B{1} = 1e6*[-0.5,1];
B{2} =  50*[-0.5,1];
plotone(Y,C,B,'chmle-sep.eps');

% challenge 2: no lesions
Y = [0.5+0.1*randn(64,1)];
C = [0*ones(64,1)];
B{1} = 1e6*[-100,1];
B{2} = 50*[-0.9,1];
plotone(Y,C,B,'chmle-noles.eps');

function [] = plotone(Y,C,B,name)
figure;
orange = [1.0,0.5,0.0];
plot(0,nan,'color',orange);
lrplot([],[],B{2},'color',blu(1));
lrplot( Y, C,B{1},'color',orange);
legend({'MLE','Desired'},'location','nw','interpreter','latex');
print(gcf,thesisname('fig',name),'-depsc');
close(gcf);