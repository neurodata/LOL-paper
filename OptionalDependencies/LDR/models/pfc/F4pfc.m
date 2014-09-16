function f = F4pfc(vals,FParameters)
%
% f = F4pfc(W,FParameters)
%
% This function computes the negative of the log-likelihood for the PFC
% model. 
%
% Inputs:
%    - vals: ordered eigenvalues of marginal covariance matrix.
%    - FParameters: structure of parameters computed from the sample. It
%    contains:
%          - FParameters.sigmag = marginal covariance matrix
%          - FParameters.n: sample size for each value of the response Y.
%
%
%==========================================================================

if nargin < 2,
    error('not enough input parameters')
end
A = FParameters.sigmag;
nj = FParameters.n; 
n = sum(nj);
p = cols(A);
u = length(vals);
f = n*p/2*(1 + log(2*pi)) + n/2*logdet(A); % this is the value for u=0
if u>0
    f = f - n/2*sum(log(vals));
end
