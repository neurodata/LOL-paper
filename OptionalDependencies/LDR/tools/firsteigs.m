function [Vk,diagkD] = firsteigs(A,k)
% [Vk,diagkD] = firsteigs(A,k)
% 
% This function gives the first k eigenvalues of matrix A along with the 
% corresponding eigenvectors. Eigenvectors are stored in Vk, while eigenvalues 
% are stored in diagkD.
% =========================================================================
if nargin < 2,
    k = size(A,2);
end
[V,D] = eig(A);
[diagkD,idx] = sort(diag(D),'descend'); 
diagkD(k+1:end) = [];
Vk = V(:,idx(1:k));


