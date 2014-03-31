function Phat = QDA_train(X,Y)
% learns all the parameters necessary for QDA
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

X0 = X(:,Y==0);
Phat.mu0 = mean(X0,2);
X0=bsxfun(@minus,X0,Phat.mu0);
Phat.InvSig0 = inverse_covariance(X0);

X1 = X(:,Y==1);
Phat.mu1 = mean(X1,2);
X1=bsxfun(@minus,X1,Phat.mu1);
Phat.InvSig1 = inverse_covariance(X1);

Phat.a0= -0.5*logdet(cov(X0'))+lnpi0;
Phat.a1= -0.5*logdet(cov(X1'))+lnpi1;

