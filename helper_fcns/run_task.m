function [task,P,Stats] = run_task(task)
% this function does the following for the input task
% 1) runs a variety of classifiers on such task for a variety of embedding
% dimensions
% 2) computes some summary statistics
% 3) saves the results
%
% INPUT is simply 'task_name', a string identifier for the task.
%
% OUTPUT: a number of structures
%   task:   a structure containing details about the tas
%   P:          structure of parameters, if task is a simulation, else just empty
%   Phat:       structure of parameter estimates
%   Stats:          structure of statistics


%% store and generate parameters from a single simulation fo plotting the spectrum and getting performance bounds

[task, X, Y, P] = get_task(task);

Z = parse_data(X,Y,task.ntrain,task.ntest,task.percent_unlabeled);
task = update_k(task);

% loop over Ntrials for this task running the specified algorithms
loop = task_loop(task);

% store stats
Stats = get_loop_stats(task,loop);
if isfield(P,'Risk')
    Stats.Risk=P.Risk;
else
    Stats.Risk=nan;
end


% save results
if task.savestuff
    save(['../../data/results/', task.name],'task','P','Stats')
end