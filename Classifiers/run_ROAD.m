function [out, ROAD_num] = run_ROAD(Z,task)

para.K=task.Nks;
fit = road(Z.Xtrain', Z.Ytrain,0,0,para);
[~,Yhat] = roadPredict(Z.Xtest', fit);
Yhat_ROAD{1}=Yhat'+1;
out=get_task_stats(Yhat_ROAD,Z.Ytest);
ROAD_num=fit.num;
