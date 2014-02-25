clearvars, clc, updatepath

just_plot=true;
task_list_name='fat';
task_list = set_task_list(task_list_name);


if just_plot==false;
    for j=1:length(task_list)
        display(task_list{j})
        
        task.name=task_list{j};
        task.ks=1:100;
        task.Ntrials=20;
        task.algs={'LDA','PDA','LOL','DRDA'};

        [tasks{j},P{j},Stats{j}] = run_task(task);
    end
    save(['../../data/results/', task_list_name])
    plot_tasks(tasks,Stats,task_list_name)
else
    load(['../../data/results/', task_list_name])
    plot_tasks(tasks,Stats,task_list_name)
end
