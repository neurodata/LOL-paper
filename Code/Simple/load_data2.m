function [Xtrain,Ytrain,Xtest,Ytest,D,ntrain,ntest]=load_data2(which)

switch which
    case 'prostate'
        data=load('../../Data/Preprocessed/prostate_data');
        X=data.X';
        Y=data.Y+1;
        [D, n] = size(X);
        ntest=round(n/3);
    case 'colon'
        data=load('../../Data/Preprocessed/colon_data');
        X=data.X';
        Y=data.Y+1;
        [D, n] = size(X);
        ntest=round(n/3);
    case 'MNIST'
        X = loadMNISTImages('../../Data/Raw/MNIST/t10k-images.idx3-ubyte');
        Y = loadMNISTLabels('../../Data/Raw/MNIST/t10k-labels.idx1-ubyte');
        [D, n] = size(X);
        ntest=n-100;
    case 'CIFAR-10'
        load('../../Data/Raw/CIFAR-10/data_batch_1.mat')
        X=double(data)';
        Y=labels;
        [D, n] = size(X);
        ntest=n-300;
end

ntrain=n-ntest;

Z = parse_data(X,Y,ntrain,ntest);
Xtrain=Z.Xtrain';
Ytrain=Z.Ytrain;
Xtest=Z.Xtest';
Ytest=Z.Ytest;

