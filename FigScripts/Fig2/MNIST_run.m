clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);

%% load data and set initial parameters
ntrain=300;
ntrials=20; %if <2, plotting will barf
nks=25;
label_keepers=[0,1,2]; %[3,7,8];

types={'DEFE';'NEFE'};
[transformers, deciders, types] = parse_algs(types);

datadir=[fpath(1:findex(end-3)), '/Data/Raw/MNIST/'];
images = loadMNISTImages([datadir, 'train-images.idx3-ubyte']);
labels = loadMNISTLabels([datadir, 'train-labels.idx1-ubyte']);

test_images = loadMNISTImages([datadir, 't10k-images.idx3-ubyte']);
test_labels = loadMNISTLabels([datadir, 't10k-labels.idx1-ubyte']);


for kk=1:ntrials
    
    %% subselect training data
    training=[]; group=[];
    for jj=1:length(label_keepers)
        training = [training, images(:,labels==label_keepers(jj))];
        group = [group; labels(labels==label_keepers(jj))];
    end
    
    % subsample
    n=length(group);
    if n>ntrain
        idx=randperm(n);
        idx=idx(1:ntrain);
        training=training(:,idx);
        group=group(idx);
    else
        ntrain=n;
    end
    
    % subselect prediction data
    sample=[]; Y=[];
    for jj=1:length(label_keepers)
        sample = [sample, test_images(:,test_labels==label_keepers(jj))];
        Y = [Y; test_labels(test_labels==label_keepers(jj))];
    end
    
    
    
    %% LOL
    clear Yhat
    ks=1:nks; %unique(round(logspace(0,log10(40),100)));
    for i=1:length(transformers)
        transform{1}=transformers{i};
        for num_k=1:length(ks);
            tic
            [Pro, P] = LOL(training,group,transform,ks(num_k));
            Xtest=Pro{1}.V*sample;
            Xtrain=Pro{1}.V*training;
            Yhat{i}(num_k,:) = decide(Xtest,Xtrain,group,'linear',ks(num_k));
            times(i,num_k,kk)=toc;
        end
        Proj{i}=Pro{1};
    end
    
    % compute accuracy
    out=get_task_stats(Yhat,Y);
    for j=1:length(types)
        for i=1:nks
            Lhat(j,i,kk)=out(j,i).Lhat;
        end
    end
    
    
%     %% GLM
%     %     opts=struct('nlambda',100);
%     load('~/Research/working/A/LOL/Data/lambda.mat');
%     un=unique(group);
%     g=group; for jj=1:length(un), g(group==un(jj))=jj;  end
%     y=Y; for jj=1:length(un), y(Y==un(jj))=jj;  end
%     
%     for klam=1:nks;
%         tic
%         opts=struct('nlambda',1,'lambda',lambda(klam));
%         fit=glmnet(training',g,'multinomial',opts);
%         pfit=glmnetPredict(fit,sample',fit.lambda,'response','false',fit.offset);
%         [~,yhat]=max(pfit,[],2);
%         Yhat_GLM{1}(klam,:)=squeeze(yhat)';
%         times(3,klam,kk)=toc;
%         ndims(klam,kk)=nnz(fit.beta{1})+nnz(fit.beta{2})+nnz(fit.beta{3});
%     end
%     
%     out=get_task_stats(Yhat_GLM,y);
%     for i=1:nks
%         Lhat(j+1,i,kk)=out(1,i).Lhat;
%     end
%     
%     ijk=1; nl=0;
%     while nl<4,
%         
%         idx1=[find(abs(fit.beta{1}(:,ijk))>1e-4)];
%         idw1=[fit.beta{1}(idx1,ijk)];
%         
%         idx2=[find(abs(fit.beta{2}(:,ijk))>1e-4)];
%         idw2=[fit.beta{2}(idx2,ijk)];
%         
%         idx3=[find(abs(fit.beta{3}(:,ijk))>1e-4)];
%         idw3=[fit.beta{3}(idx3,ijk)];
%         
%         idx=[idx1; idx2; idx3];
%         [id, foo]=unique(idx);
%         nl=numel(id);
%         ijk=ijk+1;
%     end
%     idw=[idw1; idw2; idw3];
%     idw=idw/norm(idw);
%     ln=length(idw);
%     Proj{3}.V=zeros(ln,784);
%     for ijk=1:ln
%         Proj{3}.V(ijk,idx(ijk))=idw(ijk);
%     end
%     Proj{3}.name='GLM';
end

% save([fpath(1:findex(end-3)), 'Data/Results/mnist'])

plot_mnist