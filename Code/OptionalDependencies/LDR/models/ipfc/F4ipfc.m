function f = F4ipfc(valsAfit,FParameters)
%
% f = F4epfc(W,FParameters)
%
% This function computes the negative of the log-likelihood for the IPFC
% model. 
%
% Inputs:
%    - valsAfit: ordered eigenvalues of the covariance matrix from the
%    fitted values of the regression of the centered predictors onto a basis fy.
%    - FParameters: structure of parameters computed from the sample. It
%    contains:
%          - FParameters.sigmag = marginal covariance matrix
%          - FParameters.n: sample size for each value of teh response Y.
%
%
%==========================================================================
A = FParameters.sigmag;
n = sum(FParameters.n);
p = cols(A);
u =length(valsAfit);
[vecs,valsA] =  firsteigs(A,p);
if u==0,
    f = n*p/2*(1 + log(sum(valsA)/p)); 
else
    f = n*p/2*(1 + log((sum(valsA)-sum(valsAfit))/p));
end
