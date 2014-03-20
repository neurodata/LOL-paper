clearvars, clc,
run([pwd,'/../helper_fcns/updatepath.m'])

task.name='r';
task.algs={'LOL','QOL','QOQ'};
task.Ntrials=15;

[T,P,S] = run_task(task);

F=struct;
plot_benchmarks(task.name,F)
