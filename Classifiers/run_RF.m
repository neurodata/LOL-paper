function [out] = run_RF(Z)

B = TreeBagger(100,Z.Xtrain',Z.Ytrain);
[~, scores] = predict(B,Z.Xtest');
Yhat_RF{1} = [scores(:,1)<scores(:,2)]'+1;
out=get_task_stats(Yhat_RF,Z.Ytest);
