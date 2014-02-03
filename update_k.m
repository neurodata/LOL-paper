function task = update_k(task)
% update set of dimensions to embed into based on characteristics of the
% training dataset

% estimate parameters and projection matrices
k_max=min(task.ntrain,min(task.D,task.Kmax));
task.ks=task.ks(task.ks<=k_max);
task.Nks=length(task.ks);
task.Kmax=max(task.ks);

