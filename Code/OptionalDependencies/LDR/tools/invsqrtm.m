function C = invsqrtm(A,B)
%
% C = invsqrtm(A,B)
%
% This function computes the inverse of the square-root of a matrix.
% When A and B are given, it is assumed that A is a matrix of 
% eigenvectors and that B is the corresponding matrix of eigenvalues
% (i.e. A and B are taken from the spectral decomposition of a matrix
% M by using [A,B]=eig(M)). When only one matrix is given as argument, 
% function performs its eigendecomposition before computing its 
% square-root.
%---------------------------------------------------------------

if nargin<2,
    [V,D]=eig(A);
     BB = diag(D);
     C = V*diag(sqrt(1./BB))*(V');
else
     BB = diag(B);
     C = A*diag(sqrt(1./BB))*(A');
end
