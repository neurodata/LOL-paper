clearvars, clc,
run([pwd,'/../helper_fcns/updatepath.m'])

task_list_names={'amen READINGS';'amen COGNITIVE';'amen SPECT'; 'amen X'; 'amen ACTIVATION'};

for i=1:length(task_list_names)
    task_list_name=task_list_names{i};
    [T,P,S] = run_task_list(task_list_name);
end


for i=1:length(task_list_names)
    F.ytick=0.1:0.1:0.5;
    F.plot_chance=true;
    F.plot_bayes=false;
    F.plot_risk=false;
    plot_benchmarks(task_list_name,F)
end
