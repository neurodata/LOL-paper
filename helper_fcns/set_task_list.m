function [task_list,task] = set_task_list(metatask)
% this function generates a number of tasks to run
% 
% INPUT:   
%   metatask (char): the name of a pre-defined task list
% 
% OUTPUT
%   task_list: an array of strings, each 1 naming a task
%   task: details that are consistent for each task

if nargin==1, task=struct; end
        
if strcmp(metatask,'thin')
    task_list={'sa';'s';'w'};
    task.ks=unique(floor(logspace(0,2,50)));
    task.Ntrials=10;
    task.algs={'NaiveB','LDA','PDA','SLOL','LOL','DRDA','RDA','RF','svm'};
    task.savestuff=1;
    
elseif strcmp(metatask,'pancreas')
    task_list={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};

elseif strcmp(metatask,'Mai13')
    task_list={'colon'; 'prostate'};
    task.ks=unique(floor(logspace(0,2,50)));
    task.Ntrials=500;
    task.algs={'NaiveB','PDA','SLOL','LOL','DRDA','RDA','RF','svm'};
    task.savestuff=1;
    
elseif strcmp(metatask,'test_Mai')
    task_list={'colon'; 'prostate'};
    task.ks=unique(floor(logspace(0,2,50)));
    task.Ntrials=10;
    task.algs={'LDA','QDA','LOL'};
    task.savestuff=1;

elseif strcmp(metatask,'little_toeplitzs')
    task_list={'toeplitz, D=10';'toeplitz, D=20';'toeplitz, D=50';'toeplitz, D=100'};
    task.ntrain=50;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),task.ntrain)));
    task.Ntrials=10;
    task.algs={'NaiveB','LDA','PDA','SLOL','LOL','DRDA','RDA','RF','svm'};
    task.savestuff=1;

elseif strcmp(metatask,'little_toeplitzs500')
    task_list={'toeplitz, D=10'};
    task.ntrain=500;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),task.ntrain)));
    task.Ntrials=10;
    task.algs={'LDA','lda','QDA','qda'};
    task.savestuff=1;

elseif strcmp(metatask,'little_toeplitzslq')
    task_list={'toeplitz, D=100';'a'};
    task.ntrain=500;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),task.ntrain)));
    task.Ntrials=500;
    task.algs={'LDA','lda','QDA','qda'};
    task.savestuff=1;
    
elseif strcmp(metatask,'little_toeplitzsl')
    task_list={'toeplitz, D=100';'a'};
    task.ntrain=50;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),task.ntrain)));
    task.Ntrials=10;
    task.algs={'LDA','lda'};
    task.savestuff=1;

elseif strcmp(metatask,'little_toeplitzsq')
    task_list={'toeplitz, D=100';'a'};
    task.ntrain=500;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),task.ntrain)));
    task.Ntrials=10;
    task.algs={'QDA','qda'};
    task.savestuff=1;

elseif strcmp(metatask,'little_toeplitzs100')
    task_list={'toeplitz, D=10'};
    task.ntrain=100;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),task.ntrain)));
    task.Ntrials=10;
    task.algs={'LDA','lda','QDA','qda'};
    task.savestuff=1;

elseif strcmp(metatask,'toeplitzs')
    task_list={'toeplitz, D=10';'toeplitz, D=20';'toeplitz, D=50';'toeplitz, D=100'};
    task.ntrain=50;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),task.ntrain)));
    task.Ntrials=40;
    task.algs={'LOL'};
    task.types={'NNNN';'NENL';'DENL';'DRNL';'NRNL'};
    task.savestuff=1;
    
elseif strcmp(metatask,'toeplitz100')
    task_list={'toeplitz, D=100'};
    task.ntrain=50;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),task.ntrain)));
    task.Ntrials=40;
    task.algs={'LOL'};
    task.types={'NNNN';'NENL';'DENL';'DRNL';'NRNL'};
    task.savestuff=1;

elseif strcmp(metatask,'toeplitz_timing')
    task_list={'toeplitz, D=10';'toeplitz, D=20';'toeplitz, D=50';'toeplitz, D=100';'toeplitz, D=1000'};
    task.ntrain=50;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),task.ntrain)));
    task.Ntrials=10;
