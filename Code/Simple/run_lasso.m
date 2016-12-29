function [Lhat,ks] = run_lasso(Xtrain,Xtest,Ytrain,Ytest,Nks)

%%
opts=struct('nlambda',Nks);
%             if max(Z.Ytrain)==9
%                 Z.Ytest=Z.Ytest+1;
%                 Z.Ytrain=Z.Ytrain+1;
%             end
if size(Xtrain,2)~=length(Ytrain); Xtrain=Xtrain'; end
fit=glmnet(Xtrain',Ytrain,'multinomial',opts);
pfit=glmnetPredict(fit,Xtest,fit.lambda,'response','false',fit.offset);
[~,yhat]=max(pfit,[],2);
Yhat=squeeze(yhat);
Lhat=misclass(Yhat,Ytest);
Nlam=size(fit.beta{1},2);
GLM_num=zeros(Nlam,1);
for i=1:length(fit.beta)
    for j=1:Nlam
        GLM_num(j)=GLM_num(j)+length(find(fit.beta{i}(:,j)>0));
    end
end
ks=GLM_num;