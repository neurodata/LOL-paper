function [mu,Sigma] = random_rotate(mu,Sigma)

[Q, ~] = qr(randn(length(Sigma)));
if det(Q)<-.99
    Q(:,1)=-Q(:,1);
end

Sigma=Q*Sigma*Q';
mu=Q*mu;
