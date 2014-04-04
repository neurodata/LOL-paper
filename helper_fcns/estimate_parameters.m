function P = estimate_parameters(X,Y,k)
% estimate parameters for high-dimensional discriminant analysis
%
% INPUT:
%   X in R^{D x n}: predictor matrix
%   Y in {0,1}^n: predictee vector
%   k in R: dimension of projection matrix
%
% OUTPUT: a structure, P, containing
%   mu in R^D: estimated joint mean
%   mu0 in R^D: estimated mean for class 0
%   mu1 in R^D: estimated mean for class 1
%   delta in R^D: estimated difference between class means
%   V in R^{d x D}: truncated eigenvectors

P.groups=unique(Y);
P.Ngroups=length(P.groups);

X0 = X(:,Y==0);
X1 = X(:,Y==1);
Xu = X(:,isnan(Y));

P.mu = mean(X,2);
P.mu0=mean(X0,2);
P.mu1=mean(X1,2);
P.muu=mean(Xu,2);
P.delta=P.mu0-P.mu1;

X0=bsxfun(@minus,X0,P.mu0);
X1=bsxfun(@minus,X1,P.mu1);
Xu=bsxfun(@minus,Xu,P.muu);
X_centered = [X0,X1,Xu]; %bsxfun(@minus,X,P.mu);

[D,n]=size(X_centered);
if D>n
    [V,P.d,~] = svd(X_centered,0);
else
    [~,P.d,V] = svd(X_centered',0);
end
P.V=V(:,1:k)';

% P.rdelta=trimmean([X0,-X1],10);
% P.sdelta=P.delta;
% if D>nl
%     t=quantile(abs(P.delta),sqrt(nl/D));
% else
%     t=quantile(abs(P.delta),.9);
% end
% P.sdelta(abs(P.sdelta)<t)=0;
% P.sdelta(abs(P.sdelta)<0.95*max(abs(P.sdelta)))=0;

