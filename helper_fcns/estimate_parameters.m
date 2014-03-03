function Phat = estimate_parameters(X,Y,k)
% estimate parameters for high-dimensional discriminant analysis
% 
% INPUT:
%   X in R^{D x n}: predictor matrix
%   Y in {0,1}^n: predictee vector
%   k in R: dimension of projection matrix
% 
% OUTPUT: a structure, Phat, containing
%   mu in R^D: estimated joint mean
%   mu0 in R^D: estimated mean for class 0
%   mu1 in R^D: estimated mean for class 1
%   delta in R^D: estimated difference between class means
%   V in R^{d x D}: truncated eigenvectors

X0 = X(:,Y==0);
X1 = X(:,Y==1);
Xu = X(:,isnan(Y));

Phat.mu = mean(X,2);
Phat.mu0=mean(X0,2);
Phat.mu1=mean(X1,2);
Phat.delta=Phat.mu0-Phat.mu1;

X0=bsxfun(@minus,X,Phat.mu0);
X1=bsxfun(@minus,X,Phat.mu1);
Xu=bsxfun(@minus,X,Phat.mu);

X_centered = [X0,X1,Xu]; %bsxfun(@minus,X,Phat.mu);
[~,Phat.d,V] = svd(X_centered',0);
Phat.V=V(:,1:k)';
