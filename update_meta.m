function job = update_meta(job)
% choose settings, for simulations

% set a bunch of little constants that help make code easier to read
tasks.Nks=length(tasks.ks);
tasks.Kmax=max(tasks.ks);
tasks.Nalgs=length(tasks.algs);
tasks.Ntasks=length(tasks.tasks);



if strcmp(tasks.job,'thin')
    tasks.tasks={'sa';'r';'wra'; 's'; 'w'};
    tasks.simulation=1;
    tasks.QDA_model=1;
elseif strcmp(tasks.job,'sw')
    tasks.tasks={'s';'w'}; 
    tasks.simulation=1;
    tasks.QDA_model=1;
elseif strcmp(tasks.job,'fat')
    tasks.tasks={'trunk';'toeplitz';'decaying';'trunk2';'model1';'model3'}; 
    tasks.simulation=1;
    tasks.QDA_model=1;
elseif strcmp(tasks.job,'sparse')
    tasks.tasks={'1'; '2'; '3'; '4'; '5'; '6'};
    tasks.simulation=1;
    tasks.QDA_model=1;
elseif strcmp(tasks.job,'DRL')
    tasks.tasks={'DRL0','DRL00','DRL01','DRL20','DRL200','DRL201'};    
    tasks.simulation=1;
    tasks.QDA_model=0;

elseif strcmp(tasks.job,'pancreas')
    tasks.tasks={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};
    tasks.simulation=0;
elseif strcmp(tasks.job,'pancreas2')
    tasks.tasks={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};
    tasks.simulation=0;
elseif strcmp(tasks.job,'pancreas_w')
    tasks.tasks={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};
    tasks.simulation=0;
elseif strcmp(tasks.job,'colon')
    tasks.tasks={'raw'};
    tasks.simulation=0;
elseif strcmp(tasks.job,'prostate')
    tasks.tasks={'raw'};
    tasks.simulation=0;
end