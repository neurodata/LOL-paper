function [Yhat, eta, Proj] = RDA_train_and_predict(Xtrain, Ytrain, Xtest, k)
% trains and predicts Random projection LDA
% 
% INPUT
%   Xtrain in R^{D x ntrain}: training predictor matrix
%   Ytrain in {0,1}^n: training predictee vector
%   Xtest in R^{D x ntest}: test predictor matrix
%   k in Z: # of dimensions of projection matrix

[D,~]=size(Xtrain);
Proj = randn(k,D);
Xtilde=Proj*Xtrain;
parms = LDA_train(Xtilde,Ytrain);
[Yhat, eta] = LDA_predict(Proj*Xtest,parms);
