clearvars, clc,
metatask='test_lda'
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_lda2'
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_lda3'
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_lda4'
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_LDA'
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
F.ylim=[0 0.5];
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_LDA2'
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_LDA3'
profile on
[T,S,P] = run_task_list(metatask); 
profile viewer

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_LDA4'
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_LDA5'
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_LDA6'
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_LDA7'
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_LDA8'
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_LDA9';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_Mai'
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='little_toeplitzs100'
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);


%%
clearvars, clc,
metatask='little_toeplitzs500'
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='little_toeplitzslq'
profile -memory on
[T,S,P] = run_task_list(metatask); 
profile viewer

F.plot_bayes=true;
plot_benchmarks(metatask,F);


%%
clearvars, clc,
metatask='little_toeplitzsq'
profile -memory on
[T,S,P] = run_task_list(metatask); 
profile viewer

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%
clearvars, clc,
metatask='test_qda';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);

%%

clearvars, clc,
metatask='3 cigars';
[T,S,P] = run_task_list(metatask); 

F.plot_bayes=true;
plot_benchmarks(metatask,F);






