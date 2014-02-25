function [task, X, Y, P] = get_task(task)
% this function generates everything necessarty to analyze a specific task
%
% INPUT: task_name: a string, naming the task
% OUTPUT:
%   task: a structure containing meta-data for the task
%   X:      a matrix of predictors
%   Y:      a vector of predictees
%   P:      a structure of parameters

task = set_task(task);
P = [];
if task.simulation
    if task.QDA_model
        P = set_parameters(task);
    end
end
[X,Y,task] = get_data(task,P);