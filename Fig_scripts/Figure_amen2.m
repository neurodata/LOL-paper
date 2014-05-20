clearvars, clc,

task_list_name='amen tasks';
[T,S,P] = run_task_list(task_list_name);

%%

load('../../Data/Results/generalizations')

clear F
h=figure(1); clf,
F.plot_chance=false;
F.plot_bayes=false;
F.plot_risk=false;
F.Nrows=1;
F.Ncols=length(T);
F.location = 'NorthEast';
F.colors = {'g';'m'};
F.legend = {'LOL';'PCA'};
F.ylim=[0.2, 0.5];
F.orange=[1 0.6 0];
F.gray=0.75*[1 1 1];
F.ylim = [0.3, 0.5];
F.ytick = [F.ylim(1): 0.1: F.ylim(2)];
F.xlim = [0 50];
F.xtick=[0:10:50];
F.legendOn=0;
F.colors = {'k';F.gray;'m'};
F.yscale='linear';
F.legendOn=0;
F.linestyle={'-';'-';'-';'-'};
F.doxlabel=0;

for j=1:length(T)
    F.title = 'Amen';
    plot_Lhat(T{j},S{j},F,j)                % column 1: plot Lhats
end