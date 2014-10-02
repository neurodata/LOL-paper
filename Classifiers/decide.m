function Yhat = decide(sample,training,group,classifier,ks)
% for each element of ks, train a classifier and make predictions
% 
% INPUT
%   sample (R^{D x ntest}): test sample
%   training (R^{D x ntrain}): training sample
%   group (Z^ntrain): classes of training sample
%   classifier (str): name of classifier to use
%   ks (vec of int): # of embedding dimensions to try
% 
% OUT:
%   Yhat (Z^{length(ks) x ntest}): matrix where each column is predicted
%       classes for a given element of ks
 

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
            [~, group_idx] = max(scores,[],2); 
            group_names=unique(group);
            Yhat(i,:)=group_names(group_idx);
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