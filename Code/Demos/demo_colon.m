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
task.algs={'LOL';'ROAD'};
task.types={'DENL'};
task.savestuff=1;
task.simulation=0;
task.name='Prostate';
task.ntrials=2;
task.ks=unique(round(logspace(0,1.5,10)));

[T,S,P] = run_task(task);

%%

clear F
h=figure(1); clf,
F.plot_chance=true;
F.plot_bayes=false;
F.plot_risk=false;
F.Nrows=7;
F.Ncols=3;
F.location = 'NorthEast';
F.colors = {'g';'m';'c';'y';'b';'r'};
F.legend = {'LOL';'ROAD'};
F.orange=[1 0.6 0];
F.gray=0.75*[1 1 1];
F.ylim = [0.00, 0.5];
F.ytick = [F.ylim(1): 0.1: F.ylim(2)];
F.xlim = [0 T.Kmax];
F.xtick=[5:5:30];
F.legendOn=0;
F.yscale='linear';
F.legendOn=0;
F.linestyle={'-';'-';'-';'-';'-';'-'};
F.doxlabel=0;
F.title = T.name;
F.xlabel='# of embedded dimensions';
plot_Lhat(T,S,F)                % column 1: plot Lhats


%%

