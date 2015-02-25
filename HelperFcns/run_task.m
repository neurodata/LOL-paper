function [T,S,P,Proj] = run_task(task)
% this function does the following for the input task
% 
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

[T,X,Y,P] = get_task(task);       % get T details
display(T)                           % display task details
loop = task_loop(T);                 % loop over ntrials for this task running the specified algorithms
T.algs=loop{1}.algs;
S = get_loop_stats(T,loop);      % get stats
if isfield(P,'Risk'), S.Risk=P.Risk; else S.Risk=nan; end % save risk
if isstruct(task), name=task.name; else name=task; end % store name to save as
if nargout==4,
    transformers = parse_algs(T.types);
    Z = parse_data(X,Y,T.ntrain,T.ntest,T.percent_unlabeled);
    [Proj, P] = LOL(Z.Xtrain',Z.Ytrain,transformers,max(T.ks));
end
if T.savestuff, 
    fpath = mfilename('fullpath');
    save([fpath(1:end-24), 'Data/Results/', name],'T','S','P'), 
    if nargout==4,
        save([fpath(1:end-24), 'Data/Results/', name],'Proj','-append'),
    end        
end % save results