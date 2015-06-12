function [Afit,r] = get_average_cov(X,parameters)
% [Afit,r] = get_average_cov(X,parameters)
%
% This function computes an estimate of the variance of the estimates for 
% population means when response vector Y is discrete-valued
% (the so called 'between-class' covariance matrix). Th eresult is returned
% in matrix Afit and r is the number of populations minus 1.
%
% Inputs:
%   - X: matrix of predictors. Each row is an observation.
%   - parameters: structure with basic statistics from the sample:
%           - parameters.means: the mean of predictor vectors for each
%           population.
%           - parameters.sigma: array with conditional covariance matrices
%           for each population.
%           - parameters.n: size of the sample from each population.
%
% =========================================================================

means = parameters.means;
sizes = parameters.n;
[n,p] = size(X);
h = size(parameters.sigma,1);
meanX = mean(X)';
Afit = zeros(p);
for j=1:h,
     Afit = Afit + sizes(j)/n * (means(:,j)-meanX)*(means(:,j)-meanX)';
end
r = h-1;