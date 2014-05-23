clearvars, clc,
metatask='test_qol'
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);
