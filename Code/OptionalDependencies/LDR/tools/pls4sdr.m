function [P,T,Q,U,B,W] = pls4sdr(X,Y,ncomp)
%
% P = pls4sdr(X,Y,ncomp)
%
% This function obtains an initial estimate of the central subspace based
% on Partial Least Squares regression. This estimate is assessed along
% several other estimators when searching for the best initial estimate
% prior to iterative estimation of the central subspace. See VALIN for details.
% 
% USAGE:
% Inputs:
%   X: matrix of predictors
%   Y: response vector
%   ncomp: dimension of the desired central subspace.
% 
% Outputs:
%   P: loading matrix of X
%
% ---------------------------- CREDITS ----------------------------------
% Current implementation is adapted from Yi Cao's one available through
%  the Mathworks community.
% =======================================================================
% Input check
if nargin<2
    Y=X;
end
tol = 1e-10;

% Size of x and y
[rX,cX]  =  size(X);
[rY,cY]  =  size(Y);

if nargin<3
    ncomp=cX;
end
% Allocate memory to the maximum size 
n=ncomp; %n=cX;
T=zeros(rX,n);
P=zeros(cX,n);
U=zeros(rY,n);
Q=zeros(cY,n);
B=zeros(n,n);
W=P;
k=0;
% iteration loop if residual is larger than specfied
while norm(Y)>tol && k<n
    [dummy,tidx] =  max(sum(X.*X));
    [dummy,uidx] =  max(sum(Y.*Y));
    t1 = X(:,tidx);
    u = Y(:,uidx);
    t = zeros(rX,1);
    % iteration for outer modeling until convergence
    while norm(t1-t) > tol
        w = X'*u;
        w = w/norm(w);
        t = t1;
        t1 = X*w;
        q = Y'*t1;
        q = q/norm(q);
        u = Y*q;
    end
    % update p based on t
    t=t1;
    p=X'*t/(t'*t);
    pnorm=norm(p);
    p=p/pnorm;
    t=t*pnorm;
    w=w*pnorm;
    % regression and residuals
    b = u'*t/(t'*t);
    X = X - t*p';
    Y = Y - b*t*q';
    % save iteration results to outputs:
    k=k+1;
    T(:,k)=t;
    P(:,k)=p;
    U(:,k)=u;
    Q(:,k)=q;
    W(:,k)=w;
    B(k,k)=b;
end
P(:,k+1:end)=[];
T(:,k+1:end)=[];
U(:,k+1:end)=[];
Q(:,k+1:end)=[];
W(:,k+1:end)=[];
B=B(1:k,1:k);
