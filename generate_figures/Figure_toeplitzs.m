clearvars, clc, 

task_list_name='toeplitzs';

[T,P,S] = run_task_list(task_list_name);

F.ytick=0.1:0.1:0.5;
F.plot_chance=true;
F.plot_bayes=false; 
F.plot_risk=true; 

plot_benchmarks(task_list_name,F)

[Lhats, times] = plot_Lhat_vs_time_compile(T,S,task_list_name);