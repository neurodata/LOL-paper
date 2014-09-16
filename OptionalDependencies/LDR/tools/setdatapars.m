function FParameters = setdatapars(Y,X,h)
% FParameters = setdatapars(Y,X,h)
%
% This function gets basic statistics from the data sample: marginal
% covariance matrix, conditional means and covariance matrices and sample
% size for each value of Y.
%
% Inputs:
% - Y: response vector.
% - X: predictor matrix.
% - h: number of different values in Y. It equates the number of
% populations when Y is discrete and the number of slices for a discretized
% continuous response.
%==========================================================================
   [sigmas,means,counts] = get_pars(X,Y,h);
   FParameters.sigmag = get_cov(X);
   FParameters.sigma = sigmas;
   FParameters.means = means;
   FParameters.n = counts';
