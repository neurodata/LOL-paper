function [Z,Proj,Phat] = embed_data(Z,task)

% estimate parameters and projection matrices
[Proj, Phat] = estimate_projections(Z.Xtrain,Z.Ytrain,task.Kmax,task.algs);

% generate and project test data onto subspace
Xtrain_centered = bsxfun(@minus,Z.Xtrain,Phat.mu);
Xtest_centered = bsxfun(@minus,Z.Xtest,Phat.mu);
for i=1:length(task.algs)
    Z.Xtrain_proj{i}=Proj{i}.Vhat*Xtrain_centered;
    Z.Xtest_proj{i}=Proj{i}.Vhat*Xtest_centered;
end