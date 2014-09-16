function df = dF4lad(W,FParameters)
%	Derivative of F (minus the log-likelihood) for the LAD model.
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
    p = cols(sigma);
    nj = FParameters.n;
    n = sum(nj);
    a = zeros(rows(W), cols(W), length(nj));
    sigma_i = zeros(p);
    for i=1:length(nj)
        sigma_i(:,:) = sigma(i,:,:);
        a(:,:,i) = -nj(i)*sigma_i*W*inv(W'*sigma_i*W);
    end
    first = sum(a,3);
    second = n * sigmag * W * inv(W' * sigmag * W);
    % ---Derivative of likelihood function for the LAD model
    df = -(first+second);
