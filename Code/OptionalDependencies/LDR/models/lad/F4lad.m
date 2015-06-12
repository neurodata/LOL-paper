function f = F4lad(W,FParameters)
%
% f = F4lad(W,FParameters)
%
% This function computes the negative of the log-likelihood for the LAD
% model. 
%
% Inputs:
%    - W: orthogonal basis matrix for the dimension reduction subspace.
%    - FParameters: structure of parameters computed from the sample. It
%    contains:
%          - FParameters.sigma = array of conditional covariance matrices
%          - FParameters.sigmag = marginal covariance matrix
%          - FParameters.n: sample size for each value of teh response Y.
%
%
%==========================================================================

sigma = FParameters.sigma;
sigmag = FParameters.sigmag;
nj = FParameters.n;
n = sum(nj);
p = cols(sigmag);
% ---define some convenience variables
h = nj/n;

a = zeros(length(h),1);
sigma_i = zeros(p);
for i=1:length(h),
    sigma_i(:,:) = sigma(i,:,:);
    a(i) = logdet(W'*sigma_i*W);
end
% ---Likelihood function for LAD model
f = n*p*(1+log(2*pi))/2 + n*logdet(sigmag)/2 - ...
    n/2 * (logdet(W'*sigmag*W) - h*a);
