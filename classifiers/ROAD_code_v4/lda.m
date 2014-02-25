function [obj] = lda(x, y, xtest, ytest)
[mua, mud, Sigma, x1, x2, n1, n2] = stat(x, y);
v = Sigma\mud;

yTrainPred = (Sigma\mud)'*(x-repmat(mua',size(x,1),1))'>0;

yTestPred = (Sigma\mud)'*(xtest-repmat(mua',size(xtest,1),1))'>0;

obj.trainError = mean(yTrainPred~=y');
obj.testError = mean(yTestPred~=ytest');

obj.w = v;
obj.num = sum(v~=0);





