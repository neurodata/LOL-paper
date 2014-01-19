function tasks = get_task_lists(task_list_name)

if strcmp(task_list_name,'thin')
    task_list={'sa';'r';'wra'; 's'; 'w'};
elseif strcmp(task_list_name,'sw')
    tasks.tasks={'s';'w'}; 
    tasks.simulation=1;
    tasks.QDA_model=1;
elseif strcmp(tasks.job,'fat')
    tasks.tasks={'trunk';'toeplitz';'decaying';'trunk2';'model1';'model3'}; 
    tasks.simulation=1;
    tasks.QDA_model=1;
elseif strcmp(task_list_name,'sparse')
    tasks.tasks={'1'; '2'; '3'; '4'; '5'; '6'};
    tasks.simulation=1;
    tasks.QDA_model=1;
elseif strcmp(task_list_name,'DRL')
    tasks.tasks={'DRL0','DRL00','DRL01','DRL20','DRL200','DRL201'};    
    tasks.simulation=1;
    tasks.QDA_model=0;

elseif strcmp(task_list_name,'pancreas')
    tasks.tasks={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};
    tasks.simulation=0;
elseif strcmp(task_list_name,'pancreas2')
    tasks.tasks={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};
    tasks.simulation=0;
elseif strcmp(task_list_name,'pancreas_w')
    tasks.tasks={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};
    tasks.simulation=0;
elseif strcmp(task_list_name,'colon')
    tasks.tasks={'raw'};
    tasks.simulation=0;
elseif strcmp(task_list_name,'prostate')
    tasks.tasks={'raw'};
    tasks.simulation=0;
    tasks.algs={'PCA','SDA','DRDA'};      % LDA doesn't run on prostate data
end