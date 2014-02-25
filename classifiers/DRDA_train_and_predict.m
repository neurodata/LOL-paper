function [Yhat, eta, parms] = DRDA_train_and_predict(Xtrain,Ytrain,Xtest,delta,k)

D = size(Xtrain,1);
[V_LOL, ~] = qr([delta';randn(D,k-1)']',0);           
Proj = V_LOL';

Xtilde=Proj*Xtrain;
parms = LDA_train(Xtilde,Ytrain);
[Yhat, eta] = LDA_predict(Proj*Xtest,parms);
