function [Yhat ,eta, parms] = PDA_train_and_predict(Xtrain,Ytrain,Xtest,temp)
% PCA projection of data followed by LDA in the projected space
% 
% INPUT
%   Xtrain in R^{D x ntrain}: training predictor matrix
%   Ytrain in {0,1}^n: training predictee vector
%   Xtest in R^{D x ntest}: test predictor matrix
%   temp has 2 options
%       option 1) k in Z: # of dimensions of projection matrix
%       option 2) Proj in R^{d x D}: projection matrix


if isscalar(temp)
    Phat = estimate_parameters(Xtrain,Ytrain,temp);
    Proj = Phat.V;
else
    Proj = temp;
end

Xtilde=Proj*Xtrain;
parms = LDA_train(Xtilde,Ytrain);
[Yhat, eta] = LDA_predict(Proj*Xtest,parms);
