function [Proj, P] = LOL(X,Y,types,Kmax)
% learn linear-optimal-low-rank discriminant subspace under a variety of
% differnt models
%
% INPUT:
%   X in R^{D x ntrain}: ntrain columns, each a D-dimensional example
%   Y in [K]^ntrain: a categorical vector assigning each training sample a class
%   types in cell: each element lists a different embedding type
%       D/N: whether or not to include a delta matrix
%       E/V/R/N: equal, varied, random, or no projection
%       F/R/N: fast, robust, normal
% Kmax in Z: max dimension to project into
% 
% DENL = LOL
% NENL = PDA
% NNNL = LDA
% 

%% get means
ntypes=length(types);
P.groups=unique(Y);
P.Ngroups=length(P.groups);
[P.D,P.n]=size(X);
P.nvec=nan(P.Ngroups,1);
P.mu=nan(P.D,P.Ngroups);
for k=1:P.Ngroups
    k_idx=find(Y==P.groups(k));
    P.nvec(k)=length(k_idx);
    P.mu(:,k)=mean(X(:,k_idx),2);
end
[~, IX] = sort(P.nvec);
P.nvec=P.nvec(IX);
P.groups=P.groups(IX);

%% get delta matrix (in R^{D x K-1}
Ds=nan(ntypes,1);
for i=1:ntypes, Ds(i)=types{i}(1); end; Ds=char(Ds)';
if any(strfind(Ds,'D')),
    P.delta=bsxfun(@minus,P.mu(:,2:end),P.mu(:,1));
end

%% get eigenvectors (or approximations thereof)
Vs=nan(ntypes,1);
for i=1:ntypes, Vs(i)=types{i}(2); end; Vs=char(Vs)';
if any(strfind(Vs,'E')), get_Equal_Subspaces=true; else get_Equal_Subspaces=false; end
if any(strfind(Vs,'V')), get_Varied_Subspaces=true; else get_Varied_Subspaces=false; end
if any(strfind(Vs,'R')), get_Random_Subspaces=true; else get_Random_Subspaces=false; end


% if subspaces are shared
if get_Equal_Subspaces
    X_centered=nan(size(X));
    for k=1:P.Ngroups
        k_idx=find(Y==P.groups(k));
        P.nvec(k)=length(k_idx);
        Xtemp=X(:,k_idx);
        P.mu(:,k)=mean(Xtemp,2);
        temp=[0; P.nvec(1:k)];
        X_centered(:,sum(temp(1:k))+1:sum(temp(1:k+1)))=bsxfun(@minus,Xtemp,P.mu(:,k));
    end
    [P.ds,P.Ve] = get_svd(X_centered,P.n,P.D,'N');
end


% if subspace is random
if get_Random_Subspaces
    d=min(P.D,P.n);
    P.Vr = rand(P.D,d);
end

% if each class has its own subspace
if get_Varied_Subspaces
    %     X_centered=nan(size(X));
    %     for k=1:P.Ngroups
    %         k_idx=find(Y==P.groups(k));
    %         P.nvec(k)=length(k_idx);
    %         Xtemp=X(:,k_idx);
    %         P.mu(:,k)=mean(Xtemp,2);
    %         temp=[0; P.nvec(1:k)];
    %         X_centered(:,sum(temp(1:k))+1:sum(temp(1:k+1)))=bsxfun(@minus,Xtemp,P.mu(:,k));
    %     end
end


%% generate projection matrices
Proj=cell(1:ntypes);
for i=1:ntypes
    if strcmp(types{i}(1:2),'DE')
        [V, ~] = qr([P.delta';P.Ve(1:end-1,:)]',0);
        Proj{i}.V = V(:,1:Kmax)';
    elseif strcmp(types{i}(1:2),'DV')
        [V, ~] = qr([P.delta';P.Vv(1:end-1,:)]',0);
        Proj{i}.V=V(:,1:Kmax)';
    elseif strcmp(types{i}(1:2),'DR')
        try
        [V, ~] = qr([P.delta';P.Vr(:,1:end-1)']',0);
        catch
            keyboard
        end
        Proj{i}.V=V(:,1:Kmax)';        

    elseif strcmp(types{i}(1:2),'NE')
        Proj{i}.V=P.Ve(1:Kmax,:);
    elseif strcmp(types{i}(1:2),'NV')
        Proj{i}.V=P.Ve(:,1:Kmax)';
    elseif strcmp(types{i}(1:2),'NR')
        Proj{i}.V=P.Vr(:,1:Kmax)';
    elseif strcmp(types{i}(1:2),'NN')
        Proj{i}.V=eye(P.D);
    end
    Proj{i}.name=types{i};
end


function [d,V] = get_svd(X,n,D,type)

if strcmp(type,'N')
    if n>D
        [~,d,V] = svd(X',0);
    else
        [V,d,~] = svd(X,0);
        V=V';
    end
    
elseif strcmp(type,'F')
    if n>D
        [~,d,V] = fsvd(X',min(n,D));
    else
        [V,d,~] = svd(X,min(n,D));
        V=V';
    end
    
elseif strcmp(type,'R')
    
end