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
    task.ntrials=10;
    task.algs={'NaiveB','LDA','PDA','SLOL','LOL','DRDA','RDA','RF','svm'};
    task.savestuff=1;
    
elseif strcmp(metatask,'pancreas')
    task_list={'IPMN-HvL';'IPMN-HvML'; 'IPMN-HMvL';'IPMNvsAll';'MCNvsAll';'SCAvsAll'};

elseif strcmp(metatask,'Mai13')
    task_list={'colon'; 'prostate'};
    task.ks=unique(floor(logspace(0,2,50)));
    task.ntrials=500;
    task.algs={'NaiveB','PDA','SLOL','LOL','DRDA','RDA','RF','svm'};
    task.savestuff=1;
    
elseif strcmp(metatask,'toeplitzs')
    task_list={'toeplitz, D=10';'toeplitz, D=20';'toeplitz, D=50';'toeplitz, D=100'};
    task.ntrain=50;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),task.ntrain)));
    task.ntrials=40;
    task.algs={'LOL'};
    task.types={'NNNN';'NENL';'DENL';'DRNL';'NRNL'};
    task.savestuff=1;


elseif strcmp(metatask,'rotated_toeplitzs')
    task_list={'rtoeplitz, D=10';'rtoeplitz, D=20';'rtoeplitz, D=50';'rtoeplitz, D=100'};
    task.ntrain=50;
    task.ks=unique(floor(logspace(0,log10(task.ntrain),task.ntrain)));
    task.ntrials=40;
    task.algs={'LOL'};
    task.types={'DENL';'DVNL';'DVNQ';'DENQ'};
    task.savestuff=1;

elseif strcmp(metatask,'two_trunks')
    task_list={'trunk4, D=100';'atrunk4, D=100'};

elseif strcmp(metatask,'three_trunks')
    task_list={'ntrunk4, D=1000'; 'otrunk4, D=1000';'atrunk4, D=1000'};

elseif strcmp(metatask,'both_cigars')
    task_list={'parallel cigars';'angled cigars'};

elseif strcmp(metatask,'cs')
    task_list={'ac';'oc';'rc'};

elseif strcmp(metatask,'four_cigars')
    task_list={'parallel cigars';'rotated cigars';'angled cigars'};

elseif strcmp(metatask,'all_cigars')
    task_list={'semisup cigars';'parallel cigars'; 'semisup rotated cigars'; 'rotated cigars'};
    task.ks=unique(floor(logspace(0,2,50)));
    task.ntrials=100;
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
    task.ntrials=5;
    

elseif strcmp(metatask,'amen tasks')
    task_list={...
        'amen COGNITIVE PTSD vs Healthy';'amen COGNITIVE TBI vs Healthy';'amen COGNITIVE NC PTSD vs TBI';...
        'amen ACTIVATION PTSD vs Healthy';'amen ACTIVATION TBI vs Healthy';'amen ACTIVATION NC PTSD vs TBI';...
        'amen READINGS PTSD vs Healthy';'amen READINGS TBI vs Healthy';'amen READINGS NC PTSD vs TBI';...
        'amen BASELINE PTSD vs Healthy';'amen BASELINE TBI vs Healthy';'amen BASELINE NC PTSD vs TBI';...
        'amen SPECT PTSD vs Healthy';'amen SPECT TBI vs Healthy';'amen SPECT NC PTSD vs TBI';...
        'amen CONCENTRATION PTSD vs Healthy';'amen CONCENTRATION TBI vs Healthy';'amen CONCENTRATION NC PTSD vs TBI';...
        'amen CR PTSD vs Healthy';'amen CR TBI vs Healthy';'amen CR NC PTSD vs TBI';...
        };
    task.simulation = 0;
    task.types={'NENE';'NENV';'DENE';'DVNE';'DENV';'DVNV'}; %;'DVNR';'DVNS'
    task.algs={'LOL'};
    task.ks=[1:40, 50:10:120]; %unique(floor(logspace(0,2.9,30))); 
    task.ntrials = 5;
else
    task_list = {metatask};
    task.name = metatask;
end

if ~isfield(task,'savestuff'), task.savestuff=1; end