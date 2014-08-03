function [out] = run_RF(Z)

B = TreeBagger(100,Z.Xtrain',Z.Ytrain);
[~, scores] = predict(B,Z.Xtest');
[~,Yhat_RF{1}] = max(scores,[],2);
out=get_task_stats(Yhat_RF,Z.Ytest);
