function Lhat = proj_class(Xtrain,Xtest,Ytrain,Ytest,V,ks,classifier)

if nargin<7, classifier='linear'; end

% project data
% sample=Xtest*V;
sample=bsxfun(@minus,Xtest,mean(Xtest))*V; 
training=bsxfun(@minus,Xtrain,mean(Xtest))*V;

% make predictions
Nks=length(ks);
Lhat=nan(Nks,1);
for i=1:Nks
    try
        Yhat = classify(sample(:,1:ks(i)),training(:,1:ks(i)),Ytrain,classifier);
    catch err
        Yhat=nan(size(Ytest));
        if i>1
            display(['WARNING: the classifier barfed during embedding dimension ', num2str(ks(i))])
        else
            display(['WARNING: the classifier barfed '])
        end
        display(err.message)
        break
    end
    Lhat(i)=misclass(Yhat,Ytest);
end
