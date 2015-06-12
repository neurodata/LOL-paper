clear, clc
p=10;
d=5;
k=2
switch k
    case 1
        S=eye(p);
        del=sqrt(p)*ones(p,1);
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

n=50000;
m0=rand*10;
m1=-m0;
sig=0.5;

x0=sig*(randn(n,1)+m0);
x1=sig*(randn(n,1)+m1);
x=[x0;x1];
p=0.5;

[var(x0), var(x1), var(x), p*m0^2*(sig^2)+p*m1^2*(sig^2)]


