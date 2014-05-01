function Yhat = embed_and_classify(sample,training,group,V,ks,classifier)

Xtest=V*sample;
Xtrain=V*training;

Nks=length(ks);
siz=size(sample); 
ntest=siz(2);
Yhat=nan(Nks,ntest);
for i=1:Nks
    if any(strcmp(classifier,{'linear','quadratic','diaglinear','diagquadratic','mahalanobis'}))
        Yhat(i,:) = classify(Xtest(1:ks(i),:)',Xtrain(1:ks(i),:)',group,classifier);
    elseif strcmp(classifier,'svm')
        
    end
end