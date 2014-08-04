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
task.ntrain=50;
task.ks=1:50; %unique(round(logspace(0,log10(50),30)));
task.savestuff=1;


%% trunk

j=1;
task1=task;
task1.name='trunk4, D=100';
task1.rotate=false;
[T{j},S{j},P{j}] = run_task(task1);

% rotated trunk
j=2;
task1.rotate=true;
[T{j},S{j},P{j}] = run_task(task1);


%% toeplitz

j=3;
task1=task;
task1.name='toeplitz, D=100';
task1.ntrials=100;
task1.ks=1:50;
[T{j},S{j},P{j}] = run_task(task1);

%% fat tails

j=4;
task1=task;
task1.name='fat tails, D=100';
task1.ks=1:50;
task1.ntrials=100;
task1.rotate=true;
[T{j},S{j},P{j}] = run_task(task1);


%% save generalizations

if task.savestuff
    save([fpath(1:findex(end-3)), 'Data/Results/example_sims'])
end
load([fpath(1:findex(end-3)), 'Data/Results/example_sims'])


%% set figure parameters that are consistent across panels

clear G F H
h=figure(1); clf,
G.plot_chance=false;
G.plot_bayes=false;
G.plot_risk=false;
G.plot_time=false;
G.Nrows=3;
G.Ncols=4;
G.legendOn=0;
G.legend = {'LOL';'PCA'};

G.linestyle={'-';'-';'-';'-';'-';'-';'-'};
G.ytick=[0.1:.1:.5];
G.ylim=[0, 0.5];

G.xtick=[00:20:50];
G.xlim=[0, 40];

G.yscale='linear';

orange=[1 0.6 0];
gray=0.75*[1 1 1];
purple=[0.5 0 0.5];
G.colors = {'g';'m';'c'};


% sample

for j=1:length(T)
    task1=T{j};
    [task1, X, Y, PP] = get_task(task1);
    
    Z = parse_data(X,Y,task1.ntrain,task1.ntest,0);
    
    subplot(G.Nrows,G.Ncols,j), hold on
    Xplot1=Z.Xtest(:,Z.Ytest==1);
    Xplot2=Z.Xtest(:,Z.Ytest==2);
    idx=randperm((task1.ntest-100)/2);
    idx=idx(1:100);
    plot3(Xplot1(1,idx),Xplot1(2,idx),Xplot1(3,idx),'o','color',[0 0 0],'LineWidth',1.5,'MarkerSize',4),
    plot3(Xplot2(1,idx),Xplot2(2,idx),Xplot2(3,idx),'x','color',gray,'LineWidth',1.5,'MarkerSize',4)
    view([0.25,0.5,0.5])
    axis('equal')
    if j==1
        set(gca,'XTick',[-5:5:5],'YTick',[-10:5:10],'XLim',[-8 8], 'YLim',[-10 10])   
        zlabel('samples')
    elseif j==2
        set(gca,'XTick',[-5:5:5],'YTick',[-10:5:10],'XLim',[-8 8], 'YLim',[-15 15])
    elseif j==3
        set(gca,'XTick',[-4:2:4],'YTick',[-4:2:4],'XLim',[-2 2], 'YLim',[-2 2])
    elseif j==4
        lims=[-10, 10]; ints=diff(lims)/2; ticks=[-100:ints:100];
        set(gca,'XTick',ticks,'YTick',ticks,'ZTick',ticks,'XLim',lims, 'YLim',lims, 'ZLim',lims)
    end
    grid('on')
    set(gca,'xticklabel',[],'yticklabel',[],'zticklabel',[])
    
    
    if j==1
        title('(A) Trunk')
        xlabel('LOL 1'), ylabel('LOL 2'), zlabel([{'samples'};{''};{'LOL 3'}])
        set(get(gca,'xlabel'),'rotation',23);
        set(get(gca,'ylabel'),'rotation',-55);
        F=G;
        F.doxlabel=false;
        F.title='';
        F.ylabel='error rate';
        F.xlabel='# dimensions';
        plot_Lhat(T{j},S{j},F,2*F.Ncols+j)
        ids=1:10:100;
    elseif j==2
        title('(B) Rotated Trunk')
        F=G;
        F.doxlabel=false;
        F.title='';
        plot_Lhat(T{j},S{j},F,2*F.Ncols+j)
        ids=1:10:100;
    elseif j==3
        title('(C) Toeplitz')
        F=G;
        F.doxlabel=false;
        F.ylim=[0.35,0.5];
        F.ytick=[0:0.05:0.5];
        F.xlim=[0,49];
        F.title='';
        plot_Lhat(T{j},S{j},F,2*F.Ncols+j)
        ids=1:10;
    elseif j==4
        title('(D) Fat Tails')
        F=G;
        F.doxlabel=false;
        F.ylim=[0.15,0.5];
        F.ytick=[0:0.1:0.5];
        F.xlim=[0,49];
        F.title='';
        plot_Lhat(T{j},S{j},F,2*F.Ncols+j)
        ids=1:10;
    end
    
    subplot(G.Nrows,G.Ncols,G.Ncols+j)    
    imagesc(PP.Sigma(ids,ids))
    colormap('bone')
    set(gca,'xtick',[],'ytick',[])
    axis('square')
%     if j<3
%         set(gca,'xtick',0:5:10,'xticklabel',0:50:100,'ytick',0:5:10,'yticklabel',0:50:100)
%     else
%         set(gca,'xtick',0:5:10,'ytick',0:5:10)
%     end
    if j==1, ylabel('covariance'), end
end


% print figure
if task.savestuff
    H.wh=[F.Ncols F.Nrows]*1.4;
    H.fname=[fpath(1:findex(end-3)), 'Figs/example_sims'];
    print_fig(h,H)
end




