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


%% get means
ntypes=length(types);
P.groups=unique(Y);
P.Ngroups=length(P.groups);
[P.D,P.n]=size(X);
if P.n~=length(Y), X=X'; [P.D,P.n]=size(X); end
P.nvec=nan(P.Ngroups,1);
P.mu=nan(P.D,P.Ngroups);
idx=cell(P.Ngroups,1);
for k=1:P.Ngroups
    idx{k}=find(Y==P.groups(k));
    P.nvec(k)=length(idx{k});
    P.mu(:,k)=mean(X(:,idx{k}),2);
    X(:,idx{k})=bsxfun(@minus,X(:,idx{k}),P.mu(:,k));
end
% resort in order of # of samples per class
[~, IX] = sort(P.nvec);
P.nvec=P.nvec(IX);
P.groups=P.groups(IX);
P.mu=P.mu(:,IX);
for k=1:P.Ngroups, P.idx{k}=idx{IX(k)}; end
if nargin<4, Kmax=min(P.n,P.D); end

% %% get delta matrix (in R^{D x K-1}
% Ds=nan(ntypes,1);
% for i=1:ntypes, Ds(i)=types{i}(1); end; Ds=char(Ds)';
% if any(strfind(Ds,'D')),
%     if any(isnan(P.groups)),
%         nangroup= isnan(P.groups);
%         mu=P.mu;
%         mu(:,nangroup)=[];
%         P.groups(nangroup)=[];
%         P.Ngroups=length(P.groups);
%     else
%         mu=P.mu;
%     end
%     P.Delta=bsxfun(@minus,mu(:,2:end),mu(:,1));
% end
% 
% if any(strfind(Ds,'S')),
%     [~,idx] = sort(abs(P.delta),'descend');
%     P.Selta=P.delta;
%     P.Selta(idx(10:end))=0;
% end

%% get delta matrices & eigenvectors (or approximations thereof)

for i=1:ntypes
    
    % get deltas
    if strcmp(types{i}(1),'D')
        if ~isfield(P,'Delta')
            if any(isnan(P.groups)),
                nangroup = isnan(P.groups);
                mu = P.mu;
                mu(:,nangroup)=[];
                P.groups(nangroup)=[];
                P.Ngroups=length(P.groups);
            else
                mu = P.mu;
            end
            P.Delta = bsxfun(@minus,mu(:,2:end),mu(:,1));
        end
    elseif strcmp(types{i}(1),'D')
        if ~isfield(P,'Selta')
            
            [~,idx] = sort(abs(P.delta),'descend');
            P.Selta=P.delta;
            P.Selta(idx(10:end))=0;
        end
    end
    
    % get 'eigs'
    if strcmp(types{i}(2),'E')
        if ~isfield(X,['VE',types{i}(3)])
            [P.(['DE', types{i}(3)]),X.(['VE', types{i}(3)])] = get_svd(X,P.n,P.D,types{i}(3));
        end
    elseif strcmp(types{i}(2),'V')
        if ~isfield(X,['VV',types{i}(3)])
            dv=[]; Vv=[];
            for k=1:P.Ngroups
                [d,V] = get_svd(X(:,P.idx{k}),P.nvec(k),P.D,types{i}(3));
                dv = [dv; d];
                Vv = [Vv, V'];
            end
            [P.(['DV', types{i}(3)]), idx]=sort(dv,'descend');
            X.(['VV', types{i}(3)])=Vv(:,idx)';
        end
    elseif strcmp(types{i}(2),'R')
        if ~isfield(X,'VR')
            X.VR = rand(P.D,Kmax)';
        end
    elseif strcmp(types{i}(2),'N')
        if ~isfield(X,'VN')
            X.VN = eye(P.D);
        end
    end
end

% Vs=nan(ntypes,1);  for i=1:ntypes, Vs(i)=types{i}(2); end; Vs=char(Vs)';
% Fs=nan(ntypes,1); for i=1:ntypes, Fs(i)=types{i}(3); end; Fs=char(Fs)'; % whether to go fast or normal
%
%     get_Equal_Subspaces=true;
%     get_EN=false; get_EF=false;
%     if any(strfind(Fs,'N')),
%         get_EN = true;
%     end
%     if any(strfind(Fs,'F')),
%         get_EF = true;
%     end
%     if any(strfind(Fs,'F')),
%         get_EF = true;
%     end
% else
%     get_Equal_Subspaces=false;
% end
%
% if any(strfind(Vs,'V')), get_Varied_Subspaces=true; else get_Varied_Subspaces=false; end
% if any(strfind(Vs,'R')), get_Random_Subspaces=true; else get_Random_Subspaces=false; end
% if any(strfind(Vs,'N')), no_embed = true;           else no_embed=false; end
%
% % if subspaces are shared
% if get_Equal_Subspaces
%     if get_EN==true
%         [P.ds,Ve] = get_svd(X,P.n,P.D,'N');
%     end
%     if get_EF==true
%         [P.dsf,Vef] = get_svd(X,P.n,P.D,'F');
%     end
%     if get_ER==true
%         [P.dsr,Ver] = get_svd(X,P.n,P.D,'R');
%     end
% end
%
% if subspace is random
% if get_Random_Subspaces
%     Vr = rand(P.D,Kmax)';
% end
%
% if no_embed,
%     Vn=eye(P.D);
% end
%
% % if each class has its own subspace
% if get_Varied_Subspaces
%     dv=[]; Vv=[];
%     for k=1:P.Ngroups
%         [d,V] = get_svd(X(:,P.idx{k}),P.nvec(k),P.D,'N');
%         dv = [dv; d];
%         Vv = [Vv, V'];
%     end
%     [P.dv, idx]=sort(dv,'descend');
%     Vv=Vv(:,idx)';
% end

%% generate projection matrices
Proj=cell(1:ntypes);
for i=1:ntypes
    if ~strcmp(types{i}(1),'N') % if we are appending something to "eigenvectors"
        [V, ~] = qr([P.([types{i}(1), 'elta']),X.(['V', types{i}(2), types{i}(3)])'],0);
        %         if strcmp(types{i}(1),'D'),
        %             delta = P.delta;
        %         elseif strcmp(types{i}(1),'S')
        %             delta = P.sdelta;
        %         else
        %             error('no particular delta specified')
        %         end
        %
        %             if strcmp(types{i}(3),'N')
        %                 [V, ~] = qr([delta,Ve'],0);
        %             elseif strcmp(types{i}(3),'F')
        %                 [V, ~] = qr([delta,Vef'],0);
        %             end
        %         elseif strcmp(types{i}(2),'V')
        %             [V, ~] = qr([delta,Vv'],0);
        %         elseif strcmp(types{i}(2),'R')
        %             [V, ~] = qr([delta,Vr'],0);
        %         elseif strcmp(types{i}(2),'N')
        %             [V, ~] = qr([delta,Vn'],0);
        %         end
        siz=size(V);
        if Kmax>siz(1), temp=siz(1); else temp=Kmax; end
        Proj{i}.V = V(:,1:temp)';
    elseif strcmp(types{i}(1),'N')
        V=X.(['V', types{i}(2), types{i}(3)]);
        siz=size(V);
        if Kmax>siz(1), temp=siz(1); else temp=Kmax; end
        Proj{i}.V=V(1:temp,:);
        %         if strcmp(types{i}(2),'E')
        %             siz=size(Ve);
        %             if Kmax>siz(1), temp=siz(1); else temp=Kmax; end
        %             if strcmp(types{i}(3),'N')
        %                 Proj{i}.V=Ve(1:temp,:);
        %             elseif strcmp(types{i}(3),'F')
        %                 Proj{i}.V=Vef(1:temp,:);
        %             end
        %         elseif strcmp(types{i}(2),'V')
        %             siz=size(Vv);
        %             if Kmax>siz(1), temp=siz(1); else temp=Kmax; end
        %             Proj{i}.V=Vv(1:temp,:);
        %         elseif strcmp(types{i}(2),'R')
        %             siz=size(Vr);
        %             if Kmax>siz(1), temp=siz(1); else temp=Kmax; end
        %             Proj{i}.V=Vr(1:temp,:);
        %         elseif strcmp(types{i}(2),'N')
        %             siz=size(Vn);
        %             if Kmax>siz(1), temp=siz(1); else temp=Kmax; end
        %             Proj{i}.V=Vn(1:temp,:);
        %         end
        
    end
    Proj{i}.name=types{i};
end


function [d,V] = get_svd(X,n,D,type)

if strcmp(type,'N')
    if n>D
        [~,d,V] = svd(X',0);
    else
        [V,d,~] = svd(X,0);
    end
    d=diag(d);
    
elseif strcmp(type,'F')
    if n>D
        [~,d,V] = fsvd(X',min(n,D));
    else
        [V,d,~] = fsvd(X,min(n,D));
    end
    
elseif strcmp(type,'R')
    if n>D
        cov = m_estimator_gms(X);
    else
        cov = m_estimator_gms(X');
    end
    [d,V]= eig(cov);
end

V=V';
