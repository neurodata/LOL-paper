function [Xtrain,Ytrain,Xtest,Ytest,D,ntrain,ntest] = load_data(setting,ntest)


switch setting
    case {'rtrunk','toeplitz','3trunk4','3trunk'}
        D=100; ntrain=100;
        [Xtrain,Ytrain,Xtest,Ytest] = load_gmm(setting,D,ntrain,ntest);
    case 'fat_tails'
        D=1000; ntrain=100;
        [Xtrain,Ytrain,Xtest,Ytest] = fat_tails(D,ntrain,ntest);
    case 'xor2'
        D=100; ntrain=100;
        [Xtrain,Ytrain,Xtest,Ytest] = xor2(D,ntrain,ntest);
    case 'outliers'
        D=100; ntrain=100;
        [Xtrain,Ytrain,Xtest,Ytest] = outliers(D,ntrain,ntest);
    case {'prostate','colon','MNIST','CIFAR-10'}
        [Xtrain,Ytrain,Xtest,Ytest,D,ntrain,ntest]=load_data2(setting);
end
