function Lhat = misclass(Yhat,Ytest)

Lhat = sum(Yhat~=repmat(Ytest,1,size(Yhat,2)))/length(Ytest);