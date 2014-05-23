% generalizations figure
clearvars, clc, 
fpath = mfilename('fullpath');
run([fpath(1:end-38),'install_LOL.m'])


%% even with relatively low dimension, embedding helps

j=1; clear task
task.name='toeplitz, D=50';
task.types={'DENE'; 'NENE'};
task.algs={'LOL'};
task.ntrials=100;
[T{j},S{j},P{j}] = run_task(task);


%% when D>n, LOL helps
j=2;
task.name='trunk3, D=500';
task.ntrain=50;
task.types={'DENE'; 'NENE'};
[T{j},S{j},P{j}] = run_task(task);


%% LOL is rotationally invariant

j=3;
task.name='aROAD1, D=1000';
task.types={'DENE'; 'NENE'};
task.ntrain=300;
[T{j},S{j},P{j}] = run_task(task);


%% semi-supervised toeplitz, D=50, n=500; # observed samples = 50
j=4;
task.name='toeplitz, D=50';
task.simulation=1;
task.percent_unlabeled=0.5;
task.ntrain=200;
[T{j},S{j},P{j}] = run_task(task);



%% LOL vs LOQ vs QOL vs QOQ

j=5;
task.name='rtoeplitz, D=50';
task.percent_unlabeled=0;
task.ntrain=50;
task.types={'DENE'; 'DENV';'DVNE'; 'DVNV'; };
[T{j},S{j},P{j}] = run_task(task);




%% robust
% 
% j=6;
% task.name='robust';
% task.simulation=1;
% task.ntrials=5;
% task.percent_unlabeled=0;
% task.ntrain=200;
% task.types={'DENE'; 'DERE'};
% [T{j},S{j},P{j}] = run_task(task);
% 
% %%
% % F.ylim=[0.0, 0.5];
% % F.colors = {[1 0.5 0.2];'g';'m';'c';};
% % F.legend = {'DRP';'LOL';'PCA'};
% F.ylim = [0.05, 0.5];
% F.ytick = [F.ylim(1): 0.1: F.ylim(2)];
% F.xlim = [1 50];
% F.xtick=[0:10:50];
% F.title = 'Trunk, D=50';
% F.legendOn=1;
% F.colors = {'g';'m';'c'};
% % F.legend = {'LOL';'PCA';'SOL'};
% plot_Lhat(T{j},S{j},F,j)                % column 1: plot Lhats


%% fast example

j=7;
task.name='toeplitz, D=50';
task.simulation=1;
task.percent_unlabeled=0;
task.ntrain=50;
task.types={'DEFE'; 'DENE';'DERE';'NENE'};
[T{j},S{j},P{j}] = run_task(task);

%% save generalizations

save('../../Data/Results/generalizations')


%% make figs

clear F
h=figure(1); clf, 
F.plot_chance=false;
F.plot_bayes=false; 
F.plot_risk=false; 
F.plot_time=false;
F.Nrows=4;
F.Ncols=2;
F.location = 'NorthEast';
F.colors = {'g';'m'};
F.legend = {'LOL';'PCA'};
F.ylim=[0.2, 0.5];
F.orange=[1 0.6 0];
F.gray=0.75*[1 1 1];

%
j=1;
F.colors = {'g';'m'};
F.legend = {'LOL';'PCA'};
F.ylim=[0.3, 0.5];
F.location='NorthEast';
F.legendOn=0;
F.xtick=[10:10:50];
F.xlim=[0, 49];
F.yscale='linear';
F.ytick=[0.1:.1:.5];
F.ylim=[0.3, 0.5];
F.title='(A) Toeplitz';
F.linestyle={'-';'-';'-';'-'};
plot_Lhat(T{j},S{j},F,j)                % column 1: plot Lhats

%
j=2;
F.title='(B) Trunk';
F.legendOn=0;
F.ylim=[0.15, 0.5];
F.yscale='linear';
% F.ytick=[0.1, 0.2, 0.4];

F.xtick=[10:10:50];
F.xlim=[0, 49];
F.colors = {'g';'m'};
F.legend = {'LOL';'PCA'};
plot_Lhat(T{j},S{j},F,j) 

%
j=3;
F.title = '(C) Rotational Invariance';
% F.ytick=[0.1:.2:.4];
F.ylim=[0.1, 0.5];
F.xlim=[0, 10];
F.xtick=[0:2:10];
% F=rmfield(F,'legend');
F.legendOn=0;
F.yscale='log';
plot_Lhat(T{j},S{j},F,j)                

%
j=4;
F.title = '(D) Semi-Supervised';
F.ylim = [0.2, 0.5];
F.ytick = [F.ylim(1): 0.1: F.ylim(2)];
F.xlim = [0 40];
F.xtick=[0:10:50];
F.yscale='linear';
plot_Lhat(T{j},S{j},F,j)               

%
j=5;
F.title='(E) Multiple Subspaces';
F.legendOn=0;
F.colors = {'g';'c';'y';F.orange};
F.ylim=[0.2 0.5];
F.xlim=[0 25];
F.xtick=[0:10:50];
F.legend={'LOL'; 'LOQ'; 'QOL'; 'QOQ'};
F.ylim=[0.2, 0.45];
F.doxlabel=1;
plot_Lhat(T{j},S{j},F,j)                

%
j=7;
F.title = '(G) Fast Approximation';
F.ylim = [0.3, 0.5];
F.ytick = [F.ylim(1): 0.1: F.ylim(2)];
F.xlim = [0 50];
F.xtick=[0:10:50];
F.legendOn=0;
F.colors = {F.gray;'g';'k';'m'};
F.yscale='linear';
F.legendOn=0;
F.linestyle={'-';'-.';'-';'-'};
F.doxlabel=0;
plot_Lhat(T{j},S{j},F,j)                % column 1: plot Lhats

%%
j=8;
subplot(F.Ncols,F.Nrows,j);
hold all
g(1)=plot(0,0,'color','g','linewidth',2);
g(2)=plot(1,1,'color','m','linewidth',2);
g(3)=plot(0,0,'color','c','linewidth',2);
g(4)=plot(0,0,'color','y','linewidth',2);
g(5)=plot(0,0,'color',F.orange,'linewidth',2);
g(6)=plot(0,0,'color',F.gray,'linewidth',2);
g(7)=plot(0,0,'color','k','linewidth',2);

legend(g,'LOL','PCA','LOQ','QOL','QOQ','FOL','RAL','location','NorthEast')

set(gca,'XTick',[],'YTick',[],'Box','off','xcolor','w','ycolor','w')

%% print figure


F.wh=[6.5 3]*1.2;
F.fname='../../figs/generalizations';
print_fig(h,F)
