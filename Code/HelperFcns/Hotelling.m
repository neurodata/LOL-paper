function [pval,stat,T2,T2_null,P] = Hotelling(X,Y,P)
% Hotelling T2 test
%
% INPUT
%   X in R^{n x D}: data matrix
%   Y in {0,1}^N:   vector of classes
%   P:              structure of additional parameters
%       proj:       if data were projected
%       B:          number of bootstraps for permutation test
%
% OUPUT
%   pval:   p-value
%   stat:   test statistic before multiplying by constant
%   T2:     test statistic after properly normalizing

% constants for Hotelling
if nargin==2, P=struct;                 end
if ~any(isfield(P,{'n','D'})),
    [P.n, P.D]=size(X);  % n=# samples, D=# dimensions
    if P.n~=length(Y); P.n=P.D; P.D=n; X=X'; end
end
if ~isfield(P,'n1'),    P.n1=sum(Y==1); end
if ~isfield(P,'n2'),    P.n2=P.n-P.n1;  end

% hyper-parameters necessary for projection version of Hotelling
if any(isfield(P,{'Ndim','transformers'}))
    P.proj=true;
else
    P.proj=false;
end
if ~isfield(P,'Ndim'),  P.Ndim=floor(P.n/2);            end
if ~isfield(P,'transformers'), P.transformers={'DEN'};  end

% hyper-parameter for permutation test
if ~isfield(P,'B'),     
    P.B=0;          
    T2_null=nan;
else
    T2_null=nan(P.B,1);
end

%% compute pvalue

% if P.proj==false;
    [T2, stat]=get_stat(X,Y,P);
    if P.B==0
        pval=1-fcdf(stat,P.D,P.n-P.D-1);
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%% this gets a PARFOR %%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        parfor b=1:P.B
            T2_null(b) = get_stat(X,Y(randperm(P.n)),P);
        end
        pval=sum(T2_null>T2)/P.B;
    end
    
% else % if we are projecting, because D is large
%     % get observed value of test-statistic
%     [T2, stat] = get_proj_stat(X,Y,P);
%     
%     %%  get null distribution of test statistic
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%%%%%%%% this gets a PARFOR %%%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     for b=1:P.B
%         T2_null(b) = get_proj_stat(X,Y(randperm(P.n)),P);
%     end
%     pval=sum(T2_null>T2)/P.B;
% end



end

%% compute test statistic
function [T2,stat] = get_stat(X,Y,P)

if P.proj==true
    Proj = LOL(X',Y,P.transformers,P.Ndim);
    X = X*Proj{1}.V';
    P.D=P.Ndim;
end

X1=X(Y==1,:);
X2=X(Y==2,:);

mu1=mean(X1);
mu2=mean(X2);
delta=(mu1-mu2)';

X1centered=bsxfun(@minus,X1,mu1);
X2centered=bsxfun(@minus,X2,mu2);

pooledcov=(X1centered'*X1centered+X2centered'*X2centered)/(P.n-2);

T2=(P.n1*P.n2)/P.n*delta'*pinv(pooledcov)*delta;

if P.proj==true
    constant=P.D*P.n/(P.n-P.D+1);
else
    constant=(P.n-P.D-1)/(P.D*(P.n-2));
end
stat=constant*T2;

end

% %% get proj stat
% function [T2, stat] = get_proj_stat(X,Y,P)
% 
% Proj = LOL(X',Y,P.transformers,P.Ndim);
% Xhat = X*Proj{1}.V';
% P.D=P.Ndim;
% [T2, stat]=get_stat(Xhat,Y,P);
% 
% end