function dataset_list = set_dataset_list(dataset_list_name)
% this function just lists 'sets' of datasets that we often want to run
% together. the 'else' command is if one specifies only a single dataset, in
% which case we just use that dataset.

if strcmp(dataset_list_name,'thin')
    dataset_list={'sa';'s';'w'};
elseif strcmp(dataset_list_name,'fat')
    dataset_list={'trunk';'toeplitz';'decaying';'trunk2'}; 
elseif strcmp(dataset_list_name,'MaiYuan12')
    dataset_list={'1'; '2'; '3'; '4'; '5'; '6'};
elseif strcmp(dataset_list_name,'DRL')
    dataset_list={'DRL0','DRL00','DRL01','DRL20','DRL200','DRL201'};    
elseif strcmp(dataset_list_name,'pancreas')
    dataset_list={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};
elseif strcmp(dataset_list_name,'Mai13')
    dataset_list={'colon'; 'prostate'};
elseif strcmp(dataset_list_name,'ww')
    dataset_list={'w'; 'w1'; 'w3'};
elseif strcmp(dataset_list_name,'LDA')
    dataset_list={'sa';'s'; 'w'; 'trunk';'toeplitz';'decaying';'trunk2';'1'; '2'; '3'; '4'; '5'; '6'};
elseif strcmp(dataset_list_name,'LDA1')
    dataset_list={'sa';'s'; 'w'; 'trunk';'toeplitz';'decaying';'trunk2';'model1';'model3'};
elseif strcmp(dataset_list_name,'QDA')
    dataset_list={'r';'wra';'wra2'};
elseif strcmp(dataset_list_name,'CaiLiu11')
    dataset_list={'model1, p100';'model1, p200';'model1, p400';'model1, p800';'model3, p100';'model3, p200';'model3, p400';'model3, p800'};
elseif strcmp(dataset_list_name,'increaseD')
    dataset_list={'increaseD10';'increaseD20';'increaseD50';'increaseD100'};
elseif strcmp(dataset_list_name,'all')
    dataset_list={'sa';'s';'w';'trunk';'toeplitz';'decaying';'trunk2';...
        '1'; '2'; '3'; '4'; '5'; '6';...
        'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll';...
        'colon'; 'prostate';...
        'w'; 'w1'; 'w3';...
        'r';'wra';'wra2';...
        'model1, p100';'model1, p200';'model1, p400';'model1, p800';'model3, p100';'model3, p200';'model3, p400';'model3, p800';...
        'increaseD10';'increaseD20';'increaseD50';'increaseD100'};
elseif strcmp(dataset_list_name,'all_sims')
    dataset_list={'sa';'s';'w';'trunk';'toeplitz';'decaying';'trunk2';...
        '1'; '2'; '3'; '4'; '5'; '6';...
        'w'; 'w1'; 'w2'; 'w3';...
        'r';'wra';'wra2';...
        'model1, p100';'model1, p200';'model1, p400';'model1, p800';'model3, p100';'model3, p200';'model3, p400';'model3, p800';...
        'increaseD10';'increaseD20';'increaseD50';'increaseD100'};
else 
    dataset_list = dataset_list_name;
end