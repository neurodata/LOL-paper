function P = estimate_parms(X,Y)
% learns all the parameters necessary for LDA
% note that this function supports semi-supervised learning via encoding
% NaN's into Y
% 
% INPUT:
%   X in R^{D x n}: predictor matrix
%   Y in {0,1,NaN}^n: predictee matrix
% 
% OUTPUT: P, a structure of parameters 

P.groups=unique(Y);
P.Ngroups=length(P.groups);

[P.D,P.n]=size(X);
P.nvec=nan(P.Ngroups,1);
P.mu=nan(P.D,P.Ngroups);
X_centered=nan(size(X));
for k=1:P.Ngroups
    k_idx=find(Y==P.groups(k));
    P.nvec(k)=length(k_idx); 
    Xtemp=X(:,k_idx);
    P.mu(:,k)=mean(Xtemp,2);
    temp=[0; P.nvec(1:k)];
    X_centered(:,sum(temp(1:k))+1:sum(temp(1:k+1)))=bsxfun(@minus,Xtemp,P.mu(:,k));
end
P.delta=bsxfun(@minus,P.mu(:,2:end),P.mu(:,1));

if P.n>P.D
    [~,P.d,P.V] = svd(X_centered',0);
else
    [P.V,P.d,~] = svd(X_centered,0);
end