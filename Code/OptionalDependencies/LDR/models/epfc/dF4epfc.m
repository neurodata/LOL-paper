function df = dF4epfc(W,FParameters)
%	Derivative of F (minus the log-likelihood) for the EPFC model.
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
%==========================================================================
A = FParameters.sigmag;
n = sum(FParameters.n);
Afit = FParameters.Afit;
sigres = A-Afit;    
a = sigres*W*inv(W'*sigres*W);
b = inv(A)*W*inv(W'*inv(A)*W);
% ---Derivative of likelihood function for the EPFC model
df = n*(a+b);
