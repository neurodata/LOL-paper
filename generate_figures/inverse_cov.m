function InvSig = inverse_cov(P)
% estimate inverse covariance via svd
% 
% INPUT: P (struct): with the following fields 
%   d in R^{k x k}: diagonal matrix of eigenvalues
%   u in R^{D x k}: eigenvectors
%   n in Z: # of samples
% 
% OUTPUT: InvSig in R^{D x D}: numerically stable estimate of the inverse covariance matrix

tol = max(size(P.V)) * eps(max(P.d(:)));
r = sum(P.d(:) > tol);
dd=P.d(1:r,1:r);
L = P.V(:,1:r)/dd;
InvSig = (L*L')*P.n;         % useful for classification via LDA