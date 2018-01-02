function [J,YS,CS] = jsepdiff(Y,C)
[YS,s] = sort(Y,2);
CS = zeros(size(C));
for i = 1:size(Y,1)
  CS(i,:) = C(i,s(i,:));
end
J = sum(abs(diff(CS,[],2)),2);


