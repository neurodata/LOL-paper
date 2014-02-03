function [datasets, P, Phat, Proj, Stats] = run_dataset_list(dataset_list_name)
% iterate over the list of datasets, and for each, run the dataset

dataset_list = set_dataset_list(dataset_list_name);
if ischar(dataset_list)
    [datasets{1},P{1},Phat{1},Proj{1},Stats{1}] = run_dataset(dataset_list);
else
    for j=1:length(dataset_list)
        display(dataset_list{j})
        [datasets{j},P{j},Phat{j},Proj{j},Stats{j}] = run_dataset(dataset_list{j});
    end
end

save(['../data/results/', dataset_list_name])