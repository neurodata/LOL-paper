function [Yhat, eta, Proj] = LOL_train_and_predict(Xtrain, Ytrain, Xtest, varargin)

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
