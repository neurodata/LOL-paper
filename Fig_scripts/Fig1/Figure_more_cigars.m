clearvars, clc,

savestuff=0;
task_list_name='three_cigars';
task_list = set_task_list(task_list_name);
task.ks=5;
task.ntest=1000;
task.algs={'LOL','Bayes'};
task.types={'NENL';'DENL';'DVNL'};


Nsims=length(task_list);
Nalgs=length(task.algs)+length(task.types)-1;

h(1)=figure(1); clf
nrows=Nsims;
ncols=Nalgs+1;

for j=1:Nsims
    
    task.name=task_list{j};
    % generate data and embed it
    [task1, X, Y, P] = get_task(task);
    Z = parse_data(X,Y,task1.ntrain,task1.ntest,0);
    
    subplot(nrows,ncols,1+ncols*(j-1)), hold on
    plot(Z.Xtrain(1,Z.Ytrain==2),Z.Xtrain(2,Z.Ytrain==2),'o','color',[0 0 0],'LineWidth',1.5),
    plot(Z.Xtrain(1,Z.Ytrain==1),Z.Xtrain(2,Z.Ytrain==1),'x','color',0.7*[1 1 1],'LineWidth',1.5)
    axis('equal')
    title(task1.name)
    set(gca,'XTick',[-2:2:2],'YTick',[-2:2:2],'XLim',[-2 2], 'YLim',[-2 2])
    grid('on')
    
    
    [transformers, deciders] = parse_algs(task1.types);
    Proj = LOL(Z.Xtrain,Z.Ytrain,transformers,task1.Kmax);
    
    
    
    for i=1:ncols-1
        if i<4
            Xtest=Proj{i}.V*Z.Xtest;
            Xtrain=Proj{i}.V*Z.Xtrain;
            [Yhat, parms, eta] = LDA_train_and_predict(Xtrain, Z.Ytrain, Xtest);
        elseif i==4
            Xtest=Proj{i}.V*Z.Xtest;
            Xtrain=Proj{i}.V*Z.Xtrain;
            Yhat = decide(Xtest,Xtrain,Z.Ytrain,'linear',ks)
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
        
        subplot(nrows,ncols,(i+1)+ncols*(j-1)), hold on
        %         if i==1
        %             col='g';
        %             tit='LOL';
        %         elseif i==2
        %             col='m';
        %             tit='PDA';
        %         elseif i==3
        %             tit='LOQ';
        %             col='c';
        %         elseif i==4
        %             tit='Bayes';
        %             col='k';
        %         end
        
        F = figure_settings(task1);
        if i<length(task1.types)+1
            if strcmp(task1.types{i},'DENL')
                tit='LOL';
            elseif strcmp(task1.types{i},'DVNL')
                tit='QOL';
            elseif strcmp(task1.types{i},'NENL')
                tit='PDA';
            end
        else
            tit='Bayes';
            F.colors{i}='k';
        end
        
        plot(t,y2,'-','color',F.colors{i},'linewidth',2)
        plot(t,y1,'--','color',F.colors{i}, 'linewidth',2)
        plot([0,0],[0, maxy],'k')
        
        grid on
        axis([min(min2,min1), max(max2,max1), 0, 1.05*maxy])
        title(tit)
        set(gca,'XTickLabel',[],'YTickLabel',[])
    end
end


%% save figs
F.fname=['../../figs/projections_', task_list_name];
if savestuff
    F.wh=[6 nrows]*1.2;
    print_fig(h(1),F)
end