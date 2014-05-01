function [Phat, X_centered, times] = estimate_params(X,Y)

tic
mu = mean(X,1);
Cov = cov(X);

X_centered = bsxfun(@minus,X,mu);
delta=(mean(X_centered(Y==0,:))-mean(X_centered(Y==1,:)))';
times.init = toc;

Phat.mu=mu;
Phat.delta=delta;
Phat.cov=Cov;



