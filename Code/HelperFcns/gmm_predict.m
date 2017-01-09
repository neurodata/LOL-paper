function [Yhat, P] = gmm_predict(X,Y,P)

P.groups=unique(Y);
P.Ngroups=length(P.groups);

[P.D,P.n]=size(X);
if ~isfield(P,'nvec')
    P.nvec=nan(P.Ngroups,1);
    for k=1:P.Ngroups
        k_idx=find(Y==P.groups(k));
        P.nvec(k)=length(k_idx);
    end
end

if ~isfield(P,'InvSig')
    [~,~,K]=size(P.Sigma);
    if K>1
        for k=1:K
            [P.V{k}, P.d{k}] = svd(P.Sigma(:,:,k));
        end
    else
        [P.V, P.d] = svd(P.Sigma);
    end
    P.InvSig = inverse_cov(P);
end
if ~isfield(P,'w'), P.w=0.5*ones(P.Ngroups,1); end
lnprior=log(P.w);
P.c=nan(P.Ngroups,1);
if K>1
    logdetS=get_logdet(P);
    for k=1:P.Ngroups
        P.c(k)=P.mu(:,k)'*P.InvSig(:,:,k)*P.mu(:,k)+2*lnprior(k)+logdetS(k);
    end
else
    for k=1:P.Ngroups
        P.c(k)=P.mu(:,k)'*P.InvSig*P.mu(:,k)+2*lnprior(k);
    end
end

if K>1
    Yhat = QDA_predict(X,P);
else
    if P.Ngroups==2
        P.del=P.mu(:,1)-P.mu(:,2);
        P.mu=P.mu*P.w;
        P.thresh=(lnprior(1)-lnprior(2))/2;
    end
    Yhat = LDA_predict(X,P);
end