function N = nulbasis(A)
% N = nulbasis(A) 
%
% N = nulbasis(A) returns a basis for the nullspace of A
% in the columns of N. The basis contains the n-r special 
% solutions to Ax=0.
%

[R, pivcol] = rref(A, sqrt(eps));
[m, n] = size(A);
r = length(pivcol);
freecol = 1:n;
freecol(pivcol) = [];
N = zeros(n, n-r);
N(freecol, : ) = eye(n-r);
N(pivcol,  : ) = -R(1:r, freecol);
