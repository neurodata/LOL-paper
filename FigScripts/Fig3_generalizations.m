% generalizations figure
clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);

%% task properties consistent across all tasks
clear task
task.algs={'LOL'};
task.simulation=1;
task.percent_unlabeled=0;
task.types={'DEAL';'DEFL'};
task.ntrials=4;
task.D=100;
task.ntrain=10;
task.ntest=500;
task.ks=1:task.ntrain-1;
task.savestuff=1;

%% rotated trunk

j=1;
task1=task;
task1.name=['trunk4, D=', num2str(task1.D)];
task1.rotate=true;
task1.algs={'LOL'};
task1.types={'NEFL';'DEFL'};
[T{j},S{j},P{j}] = run_task(task1);

%% union of affine spaces

j=2;
task1=task;
task1.name=['rtoeplitz, D=', num2str(task1.D)];
task1.algs={'LOL'};
task1.types={'DEFL';'DVFQ'};
[T{j},S{j},P{j}] = run_task(task1);


%% robust

j=3; 
task1=task;
task1.name='gms';
task1.n=task1.ntrain+task1.ntest;
task1.ks=1:50;
types={'DEFL';'DERL'};
[~,~, task1.types] = parse_algs(types);
[T{j},S{j},P{j}] = run_task(task1);


%% multiscale

j=4; 
task1=task;
task1.name=['xor, D=', num2str(task1.D)];
task1.ntrain=100;
task1.types={'DEFL';'DEFQ';'DEFR';'NEFL';'NEFQ';'NEFR'};
task1.algs={'LOL';'RF'};
task1.ks=unique(floor(logspace(0,log10(task1.ntrain),50)));
task1.ntrials=2;
[T{j},S{j},P{j}] = run_task(task1);


%% save generalizations

if task.savestuff
    save([fpath(1:findex(end-2)), 'Data/Results/generalizations'])
end
% load([fpath(1:findex(end-3)), 'Data/Results/generalizations'])

%% make figs
% set figure parameters that are consistent across panels

clear G F H
h=figure(1); clf, 
G.plot_chance=false;
G.plot_bayes=false; 
G.plot_risk=false; 
G.plot_time=false;
G.Nrows=2;
G.Ncols=length(T)+1; %ceil(length(T)/2);
G.location = 'NorthEast';
G.legend = {'LOL';'PCA'};
G.ylim=[0.2, 0.5];
G.linestyle={'-';'-';'-';'-';'-';'-';'-'};
 
orange=[1 0.6 0];
gray=0.75*[1 1 1];
purple=[0.5 0 0.5];
G.colors = {gray;'g';'k';'c';orange;'c';'m'};

%% scatter plots

for j=1:length(T)
    task1=T{j};
    task1.rotate=false;
    [task1, X, Y, PP] = get_task(task1);
    
    Z = parse_data(X,Y,task1.ntrain,task1.ntest,0);
    
    subplot(G.Nrows,G.Ncols,j), cla, hold on
    Xplot1=Z.Xtest(:,Z.Ytest==1);
    Xplot2=Z.Xtest(:,Z.Ytest==2);
    idx=randperm((task1.ntest-100)/2);
    idx=idx(1:100);
    plot3(Xplot1(1,idx),Xplot1(2,idx),Xplot1(3,idx),'o','color',[0 0 0],'LineWidth',1.5,'MarkerSize',4),
    plot3(Xplot2(1,idx),Xplot2(2,idx),Xplot2(3,idx),'x','color',gray,'LineWidth',1.5,'MarkerSize',4)
    view([0.5,0.5,0.5])
    axis('equal')
    ticks=[-2:2:2];
    if j==1
        zlabel('samples')
        title('> 2 classes')
    elseif j==2
        title('Nonlinear')
    elseif j==3
        title('Robust')
    elseif j==4
        title('XOR')
    end
    lims=[-2.0,2.0];
    set(gca,'XTick',ticks,'YTick',ticks,'ZTick',ticks,'XLim',lims, 'YLim',lims, 'ZLim',lims)
    grid('on')
    set(gca,'xticklabel',[],'yticklabel',[],'zticklabel',[])
    
    
end

%%
j=1; F=G;
F.title='(A) Fast';
F.legendOn=0;
F.yscale='linear';
% F.ytick=[0.1, 0.2, 0.4];
F.doxlabel=1;
F.xtick=[0:20:50];
F.xlim=[0, 49];
F.ytick=[0:.1:.5];
F.ylim=[0.05,0.35];
F.legend = {'LOL';'PCA'};
F.colors = {gray;'k'};
F.xlabel='# of dimensions';
F.ylabel='error rate';
F.linestyle={'-';'-';'-';'-';'-';'-'};
plot_Lhat(T{j},S{j},F,F.Ncols+j) 

%%
j=2; F=G;
F.title='(B) Union of Subspaces';
F.legendOn=0;
F.colors = {gray;purple;'k';'b';orange;'c'};
F.ylim=[0.3 0.5];
F.xlim=[0 21];
F.xtick=[5:5:50];
F.ytick=[0.2:0.1:0.5];
plot_Lhat(T{j},S{j},F,F.Ncols+j) 



%%
j=3; F=G;
F.title = '';
F.ylim = [0.25, 0.35];
F.ytick = [0:0.025:0.5]; %[F.ylim(1): 0.01: F.ylim(2)];
F.xlim = [1 31];
F.xtick=[0:10:F.xlim(end)];
F.legendOn=0;
F.colors = {gray;'r';'c';orange};
plot_Lhat(T{j},S{j},F,F.Ncols+j) 


%%
j=4; F=G;
F.title = '';
F.ylim = [0.0, 0.5];
F.ytick = [0:0.1:0.5]; %[F.ylim(1): 0.01: F.ylim(2)];
F.xlim = [1 40];
F.xtick=[0:20:max(F.xlim)]; %:F.xlim(end)];
F.legendOn=0;
F.colors = {gray;'r';'c';orange;gray;'r';'c';orange;'k'};
F.linestyle={'-';'-';'-';'-';':';':';':';':';'--'};
plot_Lhat(T{j},S{j},F,F.Ncols+j) 


%%
j=length(T)+1;
subplot(F.Nrows,F.Ncols,j);
hold all, i=1; clear g
g(i)=plot(0,0,'color',gray,'linewidth',2); i=i+1;
g(i)=plot(0,0,'color','k','linewidth',2); i=i+1;
g(i)=plot(1,1,'color',orange,'linewidth',2); i=i+1;
g(i)=plot(0,0,'color',purple,'linewidth',2); i=i+1;
g(i)=plot(0,0,'color','b','linewidth',2); i=i+1;
g(i)=plot(0,0,'color','c','linewidth',2); i=i+1;
g(i)=plot(0,0,'color','r','linewidth',2); i=i+1;



l=legend(g,'RAL','FOL','QOQ','LOQ','QOL','ROAD','ROL','location',[0,0,1,1]);
legend(l,'boxoff')
legend(g)

set(gca,'XTick',[],'YTick',[],'Box','off','xcolor','w','ycolor','w')
 
%% print figure
if task.savestuff
    H.wh=[6.5 3]*1.2;
    H.fname=[fpath(1:findex(end-2)), 'Figs/generalizations'];
    print_fig(h,H)
end
