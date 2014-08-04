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

types={'DEFL';'NEFL'};
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
    
    
    %% GLM
    %     opts=struct('nlambda',100);
    load('~/Research/working/A/LOL/Data/lambda.mat');
    un=unique(group);
    g=group; for jj=1:length(un), g(group==un(jj))=jj;  end
    y=Y; for jj=1:length(un), y(Y==un(jj))=jj;  end
    
    for klam=1:nks;
        tic
        opts=struct('nlambda',1,'lambda',lambda(klam));
        fit=glmnet(training',g,'multinomial',opts);
        pfit=glmnetPredict(fit,sample',fit.lambda,'response','false',fit.offset);
        [~,yhat]=max(pfit,[],2);
        Yhat_GLM{1}(klam,:)=squeeze(yhat)';
        times(3,klam,kk)=toc;
        ndims(klam,kk)=nnz(fit.beta{1})+nnz(fit.beta{2})+nnz(fit.beta{3});
    end
    
    out=get_task_stats(Yhat_GLM,y);
    for i=1:nks
        Lhat(j+1,i,kk)=out(1,i).Lhat;
    end
    
    ijk=1; nl=0;
    while nl<4,
        
        idx1=[find(abs(fit.beta{1}(:,ijk))>1e-4)];
        idw1=[fit.beta{1}(idx1,ijk)];
        
        idx2=[find(abs(fit.beta{2}(:,ijk))>1e-4)];
        idw2=[fit.beta{2}(idx2,ijk)];
        
        idx3=[find(abs(fit.beta{3}(:,ijk))>1e-4)];
        idw3=[fit.beta{3}(idx3,ijk)];
        
        idx=[idx1; idx2; idx3];
        [id, foo]=unique(idx);
        nl=numel(id);
        ijk=ijk+1;
    end
    idw=[idw1; idw2; idw3];
    idw=idw/norm(idw);
    ln=length(idw);
    Proj{3}.V=zeros(ln,784);
    for ijk=1:ln
        Proj{3}.V(ijk,idx(ijk))=idw(ijk);
    end
    Proj{3}.name='GLM';
end

% save([fpath(1:findex(end-3)), 'Data/Results/mnist'])
%%

load('~/Research/working/A/LOL/Data/Results/mnist');
%% final fig

h(6)=figure(6); clf,
gray=0.75*[1 1 1];
colormap('bone')
Ncols=4;
% orange=[1 0.6 0];

width=0.18;
height=width;
leftside=0.15;
space=0.01;
bottom1=1-(height+space);
bottom2=0.57;
bottom3=bottom2-0.2;
right=leftside+3*(width+space)+7*space;

%% plot embeddings

for i=1:3;
    iproj=i;
    Xtest=Proj{iproj}.V*sample;
    Xtrain=Proj{iproj}.V*training;
    
    for jjj=1:length(label_keepers)
        if jjj==1
            color='k';
            marker='x';
        elseif jjj==2
            color=gray;
            marker='o';
        else
            color='r';
            marker='d';
        end
        
        if i==1,
            si=3; tit='Supervised';
            left=leftside+2*(width+space);
        elseif i==3,
            si=1; tit='Sparse';
            left=leftside;
        else
            si=i; tit='Unsupervised';
            left=leftside+width+space;
        end
        subplot('Position',[left bottom3, width, height]); hold all %[left,bottom,width,height]
        plot3(Xtest(1,Y==label_keepers(jjj)),Xtest(2,Y==label_keepers(jjj)),Xtest(3,Y==label_keepers(jjj)),'.',...
            'marker',marker,'markersize',4,'color',color)
        
        view([0.5,0.5,1])
    end
    if i==1, 
        tit='Supervised'; 
        set(gca,'xtick',-20:4:20,'ytick',-20:4:20,'ztick',-20:4:20)
    elseif i==2, 
        tit='Unsupervised'; 
        xlabel('Dim 1')
        ylabel('Dim 2')
        zlabel('Dim 3')
        set(get(gca,'xlabel'),'rotation',45);
        set(get(gca,'ylabel'),'rotation',-45);
        set(gca,'xtick',-20:4:20,'ytick',-20:4:20,'ztick',-20:4:20)
    else
        set(gca,'xtick',-20:0.5:20,'ytick',-20:0.5:20,'ztick',-20:0.5:20)
        tit='Sparse'; 
        zlabel('Embeddings');
    end
    title(''), grid on, axis('tight'), axis('square')
    set(gca,'XtickLabel',[],'YTickLabel',[],'ZTickLabel',[]);
    
end

%% plot accuracies

% g=subplot(3,Ncols,Ncols+4); cla; hold all;
g=subplot('Position',[right-0.05, bottom2, width+0.1, height+0.1]); cla; hold all;
m=mean(Lhat,3);
for j=1:length(types)+1
    if j<=length(types)
        if strcmp(types{j}(1),'D'),
            color='g';
            marker='o';
            markersize=4;
        else strcmp(types{j}(1),'N')
            marker='x';
            markersize=8;
            color='m';
        end
    else
        color='c';
    end
    v=nanstd(squeeze(Lhat(j,:,:))');
    eh=errorbar(ks,m(j,:),v,'linewidth',2,'linestyle','-','color',color,'markersize',markersize);
    errorbar_tick(eh,50000);
end
axis('tight'); axis('square');
set(gca,'xlim',[0 20],'ylim',[0.05 0.4],'xtick',[]);
grid on;
legend('Supervised', 'Unsupervised','Sparse','location','NorthOutside');
legend('boxoff');
% xlabel('# embedded dimensions');
ylabel('error rate');
title(['MNIST']);



%% plot exemplars


clear aind im v vj
im1=zeros(28*4,28*4);
for j=1:3
    aind{j}=find(group==un(j));
    for k=1:4
        im{k}=reshape(training(:,aind{j}(k)),[28 28]);
        v{j}{k}=reshape(Proj{j}.V(k,:),[28 28]);
    end
    imj{j}=[im{1}, ones(28,1) im{2}; ones(1,28*2+1); im{3}, ones(28,1), im{4}];
    m=max(v{j}{1}(:));
    if j==3, m=1; end
    vj{j}=[v{j}{1}, m*ones(28,1) v{j}{2}; m*ones(1,28*2+1); v{j}{3}, m*ones(28,1), v{j}{4}];
end

colormap('bone')
%[left,bottom,width,height]
bottom=1-(height+space);
subplot('Position',[leftside, bottom1, width, height]), 
imagesc(imj{1}), set(gca,'XTickLabel',[],'YTickLabel',[]); axis('square')
ylabel('Examples')

subplot('Position',[leftside+width+space, bottom1, width, height]), 
imagesc(imj{2}), set(gca,'XTickLabel',[],'YTickLabel',[]); axis('square')

subplot('Position',[leftside+2*(width+space), bottom1, width, height]), 
imagesc(imj{3}), set(gca,'XTickLabel',[],'YTickLabel',[]); axis('square')

% projections
bottom=0.55;
subplot('Position',[leftside, bottom2, width, height]), 
imagesc(abs(vj{3})<1e-4), 

set(gca,'XTickLabel',[],'YTickLabel',[]); axis('square')
title('Sparse'), ylabel('Projections')

subplot('Position',[leftside+width+space, bottom2, width, height]), 
imagesc(vj{1}), set(gca,'XTickLabel',[],'YTickLabel',[]); axis('square')
title('Unsupervised')

subplot('Position',[leftside+2*(width+space), bottom2, width, height]), 
imagesc(vj{2}), set(gca,'XTickLabel',[],'YTickLabel',[]); axis('square')
title('Supervised')

%% plot times

subplot('Position',[right, bottom3, width, height]), cla
hold on
t=mean(times,3)*1000;
for j=1:3
    if j<=length(types)
        if strcmp(types{j}(1),'D'),
            color='g';
            marker='o';
            markersize=4;
        else strcmp(types{j}(1),'N')
            marker='x';
            markersize=8;
            color='m';
        end
    else
        color='c';
    end
    vv=nanstd(squeeze(times(j,:,:))')*500;
    eh=errorbar(ks(2:2:end),t(j,2:2:end),vv(2:2:end),'linewidth',2,'linestyle','-','color',color,'markersize',markersize);
    errorbar_tick(eh,5000);
end
axis('tight'); axis('square');
% set(gca,'xlim',[0 20],'ylim',[0. 0.06]);
set(gca,'XTick',[0:10:20],'xlim',[0 20],'ylim',[30 60],'ytick',[30:15:60])
grid on;
xlabel('# dimensions');
ylabel('wall time (msec)');


%% save plot

clear F
F.PaperSize=[6 6];ff=findex;
F.fname=[fpath(1:ff(end-3)), 'Figs/mnist'];
F.PaperPosition=[-0.5 0 F.PaperSize];
print_fig(h(6),F)