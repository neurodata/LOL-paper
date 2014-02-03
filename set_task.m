function task = set_task(name)
% sets up all metadata associated with the input task

% default settings
task.name=name;                         % name of task
task.simulation=1;                      % is this a simulation
task.QDA_model=1;                       % does this simulation satisfy the QDA model
task.ks=1:100;                          % list of dimensions to embed into
task.algs={'PCA','LOL','QOL','DRDA','RDA','LDA'};   % which algorithms to use
task.savestuff=1;                       % flag whether to save data & figures
task.Ntrials = 50;                       % # of trials
task.ntrain  = 50;                      % # of training samples
task.ntest   = 500;                     % # of test samples

% change settings for certain cases
if strcmp(name,'trunk') || strcmp(name,'toeplitz') || strcmp(name,'decaying') || strcmp(name,'trunk2') ||strcmp(name,'model1') ||strcmp(name,'model3')
    task.Ntrials=100;                        % # of trials
    task.algs={'PCA','LOL','DRDA','RDA','LDA'};   % which algorithms to use
elseif strcmp(name,'1') || strcmp(name,'2') || strcmp(name,'3') || strcmp(name,'4') ||strcmp(name,'5') ||strcmp(name,'6')
    task.Ntrials=100;                        % # of trials
elseif strfind(name,'DRL')
    task.QDA_model=0;
elseif strcmp(name,'IPMN-HvL') || strcmp(name,'IPMN-HvML') || strcmp(name,'IPMN-HMvL') || strcmp(name,'IPMNvsAll') || strcmp(name,'MCNvsAll') || strcmp(name,'SCAvsAll') 
    task.simulation=0;
    task.Ntrials=1000;                        % # of trials
elseif strcmp(name,'colon')
    task.simulation=0;
    task.Ntrials=100;                        % # of trials
    task.algs={'PCA','LOL','DRDA','RDA'};   % which algorithms to use
elseif strcmp(name,'prostate')
    task.simulation=0;
    task.Ntrials=100;                        % # of trials
    task.algs={'PCA','LOL','DRDA','RDA'};   % which algorithms to use
elseif strcmp(name,'a')
    task.Ntrials=20;
    task.ntrain=500;
elseif strcmp(name,'sa')
    task.algs={'PCA','LOL','DRDA','QOL','RDA','LDA'};   % which algorithms to use
    task.ks=1:40;                          % list of dimensions to embed into
elseif strcmp(name,'r') || strcmp(name,'wra') || strcmp(name,'wra2')
    task.algs={'PCA','LOL','DRDA','QOL','RDA','LDA'};   % which algorithms to use
elseif strfind(name,'model')
    task.Ntrials=100;
    task.ntrain=200;   % which algorithms to use
    task.algs={'PCA','LOL','DRDA','RDA'};   % which algorithms to use
elseif strfind(name,'debug')
    task.Ntrials=100;
elseif strfind(name,'trunk3')
    task.Ntrials=100;
    task.algs={'PCA','LOL','DRDA','RDA'};   % which algorithms to use
elseif strfind(name,'increaseD')
    task.Ntrials=20;
    task.algs={'PCA','LOL','DRDA','RDA','LDA'};   % which algorithms to use
elseif strfind(name,'xor')
    task.QDA_model=0;
    task.algs={'PCA','LOL','DRDA','RDA','LDA','treebagger'};   % which algorithms to use
end

if task.simulation==0
    task.QDA_model=0;
end

task.Nalgs=length(task.algs);           % # of algorithms to use
task.n=task.ntrain+task.ntest;          % # of total samples
task.Nks=length(task.ks);               % # of different dimensions
task.Kmax=max(task.ks);                 % max dimension to embed into


