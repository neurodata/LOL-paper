clearvars, clc,
fpath = mfilename('fullpath');
run([fpath(1:end-29),'install_LOL.m'])

%%
task_list_name='both_cigars';
task_list = set_task_list(task_list_name);
task.ks=5;
task.ntest=1000;
task.algs={'LOL','Bayes'};
task.types={'NENL';'DENL'};
task.savestuff=1;



h(1)=figure(1); clf
Nsims=length(task_list);
Nalgs=length(task.algs)+length(task.types)-1;
Nrows=Nsims;
Ncols=Nalgs+1;
gray=0.7*[1 1 1];
for j=1:Nsims
    
    task.name=task_list{j};
    % generate data and embed it
    [task1, X, Y, P] = get_task(task);
    Z = parse_data(X,Y,task1.ntrain,task1.ntest,0);
    
    subplot(Nrows,Ncols,1+Ncols*(j-1)), hold on
    plot(Z.Xtrain(1,Z.Ytrain==2),Z.Xtrain(2,Z.Ytrain==2),'o','color',[0 0 0],'LineWidth',1.5),
    plot(Z.Xtrain(1,Z.Ytrain==1),Z.Xtrain(2,Z.Ytrain==1),'x','color',gray,'LineWidth',1.5)
    axis('equal')
    title(task1.name)
    set(gca,'XTick',[-2:2:2],'YTick',[-2:2:2],'XLim',[-2 2], 'YLim',[-2 2])
    grid('on')
    
    
    [transformers, deciders] = parse_algs(task1.types);
    Proj = LOL(Z.Xtrain,Z.Ytrain,transformers,task1.Kmax);
    
    
    for i=1:Ncols-1
        if i<3
            Xtest=Proj{i}.V*Z.Xtest;
            Xtrain=Proj{i}.V*Z.Xtrain;
            [Yhat, parms, eta] = LDA_train_and_predict(Xtrain, Z.Ytrain, Xtest);
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
        
        subplot(Nrows,Ncols,(i+1)+Ncols*(j-1)), hold on
        if i==1
            col1='g'; col2=col1;
            tit='LOL';
        elseif i==2
            col1='m'; col2=col1;
            tit='PCA';
        elseif i==3
            tit='Bayes';
            col1='k';
            col2=gray;
        end
        
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
    F.fname=[fpath(1:end-34) 'Figs/projections_', task_list_name];
    F.wh=[6 Nrows]*1.2;
    print_fig(h(1),F)
end