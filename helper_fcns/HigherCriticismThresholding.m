% function idx = HigherCriticismThresholding(X,Y)

%%
clearvars, clc
D=10; n0=250; n1=n0;
mu0=[1; zeros(D-1,1);
mu1=-mu0;
Sig=eye(D);
L=cholcov(Sig);
X0 = bsxfun(@plus,randn(n0,D)*L,mu0')';
X1 = bsxfun(@plus,randn(n1,D)*L,mu1')';

X = [X0,X1];
Y = [-ones(n0,1);ones(n1,1)]';

%%

[D,n]=size(X);
Z=nan(D,1);
Y(Y==0)=-1;

Z=Y*X'/sqrt(n);
[Zsorted,idx]=sort(Z);

HC=nan(1,D);
for i=1:D
    HC(i) = (i/D - Zsorted(i))/sqrt(i/D*(1-i/D));
end
HC=sqrt(D)*HC;
figure(1),
subplot(121)
plot(X(1,Y==-1),X(2,Y==-1),'.b'), hold all, plot(X(1,Y==1),X(2,Y==1),'.r')

subplot(122), plot(Zsorted,HC)