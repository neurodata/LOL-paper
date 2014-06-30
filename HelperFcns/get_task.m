function [task,X,Y,P] = get_task(task_in)
% this function generates everything necessarty to analyze a specific task
%
% INPUT: task_name: a string, naming the task
% OUTPUT:
%   task: a structure containing meta-data for the task
%   X:      a matrix of predictors
%   Y:      a vector of predictees
%   P:      a structure of parameters

task = set_task(task_in);
P = [];
if task.simulation
    if strcmp(task.name,'DRL')
        [X,Y] = sample_DRL(a);
    elseif strcmp(task.name,'xor')
        [X,Y] = sample_xor(task);
    elseif strcmp(task.name,'gmm')
        P.mu=bsxfun(@times,ones(task.D,1),1:task.Ngroups);
        P.Sigma=eye(task.D);
        P.w=1/task.Ngroups*ones(task.Ngroups,1);
        gmm = gmdistribution(P.mu',P.Sigma,P.w);
        [X,Y] = random(gmm,task.n);
    elseif strcmp(task.name,'gms')
        
        Nnoise=round(task.n*0.5);
        Nsignal=task.n-Nnoise;
        N0=round(Nsignal/2);
        N1=N0;
        D=50;
        d=5;
        noise=0.1;
        offset=0.5;
        V=orth(rand(D,d));
        X0=randn(N0,d)*V';
        X1=randn(N0,d)*V'+offset;
        X=[X0;X1; randn(Nnoise,D)];
        X=X+randn(size(X))*noise;
                            
        Y=[zeros(N0,1); ones(N1,1); rand(Nnoise,1)>0.5]+1;
        
        task.QDA_model=0;
        
    else
        P = set_parameters(task);
        gmm = gmdistribution(P.mu',P.Sigma,P.w);
        [X,Y] = random(gmm,task.n);
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

k_max=min(task.ntrain,min(task.D,task.Kmax));
task.ks=task.ks(task.ks<=k_max);
task.Nks=length(task.ks);
task.Kmax=max(task.ks);

[~, ~,types] = parse_algs(task.types);
task.types=types;