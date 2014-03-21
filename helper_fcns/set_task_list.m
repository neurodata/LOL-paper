function [task_list,task] = set_task_list(metatask)
% this function generates a number of tasks to run
% 
% INPUT:   metatask (char): the name of a pre-defined task list
% 
% OUTPUT
%   task_list: an array of strings, each 1 naming a task
%   task: details that are consistent for each task

if nargin==1, task=struct; end
        
if strcmp(metatask,'thin')
    task_list={'sa';'s';'w'};
    task.ks=unique(round(logspace(0,2,50)));
    task.Ntrials=10;
    task.algs={'NaiveB','LDA','PDA','SLOL','LOL','DRDA','RDA','RF','svm'};
    task.savestuff=1;
    
elseif strcmp(metatask,'pancreas')
    task_list={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};

elseif strcmp(metatask,'Mai13')
    task_list={'colon'; 'prostate'};
    task.ks=unique(round(logspace(0,2,50)));
    task.Ntrials=500;
    task.algs={'NaiveB','PDA','SLOL','LOL','DRDA','RDA','RF','svm'};
    task.savestuff=1;
    
elseif strcmp(metatask,'little_toeplitzs')
    task_list={'toeplitz, D=10';'toeplitz, D=20';'toeplitz, D=50';'toeplitz, D=100'};
    task.ntrain=50;
    task.ks=unique(round(logspace(0,log10(task.ntrain),task.ntrain)));
    task.Ntrials=10;
    task.algs={'NaiveB','LDA','PDA','SLOL','LOL','DRDA','RDA','RF','svm'};
    task.savestuff=1;

elseif strcmp(metatask,'toeplitzs')
    task_list={'toeplitz, D=10';'toeplitz, D=20';'toeplitz, D=50';'toeplitz, D=100';'toeplitz, D=1000'};
    task.ntrain=50;
    task.ks=unique(round(logspace(0,log10(task.ntrain),task.ntrain)));
    task.Ntrials=10;
    task.algs={'NaiveB','LDA','PDA','SLOL','LOL','DRDA','RDA','RF','svm'};
    task.savestuff=1;
    
elseif strcmp(metatask,'both_cigars')
    task_list={'parallel cigars';'rotated cigars'};
    
elseif strcmp(metatask,'all_cigars')
    task_list={'semisup cigars';'parallel cigars'; 'semisup rotated cigars'; 'rotated cigars'};
    task.ks=unique(round(logspace(0,2,50)));
    task.Ntrials=100;
    task.algs={'PDA','SLOL','LOL','DRDA'};
    task.savestuff=1;

elseif strcmp(metatask,'fat')
    task_list={'trunk';'toeplitz';'decaying';'trunk2'};
elseif strcmp(metatask,'trunks')
    task_list={'trunk';'trunk2';'trunk3'};
elseif strcmp(metatask,'demo1')
    task_list={'cigars';'angled cigars';'trunk';'colon';'prostate'};
elseif strcmp(metatask,'MaiYuan12')
    task_list={'1'; '2'; '3'; '4'; '5'; '6'};
elseif strcmp(metatask,'DRL')
    task_list={'DRL0','DRL00','DRL01','DRL20','DRL200','DRL201'};
elseif strcmp(metatask,'ww')
    task_list={'w'; 'w1'; 'w3'};
elseif strcmp(metatask,'LDA')
    task_list={'sa';'s'; 'w'; 'trunk';'toeplitz';'decaying';'trunk2';'1'; '2'; '3'; '4'; '5'; '6'};
elseif strcmp(metatask,'LDA1')
    task_list={'sa';'s'; 'w'; 'trunk';'toeplitz';'decaying';'trunk2';'model1';'model3'};
elseif strcmp(metatask,'QDA')
    task_list={'r';'wra';'wra2'};
