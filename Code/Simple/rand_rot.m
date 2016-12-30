function Q = rand_rot(D)

[Q, ~] = qr(randn(D));
if det(Q)<-.99
    Q(:,1)=-Q(:,1);
end
