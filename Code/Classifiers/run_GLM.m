function [out, GLM_num, fit] = run_GLM(Z,task)

opts=struct('nlambda',task.Nks);
if max(Z.Ytrain)==9
    Z.Ytest=Z.Ytest+1;
    Z.Ytrain=Z.Ytrain+1;
end
fit=glmnet(Z.Xtrain',Z.Ytrain,'multinomial',opts);
pfit=glmnetPredict(fit,Z.Xtest',fit.lambda,'response','false',fit.offset);
[~,yhat]=max(pfit,[],2);
Yhat_GLM{1}=squeeze(yhat)';
out=get_task_stats(Yhat_GLM,Z.Ytest);
siz=size(fit.beta{1});
GLM_num=zeros(siz(2),1);
for i=1:length(fit.beta)
    for j=1:siz(2)
        GLM_num(j)=GLM_num(j)+length(find(fit.beta{i}(:,j)>0));
    end
end