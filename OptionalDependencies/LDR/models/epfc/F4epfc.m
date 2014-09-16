function f = F4epfc(W,FParameters)
%
% f = F4epfc(W,FParameters)
%
% This function computes the negative of the log-likelihood for the EPFC
% model. 
%
% Inputs:
%    - W: orthogonal basis matrix for the dimension reduction subspace.
%    - FParameters: structure of parameters computed from the sample. It
%    contains:
%          - FParameters.sigmag = marginal covariance matrix
%          - FParameters.n: sample size for each value of teh response Y.
%          - FParameters.Afit: covariance matrix of the fitted values of
%          the regression of the centered predictors onto a regression
%          basis fy.
%
%
%==========================================================================
A = FParameters.sigmag;
n = sum(FParameters.n);
p = cols(A);
Afit = FParameters.Afit;
sigres = A-Afit;
a = logdet(W' * sigres * W);
b = logdet(W' * inv(A) * W);
f = n*p/2*(1+log(2*pi)) + n/2*(a+b);
 
