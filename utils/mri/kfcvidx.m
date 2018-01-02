function [idx] = kfcvidx(h,dofig)
if nargin < 2
  dofig = 0;
end
[idx,P] = kfcvexpected(h.scan.N);
if dofig
  makefig(h,P,idx);
end

function [idx,P] = kfcvexpected(N)
% logical: used
for n = 1:numel(N)
  used{n} = false(1,N(n));
end
NN  = numel(N);
idx = cell(1,NN);
CN  = cumsum([0,N]);
P   = N'*N./sum(N);
PW  = floor(P); % first  pass: minimum whole numbers
PE  = P-PW;     % second pass: leftovers
% first pass
for f = 1:NN    % folds
  for s = 1:NN  % scanners
    % add the 
    [idx{f},used{s},Nf(f)] = addn(idx{f},used{s},CN(s),PW(f,s));
  end
end
% second pass
[~,so] = sort(PE(:),'descend');
for i = 1:NN^2
  % try to add biggest gap in probability from scanner s to fold f
  [f,s]  = ind2sub([NN,NN],so(i));
  if Nf(f) ~= N(f) % if this fold is not complete
    [idx{f},used{s},Nf(f)] = addn(idx{f},used{s},CN(s),1); % add
  end
end

function [idxf,useds,nf] = addn(idxf,useds,c,n)
if n
  toadd = find(~useds,n,'first');
  useds(toadd) = true;
  idxf = [idxf,toadd+c];
end
nf = numel(idxf);

function [] = makefig(h,P,idx)
% compute the number of images from each scanner in each fold
CN = cumsum([0,h.scan.N]);
NN = numel(h.scan.N);
Xi = nan(3*NN,NN);
Xp = nan(3*NN,NN);
for f = 1:NN
  Xi(3*f-1,:) = arrayfun(@(i)sum(idx{i}>CN(f) & idx{i}<=CN(f+1)),1:NN);
end
Xp(1:3:3*f,:) = P;
% plot the results:
hold on;
bar(Xi,'stacked');
b = bar(Xp,'stacked');
for s = 1:NN
  b(s).FaceColor = lighten(h.scan.clr(s,:),0.5);
end
set(gca,'xtick',3*(1:NN)-1.5,'xticklabel',[1:NN],'xlim',[0,3*NN]);
figresize(gcf,[1000,500]);
legend(h.scan.names,'location','bestoutside');
tightsubs(1,1,gca,0.05*[2,3,6,1]);
xlabel('Fold','interpreter','latex');
ylabel('Scanner Composition','interpreter','latex');
print(gcf,thesisname('fig','bar-kfcv.eps'),'-depsc');
close(gcf);

