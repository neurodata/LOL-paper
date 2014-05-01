function logdetS = get_logdet(P)

logdetS=nan(P.Ngroups,1);
for k=1:P.Ngroups
    tol = max(size(P.V{k})) * eps(max(P.d{k}(:)));
    r = sum(P.d{k}(:) > tol);
    dd=P.d{k}(1:r,1:r);
    L = P.V{k}(:,1:r)*dd;
    Sig = (L*L')/P.n;         % useful for classification via LDA
    logdetS(k)=logdet(Sig);
end