function [p] = pmfdef(type)
N = 128;
u = linspace(0,1,N);
switch type
  case 'uniform'
    p = ones(1,N);
  case 'normal'
    p = normpdf(linspace(-4,+4,N));
  case 'rskew'
    p = (  u).^5-(  u).^6;
  case 'lskew'
    p = (1-u).^5-(1-u).^6;
end
p = p ./ sum(p);