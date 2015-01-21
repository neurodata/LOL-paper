clear, clf, clc

fpath=pwd;
findex=strfind(fpath,'/');
p = genpath(fpath(1:findex(end)));
addpath(p);

tasknames={'diag_slow';'rand_slow'};
task.save=0;
task.B=100;
task.Ndim=5;
task.D=200;
task.n=100;
task.bvec=[1,5,10,15,20,25,50,100,250,500];
task.Ntrials=500;

[T,S] = run_hotelling_sims(tasknames,task);

save(['../Data/Results/Lopes11a'],'T','S','task')

plot_hotelling(T,S,1,4,1)