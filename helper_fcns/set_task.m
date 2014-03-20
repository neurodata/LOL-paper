function [task,X,Y,P] = set_task(task)
% sets up all metadata associated with the input task
%
% INPUT: task: a structure containing various task settings
% 
% OUTPUT:
%   task:   update task structure
%   X:      a matrix of predictors
%   Y:      a vector of predictees
%   P:      a structure of parameters


name=task.name;
% change settings for certain cases
if strfind(name,'DRL')
    task.QDA_model=0;
elseif strcmp(name,'IPMN-HvL') || strcmp(name,'IPMN-HvML') || strcmp(name,'IPMN-HMvL') || strcmp(name,'IPMNvsAll') || strcmp(name,'MCNvsAll') || strcmp(name,'SCAvsAll')
    task.simulation=0;
    task.Ntrials=1000;                        % # of trials
elseif strcmp(name,'colon')
    task.simulation=0;
elseif strcmp(name,'prostate')
    task.simulation=0;
elseif strfind(name,'xor')
    task.QDA_model=0;
elseif strcmp(name,'parallel cigars')
    task.ntrain=50;
elseif strcmp(name,'rotated cigars')
    task.ntrain=50;
elseif strcmp(name,'semisup cigars')
    task.ntrain = 500;
    task.percent_unlabeled=0.9;
elseif strcmp(name,'semisup rotated cigars')
    task.ntrain = 500;
    task.percent_unlabeled=0.9;
elseif strfind(name,'amen')==1
    task.simulation = 0;
    task.ntrain=5112;
    task.ntest=569;
    task.ks=unique(round(logspace(0,2.9,30)));
    task.algs={'LDA','SLOL','LOL','RF'};
elseif strfind(name,'toeplitz, D')==1 
    Dind=strfind(task.name,'D');
    task.D=str2double(task.name(Dind+2:end));
elseif strcmp(name,'mnist')==1
    task.ks=unique(round(logspace(0,2,50)));
    task.Ntrials=10;
    task.algs={'NaiveB','RF','PDA','LOL'};
    task.savestuff=1;
end

% default settings
if ~isfield(task,'algs'),       task.algs={'LDA','PDA','LOL','Bayes'}; end               % which algorithms to use
if ~isfield(task,'name'),       task.name=name;     end                         % name of task
if ~isfield(task,'simulation'), task.simulation=1;  end                    % is this a simulation
if ~isfield(task,'QDA_model'),  task.QDA_model=1;   end                   % does this simulation satisfy the QDA model
if ~isfield(task,'ks'),         task.ks=1:100;      end                          % list of dimensions to embed into
if ~isfield(task,'algs'),       task.algs={'PDA','LOL','QOL','DRDA','RDA','LDA'};  end % which algorithms to use
if ~isfield(task,'savestuff'),  task.savestuff=1;   end                       % flag whether to save data & figures
if ~isfield(task,'Ntrials'),    task.Ntrials = 20;  end                   % # of trials
if ~isfield(task,'ntrain'),     task.ntrain  = 50;  end                  % # of training samples
if ~isfield(task,'ntest'),      task.ntest   = 500; end                     % # of test samples
if ~isfield(task,'percent_unlabeled'),      task.percent_unlabeled = 0; end                     % # of test samples

if task.simulation==0
    task.QDA_model=0;
end

task.Nalgs=length(task.algs);           % # of algorithms to use
task.n=sum(task.ntrain)+task.ntest;     % # of total samples

P = [];
if task.simulation
    if strcmp(task.name,'DRL')
        [X,Y] = sample_DRL(a);
    elseif strcmp(task.name,'xor')
        [X,Y] = sample_xor(task);
    elseif strcmp(task.name,'multiclass')
        [X,Y] = sample_multiclass(task.n);
    else
        P = set_parameters(task);
        [X,Y] = sample_QDA(task.n,P);
    end
else
    [X,Y,task] = load_data(task);
end
[D, n]=size(X);

if D==length(Y)
    X=X';
    task.D = n;
    task.n = D;
else
    task.D = D;
    task.n = n;
end

task.ks=task.ks(task.ks<=min(task.ntrain,min(task.D,max(task.ks))));
task.Nks=length(task.ks);
task.Kmax=max(task.ks);


task=orderfields(task);                 % sort fields
