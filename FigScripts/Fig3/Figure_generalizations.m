% generalizations figure
clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);

%% task properties consistent across all tasks
clear task
task.algs={'LOL'};
task.ntrials=5;
task.simulation=1;
task.percent_unlabeled=0;
task.types={'DENE'; 'NENE'};
task.ntrain=50;

%% even with relatively low dimension, embedding helps

j=1; clear task
task.name='toeplitz, D=50';
[T{j},S{j},P{j}] = run_task(task);


%% when D>n, LOL helps
j=2;
task1=task;
task1.name='trunk3, D=500';
[T{j},S{j},P{j}] = run_task(task1);


%% LOL is rotationally invariant

j=3;
task1=task;
task1.name='aROAD1, D=100';
task1.ROAD=true;
task1.algs={'LOL';'ROAD'};
task1.ntrain=300;
task1.ntrials=5;
[T{j},S{j},P{j}] = run_task(task1);

%% semi-supervised toeplitz, D=50, n=500; # observed samples = 50
j=4;
task1=task;
task1.name='toeplitz, D=50';
task1.percent_unlabeled=0.5;
task1.ntrain=200;
[T{j},S{j},P{j}] = run_task(task1);



%% LOL vs LOQ vs QOL vs QOQ

j=5;
task1=task;
task1.name='rtoeplitz, D=50';
task1.types={'DENE'; 'DENV';'DVNE'; 'DVNV'; };
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
types={'DENE'; 'DERE'};
[~,~, task1.types] = parse_algs(types);
[T{j},S{j},P{j}] = run_task(task1);


%% fast example

j=7;
task1=task;
task1.name='toeplitz, D=50';
task1.types={'DEFE'; 'DENE';'DERE';'NENE'};
[T{j},S{j},P{j}] = run_task(task1);

%% save generalizations

save([fpath(1:findex(end-3)), 'Data/Results/generalizations'])

% load([fpath(1:findex(end-3)), 'Data/Results/generalizations'])

%% make figs
% set figure parameters that are consistent across panels

clear F
h=figure(1); clf, 
F.plot_chance=false;
F.plot_bayes=false; 
F.plot_risk=false; 
F.plot_time=false;
F.Nrows=2;
F.Ncols=4;
F.location = 'NorthEast';
F.legend = {'LOL';'PCA'};
F.ylim=[0.2, 0.5];
F.linestyle={'-';'-';'-';'-'};

F.orange=[1 0.6 0];
F.gray=0.75*[1 1 1];
F.colors = {'g';'m';F.orange};


%%
j=2;
F.title='(A) Trunk';
F.legendOn=0;
F.ylim=[0.15, 0.5];
F.yscale='linear';
% F.ytick=[0.1, 0.2, 0.4];
F.doxlabel=1;
F.xtick=[10:10:50];
F.xlim=[0, 49];
F.legend = {'LOL';'PCA'};
plot_Lhat(T{j},S{j},F,1) 

%
j=3;
F.title = '(B) Rotational Invariance';
% F.ytick=[0.1:.2:.4];
F.ylim=[0.1, 0.5];
F.xlim=[0, 10];
F.xtick=[0:2:10];
F.doxlabel=0;
F.legendOn=0;
F.yscale='linear';
T{j}.Nalgs=2;
plot_Lhat(T{j},S{j},F,2)                

%
j=1;
F.title='(C) Toeplitz';
F.legend = {'LOL';'PCA'};
F.ylim=[0.3, 0.5];
F.location='NorthEast';
F.legendOn=0;
F.xtick=[10:10:50];
F.xlim=[0, 49];
F.yscale='linear';
F.ytick=[0.1:.1:.5];
F.ylim=[0.3, 0.5];
plot_Lhat(T{j},S{j},F,3)               


%
j=7;
F.title = '(D) Fast Approximation';
F.ylim  = [0.3, 0.5];
F.ytick = [F.ylim(1): 0.1: F.ylim(2)];
F.xlim  = [0 50];
F.xtick = [10:10:50];
F.legendOn=0;
F.colors = {F.gray;'g';'k';'m'};
F.yscale ='linear';
F.linestyle={'-';'-.';'-';'-'};
F.doxlabel=0;
plot_Lhat(T{j},S{j},F,4)                % column 1: plot Lhats


%
j=5;
F.title='(E) Multiple Subspaces';
F.legendOn=0;
F.colors = {'g';'c';'y';F.orange};
F.ylim=[0.2 0.5];
F.xlim=[0 25];
F.xtick=[5:5:50];
% F.legend={'LOL'; 'LOQ'; 'QOL'; 'QOQ'};
F.ylim=[0.2, 0.45];
% F.doxlabel=1;
plot_Lhat(T{j},S{j},F,j+1)                


%
j=6;
% F.ylim=[0.0, 0.5];
% F.colors = {[1 0.5 0.2];'g';'m';'c';};
% F.legend = {'DRP';'LOL';'PCA'};
F.ylim = [0.27, 0.3];
F.ytick = [F.ylim(1): 0.01: F.ylim(2)];
F.xlim = [1 50];
F.xtick=[0:10:50];
F.title = '(F) Robust';
F.legendOn=0;
F.colors = {'g';'b'};
plot_Lhat(T{j},S{j},F,j+1)                % column 1: plot Lhats

%
j=4;
F.title = '(G) Semi-Supervised';
F.ylim = [0.2, 0.5];
F.ytick = [F.ylim(1): 0.1: F.ylim(2)];
F.xlim = [0 40];
F.xtick=[10:10:50];
F.yscale='linear';
F.colors = {'g';'m'};
plot_Lhat(T{j},S{j},F,8)               

%%
j=5;
subplot(F.Nrows,F.Ncols,j);
hold all
g(1)=plot(0,0,'color','g','linewidth',2);
g(2)=plot(1,1,'color','m','linewidth',2);
g(3)=plot(0,0,'color','c','linewidth',2);
g(4)=plot(0,0,'color','y','linewidth',2);
g(5)=plot(0,0,'color',F.orange,'linewidth',2);
g(6)=plot(0,0,'color','b','linewidth',2);
g(7)=plot(0,0,'color',F.gray,'linewidth',2);
g(8)=plot(0,0,'color','k','linewidth',2);

l=legend(g,'LOL','PCA','LOQ','QOL','QOQ','ROL','FOL','RAL','location',[0.1,0.1,0.2,0.4]);
legend(l,'boxoff')
legend(l,'location',[0.1,0.1,0.2,0.4]) %[left,bottom,width,height]

set(gca,'XTick',[],'YTick',[],'Box','off','xcolor','w','ycolor','w')

%% print figure


F.wh=[6.5 3]*1.2;
F.fname=[fpath(1:findex(end-3)), 'Figs/generalizations'];
print_fig(h,F)
