function task = get_setting(name)
% sets up all metadata associated with the input task

% default settings
task.name=name;                         % name of task
task.simulation=1;                      % is this a simulation
task.QDA_model=1;                       % does this simulation satisfy the QDA model
task.ks=1:100;                          % list of dimensions to embed into
task.Nks=length(task.ks);               % # of different dimensions
task.Kmax=max(task.ks);                 % max dimension
task.algs={'PCA','SDA','DRDA','LDA'};   % which algorithms to use
task.savestuff=1;                       % flag whether to save data & figures
task.Ntrials=20;                        % # of trials
task.ntrain = 50;                       % # of training samples
task.ntest = 500;                       % # of test samples

% change settings for certain cases
if strcmp(name,'trunk') || strcmp(name,'toeplitz') || strcmp(name,'decaying') || strcmp(name,'trunk2') ||strcmp(name,'model1') ||strcmp(name,'model3')
    task.Ntrials=20;                        % # of trials
elseif strcmp(name,'1') || strcmp(name,'2') || strcmp(name,'3') || strcmp(name,'4') ||strcmp(name,'5') ||strcmp(name,'6')
    task.Ntrials=20;                        % # of trials
elseif strfind(name,'DRL')
    task.QDA_model=0;
elseif strcmp(name,'IPMN-HvL') || strcmp(name,'IPMN-HvML') || strcmp(name,'IPMN-HMvL') || strcmp(name,'IPMNvsAll') || strcmp(name,'MCNvsAll') || strcmp(name,'SCAvsAll') 
    task.simulation=0;
    task.Ntrials=1000;                        % # of trials
elseif strcmp(name,'colon')
    task.simulation=0;
    task.Ntrials=100;                        % # of trials
elseif strcmp(name,'prostate')
    task.simulation=0;
    task.Ntrials=100;                        % # of trials
    task.algs={'PCA','SDA','DRDA'};      % LDA doesn't run on prostate data
elseif strcmp(name,'a')
    task.Ntrials=20;
    task.ntrain=500;
end

if task.simulation==0
    task.QDA_model=0;
end
task.Nalgs=length(task.algs);       % # of algorithms to use
task.n=task.ntrain+task.ntest;          % # of total samples

