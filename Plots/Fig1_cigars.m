% this script generates the simulation and plots the results for Fig 1

%% set path correctly
clearvars, clc, 
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
rootDir=fpath(1:findex(end-1));
p = genpath(rootDir);
gits=strfind(p,'.git');
colons=strfind(p,':');
for i=0:length(gits)-1
    endGit=find(colons>gits(end-i),1);
    p(colons(endGit-1):colons(endGit)-1)=[];
end
addpath(p);


%% set up tasks
clear idx
task_list_name='cs'; 
task.D=1000;
task.ntrain=100;
k=20;
task_list = set_task_list(task_list_name);
task.ntest=500;
task.rotate=false;
task.algs={'LOL';'ROAD'};
task.types={'NEFL';'DEFL'};
task.savestuff=0;

h(1)=figure(1); clf
Nsims=length(task_list);
Nalgs=length(task.algs)+length(task.types)-1;
Ncols=Nsims;
Nrows=Nalgs+2;
gray=0.7*[1 1 1];

width=0.21;
height=0.13;
left=0.13;
y3=0.63;
hspace=0.07;
vspace=0.05;
bottom=0.02;
dd=1;
gg=1;
marker='.';
ms=4; % markersize

%%
for j=1:Nsims
    
    % generate data and embed it
    task.name=task_list{j};
    [task1, X, Y, P] = get_task(task);
    Z = parse_data(X,Y,task1.ntrain,task1.ntest,0);
        
    % scatter plots
    subplot('Position',[left+(j-1)*(width+hspace) bottom+4*(height+vspace), width, width ]) %[left,bottom,width,height]
    hold on
    Xtest=Z.Xtest(1:2,:);
    Xtest=Xtest-repmat(mean(Xtest,2),1,length(Z.Ytest));
    
    Xplot1=Xtest(:,Z.Ytest==1);
    Xplot2=Xtest(:,Z.Ytest==2);
    idx=randperm((task.ntest-100)/2);
    idx=idx(1:100);
    plot(Xplot1(1,idx),Xplot1(2,idx),'.','color',[0 0 0],'LineWidth',1.0,'markersize',ms),
    plot(Xplot2(1,idx),Xplot2(2,idx),'.','color',gray,'LineWidth',1.0,'markersize',ms)
    axis('equal')
    set(gca,'XTick',[0],'YTick',[0],'XTickLabel',[],'YTickLabel',[])
    grid('on')
    set(gca,'TickDir','out')
    
    switch j
        case 1, tit='(A) Aligned';
        case 2, tit='(B) Orthogonal';
        case 3, tit='(C) Rotated Orthogonal';
    end
    title(tit,'fontsize',8)
%     axis('square')
    
    [transformers, deciders] = parse_algs(task1.types);
    Proj = LOL(Z.Xtrain,Z.Ytrain,transformers,task1.Kmax);
    PP{2}=Proj{1};
    PP{1}=Proj{2};
    Proj=PP;
    
    for i=1:Nrows-1
        if i<3
            Xtest=Proj{i}.V(1:k,:)*Z.Xtest;
            Xtrain=Proj{i}.V(1:k,:)*Z.Xtrain;
            [Yhat, parms, eta] = LDA_train_and_predict(Xtrain, Z.Ytrain, Xtest);
        elseif i==3
            para.K=20;
            fit = road(Z.Xtrain', Z.Ytrain,0,0,para);
            nl=0; kk=1;
            while nl<=k, nl=nnz(fit.wPath(:,kk)); kk=kk+1; end
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
        y2=normpdf(t,mu2,sig2); yy2=y2;
        y1=normpdf(t,mu1,sig1); yy1=y1;
        maxy=max(max(y2),max(y1));
        ls1='-';
        ls2='--';
        
        if i==3
            col1='c'; col2=col1;
            ylab='ROAD';
            si=3;
            yy1=y2;
            yy2=y1;
        elseif i==2
            col1='g'; col2=col1;
            ylab='LOL';
            si=2;
        elseif i==1
            col1='m'; col2=col1;
            ylab='LDA o PCA';
            si=4;
        elseif i==4
            ylab=[{'Bayes'};{'Optimal'}];
            col1='k';
            col2='k';
            si=1;
        end
        subplot('Position',[left+(j-1)*(width+hspace) bottom+(si-1)*(height+vspace), width, height ]) %[left,bottom,width,height]
        hold on
    
        plot(t,yy2,'linestyle',ls1,'color',col2,'linewidth',2)
        dashline(t,yy1,dd,gg,dd,gg,'color',col1,'linewidth',2)
        if i~=3
            fill(t,[y1(1:50),y2(51:end)],col1,'EdgeColor',col1)
        else
            fill(t,[y2(1:50),y1(51:end)],col1,'EdgeColor',col1)
        end
        plot([0,0],[0, maxy],'k')
        
        axis([min(min2,min1), max(max2,max1), 0, 1.05*maxy])
        if j==1, ylabel(ylab,'fontsize',8,'FontWeight','bold','FontName','FixedWidth'), end

        set(gca,'XTickLabel',[],'YTickLabel',[],'XTick',[],'YTick',[])
    end
end

%% save figs
if task.savestuff
    F.fname=[rootDir, '../Figs/cigars'];
    F.wh=[2 1.5]*2.5;
    print_fig(h(1),F)
end