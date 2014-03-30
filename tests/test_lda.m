clearvars, clc,
metatask='test_lda';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F)

%%
clearvars, clc,
metatask='test_lda2';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F)

%%
clearvars, clc,
metatask='test_lda3';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F)

%%
clearvars, clc,
metatask='test_lda4';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F)

%%
profile on
clearvars, clc,
metatask='test_mlda';
[T,S,P] = run_task_list(metatask); 
profile viewer

F.plot_bayes=true;
plot_benchmarks(metatask,F)