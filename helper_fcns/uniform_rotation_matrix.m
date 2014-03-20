function Q = uniform_rotation_matrix(n)

[Q, R] = qr(randn(n));
Q = Q*diag(sign(diag(R)));
if det(Q)<0
    Q=[-Q(:,1),  Q(:,2:end)];
end