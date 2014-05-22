function Z = parse_data(X,Y,ntrain,ntest,percent_unlabeled)
% parse data into training and testing sets and output everything in a
% structure to make it easier to save stuff

n=length(Y);
if ntrain+ntest>n, error('ntrain+ntest>length(Y)'), end
idx=randperm(n);

Z.Xtrain=X(:,idx(1:ntrain));
Z.Ytrain=Y(idx(1:ntrain));

Z.Xtest=X(:,idx(ntrain+1:end));
Z.Ytest=Y(idx(ntrain+1:end));

% unlabeled some data points
nu=binornd(ntrain,percent_unlabeled);
idx_un=randperm(ntrain);
Z.Ytrain(idx_un(1:nu))=NaN;

