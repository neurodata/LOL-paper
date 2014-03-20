clearvars, clc,
run([pwd,'/../helper_fcns/updatepath.m'])

task.ntrain=10000;
task.D=500;
task.name='s';
task.algs={'LDA','lda'};
task.Ntrials=5;

% task_list_name=task_list_names{i};
% [T,P,S] = run_task_list(task_list_name);

[T,P,S] = run_task(task);

F.plot_bayes=true;
plot_benchmarks(task.name,F)


