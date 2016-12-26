function Lhat = misclass(Yhat,Ytest)

Lhat = sum(Yhat~=Ytest)/length(Ytest);