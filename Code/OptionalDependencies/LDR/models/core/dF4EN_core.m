function df = dF4EN_core(W,FParameters)
%	Derivative of F (minus the likelihood) on the dimension of the 
%   reduced subspace for the CORE model.
%   USAGE: 
%     - W is the projection matrix onto the reduced subspace, as
%       computed with the FNFP function.
%   Notice that global FParameters are supposed to be already set.
% ==============================================================
    sigma = FParameters.sigma;
    sigmag = FParameters.sigmag;
    p = cols(sigmag);
    n = FParameters.n;
    a = zeros(size(W,1), size(W,2), length(n));
    sigma_i = zeros(p);
    for i=1:length(n)
        sigma_i(:,:) = sigma(i,:,:);
        a(:,:,i) = n(i)*sigma_i*W*inv(W'*sigma_i*W);
    end
    first = sum(a,3);
    second = sum(n) * inv(sigmag) * W * inv(W' * inv(sigmag) * W);
    % ---Derivative of likelihood function for the LAD model
    df = (first+second);
