function [Xtrain,Ytrain,Xtest,Ytest] = fat_tails(D,n,ntest)

s0=10;
mu0=zeros(D,1);
mu1=[ones(s0,1); zeros(D-s0,1)];
mu=[mu0,mu1];

rho=0.2;
A=rho*ones(D);
A(1:D+1:end)=1;

Sigma=A;
p=1; 
while p>0  % make sure after rotation we still have a proper covariance matrix
    [mu,Sigma]=random_rotate(mu,Sigma);
    [~,p]=chol(Sigma);
end
w=1/2*ones(2,1);

gmm = gmdistribution(mu',Sigma,w);
[X0,Y0] = random(gmm,n*0.8);

gmm = gmdistribution(mu',Sigma*15,w);
[X1,Y1] = random(gmm,n*0.2);

Xtrain=[X0;X1];
Ytrain=[Y0;Y1];


gmm = gmdistribution(mu',Sigma,w);
[X0,Y0] = random(gmm,ntest*0.8);
gmm = gmdistribution(mu',Sigma*15,w);
[X1,Y1] = random(gmm,ntest*0.2);

Xtest=[X0;X1];
Ytest=[Y0;Y1];

