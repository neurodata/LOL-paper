function task = set_task(task)
% sets up all metadata associated with the input task

name=task.name;
% change settings for certain cases
if strcmp(name,'trunk') || strcmp(name,'toeplitz') || strcmp(name,'decaying') || strcmp(name,'trunk2') ||strcmp(name,'model1') ||strcmp(name,'model3')
    if ~isfield(task,'algs'), task.algs={'PDA','LOL','DRDA'}; end                              % list of dimensions to embed into
elseif strcmp(name,'1') || strcmp(name,'2') || strcmp(name,'3') || strcmp(name,'4') ||strcmp(name,'5') ||strcmp(name,'6')
    if ~isfield(task,'Ntrials'), task.Ntrials=100;   end                     % # of trials
elseif strfind(name,'DRL')
    task.QDA_model=0;
elseif strcmp(name,'IPMN-HvL') || strcmp(name,'IPMN-HvML') || strcmp(name,'IPMN-HMvL') || strcmp(name,'IPMNvsAll') || strcmp(name,'MCNvsAll') || strcmp(name,'SCAvsAll') 
    task.simulation=0;
    task.Ntrials=1000;                        % # of trials
elseif strcmp(name,'colon')
    task.simulation=0;
    if ~isfield(task,'Ntrials'), task.Ntrials=10; end                       % # of trials
%     if ~isfield(task,'algs'),   task.algs={'PDA','LOL','DRDA','RDA'}; end  % which algorithms to use
    task.algs={'PDA','LOL','DRDA'};   % which algorithms to use
elseif strcmp(name,'prostate')
    task.simulation=0;
    if ~isfield(task,'Ntrials'), task.Ntrials=10; end                       % # of trials
%     if ~isfield(task,'algs'),   task.algs={'PDA','LOL','DRDA','RDA'}; end  % which algorithms to use
    task.algs={'PDA','LOL','DRDA'};   % which algorithms to use
elseif strcmp(name,'a')
%     task.Ntrials=20;
    task.ntrain=500;
elseif strcmp(name,'sa')
%     task.algs={'PDA','LOL','DRDA','QOL','RDA','LDA'};   % which algorithms to use
%     task.ks=1:40;                          % list of dimensions to embed into
elseif strcmp(name,'r') || strcmp(name,'wra') || strcmp(name,'wra2')
%     task.algs={'PDA','LOL','DRDA','QOL','QOQ','RDA','LDA'};   % which algorithms to use
elseif strfind(name,'model')
%     task.Ntrials=100;
    task.ntrain=200;   % which algorithms to use
    task.algs={'PDA','LOL','DRDA'};   % which algorithms to use
elseif strfind(name,'debug')
%     task.Ntrials=100;
elseif strfind(name,'trunk3')
%     task.Ntrials=100;
%     task.algs={'PDA','LOL','DRDA','RDA'};   % which algorithms to use
elseif strfind(name,'increaseD')
%     task.Ntrials=20;
%     task.algs={'PDA','LOL','DRDA','RDA','LDA'};   % which algorithms to use
elseif strfind(name,'xor')
%     task.Ntrials=50;
    task.QDA_model=0;
%     task.algs={'PDA','LOL','LDA','treebagger','QOL','QOQ'};   % which algorithms to use
elseif strcmp(name,'parallel cigars')
    if ~isfield(task,'ks'), task.ks=5; end                              % list of dimensions to embed into
    if ~isfield(task,'algs'), task.algs={'LDA','PDA','LOL','Bayes'}; end               % which algorithms to use
elseif strcmp(name,'angled cigars')
    if ~isfield(task,'ks'), task.ks=5; end                              % list of dimensions to embed into
    if ~isfield(task,'algs'), task.algs={'LDA','PDA','LOL','Bayes'}; end               % which algorithms to use
end


% default settings
if ~isfield(task,'name'),       task.name=name;     end                         % name of task
if ~isfield(task,'simulation'), task.simulation=1;  end                    % is this a simulation
if ~isfield(task,'QDA_model'),  task.QDA_model=1;   end                   % does this simulation satisfy the QDA model
if ~isfield(task,'ks'),         task.ks=1:100;      end                          % list of dimensions to embed into
if ~isfield(task,'algs'),       task.algs={'PDA','LOL','QOL','DRDA','RDA','LDA'};  end % which algorithms to use
if ~isfield(task,'savestuff'),  task.savestuff=1;   end                       % flag whether to save data & figures
if ~isfield(task,'Ntrials'),    task.Ntrials = 20;  end                   % # of trials
if ~isfield(task,'ntrain'),     task.ntrain  = 50;  end                  % # of training samples
if ~isfield(task,'ntest'),      task.ntest   = 500; end                     % # of test samples

if task.simulation==0
    task.QDA_model=0;
end

task.Nalgs=length(task.algs);           % # of algorithms to use
task.n=task.ntrain+task.ntest;          % # of total samples
task.Nks=length(task.ks);               % # of different dimensions
task.Kmax=max(task.ks);                 % max dimension to embed into
