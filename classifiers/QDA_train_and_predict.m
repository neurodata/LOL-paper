function [Yhat] = QDA_train_and_predict(Xtrain, Ytrain, Xtest)

% Bayes optimal under QDA model
X0 = Xtrain(:,Ytrain==0);
X1 = Xtrain(:,Ytrain==1);
ntrain = size(Ytrain,2);
ntest = size(Xtest,2);
Yhat=nan(ntest, 1);

pihat = sum(Ytrain)/ntrain;
lnp1=log(1-pihat);
lnp0=log(pihat);

Phat.mu0 = mean(X0,2);
Phat.mu1 = mean(X1,2);
Phat.Sigma0 = cov(X0');
Phat.Sigma1 = cov(X1'); 
Phat.InvSig0 = pinv(Phat.Sigma0);
Phat.InvSig1 = pinv(Phat.Sigma1);

Phat.a1= -0.5*logdet(Phat.Sigma1)+lnp1;
Phat.a0= -0.5*logdet(Phat.Sigma0)+lnp0;

Phat.d1 = bsxfun(@minus,Phat.mu1,Xtest);
Phat.d0 = bsxfun(@minus,Phat.mu0,Xtest);

for mm=1:ntest
    l1=-0.5*Phat.d1(:,mm)'*Phat.InvSig1* Phat.d1(:,mm)-Phat.a1;
    l0=-0.5*Phat.d0(:,mm)'*Phat.InvSig0* Phat.d0(:,mm)-Phat.a0;
    Yhat(mm)= l1 > l0;
end

% parms = QDA_train(Xtrain,Ytrain);
% [Yhat, eta] = QDA_predict(Xtest,parms);
