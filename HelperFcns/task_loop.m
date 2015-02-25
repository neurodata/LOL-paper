function loop = task_loop(task_in)
% this function implements a parloop for ntrials iterations and outputs the results

loop = cell(1,task_in.ntrials);
for k=1:task_in.ntrials
    
    if mod(k,10)==0, display(['trial # ', num2str(k)]); end
    
    % prepare data
    [task, X, Y, P] = get_task(task_in);
    Z = parse_data(X,Y,task.ntrain,task.ntest,task.percent_unlabeled);
    
    % chance
    pihat = sum(Z.Ytrain)/task.ntrain;
    Yhatchance=pihat>0.5;
    loop{k}.Lchance=sum(Yhatchance*ones(size(Z.Ytest))~=Z.Ytest)/task.ntest;
    
    % Bayes optimal under QDA model when parameters are given
    if task.QDA_model
        Yhat = gmm_predict(Z.Xtest,Z.Ytest,P);
        loop{k}.Lbayes=sum(Yhat~=Z.Ytest)/task.ntest;
    end
    
    % run all the classifiers
    jj=0;
    for j=1:length(task.algs)
        tic
        jj=jj+1;
        switch task.algs{j}
            case 'LOL'      
                Yhats = LOL_classify(Z.Xtest',Z.Xtrain',Z.Ytrain,task);
                loop{k}.out(jj:jj+length(task.types)-1,:)=get_task_stats(Yhats,Z.Ytest);
                jj=jj+length(task.types)-1;
            case 'ROAD'        
                [loop{k}.out(jj,:), loop{k}.nnz] = run_ROAD(Z,task);
            case 'GLM'
                [loop{k}.out(jj,:), loop{k}.nnz] = run_GLM(Z,task);
            case 'lolLOL'   % multi-LOL
                Yhats = multiLOL_classify(Z.Xtest',Z.Xtrain',Z.Ytrain,task);
                [loop{k}.out(jj,1)] = get_task_stats(Yhats,Z.Ytest);
            case 'RF'       % random forest
                loop{k}.out(jj,1) = run_RF(Z);
            case 'DR'       % sufficient dimensionality reduciton
                [loop{k}.out(jj,1)] = run_DR(Z,task);
            case 'LAD'      % likelihood acquired directions (Cook and Forzani, 2009b)
                [loop{k}.out(jj,1)] = run_LAD(Z,task);
            case 'SVM'
                loop{k}.out(jj,:) = run_SVM(Z,task.Nks);
        end
        loop{k}.time(jj)=toc;
        loop{k}.algs{j}=task.algs{j};
    end
    
    
end