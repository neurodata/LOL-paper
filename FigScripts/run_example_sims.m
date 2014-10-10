% generalizations figure
clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);

%% task properties consistent across all tasks
clear task T S P
task.algs={'LOL';'ROAD'};
task.ntrials=50;
task.simulation=1;
task.percent_unlabeled=0;
task.types={'DENL';'NENL'};
task.ntrain=100;
task.ks=unique(round(logspace(0,log10(task.ntrain-1),50)));
task.savestuff=1;


%% trunk

j=1;
task1=task;
task1.name='trunk4, D=100';
task1.rotate=true;
[T{j},S{j},P{j}] = run_task(task1);


%% toeplitz

j=2;
task1=task;
task1.name='toeplitz, D=100';
[T{j},S{j},P{j}] = run_task(task1);

%% fat tails

j=3;
task1=task;
task1.name='fat tails, D=100';
task1.rotate=true;
task1.QDA_model=false;
[T{j},S{j},P{j}] = run_task(task1);


%% save generalizations

% if task.savestuff
%     save([fpath(1:findex(end-2)), 'Data/Results/example_sims'])
% end
load([fpath(1:findex(end-2)), 'Data/Results/example_sims'])


%% set figure parameters that are consistent across panels

clear G F H
h=figure(1); clf,
G.plot_chance=false;
G.plot_bayes=false;
G.plot_risk=false;
G.plot_time=false;
G.Nrows=3;
G.Ncols=3;
G.legendOn=0;
G.legend = {'LOL';'PCA'};

G.linestyle={'-';'-';'-';'-';'-';'-';'-'};
G.ytick=[0.1:.1:.5];
G.ylim=[0, 0.5];

G.xtick=[25:25:task.ntrain];
G.xlim=[0, 80];

G.yscale='log';

orange=[1 0.6 0];
gray=0.75*[1 1 1];
purple=[0.5 0 0.5];
G.colors = {'g';'m';'c'};
dd=2;
gg=dd*0.75;
G.ti=[1,3,2]; % order of ticks

% sample

for j=1:length(T)
    task1=T{j};
    task1.rotate=false; 
    [task1, X, Y, PP] = get_task(task1);
    
    Z = parse_data(X,Y,task1.ntrain,task1.ntest,0);
    
    if j~=2
        subplot(G.Nrows,G.Ncols,j),
    else
        subplot('position',[.41 .71 .10 .21]),
    end
    hold on
    maxd=task1.ntrain;
    mu=PP.mu; mu=mu/max(mu(:));
    plot(1:length(mu(:,2)),mu(:,1),'color','k','linestyle','-','linewidth',1.5)
%     plot(1:length(mu(:,2)),mu(:,2),'color','w','linestyle','-','linewidth',1.5)
    % hold on
    dashline(1:length(mu(:,2)),mu(:,2),dd,gg,dd,gg,'color',gray,'linewidth',1.5)
    
    xlim=[0,100];
    ylim=[-1,1];
    xtick=50:50:xlim(end);
    
    if j==1
        title('(A) Rotated Trunk')
        ylabel('means')
        ytick=[-1,0,1];
    elseif j==2, 
%         title('')
        xlim=[1,4]; 
        xtick=2:2:xlim(end); 
        xlabel('ambient dimension index'); 
        ytick=[];
    elseif j==3, 
        title('(C) Fat Tails')
        ytick=[];
    end
    
    set(gca,'XTick',xtick,'Xlim',xlim,'ylim',ylim,'ytick',ytick)
    grid('off'), %axis('tight')
   
    
    if j==2
        subplot('position',[.58 .71 .07 .21]), hold on
        plot(1:length(mu(:,2)),mu(:,1),'color','k','linestyle','-','linewidth',1.5)
        dashline(1:length(mu(:,2)),mu(:,2),dd,gg,dd,gg,'color',gray,'linewidth',1.5)
        set(gca,'XTick',xtick,'Xlim',xlim,'xlim',[98,100],'xtick',0:2:100,'ytick',[],'Ycolor','w')
        annotation('textbox', [0.51,0.76,0.10,0.1],...
           'String', '...','EdgeColor','w','FontSize',16);
        annotation('textbox', [0.43,0.89,0.10,0.1],...
           'String', '(B) Toeplitz','EdgeColor','w');
  
    end
    
    if j==1
        F=G;
        F.doxlabel=false;
        F.title='';
        F.ylabel='error rate';
        F.ytick=[0.05, 0.15, 0.35]; %[0.06, [0.1:0.1:0.3]];
        F.ylim=[0.03,0.5];
        plot_Lhat(T{j},S{j},F,2*F.Ncols+j)
        ids=1:10:100;
    elseif j==2
        F=G;
        F.doxlabel=false;
        F.ylim=[0.30,0.5];
        F.ytick=[0:0.1:0.5];
        F.title='';
        F.xlabel='total # of embedded dimensions';
        plot_Lhat(T{j},S{j},F,2*F.Ncols+j)
        ids=1:10;
    elseif j==3
        F=G;
        F.doxlabel=false;
        F.ylim=[0.15,0.5];
        F.ytick=[0:0.1:0.5];
        F.title='';
        F.xticklabel=[];
        plot_Lhat(T{j},S{j},F,2*F.Ncols+j)
        ids=1:10:100;
    end

    subplot(G.Nrows,G.Ncols,G.Ncols+j)
    imagesc(PP.Sigma(ids,ids))
    set(gca,'xticklabel',[],'yticklabel',[])
    colormap('bone')
    axis('square')
    if j==1, ylabel('covariance'), end
end


% print figure
if task.savestuff
    H.wh=[F.Ncols F.Nrows]*1.4;
    H.fname=[fpath(1:findex(end-2)), 'Figs/example_sims'];
    print_fig(h,H)
end




