function [Yhat, eta, parms] = LDA_train_and_predict(Xtrain, Ytrain, Xtest)

parms = LDA_train(Xtrain,Ytrain);
[Yhat, eta] = LDA_predict(Xtest,parms);
