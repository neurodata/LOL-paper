function [Xtrain,Ytrain,Xtest,Ytest,mu,Sigma] = fat_tails(D,n,ntest,r,f,t)

if nargin<4, r=1; end
if nargin<5, f=15; end
if nargin<6, t=0.8; end

s0=10;
mu0=zeros(D,1);
mu1=[ones(s0,1); zeros(D-s0,1)];
mu=[mu0,mu1];

rho=0.2;
A=rho*ones(D);
A(1:D+1:end)=1;
Sigma=A;
if r==1, [mu,Sigma]=random_rotate(mu,Sigma); end
w=1/2*ones(2,1);

% Q=rand_rot(D);

gmm = gmdistribution(mu',Sigma,w);
[X0,Y0] = random(gmm,round(n*t));

gmm = gmdistribution(mu',Sigma*15,w);
[X1,Y1] = random(gmm,round(n*(1-t)));

Xtrain=[X0;X1];
Ytrain=[Y0;Y1];


gmm = gmdistribution(mu',Sigma,w);
[X0,Y0] = random(gmm,round(ntest*t));
gmm = gmdistribution(mu',Sigma*f,w);
[X1,Y1] = random(gmm,round(ntest*(1-t)));

Xtest=[X0;X1];
Ytest=[Y0;Y1];

