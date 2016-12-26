function [Xtrain,Ytrain,Xtest,Ytest] = xor2(D,ntrain,ntest)


mu0=zeros(D,1);
mu1=repmat([1;0],D/2,1);
Sigma=sqrt(D/4)*eye(D);

gmm = gmdistribution([mu0,mu1]',Sigma,[0.5,0.5]);
[X0train,Y0train] = random(gmm,ntrain*0.5);
[X0test,Y0test] = random(gmm,ntest*0.5);

P.Sigma=Sigma;
P.w=1/2*[1,1];
P.mu=[mu0,mu1];

mu0=ones(D,1);
mu1=repmat([0;1],D/2,1);
gmm = gmdistribution([mu0,mu1]',Sigma,[0.5,0.5]);
[X1train,Y1train] = random(gmm,ntrain*0.5);
[X1test,Y1test] = random(gmm,ntest*0.5);

Xtrain=[X0train;X1train];
Ytrain=[Y0train;Y1train];

Xtest=[X0test;X1test];
Ytest=[Y0test;Y1test];