clearvars, clc, 

task_list_name='toeplitzs';

[T,S,P] = run_task_list(task_list_name);

%%
clear F
F.plot_chance=true;
F.plot_bayes=false; 
F.plot_risk=false; 
F.plot_time=false;

plot_benchmarks(task_list_name,F)

