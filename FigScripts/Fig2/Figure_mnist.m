clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);

%%
ntrain=100;
ntrials=20; %if <2, plotting will barf
label_keepers=[3,7,8];

types={'DENE';'NENE'};
[transformers, deciders, types] = parse_algs(types);


datadir=[fpath(1:findex(end-3)), '/Data/Raw/MNIST/'];
images = loadMNISTImages([datadir, 'train-images.idx3-ubyte']);
labels = loadMNISTLabels([datadir, 'train-labels.idx1-ubyte']);

test_images = loadMNISTImages([datadir, 't10k-images.idx3-ubyte']);
test_labels = loadMNISTLabels([datadir, 't10k-labels.idx1-ubyte']);

tic

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
    
    %% learn projections
    [Proj, P] = LOL(training,group,transformers);
    
    %% subselect prediction data
    sample=[]; Y=[];
    for jj=1:length(label_keepers)
        sample = [sample, test_images(:,test_labels==label_keepers(jj))];
        Y = [Y; test_labels(test_labels==label_keepers(jj))];
    end
    
    %% classify
    
    i=1; k=0; clear Yhat
    ks=unique(round(logspace(0,log10(784),100)));
    for i=1:length(transformers)
        Xtest=Proj{i}.V*sample;
        Xtrain=Proj{i}.V*training;
        for j=1:length(deciders{i})
            k=k+1;
            Yhat{k} = decide(Xtest,Xtrain,group,deciders{i}{j},ks);
        end
    end
    
    %% compute accuracy
    out=get_task_stats(Yhat,Y);
    for j=1:length(types)
        for i=1:74
            Lhat(j,i,kk)=out(j,i).Lhat;
        end
    end
    
end
toc

%% plot projections

h(1)=figure(1); clf,

subplot(331), imagesc(reshape(P.mu(:,1),[28 28])), colormap('gray'), set(gca,'XTickLabel',[],'YTickLabel',[]), axis('square')
subplot(332), imagesc(reshape(P.mu(:,2),[28 28])), colormap('gray'), set(gca,'XTickLabel',[],'YTickLabel',[]), axis('square')

for i=1:2;
    %     if i==2, iproj=3; else iproj=1; end
    iproj=i;
    Xtest=Proj{iproj}.V*sample;
    Xtrain=Proj{iproj}.V*training;
    
    subplot(3,3,(i)*3+1), imagesc(reshape(Proj{i}.V(1,:),[28 28])), colormap('gray'), set(gca,'XTickLabel',[],'YTickLabel',[]), axis('square')
    subplot(3,3,(i)*3+2), imagesc(reshape(Proj{i}.V(2,:),[28 28])), colormap('gray'), set(gca,'XTickLabel',[],'YTickLabel',[]), axis('square')
    
    subplot(3,3,(i)*3+3),hold all
    plot3(Xtest(1,Y==3),Xtest(2,Y==3),Xtest(3,Y==3),'og','markersize',4)
    plot3(Xtest(1,Y==8),Xtest(2,Y==8),Xtest(3,Y==8),'xm','markersize',4)
    if i==1, tit='LOL'; else tit='PCA'; end
    title(tit), grid on, axis('tight'), axis('square')
    xlabel('dimension 1')
    ylabel('dimension 2')
    zlabel('dimension 3')
    %     view([0.5,0.5,1])
    
end

% F.fname = [fpath(1:findex(end-3)), 'Figs/MNIST_', num2str(label_keepers), '_ntrain_', num2str(ntrain)];
% F.PaperSize = [4 5]*2;
% print_fig(h(1),F)


%% final fig

h(6)=figure(6); clf,
gray=0.75*[1 1 1];
for i=1:2;
    %     if i==2, iproj=3; else iproj=1; end
    iproj=i;
    Xtest=Proj{iproj}.V*sample;
    Xtrain=Proj{iproj}.V*training;
        
    subplot(1,3,i),hold all
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
            
        plot3(Xtest(1,Y==label_keepers(jjj)),Xtest(2,Y==label_keepers(jjj)),Xtest(3,Y==label_keepers(jjj)),'.',...
            'marker',marker,'markersize',4,'color',color)
    end
    if i==1, tit='LOL'; else tit='PCA'; end
    title(tit), grid on, axis('tight'), axis('square')
    xlabel('dimension 1')
    ylabel('dimension 2')
    zlabel('dimension 3')
    %     view([0.5,0.5,1])
    
end

% plot accuracies
g=subplot(133); cla, hold all
for j=1:length(types)
    if strcmp(types{j}(1),'D'),
        color='g';
        marker='o';
        markersize=4;
    else
        marker='x';
        markersize=8;
        color='m';
    end
    if strcmp(types{j}(2),'E')
        linestyle='-';
    else
        linestyle='--';
    end
    m=mean(Lhat,3);
    v=nanstd(squeeze(Lhat(j,:,:))');
    eh=errorbar(ks,m(j,:),v,'linewidth',2,'linestyle',linestyle,'color',color,'markersize',markersize);
    errorbar_tick(eh,50000);
end
axis('tight'), axis('square')
set(gca,'xlim',[0 20],'ylim',[0.05 0.4])
grid on
% legend(types{1},types{2},types{3},types{4},types{5},types{6},types{7},types{8})
legend('LOL', 'PCA')
xlabel('# embedded dimensions')
ylabel('error rate')
title(['MNIST: ', num2str(label_keepers),';  ntrain=', num2str(ntrain)])

%% save plot

F.wh=[5 2]*1.5;
F.fname=[fpath(1:findex(end-3)), '/Figs/MNIST_', num2str(label_keepers), '_ntrain_',num2str(ntrain)];
print_fig(h(6),F)
% fname=[fpath(1:findex(end-3)), '/Data/MNIST_', num2str(label_keepers), '_ntrain_',num2str(ntrain)];
% save(F.fname,'Proj','P')
