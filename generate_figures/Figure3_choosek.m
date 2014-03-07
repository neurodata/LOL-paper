clearvars, clc, updatepath

just_plot=true;
task_list_name='all';
task_list = set_task_list(task_list_name);
renderer='zbuffer'; % options: 'painters', 'zbuffer', 'OpenGL'

if just_plot==false;
    for j=1:length(task_list)
        display(task_list{j})
        
        task.name=task_list{j};
        task.ks=1:50;
        task.Ntrials=100;
        task.algs={'LDA','PDA','SLOL','LOL'};
        task.savestuff=1;
        
        [tasks{j},P{j},Stats{j}] = run_task(task);
    end
    save(['../../data/results/', task_list_name])
else
    load(['../../data/results/', task_list_name])
end
plot_choosek(tasks,Stats,task_list_name,renderer)
