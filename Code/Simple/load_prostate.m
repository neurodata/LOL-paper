function [Xtrain,Ytrain,Xtest,Ytest,D,ntrain]=load_data2(which)

switch which
    case 'prostate'
        data=load('../../Data/Preprocessed/prostate_data');
end

X=data.X';
Y=data.Y+1;
[D, n] = size(X);
ntest=round(n/3);
ntrain=n-ntest;

Z = parse_data(X,Y,ntrain,ntest);
Xtrain=Z.Xtrain';
Ytrain=Z.Ytrain;
Xtest=Z.Xtest';
Ytest=Z.Ytest;

