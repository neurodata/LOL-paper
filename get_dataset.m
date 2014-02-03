function [dataset, X, Y, P] = get_dataset(dataset_name)
% this function generates everything necessarty to analyze a specific dataset
%
% INPUT: dataset_name: a string, naming the dataset
% OUTPUT:
%   dataset: a structure containing meta-data for the dataset
%   X:      a matrix of predictors
%   Y:      a vector of predictees
%   P:      a structure of parameters

dataset = set_dataset(dataset_name);
P = [];
if dataset.simulation
    if dataset.QDA_model
        P = set_parameters(dataset);
    end
end
[X,Y,dataset] = get_data(dataset,P);