function [] = exp_hyp(h)
for k = 1:numel(h)
  try
    arbiter(h{k});
  catch ME
    statusupdate();
    warning(ME.getReport);
    statusupdate();
    statusupdate('(!) ABORTING ...'); statusupdate();
    statusupdate(80); statusupdate();
  end
end




