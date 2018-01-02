% DATAREGFUN
% This function adds pseudo-lesions to the training data,
% and updates the CV indexes appropriately.

function[Y,C,idx] = dataregfun(py,pc,Y,C,idx)
assert(all(size(py)==size(pc)),'Pseudo Data Y and C must have the same size!');
% re-assign all C -> 0 if Y is less than mean {Y|C==0}
for i = 1:size(Y,1)
  C(i,Y(i,:)<mean(Y(i,C(i,:)<0.5))) = 0;
end
% append the pseudo-data
np = numel(py);
if all(size(py)) % make sure not empty
  for p = 1:np
    Y(:,end+1) = py(p);
    C(:,end+1) = pc(p);
  end
  idx.s.train = [idx.s.train, true(1,np)];
  idx.s.valid = [idx.s.valid,false(1,np)];
end