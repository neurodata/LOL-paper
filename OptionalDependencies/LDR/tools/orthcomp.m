function BCOMP = orthcomp(B)
% BCOMP = orthcomp(B)
% 
% This function provides the orthogonal complement of a subspace.
% It returns a basis for the orthogonal complement of the column space of B.
% This subspace contains all vectors orthogonal to the column space of B.
% It is the left nullspace of B.
%

BCOMP = leftnull(B);
