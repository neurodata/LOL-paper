function Phat = QOQ_train(X,Y,delta,k)
% train Quadratic Low Rank Quadratic Discriminant Analysis Classifier
% 
% INPUT:
%   X \in R^{D x n}: predictor matrix
%   Y \in R^n: predictee vector
%   delta \in R^D: difference of means
%   k: projection matrix dimension
% 
% OUTPUT: a structure Phat with the following fields
%   mu0 \in R^d: empirical mean of class 0
%   mu1 \in R^d: empirical mean of class 1
%   Sig0 \in R^dxd: empirical covariance of class 0
%   Sig1 \in R^dxd: empirical covariance of class 1
%   invSig0 \in R^dxd: empirical inverse covariance of class 0
%   invSig1 \in R^dxd: empirical inverse covariance of class 1


mu0 = mean(X(:,Y==0),2);
X0_centered = bsxfun(@minus,X(:,Y==0),mu0);

mu1 = mean(X(:,Y==1),2);
X1_centered = bsxfun(@minus,X(:,Y==1),mu1);

[~,d0,V0] = svd(X0_centered',0);
[~,d1,V1] = svd(X1_centered',0);

d0=diag(d0); d1=diag(d1);
dd=[d0; d1];
[~, idx]=sort(dd,'descend');

VV=[V0,V1];
if k<length(idx), idx(k+1:end)=[]; end
V=[delta, VV(:,idx(1:end-1))];
[V_QOL, ~] = qr(V,0);           
Phat.Proj = V_QOL';

features = Phat.Proj*X;

features0 = features(:,Y==0);
features1 = features(:,Y==1);

Phat.mu0 = mean(features0,2);
Phat.mu1 = mean(features1,2);

Phat.Sig0 = cov(features0');
Phat.Sig1 = cov(features1');

Phat.invSig0=pinv(Phat.Sig0);
Phat.invSig1=pinv(Phat.Sig1);


Phat.pi1 = sum(Y)/length(Y);
Phat.pi0 = 1 - Phat.pi1;