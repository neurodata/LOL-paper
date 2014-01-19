function [X, Y] = sample_QDA(n,mu1,mu2,Sig1,Sig2)

D=length(mu1);

if length(n)==1
    n1=n/2; n2=n/2;
else
    n1=n(1); n2=n(2);
end


% generate data
X1 = bsxfun(@plus,mu1,Sig1*randn(D,n1));
X2 = bsxfun(@plus,mu2,Sig2*randn(D,n2));
X = [X1,X2]';
Y = [zeros(n1,1);ones(n2,1)];
