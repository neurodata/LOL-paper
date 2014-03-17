function [task,P,Stats] = run_task(task_in)
% this function does the following for the input task
% 1) gets details for running the task
% 2) runs a variety of classifiers on such task for a variety of embedding dimensions
% 3) computes some summary statistics
% 4) saves the results
%
% INPUT is simply 'task_in', a structure containing a bunch of info about the task
%
% OUTPUT: a number of structures
%   task:   a structure containing details about the tas
%   Stats:  structure of statistics
%   P:      structure of parameters, if task is a simulation, else just empty

%% store and generate parameters from a single simulation fo plotting the spectrum and getting performance bounds

[task, ~, ~, P] = set_task(task_in);    % get task details
loop = task_loop(task);                 % loop over Ntrials for this task running the specified algorithms
Stats = get_loop_stats(task,loop);      % get stats
if isfield(P,'Risk'), Stats.Risk=P.Risk; else Stats.Risk=nan; end % save risk
if task.savestuff, save(['../../data/results/', task.name],'task','Stats','P'), end % save results