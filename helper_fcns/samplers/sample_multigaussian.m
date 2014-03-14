function [X, Y] = sample_multigaussian(n,P)
% sample from the QDA model
% 
% INPUT
%   n in R or R^2: # samples or # samples per class
%   P: structure containing parameters
% 
% OUTPUT
%   X in R^{D x n}: predictor matrix
%   Y in {0,1}^n: predictee vector

L=cholcov(P.Sig);

% if length(n)==1
%     n0=binornd(n,P.pi0);
%     n1=n-n0;
% elseif length(n)==2
%     n0=n(1); 
%     n1=n(2); 
% end

[k,D]=size(P.mu);
X=[]; Y=[];
for i=1:k
    temp = bsxfun(@plus,randn(n(i),D)*L,P.mu(i,:)')';
    X = [X, temp];
    Y = [Y, i*ones(n(i),1)];
end

