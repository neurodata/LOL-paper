function [Yhat, parms] = mLDA_train_and_predict(Xtrain, Ytrain, Xtest)

parms = mLDA_train(Xtrain,Ytrain);
[Yhat] = mLDA_predict(Xtest,parms);
