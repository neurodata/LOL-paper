function f = F4core(W,FParameters)
%
% f = F4core(W,FParameters)
%
% This function computes the negative of the log-likelihood for the CORE
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
n = FParameters.n;
p = cols(sigmag);
% ---define some convenient variables
sum_n = sum(n);
h = n/sum_n;
a = zeros(length(h),1);
sigma_i = zeros(p);
for i=1:length(h),
    sigma_i(:,:) = sigma(i,:,:);
    a(i) = logdet(W' * sigma_i * W);
end
% ---Likelihood function for LAD model
f = -sum_n/2 * (logdet(W' * sigmag * W) - h*a);
