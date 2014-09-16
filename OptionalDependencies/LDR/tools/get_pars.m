function [sigmas,means,sizes] = get_pars(X,Y,h)
%
% function sigma = get_pars(X,Y,h)
% 
% This function estimates conditional covariance matrices and means for
% each one of the h populations in the sample (Y,X). 
% The number of observation for each populations is given too.
%
% USAGE:
%  - outputs: 
%     - sigmas: array of conditional covariance matrices.
%     - means: matrix of predictors' means for each population
%     - sizes: vector with the number of observations/population
%  - inputs:
%     - X: matrix of predictors
%     - Y: response vector
%     - h: number of populations or slices
%----------------------------------------------------------
ncols = size(X,2);
sigmas = zeros(h,ncols,ncols);
sizes = zeros(h,1);
means = zeros(ncols,h);
if ~isinZ(Y),
    h = length(Y);
    Y = 1:h;
end
for j=1:h
    Xj=X(Y==j,:);
    sizes(j) = size(Xj,1);
    means(:,j) = mean(Xj)';
    sigmas(j,:,:) = get_cov(Xj);
end
