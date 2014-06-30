function Yhat = decide(sample,training,group,classifier,ks)

Nks=length(ks);
ntest=size(sample,2);
Yhat=nan(Nks,ntest);
for i=1:Nks
    try
        if any(strcmp(classifier,{'linear','quadratic','diagLinear','diagquadratic','mahalanobis'}))
            Yhat(i,:) = classify(sample(1:ks(i),:)',training(1:ks(i),:)',group,classifier);
        elseif strcmp(classifier,'NaiveBayes')
            nb = NaiveBayes.fit(training',group);
            Yhat(i,:) = predict(nb,sample')';
        elseif strcmp(classifier,'svm')
            SVMStruct = svmtrain(training(1:ks(i),:)',group);
            Yhat(i,:) = svmclassify(SVMStruct,sample(1:ks(i),:)');
        elseif strcmp(classifier,'RF')
            B = TreeBagger(100,training(1:ks(i),:)',group);
            [~, scores] = predict(B,sample(1:ks(i),:)');
            Yhat(i,:) = scores(:,1)<scores(:,2);
        elseif strcmp(classifier,'kNN')
            %             d=bsxfun(@minus,Z.Xtrain,Z.Xtest).^2;
            %             [~,IX]=sort(d);
            %             for l=1:tasks1.Nks
            %                 Yhat(i)=sum(Z.Ytrain(IX(1:l,:)))>k/2;
            %                 loop{k}.out(i,l) = get_task_stats(Yhat,Z.Ytest);              % get accuracy
            %             end
        end
    catch err
        if i>1
            display(['the ', classifier, ' classifier barfed during embedding dimension ', num2str(ks(i))])
        else
            display(['the ', classifier, ' classifier barfed '])
        end
        display(err.message)
        break
    end
end