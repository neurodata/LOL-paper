function P = LDA_train(X,Y)
% learns all the parameters necessary for LDA
% note that this function supports semi-supervised learning via encoding
% NaN's into Y
% 
% INPUT:
%   X in R^{D x n}: predictor matrix
%   Y in {0,1,NaN}^n: predictee matrix
% 
% OUTPUT: P, a structure of parameters required for classification


P = estimate_parms(X,Y);
P.InvSig = inverse_cov(P);
lnprior=log(P.nvec/P.n);

P.c=nan(P.Ngroups,1);
for k=1:P.Ngroups
   P.c(k)=P.mu(:,k)'*P.InvSig*P.mu(:,k)+2*lnprior(k);
end

if P.Ngroups==2
   P.del=P.mu(:,1)-P.mu(:,2);
   P.mu=P.mu*P.nvec/P.n;
   P.thresh=(lnprior(1)-lnprior(2))/2;
end