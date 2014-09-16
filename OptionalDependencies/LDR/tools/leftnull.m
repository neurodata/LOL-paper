function OUT = leftnull(A)
% OUT = leftnull(A)
%
% OUT = leftnull(A) returns a basis for the left nullspace in the columns
% of OUT. The left nullspace of A is the nullspace of A'.
%

OUT = nulbasis(A');
