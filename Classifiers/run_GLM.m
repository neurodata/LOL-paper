function out = run_GLM(Z,task)

opts=struct('nlambda',task.Nks);
fit=glmnet(Z.Xtrain',Z.Ytrain,'multinomial',opts);
pfit=glmnetPredict(fit,Z.Xtest',fit.lambda,'response','false',fit.offset);
[~,yhat]=max(pfit,[],2);
Yhat_GLM{1}=squeeze(yhat)';
out=get_task_stats(Yhat_GLM,Z.Ytest);
