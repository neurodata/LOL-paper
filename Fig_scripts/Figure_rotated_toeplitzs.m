clearvars, clc, 

metatask='rotated_toeplitzs';

[T,S,P] = run_task_list(metatask);

%%

clear F
F.plot_chance=false;
F.plot_bayes=false; 
F.plot_risk=false; 
F.plot_time=false;

plot_benchmarks(metatask,F)

