function [X,Y,task] = get_data(task,P)
% get data based on description in task (and P if simulation)

if task.simulation
    if ~strcmp(task.name,'DRL')
        [X,Y] = sample_QDA(task.n,P.mu1,P.mu0,P.Sig1,P.Sig0);
    else
        [X,Y] = sample_DRL(a);
    end
else
    [X,Y,task] = load_cancer(task);
end

[task.n, task.D]=size(X);
