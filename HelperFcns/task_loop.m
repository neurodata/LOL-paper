function loop = task_loop(task_in)
% this function implements a parloop for Ntrials iterations and outputs the results

loop = cell(1,task_in.Ntrials);
parfor k=1:task_in.Ntrials
    
    if mod(k,10)==0, display(['trial # ', num2str(k)]); end
    
    % prepare data
    [task, X, Y, P] = get_task(task_in);
    Z = parse_data(X,Y,task.ntrain,task.ntest,task.percent_unlabeled);
    
    % classify
    Yhats = LOL_classify(Z.Xtest',Z.Xtrain',Z.Ytrain,task);
    loop{k}.out=get_task_stats(Yhats,Z.Ytest);
    
    % chance
    pihat = sum(Z.Ytrain)/task.ntrain;
    Yhatchance=pihat>0.5;
    loop{k}.Lchance=sum(Yhatchance*ones(size(Z.Ytest))~=Z.Ytest)/task.ntest;
    
    % Bayes optimal under QDA model
    if task.QDA_model
        Yhat = gmm_predict(Z.Xtest,Z.Ytest,P);
        loop{k}.Lbayes=sum(Yhat~=Z.Ytest)/task.ntest;
    end
end