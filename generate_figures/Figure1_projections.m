clearvars, clc,

savestuff=1;
task_list_name='both_cigars';
task_list = set_task_list(task_list_name);
Nsims=length(task_list);
nrows=Nsims;

h(1)=figure(1); clf
for j=1:Nsims
    
    figure(1)
    % generate data and embed it
    task.name=task_list{j};
    task.ks=5;
    task.ntest=1000;
    task.algs={'LDA','PDA','LOL','Bayes'};
    [task1, X, Y, P] = get_task(task);
    Z = parse_data(X,Y,task1.ntrain,task1.ntest,0);
    task1 = update_k(task1);
    
    Phat = estimate_parameters(Z.Xtrain,Z.Ytrain,task1.Kmax);
    
    Xtrain_centered = bsxfun(@minus,Z.Xtrain,Phat.mu);
    Xtest_centered = bsxfun(@minus,Z.Xtest,Phat.mu);
    
    
    Nalgs=length(task1.algs);
    ncols=Nalgs+1;
    
    subplot(nrows,ncols,1+ncols*(j-1)), hold on
    plot(X(1,Y==0),X(2,Y==0),'o','color',[0 0 0]),
    plot(X(1,Y==1),X(2,Y==1),'x','color',0.7*[1 1 1])
%     axis('equal')
    title(task1.name)
    set(gca,'XTick',[-2:2:2],'YTick',[-2:2:2],'XLim',[-2 2], 'YLim',[-2 2])
    grid('on')
    
    for i=1:ncols-1
        subplot(nrows,ncols,(i+1)+ncols*(j-1)), hold on
        
        if strcmp(task1.algs{i},'LDA')
            [Yhat, eta] = LDA_train_and_predict(Xtrain_centered,Z.Ytrain,Xtest_centered);
            col='g';
        elseif strcmp(task1.algs{i},'PDA')
            [Yhat, eta] = PDA_train_and_predict(Xtrain_centered,Z.Ytrain,Xtest_centered,Phat.V(1:3,:));
            col='m';
        elseif strcmp(task1.algs{i},'LOL')
            [Yhat, eta] = LOL_train_and_predict(Xtrain_centered,Z.Ytrain,Xtest_centered,Phat.delta,Phat.V(1:3,:));
            col='c';
        elseif strcmp(task1.algs{i},'ROAD')
            fit = road(Xtrain_centered, Z.Ytrain);
        elseif strcmp(task1.algs{i},'Bayes')
            parms.thresh=(log(P.pi0)-log(P.pi1))/2;
            parms.del=P.delta;
            parms.InvSig=pinv(P.Sig0);
            parms.mu=P.mu0+P.mu1;
            [Yhat, eta] = LDA_predict(Xtest_centered,parms);
            tit='Bayes';
            col='k';
        end
        
        % class 0 parms
        eta0=eta(Z.Ytest==0);
        mu0=mean(eta0);
        sig0=std(eta0);
        
        % class 1 parms
        eta1=eta(Z.Ytest==1);
        mu1=mean(eta1);
        sig1=std(eta1);

        % get plotting bounds
        min0=mu0-3*sig0;
        max0=mu0+3*sig0;
        min1=mu1-3*sig1;
        max1=mu1+3*sig1;

        t=linspace(min(min0,min1),max(max0,max1),100);
        y0=normpdf(t,mu0,sig0);
        y1=normpdf(t,mu1,sig1);
        maxy=max(max(y0),max(y1));

        plot(t,y0,'-','color',col,'linewidth',2)
        plot(t,y1,'--','color',col, 'linewidth',2)
        plot([0,0],[0, maxy],'k')
        
        grid on
        axis([min(min0,min1), max(max0,max1), 0, 1.05*maxy])
        title(task1.algs{i})
        set(gca,'XTickLabel',[],'YTickLabel',[])
    end
end


%% save figs
fname=['../../figs/projections_', task_list_name];
if savestuff
    wh=[6 nrows]*1.2;
    print_fig(h(1),wh,fname,'painters')
end