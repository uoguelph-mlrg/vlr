function [] = plot_converge()
% define the hyperparameters
h = hypdef_final;
h.name.cv   = 'nocv';
h.sam.fresh = 0;
h = hypfill(h);
% load the training data
[h,Y,C] = gettrainingdata(h);
ivec = true([1,size(Y,2)]);
idx.i.train = ivec;
idx.s.train = ivec;
idx.i.valid = ivec;
idx.s.valid = ivec;
[Y,C,idx] = dataregfun(h.lr.reg.py,h.lr.reg.pc,Y,C,idx);
[b,db] = vlrmap(h, Y(:,idx.s.train), C(:,idx.s.train));
% plot the quantiles of dB vs iterations
for b = 1:2
  plotone(squeeze(db(:,b,:)),b);
end

function [] = plotone(db,b)
qvec = 0.00:0.05:1.00;
clr  = flipud(monomap(red(1),numel(qvec),[-0.8,+0.8]));
qdb  = quantile(abs(db),qvec)';
figure;
hold on;
for q = 1:numel(qvec)
  plot(qdb(:,q),'color',clr(q,:));
end
ylabel(['Upate magnitude $\left|\Delta\beta^',num2str(b-1),'\right|$'],'interpreter','latex');
xlabel('Iteration $(t)$','interpreter','latex');
set(gca,'xtick',[0:5:size(db,2)]);
tightsubs(1,1,gca,0.05*[3,3,1,1]);
print(thesisname('fig','seg',['converge-b',num2str(b-1),'.eps']),'-depsc');
close(gcf);