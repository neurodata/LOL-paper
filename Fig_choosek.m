clearvars,
%clc,

% dataset_list_names={'thin','sparse','fat','colon_prostate','pancreas'};
dataset_list_names={'thin'};
% dataset_list_names={'Mai13','QDA','CaiLiu11','increaseD2','pancreas'};
% dataset_list_names={'thin','fat','MaiYuan12','Mai13','QDA','CaiLiu11','increaseD2','pancreas'};

just_plot=false;


for i=1:length(dataset_list_names)
    display(dataset_list_names{i})
    if ~just_plot
        [datasets, P, Phat, Proj, Stats] = run_dataset_list(dataset_list_names{i});
    else
        load(['../data/results/', dataset_list_names{i}]);
    end
    plot_datasets(datasets,Stats,P,Proj,dataset_list_names{i})
end

