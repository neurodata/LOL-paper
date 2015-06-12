function out = run_LAD(Z,task)

[~,W] = ldr(Z.Ytrain,Z.Xtrain','LAD','disc',task.Kmax,'initval',orth(rand(task.D,task.Kmax)));
Xtest=Z.Xtest'*W;
Xtrain=Z.Xtrain'*W;
Yhat_DR{1} = decide(Xtest',Xtrain,Z.Ytrain,'linear',task.ks);
out=get_task_stats(Yhat_DR,Z.Ytest);
