function Z = parse_data(X,Y,ntrain,ntest)
% parse data into training and testing sets and output everything in a
% structure to make it easier to save stuff

n=ntrain+ntest;
idx=randperm(n);

Z.Xtrain=X(idx(1:ntrain),:);
Z.Ytrain=Y(idx(1:ntrain));

Z.Xtest=X(idx(ntrain+1:end),:);
Z.Ytest=Y(idx(ntrain+1:end));

Z.Y0train=Z.Ytrain==0;
Z.Y1train=Z.Ytrain==1;

Z.Y0test=Z.Ytest==0;
Z.Y1test=Z.Ytest==1;