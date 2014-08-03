function [transformers, deciders, types] = parse_algs(algs)
% each classifier is defined as a composition of a 'transformer' and a
% 'decider'. this fcn parses that composition for efficient computation
%
% INPUT: algs (cell): each element contains the name of a composite classifier
%
% OUTPUT:
%   transformers (cell of chars): each element contains the name of a transformer
%   deciders (cell of cells):   each transformer has a cell containing the name of each
%                               decider for that transformer
%   types (cell of chars):      algs re-ordered
% 
% CODE FOR TYPES: each type is a 4 letter code: ABCD
%   A: kind of difference matrix
%   B: whether to share covariance matrices 
%   C: how to compute/approximate eigenvectors
%   D: which classifier to use
%    
%   OPTIONS FOR EACH:
%       A: D=delta, N=none, R=robst, S=spase
%       B: E=equal, V=varied
%       C: N=normal, F=fast, R=robust, A=random
%       D: N = NaiveBayes, L = LDA, Q = QDA, R = RandomForest, S = SVM



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
l=0;
types=cell(length(algs),1);
for j=1:Ntransformers
    k=0;
    for i=1:length(algs)
        if strcmp(algs{i}(1:3),transformers{j})
            k=k+1;
            if strcmp(algs{i}(4),'L') || strcmp(algs{i}(4),'E')
                deciders{j}{k}='linear';
            elseif strcmp(algs{i}(4),'Q') || strcmp(algs{i}(4),'V')
                deciders{j}{k}='quadratic';
            elseif strcmp(algs{i}(4),'l')
                deciders{j}{k}='diagLinear';
            elseif strcmp(algs{i}(4),'Q')
                deciders{j}{k}='diagQuadratic';
            elseif strcmp(algs{i}(4),'M')
                deciders{j}{k}='mahalanobis';
            elseif strcmp(algs{i}(4),'N')
                deciders{j}{k}='NaiveBayes';
            elseif strcmp(algs{i}(4),'R')
                deciders{j}{k}='RF';
            elseif strcmp(algs{i}(4),'S')
                deciders{j}{k}='svm';
            end
            l=l+1;
            types{l}=[transformers{j}, algs{i}(4)];
        end
    end
end