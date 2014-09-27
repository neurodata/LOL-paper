function loop = task_loop(task_in)
% this function implements a parloop for ntrials iterations and outputs the results

loop = cell(1,task_in.ntrials);
parfor k=1:task_in.ntrials
    
    try
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
        
        if any(strcmp(task.algs,'LOL'))      % LOL
            Yhats = LOL_classify(Z.Xtest',Z.Xtrain',Z.Ytrain,task);
            loop{k}.out=get_task_stats(Yhats,Z.Ytest);
        end
        
        if any(strcmp(task.algs,'lolLOL'))    % multi-LOL
            Yhats = multiLOL_classify(Z.Xtest',Z.Xtrain',Z.Ytrain,task);
            [loop{k}.out(size(loop{k}.out,1)+1,1)] = get_task_stats(Yhats,Z.Ytest);
        end
        
        if any(strcmp(task.algs,'ROAD'))        % ROAD
            [loop{k}.out(size(loop{k}.out,1)+1,:), loop{k}.ROAD_num] = run_ROAD(Z,task);
        end
        
        if any(strcmp(task.algs,'RF'))        % random forest
            loop{k}.out(size(loop{k}.out,1)+1,1) = run_RF(Z);
        end
        
        if any(strcmp(task.algs,'DR'))      % sufficient dimensionality reduciton
            [loop{k}.out(size(loop{k}.out,1)+1,1)] = run_DR(Z,task);
        end
        
        if any(strcmp(task.algs,'LAD'))         % likelihood acquired directions (Cook and Forzani, 2009b)
            [loop{k}.out(size(loop{k}.out,1)+1,1)] = run_LAD(Z,task);
        end
        
        if any(strcmp(task.algs,'GLM'))
            loop{k}.out(size(loop{k}.out,1)+1,:) = run_GLM(Z,task);
        end
        
    catch
        keyboard
    end
    
end