function [mu,Sigma] = toep(D,r)

if nargin<2, r=0; end
b=0.4;
D1=10;
rho=0.5;
c=rho.^(0:D1-1);
A = toeplitz(c);
K1=sum(A(:));

c=rho.^(0:D-1);
A = toeplitz(c);
K=sum(A(:));

mudelt=(K1*b^2/K)^0.5/2;
mu0 = ones(D,1);
mu0(2:2:end)=-1;
mu0=mudelt*mu0;
mu1=-mu0;
mu=[mu1, mu0];
Sigma=A;

if r==1 
    [mu2,Sigma2]=random_rotate(mu,Sigma); 
    mu(:,2)=mu2(:,2);
    Sigma(:,:,2)=Sigma2;
end

    