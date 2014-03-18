function [T,P,S] = run_task_list(task_list_name)
updatepath

[task_list, task] = set_task_list(task_list_name);

for j=1:length(task_list)
    fprintf('\n task name = %s\n\n',task_list{j})
    task.name=task_list{j};
    [T{j},P{j},S{j}] = run_task(task);
end

if task.savestuff
    save(['../../data/results/', task_list_name],'T','P','S')
end