%     task.algs={'NaiveB','LDA','PDA','SLOL','LOL','DRDA','RDA','RF','svm'};
    task.algs={'LOL'};
    task.types={'NNNN';'NENL';'DENL';'DRNL';'NRNL';'NNNS';'NNNR'};
    task.savestuff=1;

elseif strcmp(metatask,'both_cigars')
    task_list={'parallel cigars';'rotated cigars'};
    
elseif strcmp(metatask,'all_cigars')
    task_list={'semisup cigars';'parallel cigars'; 'semisup rotated cigars'; 'rotated cigars'};
    task.ks=unique(floor(logspace(0,2,50)));
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
elseif strcmp(metatask,'timingtest')
    task_list={'s','toeplitz, D=50'};
    task.algs={'LOL','PDA','LDA'};
    task.D=100;
    task.ntrain=50;
    task.ks=[1, 30];
    task.Ntrials=5;
    
elseif strcmp(metatask,'amen READINGS')
    task_list={'amen READINGS depression';'amen READINGS adhd';'amen READINGS gender'}; %'amen mood';'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
elseif strcmp(metatask,'amen COGNITIVE')
    task_list={'amen COGNITIVE depression';'amen COGNITIVE adhd';'amen COGNITIVE gender'}; %'amen mood';'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
elseif strcmp(metatask,'amen SPECT')
    task_list={'amen SPECT depression';'amen SPECT adhd';'amen SPECT gender'}; %'amen mood';'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
elseif strcmp(metatask,'amen X')
    task_list={'amen X depression';'amen X adhd';'amen X gender'}; %'amen mood';'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
elseif strcmp(metatask,'amen ACTIVATION')
    task_list={'amen ACTIVATION depression';'amen ACTIVATION adhd';'amen ACTIVATION gender'}; %'amen mood';'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
elseif strcmp(metatask,'amen first')
    task_list={'amen depression';'amen adhd';'amen gender';'amen mood'};
elseif strcmp(metatask,'amen else')
    task_list={'amen dementia';'amen bipolar';'amen adjustment';'amen anxiety'};
elseif strcmp(metatask,'amen gender')
    task_list={'amen READINGS gender';'amen COGNITIVE gender';'amen SPECT gender';'amen ACTIVATION gender';'amen X gender';'amen BASELINE gender';'amen CONCENTRATION gender';'amen CR gender'};
    task.algs={'NaiveB','LDA','QDA','RF','LOL','QOL','QOQ'};
    task.simulation = 0;
    task.ntrain=5112;
    task.ntest=569;
    task.ks=unique(floor(logspace(0,2.9,30))); 
    task.Ntrials = 5;
elseif strcmp(metatask,'amen dementia')
    task_list={'amen READINGS dementia';'amen COGNITIVE dementia';'amen SPECT dementia';'amen ACTIVATION dementia';'amen X dementia';'amen BASELINE dementia';'amen CONCENTRATION dementia';'amen CR dementia'};
    task.algs={'NaiveB','LDA','QDA','RF','LOL','QOL','QOQ'};
    task.simulation = 0;
    task.ntrain=5112;
    task.ntest=569;
    task.ks=unique(floor(logspace(0,2.9,30))); 
    task.Ntrials = 5;

elseif strcmp(metatask,'amen depression')
    task_list={'amen READINGS depression';'amen COGNITIVE depression';'amen SPECT depression';'amen ACTIVATION depression';'amen X depression';'amen BASELINE depression';'amen CONCENTRATION depression';'amen CR depression'};
    task.algs={'NaiveB','LDA','QDA','RF','LOL','QOL','QOQ'};
    task.simulation = 0;
    task.ntrain=5112;
    task.ntest=569;
    task.ks=unique(floor(logspace(0,2.9,30))); 
    task.Ntrials = 5;
else
    task_list = {metatask};
    task.name = metatask;
end

if ~isfield(task,'savestuff'), task.savestuff=1; end