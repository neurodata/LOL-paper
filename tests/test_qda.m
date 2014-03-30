profile on
clearvars, clc,
metatask='test_qda';
[T,S,P] = run_task_list(metatask); 
profile viewer

F.plot_bayes=true;
plot_benchmarks(metatask,F)
