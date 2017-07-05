function res = sqrm(A)
[V,D] = eig(A);
res = V*diag(diag(D).^2)*V';