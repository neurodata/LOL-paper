function [dataset,P,Phat,Proj,Stats] = run_dataset(dataset_name)
% this function does the following for the input dataset
% 1) runs a variety of classifiers on such dataset for a variety of embedding
% dimensions
% 2) computes some summary statistics
% 3) saves the results
%
% INPUT is simply 'dataset_name', a string identifier for the dataset.
%
% OUTPUT: a number of structures
%   dataset:   a structure containing details about the tas
%   P:          structure of parameters, if dataset is a simulation, else just empty
%   Phat:       structure of parameter estimates
%   Stats:          structure of statistics


%% store and generate parameters from a single simulation fo plotting the spectrum and getting performance bounds

[dataset, X, Y, P] = get_dataset(dataset_name);

Z = parse_data(X,Y,dataset.ntrain,dataset.ntest);
[~,Proj,Phat,dataset] = embed_data(Z,dataset);

% loop over Ntrials for this dataset running the specified algorithms
loop = dataset_loop(dataset);

% store stats
Stats = get_loop_stats(dataset,loop);
if isfield(P,'Risk')
    Stats.Risk=P.Risk;
else
    Stats.Risk=nan;
end


% save results
if dataset.savestuff
    save(['../data/results/', dataset.name],'dataset','P','Phat','Proj','Stats')
end