elseif strcmp(metatask,'CaiLiu11')
    task_list={'model1, p100';'model1, p200';'model1, p400';'model1, p800';'model3, p100';'model3, p200';'model3, p400';'model3, p800'};

elseif strcmp(metatask,'all')
    task_list={'sa';'s';'w';'trunk';'toeplitz';'decaying';'trunk2';...
        'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll';...
        'colon'; 'prostate';...
        'w'; 'w1'; 'w3';...
        'r';'wra';'wra2';...
        'model1, p100';'model1, p200';'model1, p400';'model1, p800';'model3, p100';'model3, p200';'model3, p400';'model3, p800';...
        'toeplitz, D=10';'toeplitz, D=20';'toeplitz, D=50';'toeplitz, D=100';...
        'semisup cigars';'parallel cigars';'rotated cigars';...
        '1'; '2'; '3'; '4'; '5'; '6'};

elseif strcmp(metatask,'all_sims')
    task_list={'sa';'s';'w';'trunk';'toeplitz';'decaying';'trunk2';...
        'w'; 'w1'; 'w2'; 'w3';...
        'r';'wra';'wra2';...
        'model1, p100';'model1, p200';'model1, p400';'model1, p800';'model3, p100';'model3, p200';'model3, p400';'model3, p800';...
        'toeplitz, D=10';'toeplitz, D=20';'toeplitz, D=50';'toeplitz, D=100';...
        'semisup cigars';'parallel cigars';'rotated cigars';...
        '1'; '2'; '3'; '4'; '5'; '6'};

elseif strcmp(metatask,'bunch')
    task_list={'sa';'s';'w';'trunk';'toeplitz';'decaying';'trunk2';...
        'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll';...
        'colon'; 'prostate';...
        'w'; 'w1'; 'w3';...
        'r';'wra';'wra2';...
        'semisup cigars';'parallel cigars';'rotated cigars';...
        'model1, p100';'model1, p200';'model1, p400';'model1, p800';'model3, p100';'model3, p200';'model3, p400';'model3, p800';...
        'toeplitz, D=10';'toeplitz, D=20';'toeplitz, D=50';'toeplitz, D=100'};
elseif strcmp(metatask,'thisisatest')
    task_list={'s','w'};
    task.algs={'LOL','PDA','LDA'};
    task.D=100;
    task.ntrain=50;
    task.ks=[50, 100];
    task.Ntrials=5;
    
elseif strfind(metatask,'amen READINGS')
    task_list={'amen READINGS depression';'amen READINGS adhd';'amen READINGS gender'}; %'amen mood';'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
elseif strfind(metatask,'amen COGNITIVE')
    task_list={'amen COGNITIVE depression';'amen COGNITIVE adhd';'amen COGNITIVE gender'}; %'amen mood';'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
elseif strfind(metatask,'amen SPECT')
    task_list={'amen SPECT depression';'amen SPECT adhd';'amen SPECT gender'}; %'amen mood';'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
elseif strfind(metatask,'amen X')
    task_list={'amen X depression';'amen X adhd';'amen X gender'}; %'amen mood';'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
elseif strfind(metatask,'amen ACTIVATION')
    task_list={'amen ACTIVATION depression';'amen ACTIVATION adhd';'amen ACTIVATION gender'}; %'amen mood';'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
elseif strfind(metatask,'amen first')
    task_list={'amen depression';'amen adhd';'amen gender';'amen mood'};
elseif strfind(metatask,'amen else')
    task_list={'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
else
    task_list = {metatask};
    task.name = metatask;
%     if ~isfield(task,'Ntrials'), task.Ntrials=5; end
%     if ~isfield(task,'algs'), task.algs={'NaiveB','LDA','LOL'}; end
%     if ~isfield(task,'savestuff'), task.savestuff=1; end
%     if ~isfield(task,'ks'), task.ks=unique(round(logspace(0,2,50))); end
end

if ~isfield(task,'savestuff'), task.savestuff=1; end