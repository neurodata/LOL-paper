function [sROAD1fit, sROAD2fit, ROADfit] = analyzeReal(traindata, testdata)

%%%%traindata: ntrain*(p+1) matrix, last column class labels ,0 and 1
%%%%testdata: ntest*(p+1) matrix, last column class labels ,0 and 1
data = [traindata ;testdata];
trlab = traindata(:,end);
telab = testdata(:,end);
data = data(:,1:(end-1));
n1Train = sum(trlab==0);
n2Train = sum(trlab==1);
n1Test = sum(telab==0);
n2Test = sum(telab==1);
if(n1Train+n2Train+n1Test+n2Test~=size(data,1))
    error('The labeling has problem, must be 0 for the first class and 1 for the second class');
end



[n p] = size(data);
dataMean = mean(data,2);
dataStd = std(data,0,2);

normData = (data-repmat(dataMean,1,p))./repmat(dataStd,1,p);

nTrain = n1Train + n2Train;
nTest = n1Test + n2Test;


Y1Train = normData(1:n1Train,:);
Y2Train = normData((n1Train+1):nTrain, :);

Y1Test = normData((nTrain+1):(nTrain+n1Test),:);
Y2Test = normData((n-n2Test+1):n,:);


x = [Y1Train;Y2Train];

y = [zeros(n1Train,1);ones(n2Train,1)];


xtest = [Y1Test;Y2Test];
ytest = [zeros(n1Test,1);ones(n2Test,1)];

para.epsilon=1e-4;
para.K=200;
para.alpha=0;
para.nfold=5;

[ROADfit] = roadBatch(x, y, xtest, ytest, 0, 0,para);
[sROAD1fit] = roadBatch(x, y, xtest, ytest, 0, 1,para);
[sROAD2fit] = roadBatch(x, y, xtest, ytest, 0, 2,para);



ROADfit.cvError = nTrain *ROADfit.cvError;
sROAD1fit.cvError = nTrain *sROAD1fit.cvError;
sROAD2fit.cvError = nTrain *sROAD2fit.cvError;

ROADfit.trainError = nTrain *ROADfit.trainError;
sROAD1fit.trainError = nTrain *sROAD1fit.trainError;
sROAD2fit.trainError = nTrain *sROAD2fit.trainError;


ROADfit.testError = nTest *ROADfit.testError;
sROAD1fit.testError = nTest *sROAD1fit.testError;
sROAD2fit.testError = nTest *sROAD2fit.testError;

