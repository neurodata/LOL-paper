clc, clear all

%% generate data
p=1000; % dimensionality
mu=[zeros(p,1), 0.1*ones(p,1)];
Sigma=eye(p);

ntrain=100;
ntest=1000;


[Xtrain,Ytrain,Xtest,Ytest]=gmmsample(mu,Sigma,ntrain,ntest);

% learn projection
[Proj, P] = LOL(Xtrain,Ytrain,{'DENL'},ntrain/2);

% project training data
Xtrain_proj=Proj{1}.V*Xtrain';

% learn classifier
parms = LDA_train(Xtrain_proj,Ytrain);

% project test data
Xtest_proj=Proj{1}.V*Xtest';

% predict test data
[Yhat, eta] = LDA_predict(Xtest_proj,parms);

% compute error
misclassification_rate=sum(Yhat~=Ytest)/ntest

% plot estimated posterior distribution
eta1=eta(Ytest==1);
eta2=eta(Ytest==2);

[count1,centers1]=hist(eta1);
[count2,centers2]=hist(eta2);

figure(1), clf, hold all
plot(centers1,count1), 
plot(centers2,count2)
legend('class 1', 'class 2')




