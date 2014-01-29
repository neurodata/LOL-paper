function [Z,Proj,Phat,task] = embed_data(Z,task)

% estimate parameters and projection matrices
k_max=min(task.ntrain,min(task.D,task.Kmax));
[Proj, Phat] = estimate_projections(Z.Xtrain,Z.Ytrain,k_max,task.algs);

% generate and project test data onto subspace
Xtrain_centered = bsxfun(@minus,Z.Xtrain,Phat.mu);
Xtest_centered = bsxfun(@minus,Z.Xtest,Phat.mu);
for i=1:length(task.algs)
    Z.Xtrain_proj{i}=Proj{i}.Vhat*Xtrain_centered;
    Z.Xtest_proj{i}=Proj{i}.Vhat*Xtest_centered;
end

task.ks=task.ks(task.ks<=k_max);
task.Nks=length(task.ks);
task.Kmax=max(task.ks);

