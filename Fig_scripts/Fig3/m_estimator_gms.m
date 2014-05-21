function [cov,temp,iter]=m_estimator_gms(X)
% X: data matrix with each row representing a point
% cov: the estimated covariance
[N,D]=size(X);
initcov=eye(D);
oldcov=initcov-1;
cov=initcov;
iter=1;
eps=10^-10;%regulirization parameter
while norm((oldcov-cov),'fro')>10^-8 & iter<100
    temp=X*(cov+eps*eye(D))^-1;
    d=sum(temp.*X,2);
    oldcov=cov;
    temp=((real(d./log(d))+eps*ones(N,1)).^-1);
    %temp=((real(d)+eps*ones(N,1)).^-1);
    cov=X'.*repmat(((temp)),1,D)'*X/N;
    cov=cov/trace(cov);
    iter=iter+1;
    eig(cov)
end
