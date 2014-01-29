clearvars,
%clc,

% task_list_names={'thin','sparse','fat','colon_prostate','pancreas'};
task_list_names={'increaseD2'};
% task_list_names={'Mai13','QDA','CaiLiu11','increaseD2','pancreas'};
% task_list_names={'thin','fat','MaiYuan12','Mai13','QDA','CaiLiu11','increaseD2','pancreas'};

just_plot=false;

if ~just_plot
    
    for i=1:length(task_list_names)
        display(task_list_names{i})
        [tasks, P, Phat, Proj, Stats] = run_task_list(task_list_names{i});
        plot_tasks(tasks,Stats,P,Proj,task_list_names{i})
    end
    
else % just plot
    
    for i=1:length(task_list_names)
        display(task_list_names{i})
        load(['../data/results/', task_list_names{i}]);
        plot_tasks(tasks,Stats,P,Proj,task_list_names{i})
    end
    
end