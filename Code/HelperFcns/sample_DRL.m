function [X,Y] = sample_DRL(sim)

D=100;
mudelt = 5;                                 % distance betwen dim 1 of means
mu1 = [-mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
mu2 = [mudelt/2*ones(2,1); zeros(D-2,1)];                   % class 1 mean
mu1(2)=mu1(2)/3;
mu2(2)=mu2(2)/3;

sd=1;
sv = sd/sqrt(D)*ones(D,1);
sv(2)=4;
A  = eye(D,D); %A(1:2,1:2)=[1,2;0,1];       % singular vectors
Sig=A*diag(sv);                            % class 1 cov

Sig(1,2) = sv(2)/2;
Sig(2,1) = sv(2)/2;
Sig=Sig+eye(D);

delta=mu1-mu2;
Risk=1-normcdf(0.5*sqrt(delta'*(Sig\delta)));

% mu11 = [c1; c2; zeros(D,1)];

mu00 = mu1;
mu01 = mu1*3;

mu10 = mu2;
mu11 = mu2*3;

% train data
D=D-2;
n=1050;
x00 = bsxfun(@plus,mu00,Sig*randn(2+D,n))';
x01 = bsxfun(@plus,mu01,Sig*randn(2+D,n))';

x10 = bsxfun(@plus,mu10,Sig*randn(2+D,n))';
x11 = bsxfun(@plus,mu11,Sig*randn(2+D,n))';

switch sim
    case '0'
        X=[x00; x01; x10; x11];
        Y=[zeros(2*n,1); ones(2*n,1)];     
    case '00'
        X=[x00; x01];
        Y=[zeros(n,1); ones(n,1)];
    case '01'
        X=[x10; x11];
        Y=[zeros(n,1); ones(n,1)];
end

