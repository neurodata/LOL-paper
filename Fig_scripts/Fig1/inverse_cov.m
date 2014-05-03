function InvSig = inverse_cov(P)
% estimate inverse covariance via svd
%
% INPUT: P (struct): with the following fields
%   d in R^{k x k}: diagonal matrix of eigenvalues
%   u in R^{D x k}: eigenvectors
%   n in Z: # of samples
%
% OUTPUT: InvSig in R^{D x D}: numerically stable estimate of the inverse covariance matrix

if iscell(P.V)
    InvSig=nan(P.D,P.D,P.Ngroups);
    for k=1:P.Ngroups
        InvSig(:,:,k)=get_invsig(P.V{k},P.d{k},P.nvec(k));
    end
else
    InvSig = get_invsig(P.V,P.d,P.n);
end

end


function K = get_invsig(V,d,n)

tol = max(size(V)) * eps(max(d(:)));
r = sum(d(:) > tol);
dd=d(1:r,1:r);
L = V(:,1:r)/dd;
K = (L*L')*n;                           % useful for classification via LDA

end