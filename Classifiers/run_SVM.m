function out = run_SVM(Z,Nks)
% this runs the libsvm package, since the matlab one doesn't do multiple
% classes and did not its output no matter how i changed the boxconstraint

%% scale data for svm (useful for libsvm, maybe the others too)

Xmin=min(Z.Xtrain(:));
Z.Xtrain=Z.Xtrain-Xmin;
Z.Xtest=Z.Xtest-Xmin;

Xmax=max(Z.Xtrain(:));
Z.Xtrain=Z.Xtrain/Xmax;
Z.Xtest=Z.Xtest/Xmax;


%% run svm
cvec=2.^linspace(-6,25,Nks);
yhat=nan(Nks,length(Z.Ytest));
for c=1:Nks
    model = svmtrain(Z.Ytrain,Z.Xtrain',['-c ', num2str(cvec(c))]);
    yhat(c,:) = svmpredict(Z.Ytest, Z.Xtest', model);
end
Yhat{1}=yhat;
out=get_task_stats(Yhat,Z.Ytest);
