function [Yhat, Proj, P, transformers, deciders] = LOL_classify(sample,training,group,task)
% LOL_classify does the following:
% (i) parses task types into transformers and deciders
% (ii) runs LOL to learn all the linear transformers
% (iii) for each (transformer,decider pair) makes prediction for each
% specified k
% 
% INPUT
%   sample (R^{d x ntest}):     ntest d-dimensional predictors
%   training (R^{d x ntrain}):  ntrain d-dimensional training points
%   group ({0,1,2,...}^ntrain): classes for each ntrain training point
%   task (struct):              contains two fields:
%       types (cell of str):    lists transformer/decider pairs
%       ks (vector of int):     lists all differen # of embedding directions to try
% 
% OUTPUT
%   Yhat ({0,1,2,...}^ntest):   vector of predicted classes
%   Proj (struct):              containing projection matrix and type
%   P (struct):                 containing various parameters estimated from data
%   transformers:               see parse_algs.m
%   deciders:                   see parse_algs.m

[transformers, deciders] = parse_algs(task.types);
[Proj, P] = LOL(training',group,transformers,max(task.ks));

Yhat=cell(length(task.types),1);
k=0;
for i=1:length(transformers)
    Xtest=Proj{i}.V*sample';
    Xtrain=Proj{i}.V*training';
    for j=1:length(deciders{i})
        k=k+1;
        Yhat{k} = decide(Xtest,Xtrain,group,deciders{i}{j},task.ks);
    end
end
