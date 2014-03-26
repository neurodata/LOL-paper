function [task,X,Y,P] = get_data(task)

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
