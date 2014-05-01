function Yhat = decide(sample,training,group,classifier,ks)

Nks=length(ks);
siz=size(sample);
ntest=siz(2);
Yhat=nan(Nks,ntest);
for i=1:Nks
    try
        if any(strcmp(classifier,{'linear','quadratic','diagLinear','diagquadratic','mahalanobis'}))
            Yhat(i,:) = classify(sample(1:ks(i),:)',training(1:ks(i),:)',group,classifier);
        elseif strcmp(classifier,'NaiveBayes')
            nb = NaiveBayes.fit(training',group);
            Yhat = predict(nb,sample')';
        elseif strcmp(classifier,'svm')
            
        end
    catch err
        display(['the ', classifier, ' classifier barfed during embedding dimension ', num2str(ks(i))])
        display(err.message)
        break
    end
end