function [Yhat, Proj, P, times] = LOL_classify(sample,training,group,task)
% 
% 
% DENL = LOL
% DRNL = DRDA
% NRNL = RDA
% NENL = PDA
% NNNN = NaiveBayes
% NNNL = LDA
% NNNQ = QDA
%% 


[transformers, deciders] = parse_algs(task.types);

[Proj, P, times] = LOL(training',group,transformers,task.Kmax);

Yhat=cell(length(task.types),1);
k=0;
for i=1:length(transformers)
    Xtest=Proj{i}.V*sample';
    Xtrain=Proj{i}.V*training';
    for j=1:length(deciders{i})
        k=k+1; tic
        Yhat{k} = decide(Xtest,Xtrain,group,deciders{i}{j},task.ks);
        times.decider(k)=toc;
    end
end
