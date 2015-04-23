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
task_list_name='cigars';
truth=0; % whether to estimate PCA & LOL or use the truth
k=20;
task.savestuff=1;
task.D=1000;
task.ntrain=100;
task_list = set_task_list(task_list_name);
task.ntest=500;
task.rotate=false;
task.algs={'LOL';'ROAD'};
task.types={'NENL';'DENL'};
task.Nks=100;

h(1)=figure(1); clf
Nsims=length(task_list);
Nalgs=length(task.algs)+length(task.types)-1;
Ncols=Nsims;
Nrows=Nalgs+2;
gray=0.7*[1 1 1];

width=1/(Nsims+2); %0.28;
scatsize=1/(Nsims+2.5); %0.21;
height=0.13;
left=0.06;
left1=0.03;
y3=0.63;
hspace=0.03;
vspace=0.05;
bottom=0.02;
dd=1;
gg=2;
marker='.';
ms=4; % markersize
teps=10^-4;
charString = char(1:length(task_list)-1+'A');

%%
for j=1:Nsims
    
    disp(task_list{j})
    
    % generate data and embed it
    task.name=task_list{j};
    tt=task;
    [task1, X, Y, P] = get_task(task);
    ids=1:784;
    figure(j+1), clf
    plot(P.del(1:10),'r')
    hold all
    plot(P.diag(1:10),'k')
    legend('delta','diag')
    set(gca,'Ylim',[0 8])
    title([task1.name, ' corr', num2str(corr(P.del,P.diag)), ' corr_k', num2str(corr(P.del(1:k),P.diag(1:k)))])
    
    Z = parse_data(X,Y,task1.ntrain,task1.ntest,0);
    
    % scatter plots
    figure(1)
    subplot('Position',[left1+(j-1)*(width+hspace)+0.035 bottom+4*(height+vspace), scatsize, scatsize]) %[left,bottom,width,height]
    hold on
    Xtest=Z.Xtest(ids(1:2),:);
    Xtest=Xtest-repmat(mean(Xtest,2),1,length(Z.Ytest));
    
    Xplot1=Xtest(:,Z.Ytest==1);
    Xplot2=Xtest(:,Z.Ytest==2);
    idx=randperm((task.ntest-100)/2);
    idx=idx(1:100);
    plot(Xplot1(1,idx),Xplot1(2,idx),'.','color',[0 0 0],'LineWidth',1.0,'markersize',ms),
    plot(Xplot2(1,idx),Xplot2(2,idx),'.','color',gray,'LineWidth',1.0,'markersize',ms)
    axis('equal')
    if strfind(task.name,'MNIST'),
        axis('tight') %[left bottom width height]
        set(gca,'Position',[0.04 0.76 0.21 0.175]); %[0.04 0.74 0.21 0.21]),
    end
    set(gca,'XTick',0,'YTick',0,'XTickLabel',[],'YTickLabel',[])
    set(gca,'TickDir','out')
    
    switch j
        case 1, tit='(A) Stacked Cigars';
        case 2, tit='(B) Trunk';
        case 3, tit='(C) Rotated Trunk';
    end
%     tit=[{tit}; {'D=1000, n=100'}];
    title(tit,'fontsize',8)
    
    [transformers, deciders] = parse_algs(task1.types);
    Proj = LOL(Z.Xtrain,Z.Ytrain,transformers,task1.Kmax);
    PP{2}=Proj{1};
    PP{1}=Proj{2};
    Proj=PP;
    
    for i=1:Nrows-1
        if i<3 % for PCA & LOL
            if truth
                [u,d,v]=svd(P.Sigma);
                Dd=diag(d);
                Dd(k+1:end)=0;
                d=diag(Dd);
                Sig=u*d*v';
                if strcmp(Proj{i}.name(1),'N')
                    Pro=Sig(1:k,:);
                else
                    [Pro]=qr([P.del,Sig(1:k-1,:)']',0);
                    % Pro=[P.del,Sig(1:k-1,:)']';
                end
            else
                Pro=Proj{i}.V(1:k,:);
            end
            Xtest=Pro*Z.Xtest;
            Xtrain=Pro*Z.Xtrain;
            [Yhat, parms, eta] = LDA_train_and_predict(Xtrain, Z.Ytrain, Xtest);
        elseif i==3 % for the sparse setting
            para.K=100;
            fit = road(Z.Xtrain', Z.Ytrain,0,0,para);
            nl=0; kk=1;
            while nl<=k, nl=nnz(fit.wPath(:,kk)); kk=kk+1; end
            [~,Yhat,eta] = roadPredict(Z.Xtest', fit);
            eta=eta(:,kk);
        else % for Bayes Optimal
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
            ylab='ROAD';
            col1='c'; col2=col1;
            si=3;
            yy1=y2;
            yy2=y1;
        elseif i==2
            ylab='LOL';
            col1='g'; col2=col1;
            si=2;
        elseif i==1
            ylab='LDA o PCA';
            col1='m'; col2=col1;
            si=4;
        elseif i==4
            ylab=[{'Bayes'};{'Optimal'}];
            col1='k';
            col2='k';
            si=1;
        end
        
        subplot('Position',[left+(j-1)*(width+hspace) bottom+(si-1)*(height+vspace), width, height]) %[left,bottom,width,height]
        hold on
        if range(t)<teps, t=1:100; end
        plot(t,yy2,'linestyle',ls1,'color',col2,'linewidth',2)
%         plot(t,yy1,'linestyle',ls2,'color',col2,'linewidth',2)
        dashline(t,yy1,dd,gg,dd,gg,'color',col1,'linewidth',2)
        if i~=3
            fill(t,[y1(1:50),y2(51:end)],col1,'EdgeColor',col1)
        elseif i==3
            yend=find(y2>y1,1)-1;
            fill(t,[y2(1:yend), y1(yend+1:end)],col1,'EdgeColor',col1)
        end
        plot([t(50),t(50)],[0, maxy],'k')
        axis([min(t), max(t), 0, 1.05*maxy])
        if j==1, ylabel(ylab,'fontsize',8,'FontWeight','bold','FontName','FixedWidth'), end
        set(gca,'XTickLabel',[],'YTickLabel',[],'XTick',[],'YTick',[])
    end
end

%% save figs
if task.savestuff
    if truth==1
        F.fname=[rootDir, '../Figs/', task_list_name];
    else
        F.fname=[rootDir, '../Figs/', task_list_name, '_est'];
    end
    F.wh=[6, 3.5];
    print_fig(h(1),F)
end