% generalizations figure
clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);

% task properties consistent across all tasks
clear task
task.algs={'LOL';'ROAD'};
task.ntrials=5;
task.simulation=1;
task.percent_unlabeled=0;
task.types={'DENE';'DRNE';'DEFE';'NENE'};
task.ntrain=50;
task.savestuff=1;


%% when D>n, LOL helps

j=2;
task1=task;
task1.name='trunk3, D=50';
task1.rotate=true;
task1.algs={'LOL';'GLM'};
profile on
[T{j},S{j},P{j}] = run_task(task1);
profile viewer

%% LOL on sparse models

j=3;
task1=task;
task1.name='ROAD1, D=1000';
task1.ntrain=300;
task1.rotate=true;
task1.ks=unique(round(logspace(0,log10(300),175)));
[T{j},S{j},P{j}] = run_task(task1);

%% even with relatively low dimension, embedding helps

j=1;
task1=task;
task1.name='toeplitz, D=500';
task1.ntrials=50;
[T{j},S{j},P{j}] = run_task(task1);


%% semi-supervised toeplitz, D=50, n=500; # observed samples = 50

j=4;
task1=task;
task1.name='toeplitz, D=50';
task1.percent_unlabeled=0.1;
task1.ntrain=500;
task1.ntrials=5;
[T{j},S{j},P{j}] = run_task(task1);



%% LOL vs LOQ vs QOL vs QOQ

j=5;
task1=task;
task1.name='rtoeplitz, D=50';
task1.types={'DEFE';'DEFV';'DVFE';'DVFV'};
task1.ntrials=5;
[T{j},S{j},P{j}] = run_task(task1);


%% robust

j=6; 
task1=task;
task1.name='gms';
task1.D=500;
task1.ntrain=100;
task1.ntest=500;
task1.n=task1.ntrain+task1.ntest;
task1.ks=1:2:min(task1.D,task1.ntrain);
task1.ntrials=50;
types={'DEFE';'DENE';'DERE'};
[~,~, task1.types] = parse_algs(types);
[T{j},S{j},P{j}] = run_task(task1);



%% save generalizations

if task.savestuff
    save([fpath(1:findex(end-3)), 'Data/Results/generalizations'])
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
G.Ncols=4;
G.location = 'NorthEast';
G.legend = {'LOL';'PCA'};
G.ylim=[0.2, 0.5];
G.linestyle={'-';'-';'-';'-';'-';'-';'-'};

orange=[1 0.6 0];
gray=0.75*[1 1 1];
purple=[0.5 0 0.5];
G.colors = {'g';gray;'m';orange;'c';'k'};


%%
j=2; F=G;
F.title='(A) Trunk';
F.legendOn=0;
F.ylim=[0.15, 0.5];
F.yscale='linear';
% F.ytick=[0.1, 0.2, 0.4];
F.doxlabel=1;
F.xtick=[10:10:50];
F.xlim=[0, 49];
F.ytick=[0:.1:.5];
F.ylim=[0.1,0.5];
F.legend = {'LOL';'PCA'};
F.linestyle={'-';'--';'-';'-';'-';'-'};
plot_Lhat(T{j},S{j},F,1) 

%%
j=3; F=G;
F.title = '(B) Sparse';
% F.ytick=[0.1:.2:.4];
F.ylim=[0.1, 0.5];
F.xlim=[0, 300];
F.xtick=[0:100:300];
F.doxlabel=0;
F.legendOn=0;
F.yscale='linear';
plot_Lhat(T{j},S{j},F,2)                

%%
j=1;F=G;
F.title='(C) Toeplitz';
F.legend = {'LOL';'PCA'};
F.ylim=[0.3, 0.5];
F.location='NorthEast';
F.legendOn=0;
F.xtick=[10:10:50];
F.xlim=[0, 40];
F.yscale='linear';
F.ytick=[0.1:.1:.5];
F.ylim=[0.3, 0.5];
% F.colors = {gray;'g';'k';'m';orange};
plot_Lhat(T{j},S{j},F,3)               


%%
j=5; F=G;
F.title='(D) Union of Subspaces';
F.legendOn=0;
F.colors = {gray;'k';'b';purple;orange};
F.ylim=[0.25 0.5];
F.xlim=[0 20];
F.xtick=[5:5:50];
F.ytick=[0.2:0.1:0.5];
plot_Lhat(T{j},S{j},F,j)                


%%
j=6; F=G;
F.title = '(E) Robust';
F.ylim = [0.27, 0.38];
F.ytick = [0.28:0.04:0.4]; %[F.ylim(1): 0.01: F.ylim(2)];
F.xlim = [1 15];
F.xtick=[0:5:F.xlim(end)];
F.legendOn=0;
F.colors = {gray;'g';'r';orange};
plot_Lhat(T{j},S{j},F,j)                % column 1: plot Lhats

%%
j=4; F=G;
F.title = '(F) Semi-Sup Toeplitz';
F.ylim = [0.1, 0.5];
F.ytick = [F.ylim(1): 0.1: F.ylim(2)];
F.xlim = [0 40];
F.xtick=[10:10:50];
F.yscale='linear';
% F.colors = {'g';'m'};
plot_Lhat(T{j},S{j},F,7)               

%%
j=4;
subplot(F.Nrows,F.Ncols,j);
hold all, i=1; clear g
g(i)=plot(0,0,'color','g','linewidth',2); i=i+1;
g(i)=plot(0,0,'color',gray,'linewidth',2); i=i+1;
g(i)=plot(1,1,'color','m','linewidth',2); i=i+1;
g(i)=plot(0,0,'color','c','linewidth',2); i=i+1;
g(i)=plot(0,0,'color',orange,'linewidth',2); i=i+1;
g(i)=plot(0,0,'color',purple,'linewidth',2); i=i+1;
g(i)=plot(0,0,'color','k','linewidth',2); i=i+1;
g(i)=plot(0,0,'color','b','linewidth',2); i=i+1;
g(i)=plot(0,0,'color','r','linewidth',2); i=i+1;



l=legend(g,'LOL','LFL','RAL','PCA','ROAD','QOQ','LOQ','QOL','ROLOL','location',[0.1,0.1,0.2,0.4]);
legend(l,'boxoff')
% legend(l,'location',[0.1,0.1,0.2,0.4]) %[left,bottom,width,height]
% legend(l,'location',[0.8,1,0.2,0.4]) %[left,bottom,width,height]
legend(g)

set(gca,'XTick',[],'YTick',[],'Box','off','xcolor','w','ycolor','w')
 
% print figure
if task.savestuff
    H.wh=[6.5 3]*1.2;
    H.fname=[fpath(1:findex(end-3)), 'Figs/generalizations'];
    print_fig(h,H)
end
