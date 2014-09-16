function sigmag = get_meanvar(FParameters)
% sigmag = get_meanvar(FParameters)
%
% This function computes the average sample conditional covariance matrix.
% FParameters: structure with basic statistics from the sample:
%   FParameters.sigma: array with sample conditional covariance matrices
%   FParameters.n: vector with the size of sample for each different value 
%   of the response vector.
%----------------------------------------------------------
sigma = FParameters.sigma;
nj=FParameters.n;
ncols = size(sigma,2);
h = size(sigma,1);
sigmag = zeros(ncols,ncols);
sigma_j = zeros(size(sigmag));

% average of the covariance of each population
for j=1:h
    sigma_j(:,:) = sigma(j,:,:);
    sigmag = sigmag + nj(j)*sigma_j(:,:);
end
sigmag = sigmag/sum(nj);
