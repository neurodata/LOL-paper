function InvSig = inverse_covariance(X)
% estimate inverse covariance via svd
% 
% INPUT: X in R^{D x n}: centered matrix
% OUTPUT: InvSig in R^{D x D}: numerically stable estimate of the inverse covariance matrix

[D,n]=size(X);
if n>D
    [~,d,u] = svd(X',0);
else
    [u,d,~] = svd(X,0);
end
tol = max(size(X)) * eps(max(d(:)));
r = sum(d(:) > tol);
dd=d(1:r,1:r);
L = u(:,1:r)/dd;
InvSig = (L*L')*n;         % useful for classification via LDA