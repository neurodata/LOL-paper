% generalizations figure
clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);

%% task properties consistent across all tasks
clear task
task.algs={'LOL';'GLM'};
task.simulation=0;
task.percent_unlabeled=0;
task.types={'NENL';'DENL'};
task.ntrials=4;
task.savestuff=0;

%% prostate

j=1;
task1=task;
task1.name=['prostate'];
task1.ks=1:50;
[T{j},S{j},P{j}] = run_task(task1);

%% prostate

j=2;
task1=task;
task1.name=['colon'];
task1.ks=1:50;
[T{j},S{j},P{j}] = run_task(task1);

%% mnist

j=3;
task1=task;
task1.name=['mnist012'];
task1.ks=1:50;
task1.ntrain=300;
task1.ntest=500;
[T{j},S{j},P{j}] = run_task(task1);


%% save stuff

if task.savestuff
    save([fpath(1:findex(end-2)), 'Data/Results/generalizations'])
end
% load([fpath(1:findex(end-2)), 'Data/Results/generalizations'])


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
G.linestyle={'-';'-';'-';'-';'-';'-';'-'};
G.title='';

orange=[1 0.6 0];
gray=0.75*[1 1 1];
purple=[0.5 0 0.5];
G.colors = {'g';'m';'c'};
G.ms=14;
G.lw=0.5;

G.ylim=[0,0.4];
G.yticks=[0.1:0.1:0.5];
G.yscale='linear';

G.xlim=[1,30];
G.xtick=[4 8 16];
G.xscale='log';


%%

for j=1:length(S)
    F=G;
    if j==1
        F.title='';
        F.doxlabel=1;
        F.ylabel='error rate';
    elseif j==2
        F.xlim=[1,20];
    elseif j==3

    end
    F.title=[T{j}.name, ', D=',num2str(T{j}.D),', n=',num2str(T{j}.ntrain)];
    plot_Lhat(T{j},S{j},F,F.Ncols+j)
end

%% print figure
if task.savestuff
    H.wh=[6.5 2.5]*1.2;
    H.fname=[fpath(1:findex(end-2)), 'Figs/realdata'];
    print_fig(h,H)
end
