clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);
%%

ntrain=1000;
load([fpath(1:findex(end-2)), 'Data/Raw/CIFAR-10/data_batch_1.mat'])
X=single(data)';
Y=single(labels);
Y(Y==0)=10;
Z = parse_data(X,Y,ntrain,10000-ntrain);
%%

datadir=[fpath(1:findex(end-2)), 'Data/Raw/MNIST/'];
% images = loadMNISTImages([datadir, 'train-images.idx3-ubyte']);
% labels = loadMNISTLabels([datadir, 'train-labels.idx1-ubyte']);

test_images = loadMNISTImages([datadir, 't10k-images.idx3-ubyte']);
test_labels = loadMNISTLabels([datadir, 't10k-labels.idx1-ubyte']);

%%
ntrain=1000;
X=single(test_images);
Y=single(test_labels)+1;

% ind3=find(Y==3);
% ind4=find(Y==4);
% ind5=find(Y==5);
% 
% X=X(:,[ind3;ind4;ind5]);
% Y=Y([ind3;ind4;ind5]);
Z = parse_data(X,Y,ntrain,1000);


%% load data and set initial parameters

task.algs={'LOL'};
task.simulation=0;
task.types={'DVFL';'DVFR'}; %{'DEFL';'DVFL';'DVFQ';'DVFR'};
[~,~,task.types]=parse_algs(task.types);
task.ntrain=ntrain;
task.ks=unique(round(logspace(0,log10(99),5)));
task.Kmax=max(task.ks);
task.savestuff=0;


%%

[Yhats, Proj, P] = LOL_classify(Z.Xtest',Z.Xtrain',Z.Ytrain,task);

%%

loop{1}.out=get_task_stats(Yhats,Z.Ytest);

S = get_loop_stats(task,loop);      % get stats

S.means.Lhats'


%% RF direct
Xtest=Proj{1}.V(1:task.ks(end-1),:)*Z.Xtest;
Xtrain=Proj{1}.V(1:task.ks(end-1),:)*Z.Xtrain;

B = TreeBagger(100,Z.Xtrain',Z.Ytrain);
[~, scores] = predict(B,Z.Xtest');
[~, Yhat_RF{1}] = max(scores,[],2);
sum([Yhat_RF{1}~=Z.Ytest])/length(Z.Ytest)


%%

% i=i+1;
% ass=reshape(Proj{1}.V(i,:),[32,32,3]);
% ass=ass-min(ass(:));
% ass=255*ass./max(ass(:));
% imagesc(uint8(ass));

