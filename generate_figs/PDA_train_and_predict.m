function [Yhat ,eta, parms] = PDA_train_and_predict(Xtrain,Ytrain,Xtest,temp)


if isscalar(temp)
    Phat = estimate_parameters(Xtrain,Ytrain,temp);
    Proj = Phat.V;
else
    Proj = temp;
end

Xtilde=Proj*Xtrain;
parms = LDA_train(Xtilde,Ytrain);
[Yhat, eta] = LDA_predict(Proj*Xtest,parms);
