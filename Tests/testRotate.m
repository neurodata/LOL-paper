clearvars, clc, close all
task.name='toeplitz, D=5';
[task, X, Y, P] = get_task(task);
figure(1), clf

subplot(121), cla, hold all
plot(X(1,Y==1),X(2,Y==1),'ro')
plot(X(1,Y==2),X(2,Y==2),'bx')

%%

[Q, ~] = qr(randn(task.D));
if det(Q)<-.99
    Q(:,1)=-Q(:,1);
end
Xr=X;
Xr2=Xr(:,Y==2);
Xr2=(Xr2'*Q)';
Xr(:,Y==2)=Xr2;


%%

subplot(122), cla, hold all
plot(Xr(1,Y==1),Xr(2,Y==1),'ro')
plot(Xr(1,Y==2),Xr(2,Y==2),'bx')

%%

corrplot(Xr(:,Y==1)')
corrplot(Xr(:,Y==2)')

%%
S=Q*P.Sigma;
S=S*S';

Sigma(:,:,1)=P.Sigma;
Sigma(:,:,2)=S;
gmm = gmdistribution(P.mu',Sigma,P.w);
[X,Y] = random(gmm,task.n);
X=X'; Y=Y';

%%

D=task.D;
mu=zeros(1,D);
Sigma=P.Sigma;
n=10000;
X = mvnrnd(mu,Sigma,n);
[u,d,v]=svd(X,0);
plot(v,'linewidth',2)
legend(['1';'2';'3';'4';'5'])

%%
[Q, ~] = qr(randn(task.D));
if det(Q)<-.99
    Q(:,1)=-Q(:,1);
end
R=X*Q;

[u,d,vr]=svd(R,0);
hold on
plot(vr,'-.','linewidth',2)


 
 
