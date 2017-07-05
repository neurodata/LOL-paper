function sigma = get_covarray(DATA,LABELS,h)
%
% sigma = get_covarray(DATA,LABELS,h)
% 
% This function estimates conditional covariance matrices for
% each one of the h populations in DATA.
% USAGE:
%  - outputs: 
%     - sigma: array of conditional covariance matrices.
%  - inputs:
%     - DATA: matrix of predictors
%     - LABELS: vector of responses
%     - h: number of populations or slices
%----------------------------------------------------------
ncols = size(DATA,2);
sigma = zeros(h,ncols,ncols);
% covariance of each population
for j=1:h
    Xj=DATA(LABELS==j,:);
    sigma(j,:,:) = get_cov(Xj);
end
