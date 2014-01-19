function [tasks, P, Phat, Proj, Stats] = run_task_list(task_list_name)
% iterate over the list of tasks, and for each, run the task

task_list = get_task_list(task_list_name);
if ischar(task_list)
    [tasks{1},P{1},Phat{1},Proj{1},Stats{1}] = run_task(task_list);
else
    for j=1:length(task_list)
        display(task_list{j})
        [tasks{j},P{j},Phat{j},Proj{j},Stats{j}] = run_task(task_list{j});
    end
end

save(['../data/results/', task_list_name])