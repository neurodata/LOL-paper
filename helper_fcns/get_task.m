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

