function [T,P,S] = run_benchmarks(task_list_name,task)
clc, updatepath

task_list = set_task_list(task_list_name);

for j=1:length(task_list)
    fprintf('\n task name = %s\n\n',task_list{j})
    task.name=task_list{j};
    [T{j},P{j},S{j}] = run_task(task);
end