function [Yhat, Phat] = QDA_train_and_predict(Xtrain, Ytrain, Xtest)


Phat = QDA_train(Xtrain,Ytrain);
Yhat = QDA_predict(Xtest,Phat);
