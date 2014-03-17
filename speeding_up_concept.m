clear, clc
n=10;
D=20;
p=15;

A=rand(D);
S=A'*A;

[u,d,v]=svd(S);

norm(u*inv(d)*v'-inv(S),2)

x=rand(D,n);

vx=v(1:p,:)*x;

cvx=cov(vx');

vv=v(1:p,:)*v(1:p,:)';

