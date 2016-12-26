function [Pro, out] = run_eigenfaces(Z,task)


mu=mean(Z.Xtrain,2);
Xtrain = bsxfun(@minus,Z.Xtrain,mu);
[U, ~, ~] = svd(Xtrain,'econ');

Xtest=Z.Xtest'*U;
Xtrain=Z.Xtrain'*U;
Yhat{1} = decide(Xtest',Xtrain,Z.Ytrain,'linear',task.ks);
out=get_task_stats(Yhat,Z.Ytest);

Pro=U';