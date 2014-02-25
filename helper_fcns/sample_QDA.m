function [X, Y] = sample_QDA(n,P)
% sample from the QDA model
% 
% INPUT
%   n in R or R^2: # samples or # samples per class
%   P: structure containing parameters
% 
% OUTPUT
%   X in R^{D x n}: predictor matrix
%   Y in {0,1}^n: predictee vector

L0=cholcov(P.Sig0);
L1=cholcov(P.Sig1);

if length(n)==1
    n0=binornd(n,P.pi0);
    n1=n-n0;
elseif length(n)==2
    n0=n(1); 
    n1=n(2); 
end

D=length(P.mu0);
X0 = bsxfun(@plus,randn(n0,D)*L0,P.mu0')';
X1 = bsxfun(@plus,randn(n1,D)*L1,P.mu1')';


X = [X0,X1];
Y = [zeros(n0,1);ones(n1,1)];