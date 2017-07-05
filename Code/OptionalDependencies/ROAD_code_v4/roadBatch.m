function [obj] = roadBatch(x, y, xtest, ytest, droad, sroad, para)
if(nargin<6)
    sroad=0;
end
if(nargin<5)
    droad=0;
end
if(nargin<7)
    fit = road(x,y,droad,sroad);
else
    fit = road(x,y,droad,sroad,para);
end
fitCV = roadCV(x,y,fit);
[trainclass, trainclassAll] = roadPredict(x, fit, fitCV);
obj.trainError = mean(trainclass~=y);
[class, classAll] = roadPredict(xtest, fit, fitCV);
obj.testError = mean(class~=ytest);
obj.w = fitCV.w;
obj.wPath = fit.wPath;
obj.lamList = fit.lamList;
obj.num = fitCV.num;
obj.lamind = fitCV.lamind;
obj.cvError = fitCV.error(fitCV.lamind);
obj.allCvError =  fitCV.error;
obj.allTestError =  mean(classAll~=repmat(ytest,1,fit.para.K));





