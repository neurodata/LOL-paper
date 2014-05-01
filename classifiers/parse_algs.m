function [transformers, deciders] = parse_algs(algs)
% each classifier is defined as a composition of a 'transformer' and a
% 'decider'. this fcn parses that composition for efficient computation
% 
% INPUT: algs (cell): each element contains the name of a composite classifier
% 
% OUTPUT:
%   transformers (cell): each element contains the name of a transformer
%   deciders (cell of cells): each transformer has a cell containing the name of each
%   decider for that transformer



% get transformers
Tchar=[];
for i=1:length(algs)
    Tchar=[Tchar; algs{i}(1:3)];
end
Tchar=unique(Tchar,'rows');
[Ntransformers,~]=size(Tchar);
transformers=cell(Ntransformers,1);
for i=1:Ntransformers
    transformers{i}=Tchar(i,:);
end

% for each transformer, get deciders
for j=1:Ntransformers
    k=0;
    for i=1:length(algs)
        k=k+1;
        if strcmp(algs{i}(1:3),transformers{j})
            if strcmp(algs{i}(4),'L')
                deciders{j}{k}='linear'; 
            elseif strcmp(algs{i}(4),'Q')
                deciders{j}{k}='quadratic'; 
            elseif strcmp(algs{i}(4),'l')
                deciders{j}{k}='diagLinear';
            elseif strcmp(algs{i}(4),'Q')
                deciders{j}{k}='diagQuadratic';
            elseif strcmp(algs{i}(4),'M')
                deciders{j}{k}='mahalanobis';
            elseif strcmp(algs{i}(4),'N')
                deciders{j}{k}='NaiveBayes';
            end
        end
    end
end