function Phat = LDA_train(X,Y)

n=length(Y);
n1 = sum(Y);
n0 = n-n1;

X0 = X(:,Y==0);
X1 = X(:,Y==1);

Phat.pi0 = n0/n;
Phat.pi1 = n1/n;
Phat.lnpi0 = log(n0/n);
Phat.lnpi1 = log(n1/n);

Phat.mu0 = mean(X0,2);
Phat.mu1 = mean(X1,2);
Phat.mu = (Phat.mu0+Phat.mu1)/2;
Phat.del = (Phat.mu0-Phat.mu1);

Phat.Sigma = (n0*cov(X0') +  n1*cov(X1'))/n;
Phat.InvSig = pinv(Phat.Sigma);

