function [Z,Proj,Phat,dataset] = embed_data(Z,dataset)

% estimate parameters and projection matrices
k_max=min(dataset.ntrain,min(dataset.D,dataset.Kmax));
[Proj, Phat] = estimate_projections(Z.Xtrain,Z.Ytrain,k_max,dataset.algs);

% generate and project test data onto subspace
Xtrain_centered = bsxfun(@minus,Z.Xtrain,Phat.mu);
Xtest_centered = bsxfun(@minus,Z.Xtest,Phat.mu);
for i=1:length(dataset.algs)
    Z.Xtrain_proj{i}=Proj{i}.Vhat*Xtrain_centered;
    Z.Xtest_proj{i}=Proj{i}.Vhat*Xtest_centered;
end

dataset.ks=dataset.ks(dataset.ks<=k_max);
dataset.Nks=length(dataset.ks);
dataset.Kmax=max(dataset.ks);

