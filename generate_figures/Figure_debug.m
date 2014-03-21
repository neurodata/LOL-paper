profile on
clearvars, clc,
run([pwd,'/../helper_fcns/updatepath.m'])


metatask='s';
% task_list={'s','w'};
% task.algs={'LOL','PDA','LDA'};
% task.D=100;
% task.ntrain=50;
% task.ks=[50, 100];
% task.Ntrials=5;

% [T,P,S] = run_task_list(metatask); 
[T,P,S] = run_task(metatask);

% profile viewer

F.plot_bayes=true;
plot_benchmarks(metatask,F)


