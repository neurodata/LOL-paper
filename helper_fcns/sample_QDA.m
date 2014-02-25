function [X, Y] = sample_QDA(n,mu0,mu1,Sig0,Sig1)

D=length(mu0);

if length(n)==1
    n0=n/2; n1=n/2; 
else
    n0=n(2); n1=n(1); 
end


L0=cholcov(Sig0);
L1=cholcov(Sig1);

X0 = bsxfun(@plus,randn(n0,D)*L0,mu0')';
X1 = bsxfun(@plus,randn(n1,D)*L1,mu1')';

X = [X0,X1];
Y = [zeros(n0,1);ones(n1,1)];
