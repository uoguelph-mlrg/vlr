% BOXPLOTN
% Box plot with coloured grouping.
% X is a cell array. size: [bins, groups]
% cmap must have size [groups,3]
% blabs must be a cell array of bins labels

function boxplotn(X0,cmap,blabs,varargin)
NB = size(X0,1);
NC = size(X0,2);
X = []; G = []; C = [];
for b = 1:NB
  for c = 1:NC
    Xi = X0{b,c}(:);
    X  = [X;Xi];
    G  = [G;((b-1)*NC+c)*ones(size(Xi))];
    C  = [C;c];
  end
end
if nargin < 2, cmap  = jet(NC); end
if nargin < 3, blabs = 1:NB;    end
wb = 1;
wi = 1.2*wb;
wo = 2  *wb;
x  = wi.*[1:NB*NC] + (wo-wi).*ceil([1:NB*NC]./NC);
t  = cat(1,arrayfun(@(i)mean(x(NC*(i-1)+1:NC*(i))),1:NB));
boxplot(X(:),G(:),'width',wb,'position',x,varargin{:},'color',cmap(C(:),:),'symbol','+');
set(gca,'xtick',t,'xticklabel',blabs);

