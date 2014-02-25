function [Yhat, eta, Proj] = LOL_train_and_predict(Xtrain, Ytrain, Xtest, varargin)
% trains and predicts Low-rank Optimal projection LDA
% 
% INPUT
%   Xtrain in R^{D x ntrain}: training predictor matrix
%   Ytrain in {0,1}^n: training predictee vector
%   Xtest in R^{D x ntest}: test predictor matrix
%   varargin has 2 options
%       option 1) input only dimension and estimate parameters
%           k in Z: # of dimensions of projection matrix
%       option 2) 
%           delta in R^D: difference of means
%           V in R^{d x D}: projection matrix

if nargin==4
    Phat = estimate_parameters(Xtrain,Ytrain,varargin{1});
    delta = Phat.delta;
    V = Phat.V;
else
    delta = varargin{1};
    V = varargin{2};
end

Proj = LOL_train(Xtrain,Ytrain,delta,V);
Xtilde=Proj*Xtrain;
parms = LDA_train(Xtilde,Ytrain);
[Yhat, eta] = LDA_predict(Proj*Xtest,parms);
