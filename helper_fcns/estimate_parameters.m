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
Phat.muu=mean(Xu,2);
Phat.delta=Phat.mu0-Phat.mu1;

% Phat.rdelta=trimmean([X0,-X1],10);
% Phat.sdelta=Phat.delta;
% if D>nl
%     t=quantile(abs(Phat.delta),sqrt(nl/D));
% else
%     t=quantile(abs(Phat.delta),.9);
% end
% Phat.sdelta(abs(Phat.sdelta)<t)=0;
% Phat.sdelta(abs(Phat.sdelta)<0.95*max(abs(Phat.sdelta)))=0;


X0=bsxfun(@minus,X0,Phat.mu0);
X1=bsxfun(@minus,X1,Phat.mu1);
Xu=bsxfun(@minus,Xu,Phat.muu);
X_centered = [X0,X1,Xu]; %bsxfun(@minus,X,Phat.mu);

[D,n]=size(X_centered);

if D>n
    [V,Phat.d,~] = svd(X_centered,0);
else
    [~,Phat.d,V] = svd(X_centered',0);
end
Phat.V=V(:,1:k)';
