function [out] = run_RF(Z)

if max(Z.Ytrain)==9, 
    Z.Ytest=Z.Ytest+1;
    Z.Ytrain=Z.Ytrain+1;
end
B = TreeBagger(100,Z.Xtrain',Z.Ytrain);
[~, scores] = predict(B,Z.Xtest');
[~,Yhat_RF{1}] = max(scores,[],2);
out=get_task_stats(Yhat_RF,Z.Ytest');
