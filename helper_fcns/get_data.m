function [X,Y,task] = get_data(task,P)
% get data based on description in task (and P if simulation)

if task.simulation
    if strcmp(task.name,'DRL')
        [X,Y] = sample_DRL(a);
    elseif strcmp(task.name,'xor')
        [X,Y] = sample_xor(task);
    else
        [X,Y] = sample_QDA(task.n,P);
    end
else
    [X,Y,task] = load_cancer(task);
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

