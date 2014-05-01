function P = QDA_train(X,Y)
% learns all the parameters necessary for LDA
% note that this function supports semi-supervised learning via encoding
% NaN's into Y
% 
% INPUT:
%   X in R^{D x n}: predictor matrix
%   Y in {0,1,NaN}^n: predictee matrix
% 
% OUTPUT: P, a structure of parameters required for classification


P = estimate_parms_QDA(X,Y);
P.InvSig = inverse_cov(P);
lnprior=log(P.nvec/P.n);

P.c=nan(P.Ngroups,1);
logdetS=get_logdet(P);
for k=1:P.Ngroups
   P.c(k)=P.mu(:,k)'*P.InvSig(:,:,k)*P.mu(:,k)+2*lnprior(k)+logdetS(k);
end