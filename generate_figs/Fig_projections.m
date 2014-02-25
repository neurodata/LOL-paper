clearvars, clc, updatepath

savestuff=1;
task_list_name='both_cigars';
task_list = set_task_list(task_list_name);
Nsims=length(task_list);
nrows=Nsims;

h(1)=figure(1); clf
for j=1:Nsims
    
    % generate data and embed it
    task.name=task_list{j};
    task.ks=5;
    task.ntest=1000;
    task.algs={'LDA','PDA','LOL','Bayes'};
    [task1, X, Y, P] = get_task(task);
    Z = parse_data(X,Y,task1.ntrain,task1.ntest);
    task1 = update_k(task1);
    
    Phat = estimate_parameters(Z.Xtrain,Z.Ytrain,task1.Kmax);
        
    Xtrain_centered = bsxfun(@minus,Z.Xtrain,Phat.mu);
    Xtest_centered = bsxfun(@minus,Z.Xtest,Phat.mu);

    
    Nalgs=length(task1.algs);
    ncols=Nalgs+1;
    
    subplot(nrows,ncols,1+ncols*(j-1)), hold on
    [x0, y0, z0] = ellipsoid(P.mu0(1),P.mu0(2),P.mu0(3),P.Sig0(1,1),P.Sig0(2,2),P.Sig0(3,3),30);
    [x1, y1, z1] = ellipsoid(P.mu1(1),P.mu1(2),P.mu1(3),P.Sig1(1,1),P.Sig1(2,2),P.Sig1(3,3),30);
    
    S0=surfl(x0, y0, z0);
    S1=surfl(x1, y1, z1);
    
    if j==2
        rotate(S0,[0 0 1],135);
        rotate(S1,[0 0 1],135);
    end
    
    colormap copper
    axis tight
    shading interp;
    light;
    lighting phong;
    grid on
    title(task1.name)
    set(gca,'XTickLabel',[],'YTickLabel',[])

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
            parms.lnpi0=log(0.5);
            parms.lnpi1=log(0.5);
            parms.del=P.mu0-P.mu1;
            parms.InvSig=pinv(P.Sig0);
            parms.mu=P.mu0+P.mu1;
            [Yhat, eta] = LDA_predict(Xtest_centered,parms);
            tit='Bayes';
            col='k';
        end
        
        
        eta0=eta(Z.Ytest==0);
        mu0=mean(eta0);
        sig0=std(eta0);
        min0=mu0-3*sig0;
        max0=mu0+3*sig0;
        
        eta1=eta(Z.Ytest==1);
        mu1=mean(eta1);
        sig1=std(eta1);
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
fn=['../../figs/projections_', task_list_name];
if savestuff
    wh=[6 nrows]*1.2;
    print_fig(h(1),wh,fn)
end
