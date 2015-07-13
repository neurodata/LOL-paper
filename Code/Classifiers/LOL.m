function [Proj, P, Q] = LOL(X,Y,types,Kmax)
% learn linear-optimal-low-rank discriminant subspace under a variety of
% differnt models
%
% INPUT:
%   X in R^{D x ntrain}: ntrain columns, each a D-dimensional example
%   Y in [K]^ntrain: a categorical vector assigning each training sample a class
%   types in cell: each element lists a different embedding type (see below for details)
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
%       Ytiles in R^10: 0.1:0.1:1 percentiles of Y
%   Q (struct): containing eigenvectors

% CODE FOR TYPES: each type is a 3 letter code: ABC
%   A: kind of difference matrix (D=delta, N=none, R=robust, S=sparse)
%   B: whether to share covariance matrices (E=equal, V=varied)
%   C: how to compute/approximate eigenvectors (N=normal, F=fast, R=robust, A=random)

%% check and make sure inputs are all correct

[D,n]=size(X);
if n~=length(Y), X=X'; [D,n]=size(X); end
ntypes=length(types);
for i=1:ntypes
    if isempty(strfind('TDRNS',types{i}(1))), error('failed to specify a legit estimator of delta'), end
    if isempty(strfind('EV',types{i}(2))), error('failed to specify a legit equal/varied subspace'), end
    if isempty(strfind('NFRA',types{i}(3))), error('failed to specify a legit approx to eigenvectors'), end
end
Kmax=round(Kmax);

%% check if regression, if so, convert to classification
ngroups=length(unique(Y));
df=0.1;
if ngroups > length(Y)/2
    P.Ytiles=quantile(Y,linspace(df,1,1/df));
    YY=0*Y;
    yind=Y<P.Ytiles(1);
    YY(yind)=1;
    for j=2:length(P.Ytiles)
        yind=Y<P.Ytiles(j) & Y>P.Ytiles(j-1);
        YY(yind)=j;
    end
    Y=YY;
end

%% get means
Q=struct;
if iscell(Y)
    Yu=unique(Y);
    for i=1:length(Yu)
        for j=1:length(Y)
            if strcmp(Y(j),Yu(i))
                groups(j)=i;
            end
        end
    end
    Y=groups;
end
P.groups=unique(Y);

if any(isnan(P.groups)), P.groups(isnan(P.groups))=[]; P.groups=[P.groups; NaN]; end % remove nan groups from mean (NB: NaN~=NaN)
P.Ngroups=length(P.groups);
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
min_Ny=min(P.nvec);
P.groups=P.groups(IX);
P.mu=P.mu(:,IX);
for k=1:P.Ngroups, P.idx{k}=idx{IX(k)}; end
if nargin<4, Kmax=min(n,D); end

%% get delta matrices & eigenvectors (or approximations thereof)

for i=1:ntypes
    
    % get diff bases
    if strcmp(types{i}(1),'D')      % default estimate of the different of the means
        if ~isfield(P,'Delta')
            P.Delta = bsxfun(@minus,P.mu(:,2:end),P.mu(:,1));
        end
    elseif strcmp(types{i}(1),'S') % sparse estimate of difference of means
        if ~isfield(P,'Selta')
            [~,idx] = sort(abs(P.delta),'descend');
            P.Selta=P.delta;
            P.Selta(idx(10:end))=0;
        end
    elseif strcmp(types{i}(1),'R') % robust estimate of difference of means
        P.robustmean=nan(D,P.Ngroups);
        for k=1:P.Ngroups
            %             P.robustmean(:,k)=median(X(:,idx{k})',1);
            P.robustmean(:,k)=trimmean(X(:,idx{k})',10);
        end
        P.Relta = bsxfun(@minus,P.robustmean(:,2:end),P.robustmean(:,1));
    elseif strcmp(types{i}(1),'T')      % default estimate of the different of the means
        if ~isfield(P,'Telta')
            P.Telta = bsxfun(@minus,P.mu(:,2:end),P.mu(:,1));
            P.Telta = P.Telta./std(P.mu,[],2);
        end
    end
    
    % get 'eigs'
    if strcmp(types{i}(2),'E')      % equal covariances
        if ~isfield(X,['VE',types{i}(3)])
            [P.(['DE', types{i}(3)]),Q.(['VE', types{i}(3)])] = get_svd(X,n,D,types{i}(3),Kmax);
        end
    elseif strcmp(types{i}(2),'V')  % varied covariances
        if ~isfield(X,['VV',types{i}(3)])
            dv=[]; Vv=[];
            for k=1:P.Ngroups
                [d,V] = get_svd(X(:,P.idx{k}),min_Ny,D,types{i}(3),ceil(Kmax/P.Ngroups));
                dv = [dv; d];
                Vv = [Vv, V'];
            end
            [P.(['DV', types{i}(3)]), idx]=sort(dv,'descend');
            Q.(['VV', types{i}(3)])=Vv(:,idx)';
        end
    end
end


%% generate projection matrices
Proj=cell(1:ntypes);
for i=1:ntypes
    if ~strcmp(types{i}(1),'N')     % if we are appending something to "eigenvectors"
%         [V, ~] = qr([P.([types{i}(1), 'elta']),Q.(['V', types{i}(2), types{i}(3)])'],0);
                V = [P.([types{i}(1), 'elta']),Q.(['V', types{i}(2), types{i}(3)])'];
    elseif strcmp(types{i}(1),'N')  % if not
        V=Q.(['V', types{i}(2), types{i}(3)])';
    end
    
    siz=size(V,2); if Kmax>siz, Kmax=siz; end
    Proj{i}.V = V(:,1:Kmax)';
    Proj{i}.name=types{i};
end


function [d,V] = get_svd(X,n,D,type,Kmax)

if strcmp(type,'N')             % normal svd, compute all eigenvectors
    if n>D, [~,d,V] = svd(X',0);
    else [V,d,~] = svd(X,0);
    end
    d=diag(d);
elseif strcmp(type,'F')         % fast svd, comput top min([n,D,Kmax]) eigvectors
    if n>D, [~,d,V] = fsvd(X',min([n,D,Kmax]));
    else [V,d,~] = fsvd(X,min([n,D,Kmax]));
    end
elseif strcmp(type,'R')         % compute all robust eigenvectors
    %     if n>D, cov = m_estimator_gms(X');
    %     else cov = m_estimator_gms(X);
    %     end
    cov = m_estimator_gms(X');
    [V,d]= eig(cov);
    d=diag(d);
elseif strcmp(type,'A')         % random projections
    V = rand(D,Kmax); d=[];
end
V=V';
