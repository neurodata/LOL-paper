function [Xtrain,Ytrain,Xtest,Ytest] = outliers(D,ntrain,ntest)


%% model parameters
d=round(D/10);
noise=0.1;
offset=0.5;
V=orth(rand(D,d));

%% sample training data
Ninlier=ntrain/2;
n0=Ninlier/2;
n1=n0;
Noutlier=ntrain-Ninlier;

X0=randn(n0,d)*V';
X1=randn(n1,d)*V'+offset;
X=[X0;X1; randn(Noutlier,D)];
Xtrain=X+randn(size(X))*noise;

Ytrain=[zeros(n0,1); ones(n1,1); rand(Noutlier,1)>0.5]+1;


%% sample testing data
Ninlier=ntest/2;
n0=Ninlier/2;
n1=n0;
Noutlier=ntest-Ninlier;

X0=randn(n0,d)*V';
X1=randn(n1,d)*V'+offset;
X=[X0;X1; randn(Noutlier,D)];
Xtest=X+randn(size(X))*noise;

Ytest=[zeros(n0,1); ones(n1,1); rand(Noutlier,1)>0.5]+1;


% task.QDA_model=0;
% P.mu(:,1)=mean(X0);
% P.mu(:,2)=mean(X1);
% P.Sigma=V*V';
% P.w=1/2*[1,1];
% P.del=diff(P.mu')';
