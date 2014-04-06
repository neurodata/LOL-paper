clearvars, clc,
metatask='test_lda';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_lda2';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_lda3';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_lda4';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_mlda';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
F.ylim=[0 0.5];
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_mlda2';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_mlda3';
profile on
[T,S,P] = run_task_list(metatask); 
profile viewer

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_mlda4';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_mlda5';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_mlda6';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_mlda7';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_mlda8';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);