function [Yhat, eta, Proj] = QOL_train_and_predict(Xtrain, Ytrain, Xtest, delta,k)
% trains and predicts Quadratic Low-rank Optimal projection LDA
% 
% INPUT
%   Xtrain in R^{D x ntrain}: training predictor matrix
%   Ytrain in {0,1}^n: training predictee vector
%   Xtest in R^{D x ntest}: test predictor matrix
%   delta in R^D: difference of means
%   k in Z: # of dimensions of projection matrix
% 
% OUTPUT
%   Yhat in {0,1}^ntest: vector of test predictions
%   eta in R^ntest: vector of predictions after projecting on discriminant
%                   plane, prior to thresholding
%   Proj in R^{k x D}: projection matrix

Proj = QOL_train(Xtrain,Ytrain,delta,k);
Xtilde=Proj*Xtrain;
parms = LDA_train(Xtilde,Ytrain);
[Yhat, eta] = LDA_predict(Proj*Xtest,parms);
