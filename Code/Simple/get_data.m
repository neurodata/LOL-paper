function [Xtrain,Ytrain,Xtest,Ytest,D,ntrain,ntest,Lbayes,P] = get_data(setting,ntest)

Lbayes=NaN;
switch setting
    case {'rtrunk','toeplitz','3trunk4','3trunk','r2toeplitz'}
        D=100; ntrain=100;
        [Xtrain,Ytrain,Xtest,Ytest,mu,Sigma] = load_gmm(setting,D,ntrain,ntest);
        P.mu=mu; P.Sigma=Sigma;
        YBayes = gmm_predict(Xtest',Ytest,P);
        Lbayes= misclass(YBayes,Ytest);
    case 'fat_tails'
        D=1000; ntrain=100;
        [Xtrain,Ytrain,Xtest,Ytest] = fat_tails(D,ntrain,ntest);
    case 'fat_tails100'
        D=100; ntrain=100; 
        [Xtrain,Ytrain,Xtest,Ytest] = fat_tails(D,ntrain,ntest,1,15,0.2);
    case 'xor2'
        D=100; ntrain=100;
        [Xtrain,Ytrain,Xtest,Ytest] = xor2(D,ntrain,ntest);
    case 'outliers'
        D=100; ntrain=100;
        [Xtrain,Ytrain,Xtest,Ytest] = outliers(D,ntrain,ntest);
    case {'prostate','colon','MNIST','CIFAR-10'}
        [Xtrain,Ytrain,Xtest,Ytest,D,ntrain,ntest]=load_data2(setting);
end
