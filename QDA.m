function Yhat = QDA(X,P)

lnp0=log(P.pi0);
lnp1=log(P.pi1);

a1= -0.5*logdet(P.Sig1)+lnp1;
a0= -0.5*logdet(P.Sig0)+lnp0;

d1 = bsxfun(@minus,X,P.mu1);
d0 = bsxfun(@minus,X,P.mu0);

[~,n]=size(X);
Yhat=nan(n,1);
for i=1:n
    l1=-0.5*d1(:,i)'*P.invSig1*d1(:,i)-a1;
    l0=-0.5*d0(:,i)'*P.invSig0*d0(:,i)-a0;
    Yhat(i)= l1 > l0;
end