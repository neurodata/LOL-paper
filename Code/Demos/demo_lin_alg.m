clear, clc
p=10;
d=5;
k=4
switch k
    case 1
        S=eye(p);
        del=sqrt(p)*ones(p,1)/p;
    case 2
        S=orth(rand(p));
        del=sqrt(p)*ones(p,1);
    case 3
        L=randn(p);
        S=L'*L;
        del=sqrt(p)*ones(p,1);
    case 4
        S=eye(p);
        del=sqrt(p)*randn(p,1);
        del=p*del/norm(del);
    case 5
        S=orth(rand(p));
        del=sqrt(p)*randn(p,1);
        del=p*del/norm(del);
    case 6
        L=randn(p);
        S=L'*L;
        del=sqrt(p)*randn(p,1);
        del=p*del/norm(del);
    case 7
        s=(p:-1:1).*ones(1,p);
        S=diag(s);
        del=sqrt(p)/p*ones(p,1);
end

Ps=pinv(S)*del;
nPs=norm(Ps);

%% angle when A=I
A=eye(p);
PA=A'*A*pinv(S)*A'*A*del;
PAPs=PA'*Ps;
angle(1)=PAPs/(norm(PA)*nPs);

%% angle when A=eye(p-1)
A=[eye(d), zeros(d,p-d)];
PA=A'*A*pinv(S)*A'*A*del;
PAPs=PA'*Ps;

angle(2)=PAPs/(norm(PA)*nPs);

%% angle when A=eigenvectors
[U,D,V]=svd(S);
A=U;
PA=A'*A*pinv(S)*A'*A*del;
PAPs=PA'*Ps;

angle(3)=PAPs/(norm(PA)*nPs);

%% angle when A=top d eigenvectors
A=U(1:d,:);
PA=A'*A*pinv(S)*A'*A*del;
PAPs=PA'*Ps;

angle(4)=PAPs/(norm(PA)*nPs);

%%
display(angle)

%%
clear, clc
p=10;
% del=sqrt(p)/p*ones(p,1);
del=orth(randn(p,1));
n=1;
for i=1:n
    s=sort(rand(p,1),'descend');
    S=diag(s);
    
    [U,D,V]=svd(S);
    
    As=(S^-1*del);
    As=As/norm(As);
    
    errs(1)=As'*del;
    errs(2)=As'*U(:,1);
    
    err_diff(i)=diff(errs);
    
    A=del';
    PA=A'*A*pinv(S)*A'*A*del;
    PA=PA/norm(PA);
    ang_err(1)=PA'*As;

    A=U(:,1)';
    PA=A'*A*pinv(S)*A'*A*del;
    ang_err(2)=PA'*As;

    ang_diff(i)=diff(ang_err);
    
    [~,bar]=max(s);
    right(i)=find(U(:,1))==bar;
end
[counts1,centers1] = ksdensity(err_diff);
[counts2,centers2] = ksdensity(ang_diff);
figure(1), clf, hold all
plot(centers1,counts1)
plot(centers2,counts2)
legend('error','angle')

%%
% clc
n=50000;
m0=rand*10;
m1=-m0;
sig=0.5;

x0=sig*(randn(n,1)+m0);
x1=sig*(randn(n,1)+m1);
x=[x0;x1];
p=0.5;

[var(x0), var(x1), var(x), p*m0^2*(sig^2)+p*m1^2*(sig^2)]


