function [Proj, P, Q] = LOL(X,Y,types,Kmax)
% learn linear-optimal-low-rank discriminant subspace under a variety of
% differnt models
%
% INPUT:
%   X in R^{D x ntrain}: ntrain columns, each a D-dimensional example
%   Y in [K]^ntrain: a categorical vector assigning each training sample a class
%   types in cell: each element lists a different embedding type
%       D/S/N: delta, sparse, or no delta matrix
%       E/V/R/N: equal, varied, random, or no projection
%       F/R/N: fast, robust, normal
%   Kmax in Z: max dimension to project into
% 
% OUTPUT:
%   Proj (struct): one per types, with fields
%       name (char): name of projection
%       V (R^{Kmax x D}: projection matrix
%   P (struct): of parameters, including
%       Ngroups (int): # of groups
%       groups (vec): name of groups (can be all ints or possibly chars, tho i've never tested that
%       nvec (int^Ngroups): # of points per class
%       idx (cell(Ngroups,1)): list of indices for each group 
%       mu in R^{D x Ngroups}: means
%       Delta in R^{D x (Ngroups-1)}: means minus first mean
%       Selta in R^{D x (Ngroups-1)}: sparse version
%       DEN/DVN: eigenvalues for equal/varied subspace assumptions
%   Q (struct): containing eigenvectors

%% get means
ntypes=length(types);
P.groups=unique(Y);
if any(isnan(P.groups)), P.groups(isnan(P.groups))=[]; P.groups=[P.groups; NaN]; end % remove nan groups from mean (NB: NaN~=NaN)
P.Ngroups=length(P.groups);
[D,n]=size(X);
if n~=length(Y), X=X'; [D,n]=size(X); end
P.nvec=nan(P.Ngroups,1);
P.mu=nan(D,P.Ngroups);
idx=cell(P.Ngroups,1);
for k=1:P.Ngroups
    idx{k}=find(Y==P.groups(k));
    if isempty(idx{k}), idx{k}=find(isnan(Y)); end % for the NaN's
    P.nvec(k)=length(idx{k});
    P.mu(:,k)=mean(X(:,idx{k}),2);
    X(:,idx{k})=bsxfun(@minus,X(:,idx{k}),P.mu(:,k));
end
% sort classes in order of # of samples per class
[~, IX] = sort(P.nvec);
P.nvec=P.nvec(IX);
P.groups=P.groups(IX);
P.mu=P.mu(:,IX);
for k=1:P.Ngroups, P.idx{k}=idx{IX(k)}; end
if nargin<4, Kmax=min(n,D); end

%% get delta matrices & eigenvectors (or approximations thereof)

for i=1:ntypes
    
    % get diff bases
    if strcmp(types{i}(1),'D')
        if ~isfield(P,'Delta')
            P.Delta = bsxfun(@minus,P.mu(:,2:end),P.mu(:,1));
        end
    elseif strcmp(types{i}(1),'S')
        if ~isfield(P,'Selta')
            [~,idx] = sort(abs(P.delta),'descend');
            P.Selta=P.delta;
            P.Selta(idx(10:end))=0;
        end
    end
    
    % get 'eigs'
    if strcmp(types{i}(2),'E')
        if ~isfield(X,['VE',types{i}(3)])
            [P.(['DE', types{i}(3)]),Q.(['VE', types{i}(3)])] = get_svd(X,n,D,types{i}(3));
        end
    elseif strcmp(types{i}(2),'V')
        if ~isfield(X,['VV',types{i}(3)])
            dv=[]; Vv=[];
            for k=1:P.Ngroups
                [d,V] = get_svd(X(:,P.idx{k}),P.nvec(k),D,types{i}(3));
                dv = [dv; d]; 
                Vv = [Vv, V'];
            end
            [P.(['DV', types{i}(3)]), idx]=sort(dv,'descend');
            Q.(['VV', types{i}(3)])=Vv(:,idx)';
        end
    elseif strcmp(types{i}(2),'R')
        if ~isfield(Q,'VR')
            Q.VR = rand(D,Kmax)';
        end
    elseif strcmp(types{i}(2),'N')
        if ~isfield(Q,'VN')
            Q.VN = eye(D);
        end
    end
end


%% generate projection matrices
Proj=cell(1:ntypes);
for i=1:ntypes
    if ~strcmp(types{i}(1),'N') % if we are appending something to "eigenvectors"
        [V, ~] = qr([P.([types{i}(1), 'elta']),Q.(['V', types{i}(2), types{i}(3)])'],0);
    elseif strcmp(types{i}(1),'N')
        V=Q.(['V', types{i}(2), types{i}(3)])';
    end
    if Kmax>size(V,1), Kmax=siz(1); end
    Proj{i}.V = V(:,1:Kmax)';
    Proj{i}.name=types{i};
end


function [d,V] = get_svd(X,n,D,type)

if strcmp(type,'N')
    if n>D, [~,d,V] = svd(X',0);
    else [V,d,~] = svd(X,0);
    end
    d=diag(d);
elseif strcmp(type,'F')
    if n>D, [~,d,V] = fsvd(X',min(n,D));
    else [V,d,~] = fsvd(X,min(n,D));
    end
elseif strcmp(type,'R')
    if n>D, cov = m_estimator_gms(X');
    else cov = m_estimator_gms(X);
    end
    [V,d]= eig(cov);
    d=diag(d);
end
V=V';
