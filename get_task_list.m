function task_list = get_task_list(task_list_name)

if strcmp(task_list_name,'thin')
    task_list={'sa';'r';'wra'; 's'; 'w'};
elseif strcmp(task_list_name,'fat')
    task_list={'trunk';'toeplitz';'decaying';'trunk2';'model1';'model3'}; 
elseif strcmp(task_list_name,'sparse')
    task_list={'1'; '2'; '3'; '4'; '5'; '6'};
elseif strcmp(task_list_name,'DRL')
    task_list={'DRL0','DRL00','DRL01','DRL20','DRL200','DRL201'};    
elseif strcmp(task_list_name,'pancreas')
    task_list={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};
elseif strcmp(task_list_name,'colon_prostate')
    task_list=[{'colon'}; {'prostate'}];
elseif strcmp(task_list_name,'ww')
    task_list=[{'w'}; {'w2'}];
elseif strcmp(task_list_name,'QDA')
    task_list={'sa';'s'; 'w'; 'trunk';'toeplitz';'decaying';'trunk2';'model1';'model3';'1'; '2'; '3'; '4'; '5'; '6'};
else 
    task_list = task_list_name;
end