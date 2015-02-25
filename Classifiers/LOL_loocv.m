function [Lhat, Yhats] = LOL_loocv(X,Y,parms)
% this function performs leave-one-out cross-validation for LOL

n=length(Y);
[N,~]=size(X);
if N~=n
    X=X';
    [n,~]=size(X);
end
if nargin==2, parms=struct; end
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

for i=1:n
    for j=1:length(parms.types)
        for k=1:length(parms.ks)
            disagree(i,j,k) = Yhats{i}{j}(k)~=Y(i);
        end
    end
end

Lhats=squeeze(mean(disagree,1));