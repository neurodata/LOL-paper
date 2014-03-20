function [Yhat, eta] = QDA_predict(X,P)
% make predictions using QDA
% 
% INPUT:
%   X in R^{n x d}: data matrix where columns are data points
%   P: structure containing all necessary parameters, including
%       InvSig in R^{d x d}: inverse covariance matrix
%       del in R^{d x 1}: mu0-mu1
%       mu in R^{d x 1}: (mu0+mu1)/2
%       thresh: (lnpi0-lnpi1)/2 in R_+: classification threshold
% 
% Outuput:
%   Yhat in {0,1}^n: vector of predictions
%   eta in R^{n x 1}: vector of magnitudes

eta = P.del'*P.InvSig0*X -P.del'*P.InvSig1*P.mu - P.thresh;
Yhat = eta' < 0;
