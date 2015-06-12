function [Lhats, Yhats] = LOL_loocv(X,Y,parms)
% this function performs leave-one-out cross-validation for LOL


n=length(Y);
if iscell(Y) % make sure Y is numeric
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

% make sure X is the right size
[N,~]=size(X);
if N~=n
    X=X';
    [n,~]=size(X);
end

if nargin==2, parms=struct; end

% compute loo predict for all n (LOL will try multiple types & d's)
Yhats{n}=nan(n,1);
for i=1:n
   Xtrain=X;
   Xtrain(i,:)=[];
   Ytrain=Y;
   Ytrain(i)=[];
   
   Xtest=X(i,:);
   Ytest=Y(i);
    
   Yhats{i} = LOL_classify(Xtest,Xtrain,Ytrain,parms);
   
end

% compute disagreements
for i=1:n
    for j=1:length(Yhats{i})
        for k=1:length(Yhats{i}{j})
            disagree(i,j,k) = Yhats{i}{j}(k)~=Y(i);
        end
    end
end

% error rate
Lhats=squeeze(mean(disagree,1));