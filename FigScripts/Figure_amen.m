clearvars,
clc,
fpath = mfilename('fullpath');
run([fpath(1:end-22), 'install_LOL.m'])
%%

task_list_name='amen tasks';
[T,S,P] = run_task_list(task_list_name);

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

for j=1:length(T)
    F.title = T{j}.name;
    plot_Lhat(T{j},S{j},F,j)                % column 1: plot Lhats
end