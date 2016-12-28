function [Xtrain,Ytrain,Xtest,Ytest] = gmmsample(mu,Sigma,n,ntest)

% sample data
K=size(mu,2); % # of classes
gmm = gmdistribution(mu',Sigma,1/K*ones(K,1));
[Xtrain,Ytrain] = random(gmm,n);
[Xtest,Ytest] = random(gmm,ntest);
