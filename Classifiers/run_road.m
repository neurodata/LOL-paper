function [out, ROAD_num] = run_ROAD(Z,task)

para.K=task.Nks;
if min(Z.Ytrain)==1, 
    Z.Ytest=Z.Ytest-1;
    Z.Ytrain=Z.Ytrain-1;
end
%% normalize X by converting to z-scores
Xmean=mean(Z.Xtrain')';
Xtrain=bsxfun(@minus,Z.Xtrain,Xmean);
Xtest=bsxfun(@minus,Z.Xtest,Xmean);

Xstd=std(Z.Xtrain,[],2);
Xtrain=bsxfun(@rdivide,Z.Xtrain,Xstd);
Xtest=bsxfun(@rdivide,Z.Xtest,Xstd);
%%

fit = road(Z.Xtrain', Z.Ytrain,0,0,para);
[~,Yhat] = roadPredict(Z.Xtest', fit);
Yhat_ROAD{1}=Yhat';
out=get_task_stats(Yhat_ROAD,Z.Ytest);
ROAD_num=fit.num;
