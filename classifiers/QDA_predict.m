function [Yhat] = QDA_predict(X,P)
% make predictions using QDA
% 
% INPUT:
%   X in R^{n x d}: data matrix where columns are data points
%   P: structure containing all necessary parameters, including
% 
% OUTPUT: Yhat in {0,1}^n: vector of predictions

[~,n]=size(X);

d1 = bsxfun(@minus,P.mu1,X);
d0 = bsxfun(@minus,P.mu0,X);

Yhat=nan(n,1);
for i=1:n
    l1=-0.5*d1(:,i)'*P.InvSig1* d1(:,i)-P.a1;
    l0=-0.5*d0(:,i)'*P.InvSig0* d0(:,i)-P.a0;
    Yhat(i)= l1 > l0;
end

