function Phat = LDA_train(X,Y)
% learns all the parameters necessary for LDA
% note that this function supports semi-supervised learning via encoding
% NaN's into Y
% 
% INPUT:
%   X in R^{D x n}: predictor matrix
%   Y in {0,1,NaN}^n: predictee matrix
% 
% OUTPUT: Phat, a structure of parameters 

n0=sum(Y==0);
n1=sum(Y==1);
n=n0+n1;

lnpi0 = log(n0/n);
lnpi1 = log(n1/n);

Phat.thresh = (lnpi0-lnpi1)/2;    % useful for classification via LDA

X0 = X(:,Y==0);
X1 = X(:,Y==1);

mu0 = mean(X0,2);
mu1 = mean(X1,2);

Phat.mu = (mu0+mu1)/2;            % useful for classification via LDA 
Phat.del = (mu0-mu1);             % useful for classification via LDA

X0=bsxfun(@minus,X0,mu0);
X1=bsxfun(@minus,X1,mu1);
X_centered = [X0,X1]; 

[u,d,~] = svd(X_centered,0);
s = diag(d);                        % find min singular value for numerical stability
tol = max(size(X_centered)) * eps(max(s));
r = sum(s > tol);
dd=d(1:r,1:r);
L = u(:,1:r)/dd;
Phat.InvSig = (L*L')*n;         % useful for classification via LDA


