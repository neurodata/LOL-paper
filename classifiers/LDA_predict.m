function [Yhat, eta] = LDA_predict(X,Phat)
% make predictions using LDA
% 
% INPUT:
%   X in R^{n x d}: data matrix where columns are data points
%   Phat: structure containing all necessary parameters, including
%       InvSig in R^{d x d}: inverse covariance matrix
%       del in R^{d x 1}: mu0-mu1
%       mu in R^{d x 1}: (mu0+mu1)/2
%       lnpi0 in R_+: class 0 prior
%       lnpi1 in R_+: class 1 prior
% 
% Outuput:
% 
%   Yhat in {0,1}^n: vector of predictions
%   eta in R^{n x 1}: vector of magnitudes

eta = Phat.del'*Phat.InvSig*X -Phat.del'*Phat.InvSig*Phat.mu - (Phat.lnpi0-Phat.lnpi1)/2;
Yhat = eta' < 0;
