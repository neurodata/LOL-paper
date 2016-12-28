function [Xtrain,Ytrain,Xtest,Ytest] = load_gmm(setting,D,ntrain,ntest)

switch setting
    case 'rtrunk'
        [mu,Sigma]=rtrunk(D);
    case 'toeplitz'
        [mu,Sigma]=toep(D);
    case '3trunk4'
        [mu,Sigma] = rtrunk(D,6,1,3);
end

[Xtrain,Ytrain,Xtest,Ytest]=gmmsample(mu,Sigma,ntrain,ntest);
