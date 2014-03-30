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
X1 = X(:,Y==1);

Phat.mu0 = mean(X0,2);
Phat.mu1 = mean(X1,2);

X0=bsxfun(@minus,X0,Phat.mu0);
[u0,d0,~] = svd(X0,0);
s0 = diag(d0);                        % find min singular value for numerical stability
tol0 = max(size(X0)) * eps(max(s0));
r0 = sum(s0 > tol0);
dd0=d0(1:r0,1:r0);
L0 = u0(:,1:r0)/dd0;
Phat.InvSig0 = (L0*L0')*n0;         % useful for classification via LDA

X1=bsxfun(@minus,X1,Phat.mu1);
[u1,d1,~] = svd(X1,0);
s1 = diag(d1);                        % find min singular value for numerical stability
tol1 = max(size(X1)) * eps(max(s1));
r1 = sum(s1 > tol1);
dd1=d1(1:r1,1:r1);
L1 = u1(:,1:r1)/dd1;
Phat.InvSig1 = (L1*L1')*n1;         % useful for classification via LDA

% Sigma0 = cov(X0');
% InvSig0 = pinv(Sigma0);             
% 
% Sigma1 = cov(X1'); 
% InvSig1 = pinv(Sigma1);             


Phat.a0= -0.5*logdet(cov(X0'))+lnpi0;
Phat.a1= -0.5*logdet(cov(X1'))+lnpi1;

