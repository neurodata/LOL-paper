function task_list = set_task_list(task_list_name)
% this function just lists 'sets' of tasks that we often want to run
% together. the 'else' command is if one specifies only a single task, in
% which case we just use that task.

if strcmp(task_list_name,'thin')
    task_list={'sa';'s';'w'};
elseif strcmp(task_list_name,'fat')
    task_list={'trunk';'toeplitz';'decaying';'trunk2'}; 
elseif strcmp(task_list_name,'trunks')
    task_list={'trunk';'trunk2';'trunk3'}; 
elseif strcmp(task_list_name,'demo1')
    task_list={'cigars';'angled cigars';'trunk';'colon';'prostate'}; 
elseif strcmp(task_list_name,'MaiYuan12')
    task_list={'1'; '2'; '3'; '4'; '5'; '6'};
elseif strcmp(task_list_name,'DRL')
    task_list={'DRL0','DRL00','DRL01','DRL20','DRL200','DRL201'};    
elseif strcmp(task_list_name,'pancreas')
    task_list={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};
elseif strcmp(task_list_name,'Mai13')
    task_list={'colon'; 'prostate'};
elseif strcmp(task_list_name,'ww')
    task_list={'w'; 'w1'; 'w3'};
elseif strcmp(task_list_name,'LDA')
    task_list={'sa';'s'; 'w'; 'trunk';'toeplitz';'decaying';'trunk2';'1'; '2'; '3'; '4'; '5'; '6'};
elseif strcmp(task_list_name,'LDA1')
    task_list={'sa';'s'; 'w'; 'trunk';'toeplitz';'decaying';'trunk2';'model1';'model3'};
elseif strcmp(task_list_name,'QDA')
    task_list={'r';'wra';'wra2'};
elseif strcmp(task_list_name,'CaiLiu11')
    task_list={'model1, p100';'model1, p200';'model1, p400';'model1, p800';'model3, p100';'model3, p200';'model3, p400';'model3, p800'};
elseif strcmp(task_list_name,'toeplitzs')
    task_list={'toeplitz, D=10';'toeplitz, D=20';'toeplitz, D=50';'toeplitz, D=100'};
elseif strcmp(task_list_name,'all')
    task_list={'sa';'s';'w';'trunk';'toeplitz';'decaying';'trunk2';...
        'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll';...
        'colon'; 'prostate';...
        'w'; 'w1'; 'w3';...
        'r';'wra';'wra2';...
        'model1, p100';'model1, p200';'model1, p400';'model1, p800';'model3, p100';'model3, p200';'model3, p400';'model3, p800';...
        'toeplitz, D=10';'toeplitz, D=20';'toeplitz, D=50';'toeplitz, D=100';...
        '1'; '2'; '3'; '4'; '5'; '6'};
elseif strcmp(task_list_name,'all_sims')
    task_list={'sa';'s';'w';'trunk';'toeplitz';'decaying';'trunk2';...
        'w'; 'w1'; 'w2'; 'w3';...
        'r';'wra';'wra2';...
        'model1, p100';'model1, p200';'model1, p400';'model1, p800';'model3, p100';'model3, p200';'model3, p400';'model3, p800';...
        'toeplitz, D=10';'toeplitz, D=20';'toeplitz, D=50';'toeplitz, D=100';...
        '1'; '2'; '3'; '4'; '5'; '6'};
elseif strcmp(task_list_name,'both_cigars')
    task_list={'parallel cigars';'rotated cigars'}; 
elseif strcmp(task_list_name,'semi comp')
    task_list={'semisup cigars';'parallel cigars'}; 
else 
    task_list = {task_list_name};
end