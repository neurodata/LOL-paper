function dataset = set_dataset(name)
% sets up all metadata associated with the input dataset

% default settings
dataset.name=name;                         % name of dataset
dataset.simulation=1;                      % is this a simulation
dataset.QDA_model=1;                       % does this simulation satisfy the QDA model
dataset.ks=1:100;                          % list of dimensions to embed into
dataset.algs={'PCA','LOL','QOL','DRDA','RDA','LDA'};   % which algorithms to use
dataset.savestuff=1;                       % flag whether to save data & figures
dataset.Ntrials = 50;                       % # of trials
dataset.ntrain  = 50;                      % # of training samples
dataset.ntest   = 500;                     % # of test samples

% change settings for certain cases
if strcmp(name,'trunk') || strcmp(name,'toeplitz') || strcmp(name,'decaying') || strcmp(name,'trunk2') ||strcmp(name,'model1') ||strcmp(name,'model3')
    dataset.Ntrials=100;                        % # of trials
    dataset.algs={'PCA','LOL','DRDA','RDA','LDA'};   % which algorithms to use
elseif strcmp(name,'1') || strcmp(name,'2') || strcmp(name,'3') || strcmp(name,'4') ||strcmp(name,'5') ||strcmp(name,'6')
    dataset.Ntrials=100;                        % # of trials
elseif strfind(name,'DRL')
    dataset.QDA_model=0;
elseif strcmp(name,'IPMN-HvL') || strcmp(name,'IPMN-HvML') || strcmp(name,'IPMN-HMvL') || strcmp(name,'IPMNvsAll') || strcmp(name,'MCNvsAll') || strcmp(name,'SCAvsAll') 
    dataset.simulation=0;
    dataset.Ntrials=1000;                        % # of trials
elseif strcmp(name,'colon')
    dataset.simulation=0;
    dataset.Ntrials=10;                        % # of trials
    dataset.algs={'PCA','LOL','DRDA','RDA'};   % which algorithms to use
elseif strcmp(name,'prostate')
    dataset.simulation=0;
    dataset.Ntrials=10;                        % # of trials
    dataset.algs={'PCA','LOL','DRDA','RDA'};   % which algorithms to use
elseif strcmp(name,'a')
    dataset.Ntrials=20;
    dataset.ntrain=500;
elseif strcmp(name,'sa')
    dataset.algs={'PCA','LOL','DRDA','QOL','RDA','LDA'};   % which algorithms to use
    dataset.ks=1:40;                          % list of dimensions to embed into
elseif strcmp(name,'r') || strcmp(name,'wra') || strcmp(name,'wra2')
    dataset.algs={'PCA','LOL','DRDA','QOL','RDA','LDA'};   % which algorithms to use
elseif strfind(name,'model')
    dataset.Ntrials=100;
    dataset.ntrain=200;   % which algorithms to use
    dataset.algs={'PCA','LOL','DRDA','RDA'};   % which algorithms to use
elseif strfind(name,'debug')
    dataset.Ntrials=100;
elseif strfind(name,'trunk3')
    dataset.Ntrials=100;
    dataset.algs={'PCA','LOL','DRDA','RDA'};   % which algorithms to use
elseif strfind(name,'increaseD')
    dataset.Ntrials=20;
    dataset.algs={'PCA','LOL','DRDA','RDA','LDA'};   % which algorithms to use
elseif strfind(name,'xor')
    dataset.Ntrials=10;
    dataset.QDA_model=0;
    dataset.algs={'PCA','LOL','DRDA','RDA','LDA','treebagger'};   % which algorithms to use
end

if dataset.simulation==0
    dataset.QDA_model=0;
end

dataset.Nalgs=length(dataset.algs);           % # of algorithms to use
dataset.n=dataset.ntrain+dataset.ntest;          % # of total samples
dataset.Nks=length(dataset.ks);               % # of different dimensions
dataset.Kmax=max(dataset.ks);                 % max dimension to embed into


