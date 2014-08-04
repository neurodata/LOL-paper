% this script generates the simulation and plots the results for Fig 1

%% set path correctly
clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);
% s=rng;
% save('~/Research/working/A/LOL/Data/randstate','s')
load([fpath(1:findex(end-3)), '/Data/randstate']);
rng(s);

%% set up tasks
task_list_name='trunk4';
task_list = set_task_list(task_list_name);
task.ks=5;
task.ntest=1000;
task.ntrain=50;
task.D=200;
task.rotate=true;
task.algs={'ROAD'};
task.types={'NENL';'DENL'};
task.savestuff=1;

orange=[1 0.6 0];


h(1)=figure(1); clf
Nsims=length(task_list);
Nalgs=length(task.algs)+length(task.types)-1;
Nrows=Nsims;
Ncols=Nalgs+3;
gray=0.7*[1 1 1];
for j=1:Nsims
    
    task.name=task_list{j};
    % generate data and embed it
    [task1, X, Y, P] = get_task(task);
    Z = parse_data(X,Y,task1.ntrain,task1.ntest,0);
    
    task2=task;
    task2.rotate=false;
    [task2, X2, Y2, P2] = get_task(task2);
    Z2 = parse_data(X2,Y2,task2.ntrain,task2.ntest,0);
    
    subplot(Nrows,Ncols,1+Ncols*(j-1)), hold on
    Xplot1=Z2.Xtest(:,Z2.Ytest==1);
    Xplot2=Z2.Xtest(:,Z2.Ytest==2);
    idx=randperm((task2.ntest-100)/2);
    idx=idx(1:100);
    plot(Xplot1(1,idx),Xplot1(2,idx),'o','color',[0 0 0],'LineWidth',1.5),
    plot(Xplot2(1,idx),Xplot2(2,idx),'x','color',gray,'LineWidth',1.5)
    axis('equal')
    set(gca,'XTick',[-5:5:5],'YTick',[-10:5:10],'XLim',[-8 8], 'YLim',[-15 15])
    grid('on')
    title('Parallel Cigars')
    
    
    [transformers, deciders] = parse_algs(task1.types);
    Proj = LOL(Z.Xtrain,Z.Ytrain,transformers,task1.Kmax);
    PP{2}=Proj{1};
    PP{1}=Proj{2};
    Proj=PP;
    
    for i=1:Ncols-1
        if i<3
            Xtest=Proj{i}.V*Z.Xtest;
            Xtrain=Proj{i}.V*Z.Xtrain;
            [Yhat, parms, eta] = LDA_train_and_predict(Xtrain, Z.Ytrain, Xtest);
        elseif i==3
            para.K=20;
            fit = road(Z.Xtrain', Z.Ytrain,0,0,para);
            nl=0; kk=1;
            while nl<5, nl=nnz(fit.wPath(:,kk)); kk=kk+1; end
            [~,Yhat,eta] = roadPredict(Z.Xtest', fit);            
            eta=eta(:,kk);
        else
            parms.del=P.del;
            parms.InvSig=pinv(P.Sigma);
            parms.mu=P.mu*P.w;
            
            parms.del=P.mu(:,1)-P.mu(:,2);
            parms.mu=P.mu*P.w;
            parms.thresh=(log(P.w(1))-log(P.w(2)))/2;
            eta = parms.del'*parms.InvSig*Z.Xtest - parms.del'*parms.InvSig*parms.mu - parms.thresh;
        end
            
        
        % class 1 parms
        eta1=eta(Z.Ytest==1);
        mu1=mean(eta1);
        sig1=std(eta1);
        
        % class 2 parms
        eta2=eta(Z.Ytest==2);
        mu2=mean(eta2);
        sig2=std(eta2);
        
        % get plotting bounds
        min2=mu2-3*sig2;
        max2=mu2+3*sig2;
        min1=mu1-3*sig1;
        max1=mu1+3*sig1;
        
        t=linspace(min(min2,min1),max(max2,max1),100);
        y2=normpdf(t,mu2,sig2);
        y1=normpdf(t,mu1,sig1);
        maxy=max(max(y2),max(y1));
        
        if i==3
            col1='c'; col2=col1;
            tit='Sparse';
            si=1;
        elseif i==2
            col1='g'; col2=col1;
            tit='Supervised';
            si=3;
        elseif i==1
            col1='m'; col2=col1;
            tit='Unsupervised';
            si=2;
        elseif i==4
            tit='Bayes';
            col1='k';
            col2='k';
            si=4;
        end
        subplot(Nrows,Ncols,(si+1)+Ncols*(j-1)), hold on
        
        plot(t,y2,'-','color',col2,'linewidth',2)
        plot(t,y1,'--','color',col1, 'linewidth',2)
        plot([0,0],[0, maxy],'k')
        
        grid on
        axis([min(min2,min1), max(max2,max1), 0, 1.05*maxy])
        title(tit)
        set(gca,'XTickLabel',[],'YTickLabel',[])
    end
end


%% save figs
if task.savestuff
    F.fname=[fpath(1:end-34) 'Figs/cigars'];
    F.wh=[4 Nrows]*2;
    print_fig(h(1),F)
end