function [out, ROAD_num,Yhat,eta] = run_ROAD(Z,task)

para.K=task.Nks;
% if min(Z.Ytrain)==1, 
%     Z.Ytest=Z.Ytest-1;
%     Z.Ytrain=Z.Ytrain-1;
% end
% if max(Z.Ytrain)>1
ys=unique(Z.Ytrain);
if length(ys)>2, 
    error('ROAD only works for 2 class problems'), 
else % convert ys to be 0 & 1, as ROAD requires
    Z.Ytrain(Z.Ytrain==ys(1))=0;
    Z.Ytrain(Z.Ytrain==ys(2))=1;
    
    Z.Ytest(Z.Ytest==ys(1))=0;
    Z.Ytest(Z.Ytest==ys(2))=1;
end
% end
%% normalize X by converting to z-scores
Xmean=mean(Z.Xtrain')';
Xtrain=bsxfun(@minus,Z.Xtrain,Xmean);
Xtest=bsxfun(@minus,Z.Xtest,Xmean);

Xstd=std(Z.Xtrain,[],2);
Xtrain=bsxfun(@rdivide,Xtrain,Xstd);
Xtest=bsxfun(@rdivide,Xtest,Xstd);
%%

fit = road(Xtrain', Z.Ytrain,0,0,para);
[~,Yhat,eta] = roadPredict(Xtest', fit);
Yhat_ROAD{1}=Yhat';
out=get_task_stats(Yhat_ROAD,Z.Ytest);
ROAD_num=fit.num;
