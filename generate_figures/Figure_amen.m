clearvars, clc,

task_list_names={'amen gender';'amen dementia';'amen depression'};
%%
profile on
for i=1:length(task_list_names)
    task_list_name=task_list_names{i};
    [T,P,S] = run_task_list(task_list_name);
end
profile viewer

%%
for i=1:length(task_list_names)
    F.ytick=0.1:0.1:0.5;
    F.plot_chance=true;
    F.plot_bayes=false;
    F.plot_risk=false;
    F.ylim=[0 0.5];
    F.plot_time=true;
    plot_benchmarks(task_list_names{i},F)
end
