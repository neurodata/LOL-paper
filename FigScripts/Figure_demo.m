% this script generates the simulation and plots the results for various
% possible options

%% set path correctly
clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end-2)));
addpath(p);

%% set up tasks
task.ks=20;
task.types={'DEFL'};
task.savestuff=0;
task.simulation=0;
task.name='mnist012';
task.ntrain=300;
task.ntrials=1;

%%

tic
[T,S,P] = run_task(task);
toc

%%

% fpath = mfilename('fullpath');
% load([fpath(1:end-28), 'Data/Results/amen tasks'])

clear F
h=figure(1); clf,
F.plot_chance=true;
F.plot_bayes=false;
F.plot_risk=false;
F.Nrows=7;
F.Ncols=3;
F.location = 'NorthEast';
F.colors = {'g';'m';'c';'y';'b';'r'};
F.legend = {'LOL';'PCA'};
F.orange=[1 0.6 0];
F.gray=0.75*[1 1 1];
F.ylim = [0.00, 0.25];
F.ytick = [F.ylim(1): 0.1: F.ylim(2)];
F.xlim = [0 100];
F.xtick=[0:20:100];
F.legendOn=0;
F.yscale='linear';
F.legendOn=0;
F.linestyle={'-';'-';'-';'-';'-';'-'};
F.doxlabel=0;
F.title = T.name;
plot_Lhat(T,S,F)                % column 1: plot Lhats
