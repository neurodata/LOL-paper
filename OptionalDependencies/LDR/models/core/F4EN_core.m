function f = F4EN_core(W,FParameters)
% Objective function (minus the likelihood) for the CORE model.
% USAGE: 
% - W is the projection matrix onto the reduced subspace.
% Notice that global FParameters are supposed to be already set.
% ==============================================================
sigma = FParameters.sigma;
sigmag = FParameters.sigmag;
n = FParameters.n;
p = cols(sigmag);
% ---define some convenience variables
sum_n = sum(n);
h = n/sum_n;
a = zeros(length(h),1);
sigma_i = zeros(p);
for i=1:length(h),
    sigma_i(:,:) = sigma(i,:,:);
    a(i) = logdet(W'*sigma_i*W);
end
% ---Likelihood function for LAD model
f = sum_n/2 * (logdet(W'*inv(sigmag)*W) + h*a);
