function out = run_DR(Z,task)

[~,W] = DR(Z.Ytrain,Z.Xtrain','disc',task.Kmax);
Xtest=Z.Xtest'*W;
Xtrain=Z.Xtrain'*W;
Yhat_DR{1} = decide(Xtest',Xtrain,Z.Ytrain,'linear',task.ks);
out=get_task_stats(Yhat_DR,Z.Ytest);