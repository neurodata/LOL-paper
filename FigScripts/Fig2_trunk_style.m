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

if task.savestuff
    save([fpath(1:findex(end-2)), 'Data/Results/example_sims'])
end
% load([fpath(1:findex(end-2)), 'Data/Results/example_sims'])


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


% sample

for j=1:length(T)
    task1=T{j};
    task1.rotate=false; 
    [task1, X, Y, PP] = get_task(task1);
    
    Z = parse_data(X,Y,task1.ntrain,task1.ntest,0);
    
    subplot(G.Nrows,G.Ncols,j), hold on
    maxd=task1.ntrain;
    plot(PP.mu(:,1),'color','k','linestyle','-','linewidth',1.5)
    plot(PP.mu(:,2),'color',gray,'linestyle','-','linewidth',1.5)
    
    xlim=[0,100];
    xtick=0:50:xlim(end);
    if j==2, xlim=[1,6]; xtick=2:2:xlim(end); 
    elseif j==3, set(gca,'ylim',[-1,1]), end
    
    set(gca,'XTick',xtick,'Xlim',xlim)
    grid('on'), %axis('tight')
    if j==2, xlabel('ambient dimension index'); end
    
    
    if j==1
        title('(A) Rotated Trunk')
        ylabel('means')
        F=G;
        F.doxlabel=false;
        F.title='';
        F.ylabel='error rate';
        F.ytick=[0.05, 0.15, 0.35]; %[0.06, [0.1:0.1:0.3]];
        F.ylim=[0.03,0.5];
        plot_Lhat(T{j},S{j},F,2*F.Ncols+j)
        ids=1:10:100;
    elseif j==2
        title('(B) Toeplitz')
        F=G;
        F.doxlabel=false;
        F.ylim=[0.30,0.5];
        F.ytick=[0:0.1:0.5];
        F.title='';
        F.xlabel='total # of embedded dimensions';
        plot_Lhat(T{j},S{j},F,2*F.Ncols+j)
        ids=1:10;
    elseif j==3
        title('(C) Fat Tails')
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




