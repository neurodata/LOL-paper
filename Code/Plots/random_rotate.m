function [mu,Sigma] = random_rotate(mu,Sigma)

D=length(Sigma);
p=1; 
sym=true;
while p~=0 && sym
    [Q, ~] = qr(randn(D));
    if det(Q)<-.99
        Q(:,1)=-Q(:,1);
    end
    
    Sigma=Q*Sigma*Q';
    mu=Q*mu;
    
    [~,p]=chol(Sigma);
    sym = issymmetric(Sigma);
    
end