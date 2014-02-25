clearvars
clc

allfeatures=importdata('../../data/raw/pancreas/allFeatures.bySample.forJosh.tsv');
data=allfeatures.data;
labels=data(1:8,:);
data(1:8,:)=[];
textdata=allfeatures.textdata;
[p, n]=size(data);

sig=std(data,[],2);
data(sig<10^-5,:)=[];

data=bsxfun(@minus,data,mean(data')');
% data(1,:)=data(1,:)/std(data(1,:)); % rescale the 1st dimension cuz its various is crazy high

% mu=mean(data');
% ndata=data-repmat(mu,n,1)';
% ndata=ndata./repmat(sig,1,n);
% ndata(sig<10^-5,:)=[];

X=data';

save('../data/cancer_data','X','labels')


X=bsxfun(@rdivide,X,std(X));

save('../data/whitened_cancer_data','X','labels')
