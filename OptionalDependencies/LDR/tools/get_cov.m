function covariance = get_cov(X)
% 
% covariance = get_cov(X)
% This functions estimates the biased covariance matrix of X.
% -------------------------------------------------------------
N = size(X,1);
covariance = cov(X)*(N-1)/N;