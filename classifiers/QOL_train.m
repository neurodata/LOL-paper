function [Proj, W, d0, d1] = QOL_train(X,Y,delta,k)
% train Quadratic Low Rank Linear Discriminant Analysis Classifier
% 
% INPUT:
%   X \in R^{D x n}: predictor matrix
%   Y \in R^n: predictee vector
%   delta \in R^D: difference of means
%   k: projection matrix dimension
% 
% OUTPUT:
%   Proj \in R^{d x D}: projection matrix
%   W \in R^{2 x D}: linear classifier projector
%   d0 \in R^min(n,D): eigenvalues of class 0
%   d1 \in R^min(n,D): eigenvalues of class 1

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
Proj = V_QOL';

features = Proj*X;
W = LDA_train(features',Y);       % estimate LDA discriminating boundary from training data
