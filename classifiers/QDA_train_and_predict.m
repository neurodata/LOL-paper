function [Yhat, eta, parms] = QDA_train_and_predict(Xtrain, Ytrain, Xtest)

parms = QDA_train(Xtrain,Ytrain);
[Yhat, eta] = QDA_predict(Xtest,parms);
