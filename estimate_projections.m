function [Proj, P] = estimate_projections(X,Y,k_proj,algs)
% 
% INPUT:
%   X:      centered X in R^{n x D}
%   delta:  difference between means in R^D
%   k_proj: dimensionality of subspace to project into
%   algs:    which algorithms to use
% 
% OUTPUT:
%   Proj:       structure containing
%       alg:    name of projection algorithm
%       Vhat:   estimated projection matrix
%       time:   time to generate projection matrix
%   P:          structure of parameters
%       mu:     estimated mean
%       delta:  estimated difference between means



tic
[D, n]=size(X);
mu = mean(X,2);
X_centered = bsxfun(@minus,X,mu);
delta=(mean(X_centered(:,Y==0),2)-mean(X_centered(:,Y==1),2));
% sig2=var(X_centered)';
% r=(1-(D-2)*(sig2/n)/norm(delta,2)^2);
% sdelta=r.*delta;

P.mu=mu;
P.delta=delta;
% P.sdelta=sdelta;
times.init = toc;


[~,d,V] = svd(X_centered',0);
times.svd = toc;
k=min(length(V),k_proj);

for i=1:length(algs)
    alg=char(algs(i));
    tic
    
    switch alg
        case 'PCA'
            Proj{i}.Vhat= V(:,1:k)';
            Proj{i}.d=diag(d)/n;
            Proj{i}.time = toc + times.svd;
        case 'LOL' % subspace projection using qr(.,0)
            [V_LOL, R] = qr([delta,V(:,1:k-1)],0);           % TODO: should test for full rank
            Proj{i}.Vhat = V_LOL';
            Proj{i}.time = toc + times.svd;
        case 'SLOL' % subspace projection using qr(.,0)
            [V_LOL, R] = qr([sdelta,V(:,1:k-1)],0);           % TODO: should test for full rank
            Proj{i}.Vhat = V_LOL';
            Proj{i}.time = toc + times.svd;
        case 'RDA'
            [V_RDA, R] = qr(randn(D,k),0);
            Proj{i}.Vhat=V_RDA';
            Proj{i}.time = toc;
        case 'DRDA'
            [V_RRDA, R] = qr([delta randn(D,k-1)],0);
            Proj{i}.Vhat=V_RRDA';
            Proj{i}.time = toc;
        case 'delta'
            Proj{i}.Vhat=delta;
            Proj{i}.time=toc;
        case 'sdelta'
            Proj{i}.Vhat=sdelta;
            Proj{i}.time=toc;
        case 'QOL'
            tic
            
            mu0 = mean(X(:,Y==0),2);
            X0_centered = bsxfun(@minus,X(:,Y==0),mu0);

            mu1 = mean(X(:,Y==1),2);
            X1_centered = bsxfun(@minus,X(:,Y==1),mu1);

            [~,d0,V0] = svd(X0_centered',0);
            [~,d1,V1] = svd(X1_centered',0);
            dd=[diag(d0); diag(d1)];
            [~, idx]=sort(dd,'descend');
            VV=[V0,V1];
            if k<length(idx), idx(k+1:end)=[]; end
            V=[delta, VV(:,idx(1:end-1))];
            [V_QOL, R] = qr(V,0);           % TODO: should test for full rank
            Proj{i}.Vhat = V_QOL';
            Proj{i}.d0=diag(d0)/sqrt(n);
            Proj{i}.d1=diag(d1)/sqrt(n);
            Proj{i}.time = toc;
        case 'LDA'
            Proj{i}.Vhat=eye(D);
            Proj{i}.time = toc;
        case 'treebagger'
            Proj{i}.Vhat=eye(D);
            Proj{i}.time = toc;
    end
    Proj{i}.alg = alg;
end

