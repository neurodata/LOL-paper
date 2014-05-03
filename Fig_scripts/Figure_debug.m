profile on
clearvars, clc,


metatask='timingtest';

[T,P,S] = run_task_list(metatask); 
% [T,P,S] = run_task(task);

% profile viewer

F.plot_bayes=true;
plot_benchmarks(metatask,F)


