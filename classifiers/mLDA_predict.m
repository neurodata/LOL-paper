function [Yhat,eta] = mLDA_predict(X,P)
% make predictions using LDA
%
% INPUT:
%   X in R^{n x d}: data matrix where columns are data points
%   P: structure containing all necessary parameters, including
%       InvSig in R^{d x d}: inverse covariance matrix
%       if Ngroups>2
%           mu in R^{d x k}: mean of each of k groups
%           c in R^k: constant for each
%       if Ngroups=2
%           del in R^{d x 1}: mu0-mu1
%           thresh: (lnpi0-lnpi1)/2 in R_+: classification threshold
%           mu  in R^d: overall mean

% Outuput:
%   Yhat in {0,1}^n: vector of predictions
%   eta in R^{n x 1}: vector of magnitudes

if P.Ngroups==2
   eta = P.del'*P.InvSig*X - P.del'*P.InvSig*P.mu - P.thresh;
   Yhat = eta' < 0;
else
    [~,ntest]=size(X);
    l=nan(ntest,P.Ngroups);
    for k=1:P.Ngroups
        l(:,k)=-2*X'*P.InvSig*P.mu(:,k)+P.c(k);
    end
    [~, ymax] = min(l,[],2);
    Yhat=P.groups(ymax);
end
