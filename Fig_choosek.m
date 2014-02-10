clearvars,
clc,

% task_list_names={'thin','sparse','fat','colon_prostate','pancreas'};
task_list_names={'thin'};
% task_list_names={'Mai13','QDA','CaiLiu11','increaseD2','pancreas'};
% task_list_names={'thin','fat','MaiYuan12','Mai13','QDA','CaiLiu11','increaseD2','pancreas'};

just_plot=false;


for i=1:length(task_list_names)
    display(task_list_names{i})
    if ~just_plot
        [tasks, P, Stats] = run_task_list(task_list_names{i});
    else
        load(['../data/results/', task_list_names{i}]);
    end
    plot_tasks(tasks,Stats,task_list_names{i})
end

