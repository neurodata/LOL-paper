clearvars, clc, updatepath

task_list_name='pancreas';
task_list = set_task_list(task_list_name);
renderer='painters'; % options: 'painters', 'zbuffer', 'OpenGL'

    for j=1:length(task_list)
        load(['../../data/results/', task_list{j}])
        T{j}=task;
        S{j}=Stats;
    end
plot_choosek(T,S,task_list_name,renderer)

