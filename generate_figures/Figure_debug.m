profile on
clearvars, clc,
run([pwd,'/../helper_fcns/updatepath.m'])


metatask='timingtest';

[T,P,S] = run_task_list(metatask); 
% [T,P,S] = run_task(task);

% profile viewer

F.plot_bayes=true;
plot_benchmarks(metatask,F)


