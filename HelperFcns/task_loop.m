function loop = task_loop(task_in)
% this function implements a parloop for ntrials iterations and outputs the results

loop = cell(1,task_in.ntrials);
parfor k=1:task_in.ntrials
    
    if mod(k,10)==0, display(['trial # ', num2str(k)]); end
    
    % prepare data
    [task, X, Y, P] = get_task(task_in);
    Z = parse_data(X,Y,task.ntrain,task.ntest,task.percent_unlabeled);
    
    % chance
    pihat = sum(Z.Ytrain)/task.ntrain;
    Yhatchance=pihat>0.5;
    loop{k}.Lchance=sum(Yhatchance*ones(size(Z.Ytest))~=Z.Ytest)/task.ntest;
    
    % Bayes optimal under QDA model
    if task.QDA_model
        Yhat = gmm_predict(Z.Xtest,Z.Ytest,P);
        loop{k}.Lbayes=sum(Yhat~=Z.Ytest)/task.ntest;
    end
    
    % LOL
    if any(strcmp(task.algs,'LOL'))        
        Yhats = LOL_classify(Z.Xtest',Z.Xtrain',Z.Ytrain,task);
        loop{k}.out=get_task_stats(Yhats,Z.Ytest);
    end
    
    % multi-LOL
    if any(strcmp(task.algs,'lolLOL'))    
        Yhats = multiLOL_classify(Z.Xtest',Z.Xtrain',Z.Ytrain,task);
        alg_num=size(loop{k}.out,1);
        [loop{k}.out(alg_num+1,1)] = et_task_stats(Yhats,Z.Ytest);
    end
    
    % ROAD (sparse)
    if any(strcmp(task.algs,'ROAD'))        
        alg_num=size(loop{k}.out,1);
        [loop{k}.out(alg_num+1,:), loop{k}.ROAD_num] = run_ROAD(Z,task);
    end
    
    % random forest
    if any(strcmp(task.algs,'RF'))        
        alg_num=size(loop{k}.out,1);
        [loop{k}.out(alg_num+1,1)] = run_RF(Z);
    end
    
%     if any(strcmp(task.algs,'DR'))
%         [~,W] = DR(Z.Ytrain,Z.Xtrain','disc',task.Kmax);
%         Xtest=Z.Xtest'*W;
%         Xtrain=Z.Xtrain'*W;
%         Yhat_DR{1} = decide(Xtest',Xtrain,Z.Ytrain,'linear',task.ks);
%         loop{k}.out(size(loop{k}.out,1)+1,:)=get_task_stats(Yhat_DR,Z.Ytest);
%     end
%     
%     if any(strcmp(task.algs,'LAD'))
%         [~,W] = ldr(Z.Ytrain,Z.Xtrain','LAD','disc',task.Kmax,'initval',orth(rand(task.D,task.Kmax)));
%         Xtest=Z.Xtest'*W;
%         Xtrain=Z.Xtrain'*W;
%         Yhat_DR{1} = decide(Xtest',Xtrain,Z.Ytrain,'linear',task.ks);
%         loop{k}.out(size(loop{k}.out,1)+1,:)=get_task_stats(Yhat_DR,Z.Ytest);
%     end
%     
%     if any(strcmp(task.algs,'GLM'))
%         opts=struct('nlambda',task.Nks+11);
%         fit=glmnet(Z.Xtrain',Z.Ytrain,'multinomial',opts);
%         pfit=glmnetPredict(fit,Z.Xtest',fit.lambda,'response','false',fit.offset);
%         [~,yhat]=max(pfit,[],2);
%         Yhat_GLM{1}=squeeze(yhat)';
%         loop{k}.out(size(loop{k}.out,1)+1,:)=get_task_stats(Yhat_GLM,Z.Ytest);
%     end
    
    
end