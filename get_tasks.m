function tasks = get_tasks(names)

for i=1:length(names)

if strcmp(names,'sa') || strcmp(names,'sa') || strcmp(names,'r') || strcmp(names,'wra') || strcmp(names,'s') || strcmp(names,'w')
    for i=1:length(job_list_names)
        tasks{i}.name=job_list_names{i};            % name of task
        tasks{i}.simulation=1;                      % is this a simulation
        tasks{i}.QDA_model=1;                       % does this simulation satisfy the QDA model
        tasks{i}.ks=1:100;                          % list of dimensions to embed into
        tasks{i}.Nks=length(tasks{i}.ks);           % # of different dimensions
        tasks{i}.Kmax=max(tasks{i}.ks);             % max dimension
        tasks{i}.algs={'PCA','SDA','DRDA','LDA'};   % which algorithms to use
        tasks{i}.Nalgs=length(tasks{i}.algs);       % # of algorithms to use
        tasks{i}.savestuff=1;                       % flag whether to save data & figures
        tasks{i}.Ntrials=20;                        % # of trials
    end
elseif strcmp(names,'sw')
    tasks.tasks={'s';'w'}; 
    tasks.simulation=1;
    tasks.QDA_model=1;
elseif strcmp(tasks.job,'fat')
    tasks.tasks={'trunk';'toeplitz';'decaying';'trunk2';'model1';'model3'}; 
    tasks.simulation=1;
    tasks.QDA_model=1;
elseif strcmp(names,'sparse')
    tasks.tasks={'1'; '2'; '3'; '4'; '5'; '6'};
    tasks.simulation=1;
    tasks.QDA_model=1;
elseif strcmp(names,'DRL')
    tasks.tasks={'DRL0','DRL00','DRL01','DRL20','DRL200','DRL201'};    
    tasks.simulation=1;
    tasks.QDA_model=0;

elseif strcmp(names,'pancreas')
    tasks.tasks={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};
    tasks.simulation=0;
elseif strcmp(names,'pancreas2')
    tasks.tasks={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};
    tasks.simulation=0;
elseif strcmp(names,'pancreas_w')
    tasks.tasks={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};
    tasks.simulation=0;
elseif strcmp(names,'colon')
    tasks.tasks={'raw'};
    tasks.simulation=0;
elseif strcmp(names,'prostate')
    tasks.tasks={'raw'};
    tasks.simulation=0;
    tasks.algs={'PCA','SDA','DRDA'};      % LDA doesn't run on prostate data
end

end