function [task_list,task] = set_task_list(task_list_name)
% this function just lists 'sets' of tasks that we often want to run
% together. the 'else' command is if one specifies only a single task, in
% which case we just use that task.

if strcmp(task_list_name,'thin')
    task_list={'sa';'s';'w'};
    task.ks=unique(round(logspace(0,2,50)));
    task.Ntrials=10;
    task.algs={'NaiveB','LDA','PDA','SLOL','LOL','DRDA','RDA','RF','svm'};
    task.savestuff=1;
    
elseif strcmp(task_list_name,'pancreas')
    task_list={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};

elseif strcmp(task_list_name,'Mai13')
    task_list={'colon'; 'prostate'};
    task.ks=unique(round(logspace(0,2,50)));
    task.Ntrials=500;
    task.algs={'NaiveB','PDA','SLOL','LOL','DRDA','RDA','RF','svm'};
    task.savestuff=1;
    
elseif strcmp(task_list_name,'little_toeplitzs')
    task_list={'toeplitz, D=10';'toeplitz, D=20';'toeplitz, D=50';'toeplitz, D=100'};
    task.ks=unique(round(logspace(0,2,50)));
    task.Ntrials=10;
    task.algs={'NaiveB','LDA','PDA','SLOL','LOL','DRDA','RDA','RF','svm'};
    task.savestuff=1;

elseif strcmp(task_list_name,'toeplitzs')
    task_list={'toeplitz, D=10';'toeplitz, D=20';'toeplitz, D=50';'toeplitz, D=100';'toeplitz, D=1000'};
    task.ks=unique(round(logspace(0,2,50)));
    task.Ntrials=10;
    task.algs={'NaiveB','LDA','PDA','SLOL','LOL','DRDA','RDA','RF','svm'};
    task.savestuff=1;
    
elseif strcmp(task_list_name,'both_cigars')
    task_list={'parallel cigars';'rotated cigars'};
    
elseif strcmp(task_list_name,'all_cigars')
    task_list={'semisup cigars';'parallel cigars'; 'semisup rotated cigars'; 'rotated cigars'};
    task.ks=unique(round(logspace(0,2,50)));
    task.Ntrials=100;
    task.algs={'PDA','SLOL','LOL','DRDA'};
    task.savestuff=1;

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

elseif strcmp(task_list_name,'all')
    task_list={'sa';'s';'w';'trunk';'toeplitz';'decaying';'trunk2';...
        'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll';...
        'colon'; 'prostate';...
        'w'; 'w1'; 'w3';...
        'r';'wra';'wra2';...
        'model1, p100';'model1, p200';'model1, p400';'model1, p800';'model3, p100';'model3, p200';'model3, p400';'model3, p800';...
        'toeplitz, D=10';'toeplitz, D=20';'toeplitz, D=50';'toeplitz, D=100';...
        'semisup cigars';'parallel cigars';'rotated cigars';...
        '1'; '2'; '3'; '4'; '5'; '6'};

elseif strcmp(task_list_name,'all_sims')
    task_list={'sa';'s';'w';'trunk';'toeplitz';'decaying';'trunk2';...
        'w'; 'w1'; 'w2'; 'w3';...
        'r';'wra';'wra2';...
        'model1, p100';'model1, p200';'model1, p400';'model1, p800';'model3, p100';'model3, p200';'model3, p400';'model3, p800';...
        'toeplitz, D=10';'toeplitz, D=20';'toeplitz, D=50';'toeplitz, D=100';...
        'semisup cigars';'parallel cigars';'rotated cigars';...
        '1'; '2'; '3'; '4'; '5'; '6'};

elseif strcmp(task_list_name,'bunch')
    task_list={'sa';'s';'w';'trunk';'toeplitz';'decaying';'trunk2';...
        'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll';...
        'colon'; 'prostate';...
        'w'; 'w1'; 'w3';...
        'r';'wra';'wra2';...
        'semisup cigars';'parallel cigars';'rotated cigars';...
        'model1, p100';'model1, p200';'model1, p400';'model1, p800';'model3, p100';'model3, p200';'model3, p400';'model3, p800';...
        'toeplitz, D=10';'toeplitz, D=20';'toeplitz, D=50';'toeplitz, D=100'};

elseif strcmp(task_list_name,'amen READINGS')
    task_list={'amen READINGS depression';'amen READINGS adhd';'amen READINGS gender'}; %'amen mood';'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
elseif strcmp(task_list_name,'amen COGNITIVE')
    task_list={'amen COGNITIVE depression';'amen COGNITIVE adhd';'amen COGNITIVE gender'}; %'amen mood';'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
elseif strcmp(task_list_name,'amen SPECT')
    task_list={'amen SPECT depression';'amen SPECT adhd';'amen SPECT gender'}; %'amen mood';'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
elseif strcmp(task_list_name,'amen X')
    task_list={'amen X depression';'amen X adhd';'amen X gender'}; %'amen mood';'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
elseif strcmp(task_list_name,'amen ACTIVATION')
    task_list={'amen ACTIVATION depression';'amen ACTIVATION adhd';'amen ACTIVATION gender'}; %'amen mood';'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
elseif strcmp(task_list_name,'amen first')
    task_list={'amen depression';'amen adhd';'amen gender';'amen mood'};
elseif strcmp(task_list_name,'amen else')
    task_list={'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
else
    task_list = {task_list_name};
    task.name = task_list_name;
    task.Ntrials=5;
    task.algs={'NaiveB','LDA','LOL'};
    task.savestuff=1;
    task.ks=unique(round(logspace(0,2,50)));
end