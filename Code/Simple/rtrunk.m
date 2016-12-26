function [mu,Sigma] = rtrunk(D,b,r,K)

if nargin<2, b=4; end % scalar
if nargin<3, r=0; end % whether to rotate
if nargin<4, K=2; end % number of classes

% parameters
mu1=b./sqrt(1:2:2*D)';
mu0=-mu1;
mu=[mu1, mu0];
if K==3, mu=[mu0, 0*mu0, mu1]; end
Sigma=eye(D);
Sigma(1:D+1:end)=100./sqrt(D:-1:1);
if r==1, [mu,Sigma]=random_rotate(mu,Sigma); end
