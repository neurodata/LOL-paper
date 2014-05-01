function Yhat = LOL_classify(sample,training,group,task)

[transformers, deciders] = parse_algs(task.types);

Proj = LOL(training',group,transformers,task.Kmax);

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
