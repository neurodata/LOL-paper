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

Phat.mu = mean(X,2);
Phat.mu0=mean(X(:,Y==0),2);
Phat.mu1=mean(X(:,Y==1),2);
Phat.delta=Phat.mu0-Phat.mu1;
X_centered = bsxfun(@minus,X,Phat.mu);
[~,Phat.d,V] = svd(X_centered',0);
Phat.V=V(:,1:k)';
