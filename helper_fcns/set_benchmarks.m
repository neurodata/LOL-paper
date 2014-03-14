% profile on

clearvars, clc, updatepath
task_list_name='Mai13';
task.ks=unique(round(logspace(0,2,50)));
task.Ntrials=100;
task.algs={'LDA','PDA','SLOL','LOL','DRDA','RDA','treebagger','svm'};
task.savestuff=1;

[T,P,S] = run_benchmarks(task_list_name,task);
Figure_benchmarks(task_list_name)

% profile viewer